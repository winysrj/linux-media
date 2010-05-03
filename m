Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975Ab0ECHjg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 May 2010 03:39:36 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o437dZBK029087
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 3 May 2010 03:39:35 -0400
Received: from [10.3.224.13] (vpn-224-13.phx2.redhat.com [10.3.224.13])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o437dW06000692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 3 May 2010 03:39:34 -0400
Message-ID: <4BDE7DB4.7030706@redhat.com>
Date: Mon, 03 May 2010 04:39:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "linux-media >> Linux Media Mailing List"
	<linux-media@vger.kernel.org>
Subject: [PATCH] Fix colorspace on tm6010
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The enclosed patch fixes the color format on tm6010. What happened is that the patch
adding fourcc control on tm6010 had one small cut-and-paste trouble: it was
changing the wrong register ;)

I've fixed it. So, now, colors are working fine. I'll be applying it at my git. This
way, the current git contains a tm6000 code that is not so bad.

With this patch, analog video on tm6000/tm6010 are working again (but see the
patch comments bellow). Yet, there are a large number of TODO items for this driver:
- Fix the loss of some blocks when receiving the URB's;
- Add a lock at tm6000_read_write_usb() to prevent two simultaneous access to the
URB control transfers;
- Properly add the locks at tm6000-video;
- Add audio support;
- Add IR support;
- Do several cleanups;
- I think that frame1/frame0 are inverted. This causes a funny effect at the image.
  the fix is trivial, but require some tests.
- My tm6010 devices sometimes insist on stop working. I need to turn them off, removing
  from my machine and wait for a while for it to work again. I'm starting to think that
  it is an overheat issue;
- Sometimes, tm6010 doesn't read eeprom at the proper time (hardware bug). So, the device 
  got miss-detected as a "generic" tm6000. This can be really bad if the tuner is the 
  Low Power one, as it may result on loading the high power firmware, that could damage 
  the device. Maybe we may read eeprom to double check, when the device is marked as "generic".
- Coding Style fixes;

I'll be committing a patch with the above TODO items at tm6000/README

(Bee/Stefan/Dmitri, feel free to add more things at the todo - We need to write a README file

The lack of locks still generate some OOPS'es, but I was not able of get any Panic. So,
I'll likely add it at upstream drivers/staging at the next merge window.

-- 

Cheers,
Mauro


commit c621ed883a26dc705c38ad698f6a19a6260f172f
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Mon May 3 04:25:59 2010 -0300

    V4L/DVB: Fix color format with tm6010
    
    The values for the fourcc format were correct, but applied to the
    wrong register. With this change, video is now barely working again with
    tm6000.
    
    While here, let's remove, for now, the memset. This way, people can
    have some image when testing this device.
    
    Yet to be fixed: parts of the image frame are missed. As we don't clean
    the buffers anymore, this is "recovered" by repeating the values from a
    previous frame. The quality is bad, since the image pixels will contain
    data from some previous frames, generating weird delay artifacts.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 860553f..bfbc53b 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -156,10 +156,13 @@ int tm6000_get_reg32 (struct tm6000_core *dev, u8 req, u16 value, u16 index)
 void tm6000_set_fourcc_format(struct tm6000_core *dev)
 {
 	if (dev->dev_type == TM6010) {
+		int val;
+
+		val = tm6000_get_reg(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0) & 0xfc;
 		if (dev->fourcc == V4L2_PIX_FMT_UYVY)
-			tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0xd0);
+			tm6000_set_reg(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, val);
 		else
-			tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0x90);
+			tm6000_set_reg(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, val | 1);
 	} else {
 		if (dev->fourcc == V4L2_PIX_FMT_UYVY)
 			tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0xd0);
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 4444487..9554472 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -149,8 +149,8 @@ static inline void get_next_buf(struct tm6000_dmaqueue *dma_q,
 
 	/* Cleans up buffer - Usefull for testing for frame/URB loss */
 	outp = videobuf_to_vmalloc(&(*buf)->vb);
-	if (outp)
-		memset(outp, 0, (*buf)->vb.size);
+//	if (outp)
+//		memset(outp, 0, (*buf)->vb.size);
 
 	return;
 }
