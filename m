Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53942 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756039Ab3AFPB4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jan 2013 10:01:56 -0500
Message-ID: <50E992A0.6010007@iki.fi>
Date: Sun, 06 Jan 2013 17:05:04 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Andreas Nagel <andreasnagel@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: How to configure resizer in ISP pipeline?
References: <50C747B7.20107@gmx.net> <20130106010321.GE13641@valkosipuli.retiisi.org.uk> <50E8D6AA.1040305@gmx.net>
In-Reply-To: <50E8D6AA.1040305@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

Andreas Nagel wrote:
> Hi Sakari,
> 
> thanks for helping.
> 
>>> My "sensor" (TVP5146) already provides YUV data, so I can skip the
>>> previewer. I tried setting the input and output pad of the resizer
>>> subdevice to incoming resolution (input pad) and desired resolution
>>> (output pad). For example: 720x576 --> 352x288. But it didn't work
>>> out quite well.
>> How did it not work quite well? :)
> 
> Not sure, if I recall all the details. I haven't done much in this area
> for a few weeks now.
> Currently, I actually can configure the resizer, but then
> VIDIOC_STREAMON fails with EINVAL when I configure the devnode. Don't
> know why.
> I do connect the resizer source to the resizer output (devnode) and then
> capture from there. I think it is /dev/video6.
> If I leave the resizer out and connect the ccdc source to the ccdc
> output (/dev/video2), capturing works just fine.
> 
> One reason could be, that the resizer isn't supported right now. (You
> remember, I have to use Technexion's TI kernel 2.6.37 with its exotic
> ISP driver. ;-) )

Ouch. There have been many bugfixes and improvements in the omap3isp
driver since it was merged to mainline in this area. I don't know what
TI has backported to their own kernel; it could be something is missing
there.

The fact the ABI and API are incompatible with what's now in mainline
suggests that quite a lot may be missing.

> That's, what one could interpret from this TI wiki page.
> http://processors.wiki.ti.com/index.php/UserGuideOmap35xCaptureDriver_PSP_04.02.00.07#Architecture
> 
> Under the block diagram, there's a note saying, that only the path with
> the continuous line has been validated. So, the dotted lines are ISP
> paths that might not have been validated ("supported"?) yet.

That's very possible.

> (I might add, that all this is part of my master thesis and resizing
> would be a nice-to-have goal, but not a must-have. So I can live with it
> if it won't work.)

Good to hear that... I guess the best starting point to get things
working would definitely be the mainline kernel. The rest is at best
unsupported.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
