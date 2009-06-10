Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46025 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932094AbZFJVaw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 17:30:52 -0400
Date: Wed, 10 Jun 2009 23:30:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Muralidharan Karicheri <m-karicheri2@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] adding support for setting bus parameters in sub device
In-Reply-To: <200906102251.57644.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0906102311410.4817@axis700.grange>
References: <1244580891-24153-1-git-send-email-m-karicheri2@ti.com>
 <200906102149.32244.hverkuil@xs4all.nl> <Pine.LNX.4.64.0906102153120.4817@axis700.grange>
 <200906102251.57644.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 10 Jun 2009, Hans Verkuil wrote:

> My view of this would be that the board specification specifies the sensor 
> (and possibly other chips) that are on the board. And to me it makes sense 
> that that also supplies the bus settings. I agree that it is not complex 
> code, but I think it is also unnecessary code. Why negotiate if you can 
> just set it?

Why force all platforms to set it if the driver is perfectly capable do 
this itself? As I said - this is not a platform-specific feature, it's 
chip-specific. What good would it make to have all platforms using mt9t031 
to specify, that yes, the chip can use both falling and rising pclk edge, 
but only active high vsync and hsync?

> BTW, looking at the code there doesn't seem to be a bus type (probably only 
> Bayer is used), correct? How is the datawidth negotiation done? Is the 
> largest available width chosen? I assume that the datawidth is generally 
> fixed by the host? I don't quite see how that can be negotiated since what 
> is chosen there is linked to how the video data is transferred to memory. 
> E.g., chosing a bus width of 8 or 10 bits can be the difference between 
> transferring 8 bit or 16 bit data (with 6 bits padding) when the image is 
> transferred to memory. If I would implement negotiation I would probably 
> limit it to those one-bit settings and not include bus type and width.

Well, this is indeed hairy. And hardware developers compete in creativity 
making us invent new and new algorithms:-( I think, so far _practically_ I 
have only worked with the following setups:

8 bit parallel with syncs and clocks. Data can be either Bayer or YUV. 
This is most usual in my practice so far.

10 bit parallel (PXA270) with syncs and clocks bus with an 8 bit sensor 
connected to most significant lanes... This is achieved by providing an 
additional I2C controlled switch...

10 bit parallel with a 10 bit sensor, data 0-extended to 16 bit, raw 
Bayer.

15 bit parallel bus (i.MX31) with 8 bit sensor connected to least 
significant lanes, because i.MX31 is smart enough to use them correctly.

ATM this is a part of soc-camera pixel format negotiation code, you can 
look at various .set_bus_param() methods in sensor drivers. E.g., look in 
mt9m001 and mt9v022 for drivers, using external bus-width switches...

Now, I do not know how standard these various data packing methods on the 
bus are, I think, we will have to give it a good thought when designing an 
API, comments from developers familiar with various setups are much 
appreciated.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
