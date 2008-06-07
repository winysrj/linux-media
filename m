Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1K4zOn-0004uU-04
	for linux-dvb@linuxtv.org; Sat, 07 Jun 2008 16:28:11 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Sat, 7 Jun 2008 16:27:30 +0200
MIME-Version: 1.0
Message-Id: <200806071627.30907.dkuhlen@gmx.net>
Subject: [linux-dvb] pctv452e and TT-S2-3600 step-by-step howto
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1532751152=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1532751152==
Content-Type: multipart/signed;
  boundary="nextPart3004492.dXJly1op1B";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3004492.dXJly1op1B
Content-Type: multipart/mixed;
  boundary="Boundary-01=_SrpSIbLTyd4JWTN"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_SrpSIbLTyd4JWTN
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I have attached a step-by-step howto for these devices


Happy testing,
 Dominik


--Boundary-01=_SrpSIbLTyd4JWTN
Content-Type: text/plain;
  charset="us-ascii";
  name="howto_pctv452e.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="howto_pctv452e.txt"

# 20080607:
# tested with 2.6.23-gentoo-r3 kernel
# need to have a bash (for here-documents)

# 1. Check for old drivers already loaded:
lsmod | grep dvb
# should output nothing
# if it does: do=20
# rmmod <modulename>



# =3D2=3D dowload, patch, config and build driver
mkdir pctv452e
cd pctv452e

hg clone http://jusst.de/hg/multiproto
wget -O pctv452e.patch.bz2  http://www.linuxtv.org/pipermail/linux-dvb/atta=
chments/20080606/cc54743f/attachment-0001.obj
bunzip2 pctv452e.patch.bz2
patch -p0 < pctv452e.patch
cd multiproto

# create minimal config
# use 'make menuconfig' to add more stuff if you want
cat << EOF > v4l/.config
CONFIG_INPUT=3Dy
CONFIG_USB=3Dy
CONFIG_PARPORT=3Dm
CONFIG_FW_LOADER=3Dm
CONFIG_NET=3Dy
CONFIG_SND_AC97_CODEC=3Dm
CONFIG_I2C=3Dm
CONFIG_STANDALONE=3Dy
CONFIG_SND_MPU401_UART=3Dm
CONFIG_SND=3Dm
CONFIG_MODULES=3Dy
CONFIG_HAS_IOMEM=3Dy
CONFIG_PROC_FS=3Dy
CONFIG_I2C_ALGOBIT=3Dm
CONFIG_INET=3Dy
CONFIG_CRC32=3Dm
CONFIG_FB=3Dy
CONFIG_SYSFS=3Dy
CONFIG_PCI=3Dy
CONFIG_SND_PCM=3Dm
CONFIG_PARPORT_1284=3Dy
CONFIG_EXPERIMENTAL=3Dy
CONFIG_VIRT_TO_BUS=3Dy
CONFIG_DVB_CORE=3Dm
CONFIG_DVB_CAPTURE_DRIVERS=3Dy
CONFIG_DVB_USB=3Dm
CONFIG_DVB_USB_PCTV452E=3Dm
CONFIG_DVB_STB0899=3Dm
CONFIG_DVB_STB6100=3Dm
CONFIG_DVB_LNBP22=3Dm
EOF

make

cd v4l

## verify:
# ls *.ko=20
## should list:
## dvb-core.ko  dvb-usb-pctv452e.ko  dvb-usb.ko  lnbp22.ko  stb0899.ko  stb=
6100.ko

# need to be root at this point
insmod ./dvb-core.ko
insmod ./dvb-usb.ko
insmod ./lnbp22.ko
insmod ./stb0899.ko
insmod ./stb6100.ko
insmod ./dvb-usb-pctv452e.ko

# dmesg should show:
dvb-usb: found a 'PCTV HDTV USB' in warm state.
pctv452e_power_ctrl: 1
dvb-usb: will pass the complete MPEG2 transport stream to the software demu=
xer.
DVB: registering new adapter (PCTV HDTV USB)
pctv452e_frontend_attach Enter
stb0899_get_dev_id: Device ID=3D[3], Release=3D[0]
stb0899_get_dev_id: Demodulator Core ID=3D[DMD1], Version=3D[1]
stb0899_get_dev_id: FEC Core ID=3D[FEC1], Version=3D[1]
stb0899_attach: Attaching STB0899
lnbp22_set_voltage: 2 (18V=3D1 13V=3D0)
lnbp22_set_voltage: 0x60)
pctv452e_frontend_attach Leave Ok
DVB: registering frontend 0 (STB0899 Multistandard)...
pctv452e_tuner_attach Enter
stb6100_attach: Attaching STB6100
pctv452e_tuner_attach Leave
input: IR-receiver inside an USB DVB receiver as /class/input/input5
dvb-usb: schedule remote query interval to 100 msecs.
pctv452e_power_ctrl: 0
dvb-usb: PCTV HDTV USB successfully initialized and connected.
usbcore: registered new interface driver pctv452e
usbcore: registered new interface driver dvb-usb-tt-connect-s2-3600-01.fw


# you can drop root privileges at this point.

ls -l /dev/dvb/adapter0/
# total 0
# crw-rw---- 1 root video 212, 4 Jun  7 15:37 demux0
# crw-rw---- 1 root video 212, 5 Jun  7 15:37 dvr0
# crw-rw---- 1 root video 212, 3 Jun  7 15:37 frontend0
# crw-rw---- 1 root video 212, 7 Jun  7 15:37 net0


cd ..
cd ..
# you should be in pctv452e dir created above



