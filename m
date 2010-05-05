Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnxtsmtp2.conexant.com ([198.62.9.253]:49100 "EHLO
	cnxtsmtp2.conexant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758810Ab0EEPtm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 11:49:42 -0400
Received: from cps (nbwsmx1.bbnet.ad [157.152.183.211]) (using TLSv1 with cipher RC4-MD5 (128/128
 bits)) (No client certificate requested) by cnxtsmtp2.conexant.com (Tumbleweed MailGate 3.7.1) with
 ESMTP id 2FE4D2463A7 for <linux-media@vger.kernel.org>; Wed, 5 May 2010 08:31:44 -0700 (PDT)
From: "Palash Bandyopadhyay" <Palash.Bandyopadhyay@conexant.com>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
	"Dan Carpenter" <error27@gmail.com>
cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 5 May 2010 08:31:39 -0700
Subject: RE: -next: staging/cx25821: please revert 7a02f549fcc
Message-ID: <6CF766271A2E9A4188452BF44FF7131B66DDB6015B@NBMBX02.bbnet.ad>
References: <20100505072738.GH27064@bicker> <4BE18EF9.9010502@redhat.com>
In-Reply-To: <4BE18EF9.9010502@redhat.com>
Content-Language: en-US
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Will do. Thanks for passing over the info.

Regards,
Palash

-----Original Message-----
From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com] 
Sent: Wednesday, May 05, 2010 8:30 AM
To: Dan Carpenter; Palash Bandyopadhyay
Cc: Greg Kroah-Hartman; linux-media@vger.kernel.org
Subject: Re: -next: staging/cx25821: please revert 7a02f549fcc

Dan Carpenter wrote:
> This was my patch:  "cx25821: fix double unlock in medusa_video_init()"
> 
> It accidentally got merged two times.  The version from the staging tree
> is not correct.  Please can you revert it:
> 7a02f549fcc30fe6be0c0024beae9a3db22e1af6 "Staging: cx25821: fix double
> unlock in medusa_video_init()"

Hmm... true.
> 
> I guess this is going through the V4L/DVB so it needs to be reverted
> there as well as in the -staging tree.

There's no need to touch at staging tree, since this change come from v4l-dvb
tree.

After reviewing the logic at the function, instead of just adding a patch to
revert the wrong one, the better is to apply a different logic: add a goto 
that will always unlock and return the error.

This simplifies the code a little bit, and, instead of just return -EINVAL,
it will return the error condition reported by the called functions.

Btw, cx25821-core currently doesn't handle the error returned by medusa_video_init().

Palash,

Could you please add the proper validation code for the error conditions that may
happen during device init?

Cheers,
Mauro

--

V4L/DVB: cx25821: fix error condition logic at medusa_video_init()

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


diff --git a/drivers/staging/cx25821/cx25821-medusa-video.c b/drivers/staging/cx25821/cx25821-medusa-video.c
index 77ccef4..7545314 100644
--- a/drivers/staging/cx25821/cx25821-medusa-video.c
+++ b/drivers/staging/cx25821/cx25821-medusa-video.c
@@ -778,9 +778,9 @@ int medusa_set_saturation(struct cx25821_dev *dev, int saturation, int decoder)
 
 int medusa_video_init(struct cx25821_dev *dev)
 {
-	u32 value = 0, tmp = 0;
-	int ret_val = 0;
-	int i = 0;
+	u32 value, tmp = 0;
+	int ret_val;
+	int i;
 
 	mutex_lock(&dev->lock);
 
@@ -790,20 +790,15 @@ int medusa_video_init(struct cx25821_dev *dev)
 	value = cx25821_i2c_read(&dev->i2c_bus[0], MON_A_CTRL, &tmp);
 	value &= 0xFFFFF0FF;
 	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], MON_A_CTRL, value);
+	if (ret_val < 0)
+		goto error;
 
-	if (ret_val < 0) {
-		mutex_unlock(&dev->lock);
-		return -EINVAL;
-	}
 	/* Turn off Master source switch enable */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], MON_A_CTRL, &tmp);
 	value &= 0xFFFFFFDF;
 	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], MON_A_CTRL, value);
-
-	if (ret_val < 0) {
-		mutex_unlock(&dev->lock);
-		return -EINVAL;
-	}
+	if (ret_val < 0)
+		goto error;
 
 	mutex_unlock(&dev->lock);
 
@@ -817,31 +812,25 @@ int medusa_video_init(struct cx25821_dev *dev)
 	value &= 0xFF70FF70;
 	value |= 0x00090008;	/* set en_active */
 	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], DENC_AB_CTRL, value);
+	if (ret_val < 0)
+		goto error;
 
-	if (ret_val < 0) {
-		mutex_unlock(&dev->lock);
-		return -EINVAL;
-	}
 	/* enable input is VIP/656 */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], BYP_AB_CTRL, &tmp);
 	value |= 0x00040100;	/* enable VIP */
 	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], BYP_AB_CTRL, value);
 
-	if (ret_val < 0) {
-		mutex_unlock(&dev->lock);
-		return -EINVAL;
-	}
+	if (ret_val < 0)
+		goto error;
+
 	/* select AFE clock to output mode */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], AFE_AB_DIAG_CTRL, &tmp);
 	value &= 0x83FFFFFF;
-	ret_val =
-	    cx25821_i2c_write(&dev->i2c_bus[0], AFE_AB_DIAG_CTRL,
-			      value | 0x10000000);
+	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], AFE_AB_DIAG_CTRL,
+				    value | 0x10000000);
+	if (ret_val < 0)
+		goto error;
 
-	if (ret_val < 0) {
-		mutex_unlock(&dev->lock);
-		return -EINVAL;
-	}
 	/* Turn on all of the data out and control output pins. */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], PIN_OE_CTRL, &tmp);
 	value &= 0xFEF0FE00;
@@ -868,9 +857,9 @@ int medusa_video_init(struct cx25821_dev *dev)
 	mutex_unlock(&dev->lock);
 
 	ret_val = medusa_set_videostandard(dev);
+	return ret_val;
 
-	if (ret_val < 0)
-		return -EINVAL;
-
-	return 1;
+error:
+	mutex_unlock(&dev->lock);
+	return ret_val;
 }

Conexant E-mail Firewall (Conexant.Com) made the following annotations
---------------------------------------------------------------------
********************** Legal Disclaimer **************************** 

"This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 

********************************************************************** 

---------------------------------------------------------------------

