Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3MEQ6ZH013779
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 10:26:06 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3MEPjQG008970
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 10:25:50 -0400
Received: by py-out-1112.google.com with SMTP id a29so2569182pyi.0
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 07:25:45 -0700 (PDT)
Date: Tue, 22 Apr 2008 07:25:33 -0700
From: Brandon Philips <brandon@ifup.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20080422142533.GH7392@plankton.ifup.org>
References: <op.t3hn72busxcvug@mrubli-nb.am.logitech.com>
	<20080415001932.52039d0f@gaivota>
	<20080422022221.GE7392@plankton.ifup.org>
	<200804221040.30350.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804221040.30350.laurent.pinchart@skynet.be>
Cc: linux1@rubli.info, Martin Rubli <v4l2-lists@rubli.info>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Support for write-only controls
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On 10:40 Tue 22 Apr 2008, Laurent Pinchart wrote:
> On Tuesday 22 April 2008 04:22, Brandon Philips wrote:
> > On 00:19 Tue 15 Apr 2008, Mauro Carvalho Chehab wrote:
> > > Brandon, Could you please add this on one of your trees, together with
> > > those pending V4L2 API patches for UVC? I want to merge those changes
> > > together with the in-kernel driver that firstly requires such changes.
> > 
> > I have a tree with the change sets.  Please don't pull from the tip
> > though: hg pull -r 4ca1ed646f89 http://ifup.org/hg/v4l-uvc
> > 
> > The tip of that tree has UVC and all of the Kconfig/Makefile bits too.
> > 
> > The patch set for the tree: http://ifup.org/hg/uvc-v4l-patches
> > 
> > If Laurent wants to add his sign off to that last patch (based on r204)
> > we can commit that too :D
> 
> I want the driver to be properly reviewed on both video4linux-list and 
> linux-usb. I will post a patch on both mailing lists today.

Certainly :D

I put the UVC patch on my tree just to ensure I got all the right bits
together ;)

> Thanks for taking care of the Kconfig/Makefile bits. Could you send
> them to me so that I can include them in the patch to be reviewed ?

Signed-off-by: Brandon Philips <bphilips@suse.de>

--- a/linux/drivers/media/video/Kconfig
+++ b/linux/drivers/media/video/Kconfig
@@ -741,6 +741,14 @@ menuconfig V4L_USB_DRIVERS
 
 if V4L_USB_DRIVERS && USB
 
+config USB_UVC
+	tristate "USB Video Class (UVC)"
+	---help---
+	  Support for the USB Video Class (UVC).  Currently only video
+	  input devices, such as webcams, are supported.
+
+	  For more information see: <http://linux-uvc.berlios.de/>
+
 source "drivers/media/video/pvrusb2/Kconfig"
 
 source "drivers/media/video/em28xx/Kconfig"
--- a/linux/drivers/media/video/Makefile
+++ b/linux/drivers/media/video/Makefile
@@ -144,6 +144,8 @@ obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m
 obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
 obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
 
+obj-$(CONFIG_USB_UVC) += uvc/
+
 obj-$(CONFIG_VIDEO_AU0828) += au0828/
 
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
--- /dev/null
+++ b/linux/drivers/media/video/uvc/Makefile
@@ -0,0 +1,3 @@
+uvcvideo-objs  := uvc_driver.o uvc_queue.o uvc_v4l2.o uvc_video.o uvc_ctrl.o\
+			uvc_status.o uvc_isight.o
+obj-$(CONFIG_USB_UVC) := uvcvideo.o

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
