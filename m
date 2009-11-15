Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:51079 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZKOAM3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Nov 2009 19:12:29 -0500
Date: Sat, 14 Nov 2009 18:31:23 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: linux-media@vger.kernel.org
Subject: [PATCH] which fixes "works on OHCI and fails on UHCI" problem for
 mr97310a cameras
In-Reply-To: <4AFE7702.90004@redhat.com>
Message-ID: <alpine.LNX.2.00.0911141804210.4326@banach.math.auburn.edu>
References: <alpine.LNX.2.00.0911132134550.3455@banach.math.auburn.edu> <20091114042409.GA28964@kroah.com> <4AFE7702.90004@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hans,

If you read the mail to Oliver Neukum on the linux-usb list, then you know 
that I found a cure for the mysterious problem that the MR97310a CIF 
"type 1" cameras have been freezing up and refusing to stream if hooked 
up to a machine with a UHCI controller.

Namely, the cure is that if the camera is an mr97310a CIF type 1 camera, 
you have to send it 0xa0, 0x00. Somehow, this is a timing reset command, 
or such. It un-blocks whatever was previously stopping the CIF type 1 
cameras from working on the UHCI-based machines.

I have made a patch from your tree, which is below. I think that you 
should use all efforts to get your version of mr97310a.c with this patch 
applied to it, into upstream immediately. For, it fixes the 
rather nasty problem that the CIF type 1 cameras refuse to stream on a 
machine with a UHCI-based controller.

Fixing that problem is on top of the fact that the code which is at 
present in 2.6.32-rc6 uses the old detection scheme for the sensor type of 
the camera and is inferior in several other aspects, too. Therefore, I 
strongly support the idea of replacing the file gspca/mr97310a.c in 
2.6.32-rc6 with the patched version of the file from your tree.

As I said, the patch is based upon the code in your tree, not upon the 
version which is in 2.6.32-rc6. But the resulting version of mr97310a.c 
has been tested here on several machines, including one  running 
2.6.32-rc6 which has a UHCI controller inside. And it works nicely on all 
of them.

Theodore Kilgore

Signed off by: Theodore Kilgore <kilgota@auburn.edu>
-------------------------------------------------------------------------

diff -r 577440e8b8df linux/drivers/media/video/gspca/mr97310a.c
--- a/linux/drivers/media/video/gspca/mr97310a.c        Sun Nov 01 
17:09:15 2009 +0100
+++ b/linux/drivers/media/video/gspca/mr97310a.c        Sat Nov 14 
16:32:18 2009 -0600
@@ -697,6 +697,11 @@
                         {0x13, 0x00, {0x01}, 1},
                         {0, 0, {0}, 0}
                 };
+               /* Without this command the cam won't work with USB-UHCI 
*/
+               gspca_dev->usb_buf[0] = 0x0a;
+               gspca_dev->usb_buf[1] = 0x00;
+               if (mr_write(gspca_dev, 2) < 0)
+                       PDEBUG(D_ERR, "start_cif_cam fails");
                 err_code = sensor_write_regs(gspca_dev, 
cif_sensor1_init_data,

ARRAY_SIZE(cif_sensor1_init_data));
         }


