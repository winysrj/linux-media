Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58742 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab1ALMiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 07:38:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enric =?utf-8?q?Balletb=C3=B2_i_Serra?= <eballetbo@gmail.com>
Subject: Re: OMAP3 ISP and tvp5151 driver.
Date: Wed, 12 Jan 2011 13:39:09 +0100
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
References: <AANLkTimec2+VyO+iRSx1PYy3btOb6RbHt0j3ytmnykVo@mail.gmail.com> <201012282146.49327.laurent.pinchart@ideasonboard.com> <AANLkTi=VgexL9bm8dxo1dEgGG2Eap7t+6naiG3E7_ihc@mail.gmail.com>
In-Reply-To: <AANLkTi=VgexL9bm8dxo1dEgGG2Eap7t+6naiG3E7_ihc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101121339.10758.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Enric,

On Wednesday 12 January 2011 12:58:04 Enric Balletbò i Serra wrote:
> Hi all,
> 
> As explained in my first mail I would like port the tvp515x driver to
> new media framework, I'm a newbie with the v4l2 API and of course with
> the new media framework API, so sorry if next questions are stupid or
> trivial (please, patience with me).
> 
> My idea is follow this link schem:
> 
> ---------------------------------------
> --------------------------------------------
>  ---------------------         |    |                              | 1
> 
> | ----------> | OMAP3 ISP CCDC OUTPUT |
> | TVP515x  | 0 | -----> | 0 | OMAP3 ISP CCDC  --- |
> 
> --------------------------------------------
>  --------------------          |    |                              | 2 |
>                                 ---------------------------------------

ASCII art would look much better if you drew it in a non-proportional font, 
with 80 character per line at most.

> Where:
>  * TVP515x is /dev/v4l-subdev8 c 81 15
>  * OMAP3 ISP CCDC is /dev/v4l-subdev2 c 81 4
>  * OMAP3 ISP CCDC OUTPUT is /dev/video2 c 81 5
> 
> Then activate these links with
> 
>  ./media-ctl -r -l '"tvp5150 2-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3
> ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>  Resetting all links to disabled
>  Setting up link 16:0 -> 5:0 [1]
>  Setting up link 5:1 -> 6:0 [1]
> 
> I'm on the right way or I'm completely lost ?

That's correct.

> I think the next step is adapt the tvp515x driver to new media
> framework, I'm not sure how to do this, someone can give some points ?

You need to implement subdev pad operations. get_fmt and set_fmt are required.

> Once this is done, I suppose I can test using gstreamer, for example
> using something like this.
> 
>    gst-launch v4l2src device=/dev/video2 ! ffmpegcolorspace ! xvimagesink
> 
> I'm right in this point ?

You need to specify the format explicitly. It must be identical to the format 
configured on pad CCDC:1.

-- 
Regards,

Laurent Pinchart
