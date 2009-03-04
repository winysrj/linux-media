Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:57419 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbZCDABE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 19:01:04 -0500
Date: Tue, 3 Mar 2009 18:12:33 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Kyle Guinn <elyk03@gmail.com>
cc: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: RFC on proposed patches to mr97310a.c for gspca and v4l
In-Reply-To: <200902171907.40054.elyk03@gmail.com>
Message-ID: <alpine.LNX.2.00.0903031746030.21483@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <200902171907.40054.elyk03@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans, Jean-Francois, and Kyle,

The proposed patches are not very long, so I will give each of them, with 
my comments after each, to explain why I believe that these changes are a 
good idea.

First, the patch to libv4lconvert is short and sweet:

contents of file mr97310av4l.patch follow
----------------------------------------------
--- mr97310a.c.old	2009-03-01 15:37:38.000000000 -0600
+++ mr97310a.c.new	2009-02-18 22:39:48.000000000 -0600
@@ -102,6 +102,9 @@ void v4lconvert_decode_mr97310a(const un
  	if (!decoder_initialized)
  		init_mr97310a_decoder();

+	/* remove the header */
+	inp += 12;
+
  	bitpos = 0;

  	/* main decoding loop */

----------------- here ends the v4lconvert patch ------------------

The reason I want to do this should be obvious. It is to preserve the 
entire header of each frame over in the gspca driver, and to throw it away 
over here. The SOF marker FF FF 00 FF 96 is also kept. The reason why all 
of this should be kept is that it makes it possible to look at a raw 
output and to know if it is exactly aligned or not. Furthermore, the next 
byte after the 96 is a code for the compression algorithm used, and the 
bytes after that in the header might be useful in the future for better 
image processing. In other words, these headers contain information which 
might be useful in the future and they should not be jettisoned in the 
kernel module.

Now, the kernel module ought to keep and send along the header and SOF 
marker instead of throwing them away. This is the topic of the next patch. 
It also has the virtue of simplifying and shortening the code in the 
module at the same time, because one is not going through contortions to 
skip over and throw away some data which ought to be kept anyway.

contents of file mr97310a.patch follow, for gspca/mr97310a.c
--------------------------------------------------------
--- mr97310a.c.old	2009-02-23 23:59:07.000000000 -0600
+++ mr97310a.c.new	2009-03-03 17:19:06.000000000 -0600
@@ -302,21 +302,9 @@ static void sd_pkt_scan(struct gspca_dev
  					data, n);
  		sd->header_read = 0;
  		gspca_frame_add(gspca_dev, FIRST_PACKET, frame, NULL, 0);
-		len -= sof - data;
-		data = sof;
-	}
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
+		/* keep the header, including sof marker, for coming frame */
+		len -= n;
+		data = sof - sizeof pac_sof_marker;;
  	}

  	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
@@ -337,6 +325,7 @@ static const struct sd_desc sd_desc = {
  /* -- module initialisation -- */
  static const __devinitdata struct usb_device_id device_table[] = {
  	{USB_DEVICE(0x08ca, 0x0111)},
+	{USB_DEVICE(0x093a, 0x010f)},
  	{}
  };
  MODULE_DEVICE_TABLE(usb, device_table);


------------ end of mr97310a.patch -------------------------

You will also notice that I have added a USB ID. As I have mentioned, I 
have four cameras with this ID. The story with them is that two of them 
will not work at all. The module will not initialize the camera. As far as 
the other two of them are concerned, the module and the accompanying 
change in libv4lconvert work very well. I have mentioned this previously, 
and I did not get any comment about what is good to do. So now I decided 
to submit the ID number in the patch.

Theodore Kilgore
