Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <handygewinnspiel@gmx.de>) id 1LLb47-0004Cy-1K
	for linux-dvb@linuxtv.org; Sat, 10 Jan 2009 11:27:40 +0100
Date: Sat, 10 Jan 2009 11:27:05 +0100
From: handygewinnspiel@gmx.de
Message-ID: <20090110102705.129600@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] compiling on 2.6.28 broken?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi all,

Compiling on 2.6.28 seems to be broken (v4l-dvb-985ecd81d993, linux-2.6.28,=
 gcc-3.4.1), is this known or already some patch around?

---

-bash-3.00# make all
make -C /usr/src/v4l-dvb-985ecd81d993/v4l all
make[1]: Entering directory `/usr/src/v4l-dvb-985ecd81d993/v4l'
scripts/make_makefile.pl
Updating/Creating .config
Preparing to compile for kernel version 2.6.28
Created default (all yes) .config file
./scripts/make_myconfig.pl
make[1]: Leaving directory `/usr/src/v4l-dvb-985ecd81d993/v4l'
make[1]: Entering directory `/usr/src/v4l-dvb-985ecd81d993/v4l'
perl scripts/make_config_compat.pl /lib/modules/2.6.28/source ./.myconfig .=
/config-compat.h
creating symbolic links...
find: ../linux/drivers/media/dvb/frontends: Value too large for defined dat=
a type
find: ../linux/drivers/media/video: Value too large for defined data type
ln -sf . oss
Kernel build directory is /lib/modules/2.6.28/build
make -C /lib/modules/2.6.28/build SUBDIRS=3D/usr/src/v4l-dvb-985ecd81d993/v=
4l  modules
make[2]: Entering directory `/usr/src/linux-2.6.28'
  CC [M]  /usr/src/v4l-dvb-985ecd81d993/v4l/tuner-xc2028.o
  CC [M]  /usr/src/v4l-dvb-985ecd81d993/v4l/tuner-simple.o
  CC [M]  /usr/src/v4l-dvb-985ecd81d993/v4l/tuner-types.o
  CC [M]  /usr/src/v4l-dvb-985ecd81d993/v4l/mt20xx.o
  CC [M]  /usr/src/v4l-dvb-985ecd81d993/v4l/tda8290.o
  CC [M]  /usr/src/v4l-dvb-985ecd81d993/v4l/tea5767.o
  CC [M]  /usr/src/v4l-dvb-985ecd81d993/v4l/tea5761.o
  CC [M]  /usr/src/v4l-dvb-985ecd81d993/v4l/tda9887.o
  CC [M]  /usr/src/v4l-dvb-985ecd81d993/v4l/tda827x.o
make[3]: *** No rule to make target `/usr/src/v4l-dvb-985ecd81d993/v4l/au08=
28-core.o', needed by `/usr/src/v4l-dvb-985ecd81d993/v4l/tda18271.o'.  Stop.
make[2]: *** [_module_/usr/src/v4l-dvb-985ecd81d993/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.28'
make[1]: *** [default] Fehler 2
make[1]: Leaving directory `/usr/src/v4l-dvb-985ecd81d993/v4l'
make: *** [all] Fehler 2

Bye,
Winfried
-- =

Sensationsangebot verl=E4ngert: GMX FreeDSL - Telefonanschluss + DSL =

f=FCr nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K1308T4569a

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
