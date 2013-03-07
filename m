Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:53249 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822Ab3CGVhb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 16:37:31 -0500
Date: Thu, 7 Mar 2013 22:37:26 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Christian Rhodin <Crhodin@aptina.com>
cc: linux-media@vger.kernel.org
Subject: Re: Pixel Formats
In-Reply-To: <B4589F7BF62FDC409F64E48C95EC0572113A6BFC@sjcaex01.aptad.aptina.com>
Message-ID: <Pine.LNX.4.64.1303072227570.20470@axis700.grange>
References: <B4589F7BF62FDC409F64E48C95EC0572113A6BFC@sjcaex01.aptad.aptina.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Christian

On Wed, 6 Mar 2013, Christian Rhodin wrote:

> Hi,
> 
> I'm looking for some guidance on the correct way to handle a new pixel
> format.  What I'm dealing with is a CMOS image sensor that supports
> dynamic switching between linear and iHDR modes.  iHDR stands for
> "interlaced High Dynamic Range" and is a mode where odd and even lines
> have different exposure times, typically with an 8:1 ratio.  When I
> started implementing a driver for this sensor I used
> "V4L2_MBUS_FMT_SGRBG10_1X10" as the format for the linear mode and
> defined a new format "V4L2_MBUS_FMT_SGRBG10_IHDR_1X10" for the iHDR
> mode.  I used the format to control which mode I put the sensor in.  But
> now I'm having trouble switching modes without reinitializing the
> sensor.  Does anyone (everyone?) have an opinion about the correct way
> to implement this?  I'm thinking that the format is overloaded because
> it represents both the size and type of the data.  Should I use a single
> format and add a control to switch the mode?

I would vote for a single format with a control, maybe even somehow 
cluster it with the normal exposure, but I'm not an expert in that, not 
sure if it would make sense.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
