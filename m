Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38503 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab1ANRBY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 12:01:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enric =?utf-8?q?Balletb=C3=B2_i_Serra?= <eballetbo@gmail.com>
Subject: Re: OMAP3 ISP and tvp5151 driver.
Date: Fri, 14 Jan 2011 18:00:54 +0100
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
References: <AANLkTimec2+VyO+iRSx1PYy3btOb6RbHt0j3ytmnykVo@mail.gmail.com> <201101121339.10758.laurent.pinchart@ideasonboard.com> <AANLkTikOC_zYiyK+8r44Rdp=wigHXZwSmvPgEmBAEqDs@mail.gmail.com>
In-Reply-To: <AANLkTikOC_zYiyK+8r44Rdp=wigHXZwSmvPgEmBAEqDs@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101141801.01125.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Enric,

On Thursday 13 January 2011 13:27:43 Enric Balletbò i Serra wrote:
> 2011/1/12 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > On Wednesday 12 January 2011 12:58:04 Enric Balletbò i Serra wrote:
> >> Hi all,
> >> 
> >> As explained in my first mail I would like port the tvp515x driver to
> >> new media framework, I'm a newbie with the v4l2 API and of course with
> >> the new media framework API, so sorry if next questions are stupid or
> >> trivial (please, patience with me).
> >> 
> >> My idea is follow this link schem:
> >> 
> >> ---------------------------------------
> >> --------------------------------------------
> >>  ---------------------         |    |                              | 1
> >> 
> >> | ----------> | OMAP3 ISP CCDC OUTPUT |
> >> | TVP515x  | 0 | -----> | 0 | OMAP3 ISP CCDC  --- |
> >> 
> >> --------------------------------------------
> >>  --------------------          |    |                              | 2 |
> >>                                 ---------------------------------------
> > 
> > ASCII art would look much better if you drew it in a non-proportional
> > font, with 80 character per line at most.
> > 
> >> Where:
> >>  * TVP515x is /dev/v4l-subdev8 c 81 15
> >>  * OMAP3 ISP CCDC is /dev/v4l-subdev2 c 81 4
> >>  * OMAP3 ISP CCDC OUTPUT is /dev/video2 c 81 5
> >> 
> >> Then activate these links with
> >> 
> >>  ./media-ctl -r -l '"tvp5150 2-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3
> >> ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> >>  Resetting all links to disabled
> >>  Setting up link 16:0 -> 5:0 [1]
> >>  Setting up link 5:1 -> 6:0 [1]
> >> 
> >> I'm on the right way or I'm completely lost ?
> > 
> > That's correct.
> > 
> >> I think the next step is adapt the tvp515x driver to new media
> >> framework, I'm not sure how to do this, someone can give some points ?
> > 
> > You need to implement subdev pad operations. get_fmt and set_fmt are
> > required.
> 
> I configured the TVP5151 to  8-bit 4:2:3 YCbCr output format. Is 8-bit
> 4:2:3 YCbCr output format implemented in OMAP3 ISP CCDC  ?

I suppose you mean 4:2:2. The CCDC doesn't support that yet.

> >> Once this is done, I suppose I can test using gstreamer, for example
> >> using something like this.
> >> 
> >>    gst-launch v4l2src device=/dev/video2 ! ffmpegcolorspace !
> >> xvimagesink
> >> 
> >> I'm right in this point ?
> > 
> > You need to specify the format explicitly. It must be identical to the
> > format configured on pad CCDC:1.
> 
> Can you give me an example using gstreamer ?

I'm not a gstreamer expert, sorry.

> Running yavta I get
> 
> # ./yavta -f SGRBG10 -s 720x525 -n 4 --capture=4 --skip 3 -F /dev/video2
> Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
> Video format set: width: 720 height: 525 buffer size: 756000
> Video format: BA10 (30314142) 720x525
> 4 buffers requested.
> length: 756000 offset: 0
> Buffer 0 mapped at address 0x400f2000.
> length: 756000 offset: 757760
> Buffer 1 mapped at address 0x40385000.
> length: 756000 offset: 1515520
> Buffer 2 mapped at address 0x40466000.
> length: 756000 offset: 2273280
> Buffer 3 mapped at address 0x405ed000.
> Unable to start streaming: 22.
> Unable to dequeue buffer (22).
> 4 buffers released.
> 
> I know the format is not correct, but, is the "Unable to start
> streaming: 22" error related to the format or is related to another
> problem ?

That usually means that the format configured on the video device node 
(SGRBG10 720x525 in this case) is different than the format setup on the 
connected subdev output (CCDC pad 1 in this case). My guess is that you 
probably forgot to setup formats on the subdev pads (using media-ctl -f).

-- 
Regards,

Laurent Pinchart
