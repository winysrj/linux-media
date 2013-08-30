Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:42113
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754787Ab3H3QkZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 12:40:25 -0400
Message-ID: <5220CADF.5050805@licor.com>
Date: Fri, 30 Aug 2013 11:39:59 -0500
From: Darryl <ddegraff@licor.com>
MIME-Version: 1.0
To: <linux-media@vger.kernel.org>,
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: davinci vpif_capture
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am working on an application involving the davinci using the vpif.  My 
board file has the inputs configured to use VPIF_IF_RAW_BAYER if_type.
When my application starts up, I have it enumerate the formats 
(VIDIOC_ENUM_FMT) and it indicates that the only available format is 
"YCbCr4:2:2 YC Planar" (from vpif_enum_fmt_vid_cap).  It looks to me 
that the culprit is vpif_open().

struct channel_obj.vpifparams.iface is initialized at vpif_probe() time 
in the function vpif_set_input.  Open the device file (/dev/video0) 
overwrites this.  I suspect that it is __not__ supposed to do this, 
since I don't see any method for restoring the iface.

I'm using linux-3.10.4, but the problem appears in 3.10.9, 3.11.rc7 and 
a version I checked out at 
https://git.kernel.org/cgit/linux/kernel/git/nsekhar/linux-davinci.git. 
I have supplied a patch for 3.10.9.


diff -pubwr 
linux-3.10.9-pristine/drivers/media/platform/davinci/vpif_capture.c 
linux-3.10.9/drivers/media/platform/davinci/vpif_capture.c
--- linux-3.10.9-pristine/drivers/media/platform/davinci/vpif_capture.c 
  2013-08-20 17:40:47.000000000 -0500
+++ linux-3.10.9/drivers/media/platform/davinci/vpif_capture.c 
  2013-08-30 11:18:29.000000000 -0500
@@ -914,9 +914,11 @@ static int vpif_open(struct file *filep)
      fh->initialized = 0;
      /* If decoder is not initialized. initialize it */
      if (!ch->initialized) {
+        struct vpif_interface iface = ch->vpifparams.iface;
          fh->initialized = 1;
          ch->initialized = 1;
          memset(&(ch->vpifparams), 0, sizeof(struct vpif_params));
+        ch->vpifparams.iface = iface;
      }
      /* Increment channel usrs counter */
      ch->usrs++;




