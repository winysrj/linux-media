Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:51490 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab1IST2L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 15:28:11 -0400
Date: Mon, 19 Sep 2011 21:28:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] v4l: Add driver for Micron MT9M032 camera sensor
In-Reply-To: <201109190048.25335.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1109192125000.20916@axis700.grange>
References: <1316251771-858-1-git-send-email-martin@neutronstar.dyndns.org>
 <201109190048.25335.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

just one question:

On Mon, 19 Sep 2011, Laurent Pinchart wrote:

> > diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
> > new file mode 100644
> > index 0000000..8a64193
> > --- /dev/null
> > +++ b/drivers/media/video/mt9m032.c
> > @@ -0,0 +1,814 @@

[snip]

> > +static int mt9m032_read_reg(struct mt9m032 *sensor, const u8 reg)
> 
> No need for the const keyword, this isn't a pointer :-)

I was actually wondering about these: of course it's not the same as using 
const for a pointer to tell the compiler, that this function will not 
change caller's data. But - doesn't using const for any local variable 
tell the compiler, that that _variable_ will not be modified in this 
function? Are there no optimisation possibilities, arising from that?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
