Return-path: <mchehab@pedra>
Received: from rcdn-iport-8.cisco.com ([173.37.86.79]:33825 "EHLO
	rcdn-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab1GDJZK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 05:25:10 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [GIT PATCHES FOR 3.1] New SE401 driver + major pwc driver cleanup
Date: Mon, 4 Jul 2011 11:15:13 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E10CA67.1030906@redhat.com>
In-Reply-To: <4E10CA67.1030906@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107041115.13461.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

I have some notes:

On Sunday, July 03, 2011 22:00:39 Hans de Goede wrote:
> Hi All,
> 
> I'm happy to present my latest webcam work to you:
> 
> I could not just stand by watching the old v4l1 se401 driver
> (which has been broken for a long while btw) get removed
> from the kernel, without writing a replacement, so I'm
> happy to present a new, actually working, gspca based
> v4l2 driver for se401 based webcams :)
> 
> I've also wanted to do some much needed cleanups to the
> pwc driver for a long while. When I finally started with
> this I ended up with just replacing large parts with
> the new v4l2 framework, so after this patch set pwc
> now features:
> -videobuf2 for buffer management
> -ctrls handled by the control framework, including proper
>   setting inactive of foo controls when autofoo is on, etc.
> -new v4l2 controls for pan/tilt on models with pan/tilt
>   to replace the non standard sysfs interface for this
> 
> May I also point your attention to the
> feature-removal-schedule commit, which adds a whole bunch
> of custom pwc API's / ioctls for removal, since we can
> handle this all fine with v4l2. If you think some of
> these should not be removed speak up now, or hold
> your silence for ever :)
> 
> The following changes since commit 0c2ec360f0228bbc0c0eb6f115839d39fbbd9c61:
> 
>    [media] v4l2-event.h: add overview documentation to the header 
(2011-07-01 20:54:03 -0300)
> 
> are available in the git repository at:
>    git://linuxtv.org/hgoede/gspca.git media-for_v3.1
> 
> Hans Verkuil (1):
>        [media] v4l2-ctrls.c: add support for 
V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK
> 
> Hans de Goede (22):
>        videodev2.h Add SE401 compressed RGB format
>        gspca: reset image_len to 0 on LAST_PACKET when discarding frame
>        gspca: Add new se401 camera driver
>        gspca_sunplus: Fix streaming on logitech quicksmart 420
>        gspca: s/strncpy/strlcpy/
>        pwc: better usb disconnect handling
>        pwc: Remove a bunch of bogus sanity checks / don't return EFAULT 
wrongly
>        pwc: remove __cplusplus guards from private header
>        pwc: Replace private buffer management code with videobuf2
>        pwc: Fix non CodingStyle compliant 3 space indent in pwc.h
>        pwc: Get rid of error_status and unplugged variables
>        pwc: Remove some unused PWC_INT_PIPE left overs
>        pwc: Make power-saving a per device option
>        pwc: Move various initialization to driver load and / or stream start
>        pwc: Allow multiple opens

Snippet from this patch:

@@ -727,6 +740,9 @@ static int pwc_streamon(struct file *file, void *fh, enum 
v4l2_buf_type i)
        if (!pdev->udev)
                return -ENODEV;
 
+       if (pdev->capt_file != file)
+               return -EBUSY;
+
        return vb2_streamon(&pdev->vb_queue, i);
 }

This really needs to be codified in vb2. I'll see if I can do some work on 
this. Drivers need to keep track of this themselves at the moment, which 
varying degrees of success :-)

>        pwc: properly allocate dma-able memory for ISO buffers
>        pwc: Replace control code with v4l2-ctrls framework

The private controls should get their own range in videodev2.h. Something 
like:

/* Reserve range USER | 0x1000 to USER | 0x1020 for the pwc drivers */
#define V4L2_CID_USER_PWC_BASE  (V4L2_CTRL_CLASS_USER | 0x1000)

