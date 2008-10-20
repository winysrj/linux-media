Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail2.m00h.eu ([83.246.72.85])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christian@heidingsfelder.eu>) id 1Ks0Qs-0008Pp-Q5
	for linux-dvb@linuxtv.org; Mon, 20 Oct 2008 21:29:00 +0200
Received: from localhost (localhost [127.0.0.1])
	by mail2.m00h.eu (Postfix) with ESMTP id BB1BBF0DF236
	for <linux-dvb@linuxtv.org>; Mon, 20 Oct 2008 21:28:46 +0200 (CEST)
Received: from mail2.m00h.eu ([127.0.0.1])
	by localhost (mail2.m00h.eu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0jRortysp439 for <linux-dvb@linuxtv.org>;
	Mon, 20 Oct 2008 21:28:37 +0200 (CEST)
Received: from [192.168.2.50] (dummy.nutze-deinen-tag.de [80.152.217.184])
	(Authenticated sender: christian@heidingsfelder.eu)
	by mail2.m00h.eu (Postfix) with ESMTPA id 794D2F0DF232
	for <linux-dvb@linuxtv.org>; Mon, 20 Oct 2008 21:28:37 +0200 (CEST)
Message-ID: <48FCDBE5.1090501@heidingsfelder.eu>
Date: Mon, 20 Oct 2008 21:28:37 +0200
From: "Christian Heidingsfelder [Heidingsfelder + Partner]"
	<christian@heidingsfelder.eu>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------070805010206010303050003"
Subject: [linux-dvb] Technotrend TT-Connect S2-3650 CI
Reply-To: christian@heidingsfelder.eu
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------070805010206010303050003
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi all,

after getting this url

http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-connect_S2-3650_CI
from faruk i tried to install the modules for my technotrend.
Heres the hole session :

-------------------


scheffe@scheffenote ~ $ mkdir 3650
scheffe@scheffenote ~ $ cd 3650/
scheffe@scheffenote ~/3650 $ hg clone -r 9263=20
http://mercurial.intuxication.org/hg/s2-liplianin
destination directory: s2-liplianin
requesting all changes
adding changesets
adding manifests
adding file changes
added 9264 changesets with 24422 changes to 1647 files
updating working directory
1189 files updated, 0 files merged, 0 files removed, 0 files unresolved
scheffe@scheffenote ~/3650 $ wget=20
http://hem.passagen.se/faruks/3650/my_s2api_pctv452e.txt
--2008-10-20 19:14:13-- =20
http://hem.passagen.se/faruks/3650/my_s2api_pctv452e.txt
Aufl=F6sen des Hostnamen =BBhem.passagen.se=AB.... 80.76.152.146
Verbindungsaufbau zu hem.passagen.se|80.76.152.146|:80... verbunden.
HTTP Anforderung gesendet, warte auf Antwort... 200 OK
L=E4nge: 43373 (42K) [text/plain]
In =BBmy_s2api_pctv452e.txt=AB speichern.

100%[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>] 43.373       106K/s   in=20
0,4s =20
2008-10-20 19:14:14 (106 KB/s) - =BBmy_s2api_pctv452e.txt=AB gespeichert=20
[43373/43373]

scheffe@scheffenote ~/3650 $ cd s2-liplianin/
scheffe@scheffenote ~/3650/s2-liplianin $ patch -p1 <=20
../my_s2api_pctv452e.txt
patching file linux/drivers/media/dvb/dvb-usb/pctv452e.c
patching file linux/drivers/media/dvb/frontends/lnbp22.c
patching file linux/drivers/media/dvb/frontends/stb0899_algo.c
patching file linux/drivers/media/dvb/frontends/stb0899_drv.c
patching file linux/drivers/media/dvb/frontends/stb0899_drv.h
patching file linux/drivers/media/dvb/frontends/stb0899_priv.h
patching file linux/drivers/media/dvb/frontends/stb6100.c
patching file linux/drivers/media/dvb/frontends/stb6100.h
patching file linux/drivers/media/dvb/frontends/stb6100_cfg.h
patching file linux/include/linux/dvb/frontend.h
scheffe@scheffenote ~/3650/s2-liplianin $ cd v4l
scheffe@scheffenote ~/3650/s2-liplianin/v4l $ nano .config
scheffe@scheffenote ~/3650/s2-liplianin/v4l $ cd ..
scheffe@scheffenote ~/3650/s2-liplianin $ make
make -C /home/scheffe/3650/s2-liplianin/v4l
make[1]: Entering directory `/home/scheffe/3650/s2-liplianin/v4l'
No version yet, using 2.6.27-gentoo
make[1]: Leaving directory `/home/scheffe/3650/s2-liplianin/v4l'
make[1]: Entering directory `/home/scheffe/3650/s2-liplianin/v4l'
scripts/make_makefile.pl
Updating/Creating .config
./scripts/make_kconfig.pl /lib/modules/2.6.27-gentoo/build=20
/lib/modules/2.6.27-gentoo/source
Preparing to compile for kernel version 2.6.27
./scripts/make_myconfig.pl
make[1]: Leaving directory `/home/scheffe/3650/s2-liplianin/v4l'
make[1]: Entering directory `/home/scheffe/3650/s2-liplianin/v4l'
perl scripts/make_config_compat.pl /lib/modules/2.6.27-gentoo/source=20
./.myconfig ./config-compat.h
creating symbolic links...
ln -sf . oss
Kernel build directory is /lib/modules/2.6.27-gentoo/build
make -C /lib/modules/2.6.27-gentoo/build=20
SUBDIRS=3D/home/scheffe/3650/s2-liplianin/v4l  modules
make[2]: Entering directory `/usr/src/linux-2.6.27-gentoo'
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/dvbdev.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/dmxdev.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb_demux.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb_filter.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb_ca_en50221.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb_frontend.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb_net.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb_ringbuffer.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb_math.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/pctv452e.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb-usb-firmware.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb-usb-init.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb-usb-urb.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb-usb-i2c.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb-usb-dvb.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb-usb-remote.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/usb-urb.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/stb0899_drv.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/stb0899_algo.o
 LD [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb-core.o
 LD [M]  /home/scheffe/3650/s2-liplianin/v4l/stb0899.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/stb6100.o
/home/scheffe/3650/s2-liplianin/v4l/stb6100.c: In function=20
'stb6100_set_params':
/home/scheffe/3650/s2-liplianin/v4l/stb6100.c:486: warning: unused=20
variable 'state'
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/lnbp22.o
 CC [M]  /home/scheffe/3650/s2-liplianin/v4l/ttpci-eeprom.o
 LD [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb-usb.o
 LD [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb-usb-pctv452e.o
 Building modules, stage 2.
 MODPOST 7 modules
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_unregister_adapter' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_register_adapter' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_unregister_device' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_register_device' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_generic_ioctl' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_generic_release' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_generic_open' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_dmxdev_release' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core: 'dvb_dmxdev_init'=20
exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core: 'dvb_dmx_release'=20
exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core: 'dvb_dmx_init'=20
exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_dmx_swfilter_204' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_dmx_swfilter' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_dmx_swfilter_packets' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_filter_pes2ts' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_filter_pes2ts_init' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_filter_get_ac3info' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_ca_en50221_release' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_ca_en50221_init' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_ca_en50221_frda_irq' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_ca_en50221_camready_irq' exported twice. Previous export was in=20
vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_ca_en50221_camchange_irq' exported twice. Previous export was in=20
vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_frontend_detach' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_unregister_frontend' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_register_frontend' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_frontend_sleep_until' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'timeval_usec_diff' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_frontend_reinitialise' exported twice. Previous export was in vmlinu=
x
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core: 'dvb_net_init'=20
exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core: 'dvb_net_release'=20
exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_ringbuffer_write' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_ringbuffer_read' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_ringbuffer_read_user' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_ringbuffer_flush_spinlock_wakeup' exported twice. Previous export=20
was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_ringbuffer_avail' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_ringbuffer_free' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_ringbuffer_empty' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core:=20
'dvb_ringbuffer_init' exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core: 'intlog10'=20
exported twice. Previous export was in vmlinux
WARNING: /home/scheffe/3650/s2-liplianin/v4l/dvb-core: 'intlog2'=20
exported twice. Previous export was in vmlinux
 CC      /home/scheffe/3650/s2-liplianin/v4l/dvb-core.mod.o
 LD [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb-core.ko
 CC      /home/scheffe/3650/s2-liplianin/v4l/dvb-usb-pctv452e.mod.o
 LD [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb-usb-pctv452e.ko
 CC      /home/scheffe/3650/s2-liplianin/v4l/dvb-usb.mod.o
 LD [M]  /home/scheffe/3650/s2-liplianin/v4l/dvb-usb.ko
 CC      /home/scheffe/3650/s2-liplianin/v4l/lnbp22.mod.o
 LD [M]  /home/scheffe/3650/s2-liplianin/v4l/lnbp22.ko
 CC      /home/scheffe/3650/s2-liplianin/v4l/stb0899.mod.o
 LD [M]  /home/scheffe/3650/s2-liplianin/v4l/stb0899.ko
 CC      /home/scheffe/3650/s2-liplianin/v4l/stb6100.mod.o
 LD [M]  /home/scheffe/3650/s2-liplianin/v4l/stb6100.ko
 CC      /home/scheffe/3650/s2-liplianin/v4l/ttpci-eeprom.mod.o
 LD [M]  /home/scheffe/3650/s2-liplianin/v4l/ttpci-eeprom.ko
make[2]: Leaving directory `/usr/src/linux-2.6.27-gentoo'
./scripts/rmmod.pl check
found 7 modules
make[1]: Leaving directory `/home/scheffe/3650/s2-liplianin/v4l'
scheffe@scheffenote ~/3650/s2-liplianin $ su
SSH passphrase:
scheffenote s2-liplianin # insmod dvb-core.ko
insmod: can't read 'dvb-core.ko': No such file or directory
scheffenote s2-liplianin # cd v4l
scheffenote v4l # insmod dvb-core.ko
insmod: error inserting 'dvb-core.ko': -1 Invalid parameters
scheffenote v4l # insmod stb6100.ko verbose=3D0
scheffenote v4l # insmod stb0899.ko verbose=3D0
scheffenote v4l # insmod lnbp22.ko
scheffenote v4l # insmod ttpci-eeprom.ko
scheffenote v4l # insmod dvb-usb.ko
insmod: error inserting 'dvb-usb.ko': -1 Unknown symbol in module
scheffenote v4l # insmod dvb-usb-pctv452e.ko
insmod: error inserting 'dvb-usb-pctv452e.ko': -1 Unknown symbol in modul=
e
----------------------------
----------------------------
lsmod :
http://rafb.net/p/zFADSp45.html
---------------------------
Many thanks to Igor and  Dominik for dealing with that and to faruk for=20
dealing with me  :-)

If you need more infos , let me know

Regards Chris

--------------070805010206010303050003
Content-Type: text/x-vcard; charset=utf-8;
 name="christian.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="christian.vcf"

begin:vcard
fn:Christian Heidingsfelder [Heidingsfelder + Partner]
n:Heidingsfelder;Christian
org:Heidingsfelder + Partner
adr:;;Kirchgasse 9;Winterlingen-Benzingen;BW;72474;Deutschland
email;internet:christian@heidigsfelder.eu
title:CEO
tel;work:+49 7577 933 864
tel;fax:+49 7577 933 863
tel;home:+49 7577 933 862
x-mozilla-html:TRUE
version:2.1
end:vcard


--------------070805010206010303050003
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------070805010206010303050003--
