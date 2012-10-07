Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab2JGMfC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Oct 2012 08:35:02 -0400
Date: Sun, 7 Oct 2012 09:34:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: =?UTF-8?B?UsOpbWk=?= Cardona <remi.cardona@smartjog.com>,
	linux-media@vger.kernel.org, liplianin@me.by
Subject: Re: [PATCH 6/7] [media] ds3000: add module parameter to force
 firmware upload
Message-ID: <20121007093443.5626783f@redhat.com>
In-Reply-To: <506B88FB.1090707@iki.fi>
References: <1348837172-11784-1-git-send-email-remi.cardona@smartjog.com>
	<1348837172-11784-7-git-send-email-remi.cardona@smartjog.com>
	<506B88FB.1090707@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 03 Oct 2012 03:38:19 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> On 09/28/2012 03:59 PM, Rémi Cardona wrote:
> > Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>

Next time, please provide a better comment: why such change is
needed?

> 
> Reviewed-by: Antti Palosaari <crope@iki.fi>
> 
> 
> > ---
> >   drivers/media/dvb-frontends/ds3000.c |    6 +++++-
> >   1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
> > index 59184a8..c66d731 100644
> > --- a/drivers/media/dvb-frontends/ds3000.c
> > +++ b/drivers/media/dvb-frontends/ds3000.c
> > @@ -30,6 +30,7 @@
> >   #include "ds3000.h"
> >
> >   static int debug;
> > +static int force_fw_upload;
> >
> >   #define dprintk(args...) \
> >   	do { \
> > @@ -396,7 +397,7 @@ static int ds3000_firmware_ondemand(struct dvb_frontend *fe)
> >   	dprintk("%s()\n", __func__);
> >
> >   	ret = ds3000_readreg(state, 0xb2);
> > -	if (ret == 0) {
> > +	if (ret == 0 && force_fw_upload == 0) {

This hunk got a conflict. I solved it manually and applied. See below.

Regards,
Mauro

-

[PATCH] [media] ds3000: add module parameter to force firmware upload

From: Rémi Cardona <remi.cardona@smartjog.com>

[mchehab@redhat.com: Fix a merge conflict]
Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index 4c8ac26..5b63908 100644
--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -30,6 +30,7 @@
 #include "ds3000.h"
 
 static int debug;
+static int force_fw_upload;
 
 #define dprintk(args...) \
 	do { \
@@ -392,11 +393,13 @@ static int ds3000_firmware_ondemand(struct dvb_frontend *fe)
 
 	dprintk("%s()\n", __func__);
 
-	if (ds3000_readreg(state, 0xb2) <= 0)
+	ret = ds3000_readreg(state, 0xb2);
+	if (ret < 0)
 		return ret;
 
-	if (state->skip_fw_load)
-		return 0;
+	if (state->skip_fw_load || !force_fw_upload)
+		return 0;	/* Firmware already uploaded, skipping */
+
 	/* Load firmware */
 	/* request the firmware, this will block until someone uploads it */
 	printk(KERN_INFO "%s: Waiting for firmware upload (%s)...\n", __func__,
@@ -1306,6 +1309,9 @@ static struct dvb_frontend_ops ds3000_ops = {
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Activates frontend debugging (default:0)");
 
+module_param(force_fw_upload, int, 0644);
+MODULE_PARM_DESC(force_fw_upload, "Force firmware upload (default:0)");
+
 MODULE_DESCRIPTION("DVB Frontend module for Montage Technology "
 			"DS3000/TS2020 hardware");
 MODULE_AUTHOR("Konstantin Dimitrov");

-- 
Regards,
Mauro
