Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:38823 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbZFJV3w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 17:29:52 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Date: Wed, 10 Jun 2009 16:29:47 -0500
Subject: RE: mt9t031 (was RE: [PATCH] adding support for setting bus
 parameters in sub device)
Message-ID: <A69FA2915331DC488A831521EAE36FE40139A08E4F@dlee06.ent.ti.com>
References: <1244580891-24153-1-git-send-email-m-karicheri2@ti.com>
 <Pine.LNX.4.64.0906102022320.4817@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40139A08DC3@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0906102303190.4817@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0906102303190.4817@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



>> We need
>> streaming capability in the driver. This is how our driver works
>> with mt9t031 sensor
>> 		  raw-bus (10 bit)
>> vpfe-capture  ----------------- mt9t031 driver
>> 	  |					   |
>> 	  V				         V
>> 	VPFE	 				MT9T031
>>
>> VPFE hardware has internal timing and DMA controller to
>> copy data frame by frame from the sensor output to SDRAM.
>> The PCLK form the sensor is used to generate the internal
>> timing.
>
>So, what is missing in the driver apart from the ability to specify
>a frame-rate?
>
[MK] Does the mt9t031 output one frame (snapshot) like in a camera or can it output frame continuously along with PCLK, Hsync and Vsync signals like in a video streaming device. VPFE capture can accept frames continuously from the sensor synchronized to PCLK, HSYNC and VSYNC and output frames to application using QBUF/DQBUF. In our implementation, we have timing parameters for the sensor to do streaming at various resolutions and fps. So application calls S_STD to set these timings. I am not sure if this is an acceptable way of implementing it. Any comments?

Thanks

Murali

>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

