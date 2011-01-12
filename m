Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43886 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab1ALL6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 06:58:05 -0500
Received: by pzk35 with SMTP id 35so78817pzk.19
        for <linux-media@vger.kernel.org>; Wed, 12 Jan 2011 03:58:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201012282146.49327.laurent.pinchart@ideasonboard.com>
References: <AANLkTimec2+VyO+iRSx1PYy3btOb6RbHt0j3ytmnykVo@mail.gmail.com>
	<201012282146.49327.laurent.pinchart@ideasonboard.com>
Date: Wed, 12 Jan 2011 12:58:04 +0100
Message-ID: <AANLkTi=VgexL9bm8dxo1dEgGG2Eap7t+6naiG3E7_ihc@mail.gmail.com>
Subject: Re: OMAP3 ISP and tvp5151 driver.
From: =?UTF-8?Q?Enric_Balletb=C3=B2_i_Serra?= <eballetbo@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

As explained in my first mail I would like port the tvp515x driver to
new media framework, I'm a newbie with the v4l2 API and of course with
the new media framework API, so sorry if next questions are stupid or
trivial (please, patience with me).

My idea is follow this link schem:


---------------------------------------
--------------------------------------------
 ---------------------         |    |                              | 1
| ----------> | OMAP3 ISP CCDC OUTPUT |
| TVP515x  | 0 | -----> | 0 | OMAP3 ISP CCDC  --- |
--------------------------------------------
 --------------------          |    |                              | 2 |
                                ---------------------------------------

Where:
 * TVP515x is /dev/v4l-subdev8 c 81 15
 * OMAP3 ISP CCDC is /dev/v4l-subdev2 c 81 4
 * OMAP3 ISP CCDC OUTPUT is /dev/video2 c 81 5

Then activate these links with

 ./media-ctl -r -l '"tvp5150 2-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3
ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
 Resetting all links to disabled
 Setting up link 16:0 -> 5:0 [1]
 Setting up link 5:1 -> 6:0 [1]

I'm on the right way or I'm completely lost ?

I think the next step is adapt the tvp515x driver to new media
framework, I'm not sure how to do this, someone can give some points ?

Once this is done, I suppose I can test using gstreamer, for example
using something like this.

   gst-launch v4l2src device=/dev/video2 ! ffmpegcolorspace ! xvimagesink

I'm right in this point ?

Any help will be apreciated.

Thanks in advance,
   Enric

2010/12/28 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Enric,
>
> On Monday 27 December 2010 17:24:13 Enric Balletbò i Serra wrote:
>> Hello all,
>>
>> I'm new on media and camera, I try to use the OMAP3 ISP driver on
>> OMAP3530 with media framework. I've a TVP5151 connected on ISP port
>> though the parallel interface on own custom board
>>
>> Against which repository/branch should I start the development ?
>
> The most up-to-date code is located in the media-0004-omap3isp branch of the
> http://git.linuxtv.org/pinchartl/media.git repository.
>
>> Should I port tvp5150 driver to new tvp5151 device and new media
>> framework ?
>
> That would be great :-)
>
>> Any driver as reference ?
>
> The MT9T001 and MT9V032 drivers in the media-0005-sensors branch. I haven't
> tested the MT9T001 driver recently, so my advice would be to use the MT9V032
> driver.
>
>> Hopefully, somebody can give me some tips. Thanks
>
> --
> Regards,
>
> Laurent Pinchart
>
