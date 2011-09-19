Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36967 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab1ISWFR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 18:05:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2] v4l: Add driver for Micron MT9M032 camera sensor
Date: Tue, 20 Sep 2011 00:04:29 +0200
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1316251771-858-1-git-send-email-martin@neutronstar.dyndns.org> <201109190048.25335.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1109192125000.20916@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109192125000.20916@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109200004.31617.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Monday 19 September 2011 21:28:09 Guennadi Liakhovetski wrote:
> Hi Laurent
> 
> just one question:
> 
> On Mon, 19 Sep 2011, Laurent Pinchart wrote:
> > > diff --git a/drivers/media/video/mt9m032.c
> > > b/drivers/media/video/mt9m032.c new file mode 100644
> > > index 0000000..8a64193
> > > --- /dev/null
> > > +++ b/drivers/media/video/mt9m032.c
> > > @@ -0,0 +1,814 @@
> 
> [snip]
> 
> > > +static int mt9m032_read_reg(struct mt9m032 *sensor, const u8 reg)
> > 
> > No need for the const keyword, this isn't a pointer :-)
> 
> I was actually wondering about these: of course it's not the same as using
> const for a pointer to tell the compiler, that this function will not
> change caller's data. But - doesn't using const for any local variable
> tell the compiler, that that _variable_ will not be modified in this
> function? Are there no optimisation possibilities, arising from that?

I would expect the compiler to be smart enough to notice that the variable is 
never assigned. In practice, for such a small function, the generated code is 
identical with and without the const keyword.

-- 
Regards,

Laurent Pinchart