The control IDs themselves should be either added to videodev2.h or to a 
public pwc.h header.

I also wonder if most/all of these controls are not better done as camera 
controls (CLASS_CAMERA).

Regarding auto-whitebalance: this 'overwrites' the standard auto-whitebalance 
control: should we perhaps change the standard awb control instead to a menu? 
Or should we add a separate menu control for the lighting condition?

With respect to the autocluster part: that needs to be revisited. We need to 
clearly define acceptable behaviors on the part of the driver and codify that 
in the autocluster support of the framework. You have to do way too much work 
in the driver right now.

None of this prevents this series from being merged, BTW.

Another thing that needs to be looked at is the use of the priv field in
VIDIOC_S_FMT:

        if (f->fmt.pix.priv) {
                compression = (f->fmt.pix.priv & PWC_QLT_MASK) >> 
PWC_QLT_SHIFT;
                snapshot = !!(f->fmt.pix.priv & PWC_FPS_SNAPSHOT);
                fps = (f->fmt.pix.priv & PWC_FPS_FRMASK) >> PWC_FPS_SHIFT;
                if (fps == 0)
                        fps = pdev->vframes;
        }

I think at least the fps part should be done through G/S_PARM. What the others 
do is not clear to me.

Regards,

	Hans

>        pwc: Allow dqbuf / read to complete while waiting for controls
>        pwc: Add v4l2 controls for pan/tilt on Logitech QuickCam Orbit/Sphere
>        pwc: Add a bunch of pwc custom API to feature-removal-schedule.txt
>        pwc: Enable power-management by default on tested models
>        pwc: clean-up header files
> 
>   Documentation/DocBook/media/v4l/pixfmt.xml         |    5 +
>   .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   36 +-
>   Documentation/feature-removal-schedule.txt         |   35 +
>   drivers/media/video/gspca/Kconfig                  |   10 +
>   drivers/media/video/gspca/Makefile                 |    2 +
>   drivers/media/video/gspca/gspca.c                  |   11 +-
>   drivers/media/video/gspca/se401.c                  |  774 +++++++++++
>   drivers/media/video/gspca/se401.h                  |   90 ++
>   drivers/media/video/gspca/sunplus.c                |    3 -
>   drivers/media/video/gspca/t613.c                   |    2 +-
>   drivers/media/video/pwc/Kconfig                    |    1 +
>   drivers/media/video/pwc/pwc-ctrl.c                 |  805 ++----------
>   drivers/media/video/pwc/pwc-dec1.c                 |   28 +-
>   drivers/media/video/pwc/pwc-dec1.h                 |    8 +-
>   drivers/media/video/pwc/pwc-dec23.c                |   22 -
>   drivers/media/video/pwc/pwc-dec23.h                |   10 -
>   drivers/media/video/pwc/pwc-if.c                   | 1399 
++++++--------------
>   drivers/media/video/pwc/pwc-ioctl.h                |  322 -----
>   drivers/media/video/pwc/pwc-kiara.c                |    1 -
>   drivers/media/video/pwc/pwc-misc.c                 |    4 -
>   drivers/media/video/pwc/pwc-uncompress.c           |   17 +-
>   drivers/media/video/pwc/pwc-uncompress.h           |   40 -
>   drivers/media/video/pwc/pwc-v4l.c                  | 1256 
+++++++++++--------
>   drivers/media/video/pwc/pwc.h                      |  404 +++---
>   drivers/media/video/v4l2-ctrls.c                   |    3 +-
>   include/linux/videodev2.h                          |    4 +-
>   26 files changed, 2473 insertions(+), 2819 deletions(-)
>   create mode 100644 drivers/media/video/gspca/se401.c
>   create mode 100644 drivers/media/video/gspca/se401.h
>   delete mode 100644 drivers/media/video/pwc/pwc-ioctl.h
>   delete mode 100644 drivers/media/video/pwc/pwc-uncompress.h
> 
> Regards,
> 
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
