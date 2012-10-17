Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39964 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718Ab2JQAUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Oct 2012 20:20:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enric Balletbo Serra <eballetbo@gmail.com>
Cc: John Weber <rjohnweber@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Using omap3-isp-live example application on beagleboard with DVI
Date: Wed, 17 Oct 2012 02:21:20 +0200
Message-ID: <4949132.OD6tNZX2Jk@avalon>
In-Reply-To: <CAFqH_50FiyMiQHiTwhu82shJVb-boZ+KSu8sTwaFQxsPGA=sfA@mail.gmail.com>
References: <090701cd8c4e$be38bea0$3aaa3be0$@gmail.com> <7805846.LU2Ezfa4XS@avalon> <CAFqH_50FiyMiQHiTwhu82shJVb-boZ+KSu8sTwaFQxsPGA=sfA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enric,

On Monday 15 October 2012 14:03:20 Enric Balletbo Serra wrote:
> 2012/10/11 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > On Thursday 11 October 2012 10:14:26 Enric Balletbò i Serra wrote:
> >> 2012/10/10 Enric Balletbò i Serra <eballetbo@gmail.com>:
> >> > 2012/9/6 John Weber <rjohnweber@gmail.com>:
> >> >> Hello,
> >> >> 
> >> >> My goal is to better understand how to write an application that makes
> >> >> use of the omap3isp and media controller frameworks and v4l2.  I'm
> >> >> attempting to make use of Laurent's omap3-isp-live example application
> >> >> as a starting point and play with the AEC/WB capability.
> >> >> 
> >> >> My problem is that when I start the live application, the display
> >> >> turns blue (it seems when the chromakey fill is done), but no video
> >> >> appears on the display.  I do think that I'm getting good (or at least
> >> >> statistics) from the ISP because I can change the view in front of the
> >> >> camera (by putting my hand in front of the lens) and the gain settings
> >> >> change.

[snip]

> >> > I've exactly the same problem. Before try to debug the problem I would
> >> > like to know if you solved the problem. Did you solved ?
> >> 
> >> The first change I made and worked (just luck). I made the following
> >> change:
> >> 
> >> -       vo_enable_colorkey(vo, 0x123456);
> >> +       // vo_enable_colorkey(vo, 0x123456);
> >> 
> >> And now the live application works like a charm. Seems this function
> >> enables a chromakey and the live application can't paint over the
> >> chromakey. Laurent, just to understand what I did, can you explain
> >> this ? Thanks.
> > 
> > My guess is that the live application fails to paint the frame buffer with
> > the color key. If fb_init() failed the live application would stop, so
> > the function succeeds. My guess is thus that the application either
> > paints the wrong frame buffer (how many /dev/fb* devices do you have on
> > your system ?),
>
> I checked again and no, it opens the correct framebuffer.
> 
> > or paints it with the wrong color. The code assumes that the frame buffer
> > is configured in 32 bit, maybe that's not the case on your system ?
> 
> This was my problem, and I suspect it's the John problem. My system was
> configured in 16 bit instead of 32 bit.
> 
> FYI, I made a patch that adds this check to the live application. I did not
> know where send the patch so I attached to this email.

Thank you for the patch.

Instead of failing what would be more interesting would be to get the 
application to work in 16bpp mode as well. For that you will need to paint the 
frame buffer with a 16bpp color, and set the colorkey to the same value. Would 
you be able to try that ?

-- 
Regards,

Laurent Pinchart

