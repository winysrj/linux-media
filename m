Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55285 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754362Ab0BSVCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 16:02:32 -0500
Date: Fri, 19 Feb 2010 22:02:30 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Philipp Wiesner <p.wiesner@gmx.net>
cc: linux-media@vger.kernel.org
Subject: Re: soc-camera: pixclk polarity question
In-Reply-To: <20100219162101.92410@gmx.net>
Message-ID: <Pine.LNX.4.64.1002192153550.5860@axis700.grange>
References: <20100219162101.92410@gmx.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 19 Feb 2010, Philipp Wiesner wrote:

> Hi,
> 
> I'm working with µCs (i.MX27) and cameras (Aptina) at the moment.
> 
> Now I encountered a problem introduced by serializing and deserializing 
> (lvds) camera data on its way to the µC.
> 
> The serializer expects a specific pixclk polarity which can be 
> configured in hardware. In most cases this is no problem as it is 
> permanently connected to only one sensor chip, but camera sensors with 
> configurable pixclk could negotiate the wrong polarity.
> 
> The deserializer generates pixclk from data, its polarity again can be 
> configured in hardware. This leads to pixclk inversion depending on 
> wheter serdes is happening or not, so its not an attribute of the 
> platform (in opposition to what SOCAM_SENSOR_INVERT_PCLK is meant for)
> 
> What would be the correct way to address this?
> 
> Do we need another platform flag, e.g. SOCAM_PCLK_SAMPLE_RISING_FIXED?
> The only solution coming to my mind is checking for the SerDes on boot 
> time and setting flags like SOCAM_PCLK_SAMPLE_RISING_FIXED and 
> SOCAM_SENSOR_INVERT_PCLK if necessary.

Hm, how is any new flag better than the existing one? If it is just a 
static flag - it doesn't change anything, right? As far as I understand, 
on one and the same platform the signal polarity can be different, 
depending on some switch / jumper / hard-soldered pin, right? I think your 
boot-time verification is good then - just put it in your platform code 
and set the flag(s) accordingly.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
