Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:33348 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751787AbdAZHQY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jan 2017 02:16:24 -0500
Received: by mail-lf0-f42.google.com with SMTP id x1so54336041lff.0
        for <linux-media@vger.kernel.org>; Wed, 25 Jan 2017 23:16:23 -0800 (PST)
Date: Thu, 26 Jan 2017 08:16:20 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: odd kernel messages when running v4l2-compliance
Message-ID: <20170126071620.GD20610@bigcity.dyn.berto.se>
References: <20170125191540.GC20610@bigcity.dyn.berto.se>
 <b7898c02-9ac3-eaf9-9b17-35e86bd0ef5f@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b7898c02-9ac3-eaf9-9b17-35e86bd0ef5f@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-01-25 21:38:05 +0100, Hans Verkuil wrote:
> On 01/25/2017 08:15 PM, Niklas Söderlund wrote:
> > Hi Hans,
> > 
> > I have noticed an odd printout when running v4l2-compliance while 
> > testing the rcar-vin driver. When testing (v4l2-compliance -d 0) on 
> > ARM64 I see the following messages:
> > 
> > [ 1411.016069] compat_ioctl32: unexpected VIDIOC_FMT1 type 0
> > [ 1411.022981] compat_ioctl32: unexpected VIDIOC_FMT1 type 128
> > [ 1411.033152] compat_ioctl32: unexpected VIDIOC_FMT1 type 128
> > [ 1411.043283] compat_ioctl32: unexpected VIDIOC_FMT1 type 128
> > 
> > Running the same rcar-vin driver on ARM and I see no such messages.  
> > There can of course be problems with my driver but after digging around
> > a bit I'm a bit confused, maybe you can help me understand where the 
> > true problem is.
> > 
> > In the kernel the messages originate from __get_v4l2_format32() in
> > drivers/media/v4l2-core/v4l2-compat-ioctl32.c and they are printed if 
> > the format type is unknown, that is is not one of the specified ones in 
> > a switch statement. That is all entries of enum v4l2_buf_type except 
> > V4L2_BUF_TYPE_PRIVATE.
> > 
> >     enum v4l2_buf_type {
> >             V4L2_BUF_TYPE_VIDEO_CAPTURE        = 1,
> >             V4L2_BUF_TYPE_VIDEO_OUTPUT         = 2,
> >             V4L2_BUF_TYPE_VIDEO_OVERLAY        = 3,
> >             V4L2_BUF_TYPE_VBI_CAPTURE          = 4,
> >             V4L2_BUF_TYPE_VBI_OUTPUT           = 5,
> >             V4L2_BUF_TYPE_SLICED_VBI_CAPTURE   = 6,
> >             V4L2_BUF_TYPE_SLICED_VBI_OUTPUT    = 7,
> >             V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY = 8,
> >             V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE = 9,
> >             V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 10,
> >             V4L2_BUF_TYPE_SDR_CAPTURE          = 11,
> >             V4L2_BUF_TYPE_SDR_OUTPUT           = 12,
> >             /* Deprecated, do not use */
> >             V4L2_BUF_TYPE_PRIVATE              = 0x80,
> >     };
> > 
> > 
> > In v4l2-compliance the message is trigged inside testGetFormats() from 
> > utils/v4l2-compliance/v4l2-test-formats.cpp by:
> > 
> >     for (type = 0; type <= V4L2_BUF_TYPE_LAST; type++) {
> >             createInvalidFmt(fmt, clip, type);
> >             ret = doioctl(node, VIDIOC_G_FMT, &fmt);
> > 
> >             ....
> >     }
> > 
> > Here V4L2_BUF_TYPE_LAST is defined to V4L2_BUF_TYPE_SDR_OUTPUT and the 
> > enum struct is the same as in the kernel since it's included from 
> > include/linux/videodev2.h. One format is created with type = 0 and one 
> > with type = 128 which is why the messages gets printed by the kernel.
> > 
> > Is this something I should somehow handle in my driver (I can't see how 
> > I could even do that)? Or is it expected that v4l2-compliance
> > should provoke this messages in order to test the API and I should not 
> > worry about the messages when using v4l2-compliance?
> > 
> 
> Those messages really should be pr_debug instead of pr_info. The idea is
> that when a new format type is added, then that should also be supported
> in the 32-bit compat code. The warning helps identifying this.
> 
> However, the compliance test has a few tests with incorrect type values to
> check that the driver handle those correctly (returns EINVAL), so those
> tests trigger the compat code messages.
> 
> It's harmless, and you only get them when running a 32-bit v4l2-compliance
> on a 64-bit system.

I see, thanks for the explanation. I guess this is what I get for being 
lazy and reusing my 32-bit NFS root on my 64-bit systems :-)

> 
> Regards,
> 
> 	Hans

-- 
Regards,
Niklas Söderlund
