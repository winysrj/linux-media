Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48858 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754016AbZGATGJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jul 2009 15:06:09 -0400
Date: Wed, 1 Jul 2009 21:06:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Valentin Longchamp <valentin.longchamp@epfl.ch>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"m-karicheri2@ti.com" <m-karicheri2@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH RFC] fix cropping and scaling for mx3-camera and mt9t031
 drivers
In-Reply-To: <4A4B9416.7040107@epfl.ch>
Message-ID: <Pine.LNX.4.64.0907012048340.5609@axis700.grange>
References: <Pine.LNX.4.64.0906301656471.5748@axis700.grange> <4A4B9416.7040107@epfl.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 1 Jul 2009, Valentin Longchamp wrote:

> Guennadi Liakhovetski wrote:
> > 
> > While trying all possible skipping / binning combinations of mt9t031 I
> > came across a problem, that in some configurations the sensor produces
> > regular horizontal stripes. They depend on window geometry, with some
> > skipping factors they can be eliminated by using properly aligned left
> > window border, but with some other AFAICS valid parameter combinations
> > stripes persist. And - they seem to depend on lighting conditions... I
> > think, I'll try to ask Aptina again... Or does anyone have an idea what I
> > might be doing wrong?
> 
> It may be completely unrelated, but we had quite similar problem with
> our hardware. With a part of the image "saturated", we had some
> artefacts (missing data in fact) on some horizontal lines: pixclk wave
> was poor and the i.MX31 could not read data correctly. In order to
> resovle this problem, we had to change the bus drivers (we now use some
> SN74LVCH16244ADGGR that work well with the 3V3 signals from the camera).
> Now even with high contrast and some parts saturated, pix clk looks nice and
> we don't loose pixels anymore.

Hm interesting. What exactly did those missing pixels look like in your 
case? In my case these are periodic horizontal lines of 1 or 2 (approx.) 
pixels wide. Sometimes they are repeated one such stripe every x pixels, 
sometimes they are repeated in pairs.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
