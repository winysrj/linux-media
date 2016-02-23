Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:28431 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752333AbcBWHGL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 02:06:11 -0500
Subject: Re: [RFC] Move some soc-camera drivers to staging in preparation for
 removal
To: Ludovic Desroches <ludovic.desroches@atmel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <56C71778.2030706@xs4all.nl> <1685709.3nM7dPdDel@avalon>
 <Pine.LNX.4.64.1602221427510.10936@axis700.grange>
 <1864387.TRmC7Phqsl@avalon> <20160222160857.GB2607@odux.rfo.atmel.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Josh Wu <rainyfeeling@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Nicolas Ferre <nicolas.ferre@atmel.com>
From: "Wu, Songjun" <songjun.wu@atmel.com>
Message-ID: <56CC04DA.3030002@atmel.com>
Date: Tue, 23 Feb 2016 15:06:02 +0800
MIME-Version: 1.0
In-Reply-To: <20160222160857.GB2607@odux.rfo.atmel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 2/23/2016 00:08, Ludovic Desroches wrote:
> On Mon, Feb 22, 2016 at 04:23:54PM +0200, Laurent Pinchart wrote:
>> Hi Guennadi,
>>
>> (CC'ing Ludovic Desroches)
>>
>> On Monday 22 February 2016 14:39:08 Guennadi Liakhovetski wrote:
>>> Hi Laurent,
>>>
>>> On Mon, 22 Feb 2016, Laurent Pinchart wrote:
>>>
>>> [snip]
>>>
>>>> As far as I know Renesas (or at least the kernel upstream team) doesn't
>>>> care. The driver is only used on five SH boards, I'd also say it can be
>>>> removed.
>>> [snip]
>>>
>>>>>>> - atmel-isi: ATMEL Image Sensor Interface (ISI)
>>>>>>>
>>>>>>>    I believe this is still actively maintained. Would someone be
>>>>>>>    willing to convert this? It doesn't look like a complex driver.
>>>>
>>>> That would be nice, I would like to avoid dropping this one.
>>>
>>> Thanks for clarifying the state of the CEU driver. I did say, that I am
>>> fine with dropping soc-camera gradually, and I stay with that. But I see
>>> now, that at least two drivers want to stay active: Atmel ISI and PXA270.
>>> One possibility is of course to make them independent drivers. If people
>>> are prepared to invest work into that - sure, would be great! If we
>>> however decide to keep soc-camera, I could propose the following: IIUC,
>>> the largest problem is sensor drivers, that cannot be reused for other
>>> non-soc-camera bridge drivers. The thing is, out of all the sensor drivers
>>> currently under drivers/media/i2c/soc_camera only a couple are in use on
>>> those active PXA270 and Atmel boards. I could propose the following:
>>>
>>> 1. Remove all bridge drivers, that noone cares about.
>>> 2. If anyone ever needs to use any of soc-camera-associated sensor
>>>     drivers, take them out of soc-camera and _remove_ any soc-camera
>>>     dependencies
>>> 3. If any soc-camera boards will need that specific driver, which in
>>>     itself is already unlikely, we'll have to fix that by teaching
>>>     soc-camera to work with generic sensor drivers!
>>
>> That sounds like a good plan.
>>
>> Ludovic, any chance someone at Atmel could convert the ISI driver ?
>
> I add Songjun to the cc list. I think he has in mind to do this
> conversion.
>
> Songjun, can you confirm?
>
> Full thread here:
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/99290
>
Laurent, I will take the ISI driver, convert it from soc_camera to V4L2.

> Regards
>
> Ludovic
>
