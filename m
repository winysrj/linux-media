Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:58577 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbZCFCVy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 21:21:54 -0500
Received: from banach.math.auburn.edu (localhost [127.0.0.1])
	by banach.math.auburn.edu (8.14.2/8.14.2) with ESMTP id n262YRj6028575
	for <linux-media@vger.kernel.org>; Thu, 5 Mar 2009 20:34:27 -0600
Received: from localhost (kilgota@localhost)
	by banach.math.auburn.edu (8.14.3/8.14.2/Submit) with ESMTP id n262YRvu028572
	for <linux-media@vger.kernel.org>; Thu, 5 Mar 2009 20:34:27 -0600
Date: Thu, 5 Mar 2009 20:34:27 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: linux-media@vger.kernel.org
Subject: [PATCH] for the file gspca/mr97310a.c
Message-ID: <alpine.LNX.2.00.0903052031490.28557@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


First time ever that I mouse-copied an address and it gained a typo. 
Amazing. So trying again. The patch works better than the mouse, though. 
Guaranteed.

---------- Forwarded message ----------
Date: Thu, 5 Mar 2009 20:09:52 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Hans de Goede <hdegoede@redhat.com>
Cc: Kyle Guinn <elyk03@gmail.com>, Jean-Francois Moine <moinejf@free.fr>,
     linux-mmedia@vger.kernel.org
Subject: [PATCH] for the file gspca/mr97310a.c


I just realized that the message below only went in one direction and did not 
have the proper title. So I fix that, now. The purpose of the patch has been 
extensively discussed in the thread seen in the title of the forwarded message. 
The patch below improves on the previous patch submitted for discussion, by 
fixing a bug in that one. The purpose of the patch is to save the header for 
the raw frames from the MR97310a cameras, which previously was not done. The 
patch achieves this result, and, when tested with two cameras, gives nice 
results.

A parallel patch for libv4lconvert/mr97310a.c was also presented in the RFC. 
Needless to say, it is needed simultaneously, before the output from the camera 
can be properly decompressed.

Theodore Kilgore

---------- Forwarded message ----------
Date: Thu, 5 Mar 2009 19:27:57 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l



On Fri, 6 Mar 2009, Hans de Goede wrote:

> Well 2.6.29 is getting closer, so we need to be reasonable quick with the
> kernel side changes. As we do not want to change this after a kernel
> has been released with the current behaviour.
> 
> For libv4l we can take our time. But having a kernel patch ready soon
> would be good.

Well, it did not take as long as I thought. And, as far as the libv4lconvert 
change, you _do_ have a patch, right?

So, here is a patch for one file, namely for gspca/mr97310a.c. I hope that it 
will meet all objections.

Signed-off-by: Theodore Kilgore <kilgota@auburn.edu>
----------------------------------------------------------------------
--- mr97310a.c.old	2009-02-23 23:59:07.000000000 -0600
+++ mr97310a.c	2009-03-05 19:14:13.000000000 -0600
@@ -29,9 +29,7 @@ MODULE_LICENSE("GPL");
  /* specific webcam descriptor */
  struct sd {
  	struct gspca_dev gspca_dev;  /* !! must be the first item */
-
  	u8 sof_read;
-	u8 header_read;
  };

  /* V4L2 controls supported by the driver */
@@ -100,12 +98,9 @@ static int sd_init(struct gspca_dev *gsp

  static int sd_start(struct gspca_dev *gspca_dev)
  {
-	struct sd *sd = (struct sd *) gspca_dev;
  	__u8 *data = gspca_dev->usb_buf;
  	int err_code;

-	sd->sof_read = 0;
-
  	/* Note:  register descriptions guessed from MR97113A driver */

  	data[0] = 0x01;
@@ -285,40 +280,29 @@ static void sd_pkt_scan(struct gspca_dev
  			__u8 *data,                   /* isoc packet */
  			int len)                      /* iso packet length */
  {
-	struct sd *sd = (struct sd *) gspca_dev;
  	unsigned char *sof;

  	sof = pac_find_sof(gspca_dev, data, len);
  	if (sof) {
  		int n;
-
+		int marker_len = sizeof pac_sof_marker;
  		/* finish decoding current frame */
  		n = sof - data;
-		if (n > sizeof pac_sof_marker)
-			n -= sizeof pac_sof_marker;
+		if (n > marker_len)
+			n -= marker_len;
  		else
  			n = 0;
  		frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame,
  					data, n);
-		sd->header_read = 0;
-		gspca_frame_add(gspca_dev, FIRST_PACKET, frame, NULL, 0);
-		len -= sof - data;
+		/* Start next frame. */
+		gspca_frame_add(gspca_dev, FIRST_PACKET, frame,
+			pac_sof_marker, marker_len);
+		len -= n;
+		len -= marker_len;
+		if (len < 0)
+			len = 0;
  		data = sof;
  	}
-	if (sd->header_read < 7) {
-		int needed;
-
-		/* skip the rest of the header */
-		needed = 7 - sd->header_read;
-		if (len <= needed) {
-			sd->header_read += len;
-			return;
-		}
-		data += needed;
-		len -= needed;
-		sd->header_read = 7;
-	}
-
  	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
  }

@@ -337,6 +321,7 @@ static const struct sd_desc sd_desc = {
  /* -- module initialisation -- */
  static const __devinitdata struct usb_device_id device_table[] = {
  	{USB_DEVICE(0x08ca, 0x0111)},
+	{USB_DEVICE(0x093a, 0x010f)},
  	{}
  };
  MODULE_DEVICE_TABLE(usb, device_table);
