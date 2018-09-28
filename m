Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:39198 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbeI1W3q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 18:29:46 -0400
Date: Fri, 28 Sep 2018 18:05:07 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        jacopo mondi <jacopo@jmondi.org>
Subject: Re: [PATCH v3 00/12] media: ov5640: Misc cleanup and improvements
Message-ID: <20180928160507.4jerbp4dqgz6l4qu@flea>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
 <b3bac06f-f4d6-7620-2c3d-f8a852920f56@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <b3bac06f-f4d6-7620-2c3d-f8a852920f56@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Thu, Sep 27, 2018 at 03:59:04PM +0000, Hugues FRUCHET wrote:
> Hi Maxime & all OV5640 stakeholders,
> 
> I've just pushed a new patchset also related to rate/pixel clock 
> handling [1], based on your V3 great work:
>  >    media: ov5640: Adjust the clock based on the expected rate
>  >    media: ov5640: Remove the clocks registers initialization
>  >    media: ov5640: Remove redundant defines
>  >    media: ov5640: Remove redundant register setup
>  >    media: ov5640: Compute the clock rate at runtime
>  >    media: ov5640: Remove pixel clock rates
>  >    media: ov5640: Enhance FPS handling
> 
> This is working perfectly fine on my parallel setup and allows me to 
> well support VGA@30fps (instead 27) and also support XGA(1024x768)@15fps 
> that I never seen working before.
> So at least for the parallel setup, this serie is working fine for all 
> the discrete resolutions and framerate exposed by the driver for the moment:
> * QCIF 176x144 15/30fps
> * QVGA 320x240 15/30fps
> * VGA 640x480 15/30fps
> * 480p 720x480 15/30fps
> * XGA 1024x768 15/30fps
> * 720p 1280x720 15/30fps
> * 1080p 1920x1080 15/30fps
> * 5Mp 2592x1944 15fps

I'm glad this is working for you as well. I guess I'll resubmit these
patches, but this time making sure someone with a CSI setup tests
before merging. I crtainly don't want to repeat the previous disaster.

Do you have those patches rebased somewhere? I'm not quite sure how to
fix the conflict with the v4l2_find_nearest_size addition.

> Moreover I'm not clear on relationship between rate and pixel clock 
> frequency.
> I've understood that to DVP_PCLK_DIVIDER (0x3824) register
> and VFIFO_CTRL0C (0x460c) affects the effective pixel clock frequency.
> All the resolutions up to 720x576 are forcing a manual value of 2 for 
> divider (0x460c=0x22), but including 720p and more, the divider value is 
> controlled by "auto-mode" (0x460c=0x20)... from what I measured and
> understood, for those resolutions, the divider must be set to 1 in order 
> that your rate computation match the effective pixel clock on output, 
> see [2].
> 
> So I wonder if this PCLK divider register should be included
> or not into your rate computation, what do you think ?

Have you tried change the PCLK divider while in auto-mode? IIRC, I did
that and it was affecting the PCLK rate on my scope, but I wouldn't be
definitive about it.

Can we always set the mode to auto and divider to 1, even for the
lower resolutions?

Maxime

-- 
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
