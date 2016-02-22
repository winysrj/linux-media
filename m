Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35254 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbcBVPQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 10:16:39 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
	<niklas.soderlund@ragnatech.se>
Cc: Ulrich Hecht <ulrich.hecht@gmail.com>, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [RFC/PATCH] [media] rcar-vin: add Renesas R-Car VIN IP core
Date: Mon, 22 Feb 2016 17:17:19 +0200
Message-ID: <4002725.0WTZZGiC9K@avalon>
In-Reply-To: <20160222143616.GD3442@bigcity.dyn.berto.se>
References: <1455468932-8573-1-git-send-email-niklas.soderlund+renesas@ragnatech.se> <CAO3366xjUHVYmFJhovZp=WqsWyZAjEsOps1exSqhemdtqu-=Nw@mail.gmail.com> <20160222143616.GD3442@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Monday 22 February 2016 15:36:16 Niklas Söderlund wrote:
> On 2016-02-22 14:31:29 +0100, Ulrich Hecht wrote:
> > On Sun, Feb 14, 2016 at 5:55 PM, Niklas Söderlund
> > 
> > <niklas.soderlund+renesas@ragnatech.se> wrote:
> > > Also I
> > > could only get frames if the video signal on the composite IN was NTSC,
> > > but this also applied to the soc_camera driver, it might be my test
> > > setup.
> > 
> > I think it is.  For me, PAL works just as well as NTSC.
> 
> Yes it must have been my setup, I'm now using a PAL SNES as my video
> source and it works fine. I'm about ready to send out a v2 of this patch
> with all of Hans comments fixed. I only need to look at
> vidioc_[gs]_selection.

I think we need an SNES screenshot as a proof ;-)

> It took some extra time since I found some bugs in how I handled DMA and
> that I had been to libera in porting the format code from soc-camera.
> It's all fixed and all v4l2-compliance tests I tried works.
> 
> One concern I have is that I can't get some of the formats to display
> properly in qv4l2 (V4L2_PIX_FMT_NV16, V4L2_PIX_FMT_RGB555X,
> V4L2_PIX_FMT_RGB32) but I get the same 'errors' in the feed as I do with
> the soc-camera driver so I'm not spending so much time on the issue right
> now.

What errors do you get ?

> Unfortunate the rework I have done clashes with your HDMI series Ulrich.
> If you wish I can rework the parts of your series that touches rcar-vin
> and post them as a separate series after v2? Let me know what you think.

-- 
Regards,

Laurent Pinchart

