Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:64116 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZI3HRL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Sep 2009 03:17:11 -0400
Received: by ewy7 with SMTP id 7so6155387ewy.17
        for <linux-media@vger.kernel.org>; Wed, 30 Sep 2009 00:17:14 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 30 Sep 2009 09:17:14 +0200
Message-ID: <f85a7aa40909300017m217cbb03p433dbd2e715f001b@mail.gmail.com>
Subject: PATCH: better support for INTUIX DVB stick boot
From: Pedro Andres Aranda Gutierrez <paaguti@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a INTUIX/LITEON DVB USB adapter. It boots correctly, but no
frontend is attached.
The following patch corrects this behaviour:

diff -r 3f2dffde2429 linux/drivers/media/dvb/dvb-usb/dibusb-common.c
--- a/linux/drivers/media/dvb/dvb-usb/dibusb-common.c   Thu Jul 30
20:00:44 2009 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dibusb-common.c   Wed Sep 30
08:56:56 2009 +0200
@@ -246,6 +246,11 @@ static struct dib3000mc_config mod3000p_

 int dibusb_dib3000mc_frontend_attach(struct dvb_usb_adapter *adap)
 {
+       if (adap->dev->udev->descriptor.idVendor  == USB_VID_LITEON &&
+               adap->dev->udev->descriptor.idProduct ==
USB_PID_LITEON_DVB_T_WARM) {
+           msleep(1000);
+       }
+
        if ((adap->fe = dvb_attach(dib3000mc_attach,
&adap->dev->i2c_adap, DEFAULT_DIB3000P_I2C_ADDRESS,
&mod3000p_dib3000p_config)) != NULL ||
                (adap->fe = dvb_attach(dib3000mc_attach,
&adap->dev->i2c_adap, DEFAULT_DIB3000MC_I2C_ADDRESS,
&mod3000p_dib3000p_config)) != NULL) {
                if (adap->priv != NULL) {


Since a couple of years ago, when I bought the stick, I have been
using this alternative patch,
which has not made it to the kernel, apparently because it introduced
this 1 second delay
which was not needed by other drivers:

diff -r 3f2dffde2429 linux/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c     Thu Jul 30
20:00:44 2009 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c     Wed Sep 30
08:56:56 2009 +0200
@@ -172,7 +172,7 @@ int dvb_usb_adapter_frontend_init(struct
                err("strange: '%s' #%d doesn't want to attach a
frontend.",adap->dev->desc->name, adap->id);
                return 0;
        }
-
+      msleep(1000);
        /* re-assign sleep and wakeup functions */
        if (adap->props.frontend_attach(adap) == 0 && adap->fe != NULL) {
                adap->fe_init  = adap->fe->ops.init;
adap->fe->ops.init  = dvb_usb_fe_wakeup;

I hope this one is accepted...

Cheers,/PA
