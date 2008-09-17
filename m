Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vds2011.yellis.net ([79.170.233.11])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <frederic.cand@anevia.com>) id 1KfuG0-0001hi-HO
	for linux-dvb@linuxtv.org; Wed, 17 Sep 2008 12:27:37 +0200
Received: from goliath.anevia.com (cac94-10-88-170-236-224.fbx.proxad.net
	[88.170.236.224])
	by vds2011.yellis.net (Postfix) with ESMTP id 1596E2FA823
	for <linux-dvb@linuxtv.org>; Wed, 17 Sep 2008 12:27:36 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by goliath.anevia.com (Postfix) with ESMTP id 97E801300188
	for <linux-dvb@linuxtv.org>; Wed, 17 Sep 2008 12:27:31 +0200 (CEST)
Received: from goliath.anevia.com ([127.0.0.1])
	by localhost (goliath.anevia.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kaDylg3WUzz3 for <linux-dvb@linuxtv.org>;
	Wed, 17 Sep 2008 12:27:24 +0200 (CEST)
Received: from [10.0.1.25] (fcand.anevia.com [10.0.1.25])
	by goliath.anevia.com (Postfix) with ESMTP id 78C4B1300182
	for <linux-dvb@linuxtv.org>; Wed, 17 Sep 2008 12:27:24 +0200 (CEST)
Message-ID: <48D0DB83.4050409@anevia.com>
Date: Wed, 17 Sep 2008 12:27:15 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Content-Type: multipart/mixed; boundary="------------030503010508030501040305"
Subject: [linux-dvb] hvr 1300 mpeg sound / video issues + patches
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
--------------030503010508030501040305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dear all,

I'm experiencing an issue I had experienced previously which I though I 
got rid of but in fact no.
The issue is :

I tune the card through the [v4l] device (open/ioctls/close), then read 
the mpeg PS through the [mpeg] device. This is working.
But closing the mpeg device, retuning the [v4l] device 
(open/ioctls/close) the reopening for read the [mpeg] device will yield 
in raspy sound and/or blinking black banner on the top of the video 
frames ...

I'm using a 2.6.22.19 kernel
I'm using a quite fresh v4l-dvb snapshot (rev e5ca4534b543 of September 
9th, changeset 8963)
I'm using v4l-cx2341x-enc.fw which md5sum is 
9b39b3d3bba1ce2da40f82ef0c50ef48 from 
http://ivtvdriver.org/index.php/Firmware

By the way the mpeg was not providing anything (i.e only I/O errors) 
when selecting the analog tv tuner input so I took some time looking for 
a snapshot with tuner working and I came up with the attached 
hvr-1300-tuner-fix.patch patch file.
I don't get why but this is simply a diff between rev b7bb2b116cbb 
(changeset 7442) and its child rev 13244661a8df (changset 7483) and it 
worked for me (7442 had tuner working, 7483 had not). Applying this 
patch on recent snapshots make the analog tuner work for me ... so if 
anyone can check if it's ok or if I missed an important point ...

Another thing : the way I work with the [mpeg] device was polling the 
device, then read from it if any data is available. But the [mpeg] is 
not providing anything until a read call has initiated the codec (i.e a 
call to blackbird_start_codec). So I came up with the attached 
cx88-blackbird-poll-fix.patch patch file.
Thus, anyone willing to have a generic implementation of timeout polling 
before trying to read the device would be glad to be able to.

So if anyone has an understanding of my first issue (raspy sound / 
blinkg black banner on top of the video after some retuning function 
calls), can reproduce it, and / or has an idea on how to fix this, help 
would be greatly appreciated !

Greetings


-- 
CAND Frederic
Product Manager
ANEVIA

--------------030503010508030501040305
Content-Type: text/plain;
 name="hvr-1300-tuner-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hvr-1300-tuner-fix.patch"

--- linux/drivers/media/common/tuners/tuner-types.c	2008-09-08 21:42:40.000000000 +0200
+++ linux/drivers/media/common/tuners/tuner-types.c	2008-09-16 10:55:28.000000000 +0200
@@ -1480,6 +1480,7 @@ struct tunertype tuners[] = {
 		.min    = 16 *  57.00,
 		.max    = 16 * 858.00,
 		.stepsize = 62500,
+		.initdata = tua603x_agc103,
 	},
 
 	/* 50-59 */
@@ -1494,12 +1495,15 @@ struct tunertype tuners[] = {
 		.count  = ARRAY_SIZE(tuner_philips_fm1256_ih3_params),
 	},
 	[TUNER_THOMSON_DTT7610] = { /* THOMSON ATSC */
+		.initdata = tua603x_agc112,
+		.sleepdata = (u8[]){ 4, 0x9c, 0x60, 0x85, 0x54 },
 		.name   = "Thomson DTT 7610 (ATSC/NTSC)",
 		.params = tuner_thomson_dtt7610_params,
 		.count  = ARRAY_SIZE(tuner_thomson_dtt7610_params),
 		.min    = 16 *  44.00,
 		.max    = 16 * 958.00,
 		.stepsize = 62500,
+		.initdata = tua603x_agc103,
 	},
 	[TUNER_PHILIPS_FQ1286] = { /* Philips NTSC */
 		.name   = "Philips FQ1286",
@@ -1544,7 +1548,6 @@ struct tunertype tuners[] = {
 		.min    = 16 *  57.00,
 		.max    = 16 * 863.00,
 		.stepsize = 62500,
-		.initdata = tua603x_agc103,
 	},
 	[TUNER_TENA_9533_DI] = { /* Philips PAL */
 		.name   = "Tena TNF9533-D/IF/TNF9533-B/DF",
@@ -1562,8 +1565,6 @@ struct tunertype tuners[] = {
 		.min = 16 *  50.87,
 		.max = 16 * 858.00,
 		.stepsize = 166667,
-		.initdata = tua603x_agc112,
-		.sleepdata = (u8[]){ 4, 0x9c, 0x60, 0x85, 0x54 },
 	},
 	[TUNER_LG_TDVS_H06XF] = { /* LGINNOTEK ATSC */
 		.name   = "LG TDVS-H06xF", /* H061F, H062F & H064F */
@@ -1572,7 +1573,6 @@ struct tunertype tuners[] = {
 		.min    = 16 *  54.00,
 		.max    = 16 * 863.00,
 		.stepsize = 62500,
-		.initdata = tua603x_agc103,
 	},
 	[TUNER_YMEC_TVF66T5_B_DFF] = { /* Philips PAL */
 		.name   = "Ymec TVF66T5-B/DFF",

--------------030503010508030501040305
Content-Type: text/plain;
 name="cx88-blackbird-poll-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cx88-blackbird-poll-fix.patch"

--- linux/drivers/media/video/cx88/cx88-blackbird.c	2008-09-16 17:05:51.000000000 +0200
+++ linux/drivers/media/video/cx88/cx88-blackbird.c	2008-09-16 16:58:57.000000000 +0200
@@ -1177,6 +1177,10 @@ static unsigned int
 mpeg_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct cx8802_fh *fh = file->private_data;
+	struct cx8802_dev *dev = fh->dev;
+
+	if (!dev->mpeg_active)
+		blackbird_start_codec(file, fh);
 
 	return videobuf_poll_stream(file, &fh->mpegq, wait);
 }

--------------030503010508030501040305
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------030503010508030501040305--
