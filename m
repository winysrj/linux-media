Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from difo.com ([217.147.177.146] helo=thin.difo.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ivor@ivor.org>) id 1JaCxy-0001HK-I0
	for linux-dvb@linuxtv.org; Fri, 14 Mar 2008 17:41:11 +0100
Received: from myth.ivor.org (difo.gotadsl.co.uk [213.208.101.41])
	by thin.difo.com (8.13.8/8.13.6) with ESMTP id m2EGf1d0014013
	for <linux-dvb@linuxtv.org>; Fri, 14 Mar 2008 16:41:01 GMT
Date: Fri, 14 Mar 2008 16:41:00 +0000
From: Ivor Hewitt <ivor@ivor.org>
To: linux-dvb <linux-dvb@linuxtv.org>
Message-ID: <20080314164100.GA3470@mythbackend.home.ivor.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
Subject: [linux-dvb] Nova-T 500 issues - losing one tuner
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


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Still no failures here on 2.6.22.19, had one or two "mt2060 I2C write failed" messages but that didn't stop anything working. Running mythtv with multi-rec.
I've attached the list of usb and i2c named files that changed between 2.6.22.19 and linux-2.6.23.12. I'll browse through and if I have time I'll apply a few of the diffs and see if I can create a breakage.

Cheers,
Ivor

--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=diffs

+++ ../linux-2.6.23.12/./arch/cris/arch-v32/drivers/i2c.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./arch/powerpc/platforms/powermac/low_i2c.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/i2c/i2c-core.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/i2c/busses/i2c-i801.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/i2c/busses/i2c-piix4.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/i2c/busses/i2c-gpio.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/i2c/busses/i2c-savage4.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/i2c/busses/i2c-mv64xxx.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/i2c/busses/i2c-nforce2.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/i2c/busses/i2c-mpc.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/i2c/busses/i2c-pxa.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/i2c/busses/i2c-acorn.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/i2c/busses/i2c-viapro.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/i2c/busses/i2c-powermac.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/i2c/busses/i2c-sis5595.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/i2c/busses/i2c-iop3xx.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/i2c/busses/i2c-s3c2410.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/i2c/i2c-dev.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/sbus/char/bbc_i2c.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-i2c.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/video/cx88/cx88-vp3054-i2c.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/video/cx88/cx88-vp3054-i2c.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/video/cx88/cx88-i2c.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/video/ivtv/ivtv-i2c.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/video/ir-kbd-i2c.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./include/linux/i2c.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./include/linux/i2c-id.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./sound/usb/usx2y/usbusx2yaudio.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./sound/usb/usbmixer.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./sound/usb/usbquirks.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./sound/usb/usbaudio.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/hid/usbhid/usbkbd.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/net/usb/usbnet.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/net/usb/usbnet.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/net/irda/irda-usb.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/net/wireless/zd1211rw/zd_usb.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/net/wireless/zd1211rw/zd_usb.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/atm/usbatm.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/mon/usb_mon.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/core/usb.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/core/usb.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/misc/legousbtower.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/misc/ldusb.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/misc/usbtest.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/misc/usblcd.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/misc/sisusbvga/sisusb_con.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/misc/sisusbvga/sisusb.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/misc/sisusbvga/sisusb_init.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/class/usblp.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/storage/usb.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/storage/usb.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/storage/usb-storage.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/gadget/fsl_usb2_udc.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/gadget/fsl_usb2_udc.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/usb-skeleton.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/serial/kl5kusb105.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/serial/io_usbvend.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/serial/ti_usb_3410_5052.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/serial/usb-serial.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/usb/serial/ir-usb.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/char/watchdog/pcwd_usb.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/isdn/hisax/hfc_usb.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/isdn/hisax/hfc_usb.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/input/touchscreen/usbtouchscreen.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-ttusb2.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dibusb.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-i2c.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-dibusb-mc.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/cxusb.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-digitv.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-remote.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-m920x.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dibusb-common.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-a800.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-au6610.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-dibusb-common.mod.c	2007-12-27 21:01:19.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-vp702x.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-gl861.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-dib0700.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dibusb-mb.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-opera.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-gp8psk.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-cxusb.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-nova-t-usb2.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-vp7045.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-dtt200u.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-umt-010.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/dvb/dvb-usb/dvb-usb-dibusb-mb.mod.c	2008-01-21 09:49:39.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/video/usbvision/usbvision-cards.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/video/usbvision/usbvision-core.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/video/usbvision/usbvision.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/media/video/usbvision/usbvision-video.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/bluetooth/hci_usb.c	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./drivers/bluetooth/hci_usb.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./include/linux/usb.h	2007-12-18 21:55:57.000000000 +0000
+++ ../linux-2.6.23.12/./include/linux/usb_gadget.h	2007-12-18 21:55:57.000000000 +0000

--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--IS0zKkzwUGydFO0o--
