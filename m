Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:50672 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753904Ab0KKPb6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Nov 2010 10:31:58 -0500
Date: Thu, 11 Nov 2010 16:32:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: mediabus enums
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E9402DC1A7C8C@dbde02.ent.ti.com>
Message-ID: <Pine.LNX.4.64.1011111553320.15747@axis700.grange>
References: <E0D41E29EB0DAC4E9F3FF173962E9E9402DC1A7C8C@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 10 Nov 2010, Hadli, Manjunath wrote:

> Hello Guennadi,
>    Your media-bus enumerations capture the formats quite well. I needed 
> the following for support on Davinci SOCs and liked to check with you if 
> these are covered in some format in the list.
> 1. Parallel RGB 666 (18 data lines+ 5 sync lines)
> 2. YUYV16 (16 lines) (16 data lines + 4 or 5 sync lines)

According to the subdev-formats.xml

http://git.linuxtv.org/pinchartl/media.git?a=blob;f=Documentation/DocBook/v4l/subdev-formats.xml;h=3688f27185f72ab109e3094c268e04f67cb8643e;hb=refs/heads/media-0003-subdev-pad

they should be called V4L2_MBUS_FMT_RGB666_1X18 (or BGR666...) and 
V4L2_MBUS_FMT_YUYV16_1X16. Notice, that these codes do not define the 
complete bus topology, e.g., they say nothing about sync signals. This is 
a separate topic.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
