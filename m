Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:38942 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965515AbbD1NDV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 09:03:21 -0400
From: Fabien DESSENNE <fabien.dessenne@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Tue, 28 Apr 2015 15:00:25 +0200
Subject: RE: [PATCH 0/3] Add media bdisp driver for stihxxx platforms
Message-ID: <15ED7CB7B68B4D4C96C7D27A1A23941201B88660D7@SAFEX1MAIL2.st.com>
References: <1430150204-22944-1-git-send-email-fabien.dessenne@st.com>
 <553E630F.40001@xs4all.nl>
In-Reply-To: <553E630F.40001@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for your quick feedback.
I have read your remarks and I shall be able to take care of all of them.
I need some rework days now.

Regarding v4l2-compliance (latest), here is the current status summary.
v4l2-compliance (no option) returns:
"Total: 42, Succeeded: 42, Failed: 0, Warnings: 12".
The 12 warnings are all about the same which is highlighted here:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
I do not think this is really an issue so I do not plan to fix it.
If you disagree, please let me know!

Running "v4l2-compliance -s" returns 1 Failed TC (querybuf). I will investigate
this.

Running "v4l2-compliance -f" returns:
"Total: 42, Succeeded: 42, Failed: 0, Warnings: 12".
(Stream using all formats: Not supported for M2M devices)

Anyway, I will run again v4l2-compliance with the reworked driver and
let you know about the detailed status.

BR
Fabien

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: lundi 27 avril 2015 18:26
> To: Fabien DESSENNE; linux-media@vger.kernel.org
> Cc: Benjamin Gaignard
> Subject: Re: [PATCH 0/3] Add media bdisp driver for stihxxx platforms
> 
> Hi Fabien,
> 
> Thank you for this driver! Good to see V4L2 support for this SoC.
> 
> I did a quick initial scan over the driver and there are a few things that need
> to be addressed:
> 
> - I think bdisp as the driver name is a bit generic, perhaps something like
>   stih4xx-bdisp might be more appropriate. Similar to the exynos-* drivers.
> 
> - Replace cropcap/g_crop/s_crop by the g/s_selection ioctls. The old ioctls
>   are no longer supported for new drivers (the v4l2 core will automatically
>   add support for those ioctls if g/s_selection is implemented in the driver).
>   Read careful how crop and compose rectangles are used in a m2m device. I
>   would expect that you implement cropping for the
> BUF_TYPE_VIDEO_OUTPUT side
>   (i.e. memory to hardware) and implement composing for the
> BUF_TYPE_VIDEO_CAPTURE
>   side (i.e. hardware to memory).
> 
>   If the hardware also support composition for output or cropping for capture,
>   then let me know: in that case you will likely have to implement support for
>   V4L2_SEL_TGT_NATIVE_SIZE as well.
> 
> - Several ioctl and fop helpers were added to media/v4l2-mem2mem.h (e.g.
>   v4l2_m2m_ioctl_reqbufs, v4l2_m2m_fop_mmap, etc.). Use these instead
> of
>   rolling your own.
> 
> - I would like to see the output of these v4l2-compliance commands:
> 
> 	v4l2-compliance
> 	v4l2-compliance -s
> 	v4l2-compliance -f
> 
>   In all fairness: mem2mem devices are not often tested using v4l2-
> compliance
>   and there may be problems testing this (-f will likely fail), but I still
>   like to see the output so I know what works and what doesn't.
> 
>   Please use the latest v4l2-compliance code from the v4l-utils.git repository.
>   I won't accept the driver unless I see the results of these compliance tests:
>   running this is required for new drivers since it is a great way of verifying
>   the completeness of your driver.
> 
> Regards,
> 
> 	Hans
> 
> On 04/27/2015 05:56 PM, Fabien Dessenne wrote:
> > This series of patches adds the support of v4l2 2D blitter driver for
> > STMicroelectronics SOC.
> >
> > The following features are supported and tested:
> > - Color format conversion (RGB32, RGB24, RGB16, NV12, YUV420P)
> > - Copy
> > - Scale
> > - Flip
> > - Deinterlace
> > - Wide (4K) picture support
> > - Crop
> >
> > This driver uses the v4l2 mem2mem framework and its implementation
> was
> > largely inspired by the Exynos G-Scaler (exynos-gsc) driver.
> >
> > The driver is mainly implemented across two files:
> > - bdisp-v4l2.c
> > - bdisp-hw.c
> > bdisp-v4l2.c uses v4l2_m2m to manage the V4L2 interface with the
> > userland. It calls the HW services that are implemented in bdisp-hw.c.
> >
> > The additional bdisp-debug.c file manages some debugfs entries.
> >
> > Fabien Dessenne (3):
> >   [media] bdisp: add DT bindings documentation
> >   [media] bdisp: 2D blitter driver using v4l2 mem2mem framework
> >   [media] bdisp: add debug file system
> >
> >  .../devicetree/bindings/media/st,stih4xx.txt       |   32 +
> >  drivers/media/platform/Kconfig                     |   10 +
> >  drivers/media/platform/Makefile                    |    2 +
> >  drivers/media/platform/bdisp/Kconfig               |    9 +
> >  drivers/media/platform/bdisp/Makefile              |    3 +
> >  drivers/media/platform/bdisp/bdisp-debug.c         |  668 +++++++++
> >  drivers/media/platform/bdisp/bdisp-filter.h        |  346 +++++
> >  drivers/media/platform/bdisp/bdisp-hw.c            |  823 +++++++++++
> >  drivers/media/platform/bdisp/bdisp-reg.h           |  235 +++
> >  drivers/media/platform/bdisp/bdisp-v4l2.c          | 1492
> ++++++++++++++++++++
> >  drivers/media/platform/bdisp/bdisp.h               |  220 +++
> >  11 files changed, 3840 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/media/st,stih4xx.txt
> >  create mode 100644 drivers/media/platform/bdisp/Kconfig
> >  create mode 100644 drivers/media/platform/bdisp/Makefile
> >  create mode 100644 drivers/media/platform/bdisp/bdisp-debug.c
> >  create mode 100644 drivers/media/platform/bdisp/bdisp-filter.h
> >  create mode 100644 drivers/media/platform/bdisp/bdisp-hw.c
> >  create mode 100644 drivers/media/platform/bdisp/bdisp-reg.h
> >  create mode 100644 drivers/media/platform/bdisp/bdisp-v4l2.c
> >  create mode 100644 drivers/media/platform/bdisp/bdisp.h
> >

