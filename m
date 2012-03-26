Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57818 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab2CZIZX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 04:25:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Joshua Hintze <joshua.hintze@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Using MT9P031 digital sensor
Date: Mon, 26 Mar 2012 10:25:54 +0200
Message-ID: <16456215.DlCuaG1n70@avalon>
In-Reply-To: <CAGD8Z77akUx2S=h_AU+UcJ6yWf1Y_Rk4+8N78nFe4wP9OHYE=g@mail.gmail.com>
References: <CAGD8Z75ELkV6wJOfuCFU3Z2dS=z5WbV-7izazaG7SVtfPMcn=A@mail.gmail.com> <CAGD8Z77akUx2S=h_AU+UcJ6yWf1Y_Rk4+8N78nFe4wP9OHYE=g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Joshua,

On Sunday 25 March 2012 23:13:02 Joshua Hintze wrote:
> Alright I made some progress on this.
> 
> I can access the Mt9p031 registers that are exposed using a command such as
> 
> ./yavta -l /dev/v4l-subdev8 to list the available controls. Then I can
> set the exposure and analog gain with
> ./yavta --set-control '0x00980911 1500' /dev/v4l-subdev8   <--- This
> seems to give the desired effect.
> 
> Note that ./yavta -w (short option for --set-control) gives a seg
> fault for me. Possible bug in yavta??

That's strange, I use -w all the time and haven't noticed any segfault. Can 
you compile yavta with debugging information and provide some context ?

> Now I'm working on fixing the white balance. In my office the incandescent
> light bulbs give off a yellowish tint late at night. I've been digging
> through the omap3isp code to figure out how to enable the automatic white
> balance. I was able to find the private IOCTLs for the previewer and I was
> able to use VIDIOC_OMAP3ISP_PRV_CFG. Using this IOCTL I adjusted the
> OMAP3ISP_PREV_WB, OMAP3ISP_PREV_BLKADJ, and OMAP3ISP_PREV_RGB2RGB.
>
> Since I wasn't sure where to start on adjusting these values I just set them
> all to the TRM's default register values. However when I did so a strange
> thing occurred. What I saw was all the colors went to a decent color. I'm
> curious if anybody can shed some light on the best way to get a high quality
> image. Ideally if I could just set a bit for auto white balance and auto
> exposure that could be good too.

The ISP doesn't implement automatic white balance. It can apply white 
balancing (as well as other related processing), but computing values for 
those parameters needs to be performed in userspace. The ISP statistics engine 
engine can help speeding up the process, but the AEWB algorithm must be 
implemented in your application.

-- 
Regards,

Laurent Pinchart

