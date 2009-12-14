Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:54903 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbZLNPCQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2009 10:02:16 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 14 Dec 2009 09:02:13 -0600
Subject: RE: Latest stack that can be merged on top of linux-next tree
Message-ID: <A69FA2915331DC488A831521EAE36FE40155CEE4E4@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE40155C809AB@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0912120141160.5084@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0912120141160.5084@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi,

I marged relevant files from the latest of your v4l tree after seeing your pull request. I worked fine for VGA capture. But I need to enable SOC_CAMERA to get the MT9T031 enabled which looks improper to me. Can we remove this restriction from KConfig? I plan to send a vpfe capture patch to support capture using this driver this week.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Friday, December 11, 2009 7:47 PM
>To: Karicheri, Muralidharan
>Cc: linux-media@vger.kernel.org
>Subject: Re: Latest stack that can be merged on top of linux-next tree
>
>Hi Muralidharan
>
>On Thu, 10 Dec 2009, Karicheri, Muralidharan wrote:
>
>> Guennadi,
>>
>> I am not sure if your MT9T031 changes are part of linux-next tree at
>> v4l-dvb. If not, can you point me to the latest stack that I can apply
>> on top of linux-next tree to get your latest changes for MT9T031 sensor
>> driver?
>
>As you probably have seen, I posted a pull request a couple of hours ago,
>which also contains the change to mt9t031, that you're asking about.
>
>> I plan to do integrate sensor driver with vpfe capture driver this week.
>>
>> BTW, Is there a driver for the PCA9543 i2c switch that is part of
>> MT9T031 headboard?
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/