#
# simpledvbtune:
wget -O simpledvbtune.c.bz2 http://www.linuxtv.org/pipermail/linux-dvb/atta=
chments/20080419/6a41e0b0/attachment-0002.bin
bunzip2  simpledvbtune.c.bz2
gcc -Imultiproto/linux/include simpledvbtune.c -o simpledvbtune

# try it:
=2E/simpledvbtune -f 11954
# hit enter to refresh messages
=2E/simpledvbtune -f 11915 -d 2





############################
# next scan tool:

wget http://jusst.de/manu/scan.tar.bz2

tar xjf scan.tar.bz2
cd scan
rm *.o *.d

# update to most recent API
patch -p0 < ../scan_mp_fix.patch

# build the stuff
make

# start scan:
=2E/scan dvb-s/Astra-19.2E


#
# or do single channel scan with external tuning application (need two term=
inals for this):
=2E/simpledvbtune -f 11915 -d 2
=2E/scan -c
# output:
#using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
#0x0000 0x0081: pmt_pid 0x0062 PREMIERE -- PREMIERE HD (running, scrambled)
#0x0000 0x0082: pmt_pid 0x0063 PREMIERE -- DISCOVERY HD (running, scrambled)
#0x0000 0x0084: pmt_pid 0x0065 BetaDigital -- ANIXE HD (running)
#0x0000 0x0083: pmt_pid 0x0064 BetaDigital -- ASTRA HD+ (running)
#dumping lists (4 services)
#Done.


--Boundary-01=_SrpSIbLTyd4JWTN
Content-Type: text/x-diff;
  charset="us-ascii";
  name="scan_mp_fix.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="scan_mp_fix.patch"

=2D-- Makefile	2007-03-30 11:53:05.000000000 +0200
+++ Makefile.my	2008-06-07 15:51:49.000000000 +0200
@@ -14,7 +14,7 @@
=20
 removing =3D atsc_psip_section.c atsc_psip_section.h
=20
=2DCPPFLAGS +=3D -I/usr/include -DDATADIR=3D\"$(prefix)/share\"
+CPPFLAGS +=3D -I../multiproto/linux/include -DDATADIR=3D\"$(prefix)/share\"
=20
 .PHONY: all
=20
@@ -27,8 +27,6 @@
 atsc_psip_section.c atsc_psip_section.h:
 	perl section_generate.pl atsc_psip_section.pl
=20
=2Dinclude ../../Make.rules
=2D
 install::
 	@echo installing scan files
 	@mkdir -p $(DESTDIR)$(sharedir)/dvb/atsc
=2D-- scan.c	2008-06-07 16:04:49.000000000 +0200
+++ scan.c.my	2008-06-07 16:02:43.000000000 +0200
@@ -1673,38 +1673,22 @@
 		return -1;
 	}
=20
=2D        struct dvbfe_info fe_info1;
=2D
=2D        // a temporary hack, need to clean
=2D        memset(&fe_info1, 0, sizeof (struct dvbfe_info));
=2D           =20
=2D        if(t->modulation_system =3D=3D 0)
=2D            fe_info1.delivery =3D DVBFE_DELSYS_DVBS;
=2D        else if(t->modulation_system =3D=3D 1)
=2D            fe_info1.delivery =3D DVBFE_DELSYS_DVBS2;
+        enum dvbfe_delsys delsys;          =20
+        if(t->modulation_system =3D=3D 0) {
+            delsys =3D DVBFE_DELSYS_DVBS;info("using DVB-S");}
+        else if(t->modulation_system =3D=3D 1) {
+            delsys =3D DVBFE_DELSYS_DVBS2;info("using DVB-S2");}
+        else {
+           info("unsupported modulation system: %d\n", t->modulation_syste=
m);
+           return -1;
+        }
            =20
=2D        int result =3D ioctl(frontend_fd, DVBFE_GET_INFO, &fe_info1);
+        int result =3D ioctl(frontend_fd, DVBFE_SET_DELSYS, &delsys);
         if (result < 0) {
=2D            perror("ioctl DVBFE_GET_INFO failed");
+            perror("ioctl DVBFE_SET_DELSYS failed");
             t->last_tuning_failed =3D 1;
             return -1;
         }
=2D       =20
=2D        switch (fe_info1.delivery) {
=2D            case DVBFE_DELSYS_DVBS:
=2D                info("----------------------------------> Using '%s' DVB=
=2DS\n", fe_info.name);
=2D                break;
=2D            case DVBFE_DELSYS_DSS:
=2D                info("----------------------------------> Using '%s' DSS=
\n", fe_info.name);
=2D                break;
=2D            case DVBFE_DELSYS_DVBS2:
=2D                info("----------------------------------> Using '%s' DVB=
=2DS2\n", fe_info.name);
=2D                break;
=2D            default:
=2D                info("Unsupported Delivery system (%d)!\n", fe_info1.del=
ivery);
=2D                t->last_tuning_failed =3D 1;
=2D                return -1;
=2D        }
=20
 	if (__tune_to_transponder (frontend_fd, t) =3D=3D 0)
 		return 0;

--Boundary-01=_SrpSIbLTyd4JWTN--

--nextPart3004492.dXJly1op1B
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkhKmtIACgkQ6OXrfqftMKIiHwCgwc9GzeA8ZFHQepQDL5n7TWXb
m6MAn3waq/EpxyabttAW4D4+ldSeY7Ux
=eXjY
-----END PGP SIGNATURE-----

--nextPart3004492.dXJly1op1B--


--===============1532751152==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1532751152==--
