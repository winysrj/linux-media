Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gregoire.favre@gmail.com>) id 1KshM4-000321-5b
	for linux-dvb@linuxtv.org; Wed, 22 Oct 2008 19:18:44 +0200
Received: by wx-out-0506.google.com with SMTP id t16so1345168wxc.17
	for <linux-dvb@linuxtv.org>; Wed, 22 Oct 2008 10:18:40 -0700 (PDT)
Date: Wed, 22 Oct 2008 19:18:09 +0200
To: linux-dvb@linuxtv.org
Message-ID: <20081022171809.GI30832@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
From: Gregoire Favre <gregoire.favre@gmail.com>
Subject: [linux-dvb] Undefined symbols in hg v4l-dvb
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

Just compiled v4l-dvb and :
  Building modules, stage 2.
  MODPOST 118 modules
WARNING: "i2c_bit_add_bus" [/usr/src/CVS/v4l-dvb/v4l/cx88xx.ko] undefined!
WARNING: "i2c_bit_add_bus" [/usr/src/CVS/v4l-dvb/v4l/cx88-vp3054-i2c.ko] un=
defined!
WARNING: "i2c_bit_add_bus" [/usr/src/CVS/v4l-dvb/v4l/cx18.ko] undefined!

But sudo make install
Stripping debug info from files

Removing obsolete files from /lib/modules/2.6.27-gentoo/kernel/drivers/medi=
a/video:


Removing obsolete files from /lib/modules/2.6.27-gentoo/kernel/drivers/medi=
a/dvb/frontends:

Installing kernel modules under /lib/modules/2.6.27-gentoo/kernel/drivers/m=
edia/:
        video/cx18/: cx18.ko =

        common/tuners/: tuner-xc2028.ko tda9887.ko mt2131.ko =

                mt20xx.ko tda827x.ko tda18271.ko =

                xc5000.ko tea5761.ko tuner-types.ko =

                tda8290.ko tuner-simple.ko tea5767.ko =

                mxl5005s.ko =

        dvb/dvb-core/: dvb-core.ko =

        video/: videobuf-dma-sg.ko upd64083.ko videobuf-core.ko =

                tda9840.ko cx2341x.ko wm8775.ko =

                tuner.ko videobuf-dvb.ko tvaudio.ko =

                tea6420.ko msp3400.ko tcm825x.ko =

                wm8739.ko tda7432.ko upd64031a.ko =

                ir-kbd-i2c.ko tea6415c.ko videodev.ko =

                tda9875.ko cs53l32a.ko btcx-risc.ko =

                saa7115.ko v4l2-common.ko tvp5150.ko =

                vp27smpx.ko ov7670.ko saa7127.ko =

                m52790.ko v4l1-compat.ko compat_ioctl32.ko =

                v4l2-int-device.ko tveeprom.ko cs5345.ko =

                saa717x.ko tlv320aic23b.ko =

        video/cx23885/: cx23885.ko =

        video/cx25840/: cx25840.ko =

        dvb/ttpci/: ttpci-eeprom.ko budget-av.ko budget.ko =

                budget-core.ko budget-ci.ko =

        dvb/frontends/: nxt6000.ko dib7000m.ko drx397xD.ko =

                s5h1411.ko si21xx.ko au8522.ko =

                s5h1420.ko stv0288.ko nxt200x.ko =

                mt352.ko isl6405.ko s5h1409.ko =

                sp887x.ko dibx000_common.ko isl6421.ko =

                mt312.ko or51132.ko dib3000mb.ko =

                tda1004x.ko lgs8gl5.ko dib3000mc.ko =

                itd1000.ko sp8870.ko l64781.ko =

                dib7000p.ko ves1x93.ko tda8083.ko =

                dib0070.ko ves1820.ko stv0297.ko =

                tda10086.ko cx22700.ko zl10353.ko =

                cx24110.ko stv0299.ko dvb_dummy_fe.ko =

                dvb-pll.ko lgdt330x.ko cx24123.ko =

                lnbp21.ko cx22702.ko stb6000.ko =

                cx24116.ko tda10023.ko tua6100.ko =

                bcm3510.ko tda10021.ko tda10048.ko =

                or51211.ko tda826x.ko af9013.ko =

        video/cx88/: cx8802.ko cx8800.ko cx88-blackbird.ko =

                cx88-alsa.ko cx88xx.ko cx88-vp3054-i2c.ko =

                cx88-dvb.ko =

        common/: saa7146_vv.ko ir-common.ko saa7146.ko =

/sbin/depmod -a 2.6.27-gentoo =


And then sudo scripts/rmmod.pl load ended like this :
/sbin/insmod ./cx88xx.ko
insmod: error inserting './cx88xx.ko': -1 Unknown symbol in module
/sbin/insmod ./msp3400.ko
/sbin/insmod ./budget-ci.ko
/sbin/insmod ./compat_ioctl32.ko
/sbin/insmod ./cx18.ko
insmod: error inserting './cx18.ko': -1 Unknown symbol in module
/sbin/insmod ./cx8800.ko
insmod: error inserting './cx8800.ko': -1 Unknown symbol in module
/sbin/insmod ./budget-av.ko
/sbin/insmod ./cx8802.ko
insmod: error inserting './cx8802.ko': -1 Unknown symbol in module
/sbin/insmod ./cx23885.ko
/sbin/insmod ./cx88-alsa.ko
insmod: error inserting './cx88-alsa.ko': -1 Unknown symbol in module
/sbin/insmod ./cx88-dvb.ko
insmod: error inserting './cx88-dvb.ko': -1 Unknown symbol in module
/sbin/insmod ./cx88-blackbird.ko
insmod: error inserting './cx88-blackbird.ko': -1 Unknown symbol in module

So only one of my cards get recognized...
-- =

Gr=E9goire FAVRE http://gregoire.favre.googlepages.com http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
