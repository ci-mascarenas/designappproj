FROM python
RUN useradd -ms /bin/bash daUser
USER daUser
WORKDIR /home/daUser
ENV PATH="/home/devasc/.local/bin:/home/devasc/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/daUser/.local/bin"
COPY . /home/daUser/da
EXPOSE 5050
RUN python3 -m pip --disable-pip-version-check --quiet install flask --upgrade pip
CMD python3 /home/daUser/da/design_app.py
