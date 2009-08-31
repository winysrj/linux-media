Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:51502 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbZHaQyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 12:54:47 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
Date: Mon, 31 Aug 2009 11:54:35 -0500
Subject: RE: RFC: bus configuration setup for sub-devices
Message-ID: <A69FA2915331DC488A831521EAE36FE40154EDC55E@dlee06.ent.ti.com>
References: <200908291631.13696.hverkuil@xs4all.nl>
 <4A9BF22A.1000608@maxwell.research.nokia.com>
In-Reply-To: <4A9BF22A.1000608@maxwell.research.nokia.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari,

>
>The bus type should be definitely included. If a bridge has several
>different receivers, say parallel, CSI1 and CSI2, which of them should
>be configured to receive data unless that's part of the bus configuration?
I agree and I have responded to have it included in the RFC.
>
>> This particular API should just setup the physical bus. Nothing more,
>IMHO.
>
>How would the image format be defined then...? The ISP in this case can
>mangle the image format the way it wants so what's coming from the
>sensor can be quite different from what's coming out of the ISP. Say,
>sensor produces raw bayer and ISP writes YUYV, for example. Usually the
>format the sensor outputs is not defined by the input format the user
>wants from the device.
It is a bit tricky here. In OMAP and DMxxx SOCs of TI, the image processing block comes in between sensor output and SDRAM. I would consider the whole path from input to VPFE or ISP to output to SDRAM as being managed by the bridge device. So S_FMT will handle all the formats that could be output
to SDRAM from vpfe or isp. So it is within the bridge device how it manages all the format conversion. 

So in these cases, the following scenario applies...

sensor/decoder -> bus -> vpfe/isp. The bus here could be CSI1 or CSI2 or Raw or YbCr. The bridge device will use appropriate hardware in the pipe line
to do the conversion.
		>
>Regards,
>
>--
>Sakari Ailus
>sakari.ailus@maxwell.research.nokia.com

