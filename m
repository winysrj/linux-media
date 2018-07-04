Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:41835 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752990AbeGDGdF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 02:33:05 -0400
Received: by mail-lf0-f65.google.com with SMTP id y127-v6so3463426lfc.8
        for <linux-media@vger.kernel.org>; Tue, 03 Jul 2018 23:33:04 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Wed, 4 Jul 2018 08:33:02 +0200
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 2/2] v4l: Add support for STD ioctls on subdev nodes
Message-ID: <20180704063302.GB5237@bigcity.dyn.berto.se>
References: <20180517143016.13501-1-niklas.soderlund+renesas@ragnatech.se>
 <20180517143016.13501-3-niklas.soderlund+renesas@ragnatech.se>
 <20180628083732.3679d730@coco.lan>
 <536a05bd-372e-a509-a6b6-0a3e916e48ae@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <536a05bd-372e-a509-a6b6-0a3e916e48ae@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, Hans

On 2018-06-28 14:47:05 +0200, Hans Verkuil wrote:
> On 06/28/18 13:37, Mauro Carvalho Chehab wrote:
> > Em Thu, 17 May 2018 16:30:16 +0200
> > Niklas Söderlund         <niklas.soderlund+renesas@ragnatech.se> escreveu:
> > 
> >> There is no way to control the standard of subdevices which are part of
> >> a media device. The ioctls which exists all target video devices
> >> explicitly and the idea is that the video device should talk to the
> >> subdevice. For subdevices part of a media graph this is not possible and
> >> the standard must be controlled on the subdev device directly.
> > 
> > Why isn't it possible? A media pipeline should have at least a video
> > devnode where the standard ioctls will be issued.
> 
> Not for an MC-centric device like the r-car or imx. It's why we have v4l-subdev
> ioctls for the DV_TIMINGS API, but the corresponding SDTV standards API is
> missing.

I can only agree with Hans here, we already have this subdevice API for 
DV_DIMINGS.

    #define VIDIOC_SUBDEV_S_DV_TIMINGS              _IOWR('V', 87, struct v4l2_dv_timings)
    #define VIDIOC_SUBDEV_G_DV_TIMINGS              _IOWR('V', 88, struct v4l2_dv_timings)
    #define VIDIOC_SUBDEV_ENUM_DV_TIMINGS           _IOWR('V', 98, struct v4l2_enum_dv_timings)
    #define VIDIOC_SUBDEV_QUERY_DV_TIMINGS          _IOR('V', 99, struct v4l2_dv_timings)
    #define VIDIOC_SUBDEV_DV_TIMINGS_CAP            _IOWR('V', 100, struct v4l2_dv_timings_cap)

And to me it both makes perfect sens to add this for SDTV ioctls and it 
solves a real use case for me. Currently on the R-Car Gen3 boards which 
uses a MC-centric model I have no way of controlling video standard of 
my CVBS input. The adv748x driver defaults to NTSC which means when I 
test using a PAL source I'm out of luck.

Without a change that allows controlling the video standard of the 
subdevice I don't see how this can be solved. As Hans have outlined 
using the video device node to control the subdevices is not how things 
are done for MC-centric setups.

Mauro, after the discussion in this thread are you willing to take this 
patch? If not I'm happy to keep working on scratching my itch, but a 
solution where the video device node is used to set the standard of the 
subdev I feel is the wrong way of doing things. Can you see a different  
solution to my issue that works in a MC-centric environment?

> 
> And in a complex scenario there is nothing preventing you from having multiple
> SDTV inputs, some of which need PAL-BG, some SECAM, some NTSC (less likely)
> which are all composed together (think security cameras or something like that).
> 
> You definitely cannot set the standard from a video device. If nothing else,
> it would be completely inconsistent with how HDMI inputs work.
> 
> The whole point of MC centric devices is that you *don't* control subdevs
> from video nodes.
> 
> Regards,
> 
> 	Hans
> 
> > So, I don't see why you would need to explicitly set the standard inside
> > a sub-device.
> > 
> > The way I see, inside a given pipeline, all subdevs should be using the
> > same video standard (maybe except for a m2m device with would have some
> > coded that would be doing format conversion).
> > 
> > Am I missing something?
> > 
> > Thanks,
> > Mauro
> > 
> 

-- 
Regards,
Niklas Söderlund
