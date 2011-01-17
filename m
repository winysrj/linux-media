Return-path: <mchehab@pedra>
Received: from smtprelay01.ispgateway.de ([80.67.18.43]:33038 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab1AQPmG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 10:42:06 -0500
Message-ID: <4D34617D.9090301@tqsc.de>
Date: Mon, 17 Jan 2011 16:34:21 +0100
From: Markus Niebel <list-09_linux_media@tqsc.de>
Reply-To: list-09_linux_media@tqsc.de
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: mx3_camera and DMA / double buffering
References: <4CF7AE4A.7070107@tqsc.de> <Pine.LNX.4.64.1012022103270.26762@axis700.grange> <4CF91228.3030709@tqsc.de> <Pine.LNX.4.64.1012032105200.5693@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1012032105200.5693@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am 03.12.2010 21:07, schrieb Guennadi Liakhovetski:
> On Fri, 3 Dec 2010, Markus Niebel wrote:
>
>> Hello,
>>
>> thank you for your answer. I think there is a problem, but I did not describe
>> it correctly. See my comments
>>
>>> On Thu, 2 Dec 2010, Markus Niebel wrote:
>>>
>>>> Hello,
>>>>
>>>> we're working with a special cameraboard (CCD + Analog Frontend IC). Using
>>>> the
>>>> soc_camera stack on the i.MX35 (mx3_camera) the following problem arises:
>>>>
>>>> VIDIOC_STREAMON calls soc_camera_streamon which calls videobuf_streamon -
>>>> when
>>>> iterating the buffers in the queue the function mx3_videobuf_queue is
>>>> called
>>>> for every buffer. This sends the buffers to the omage DMA (IDMAC) using
>>>> the
>>>> tx_submit method. The function ipu_init_channel_buffer (DMA driver
>>>> ipu_core)
>>>> gets only one buffer from the scatterlist, this leads to a single buffer
>>>> capture.
>>
>> What I wanted to say was, that tx_submit (in case of  ipu_core
>> idmac_tx_submit) calls ipu_init_channel_buffer if channel status is<
>> IPU_CHANNEL_READY. Since only one buffer is submitted (mx3_videobuf_queue is
>> called in a loop for every single buffer in the videobuf_queue) in the
>> IPU_CHA_DB_MODE_SEL register double buffering will not be enabled for the
>> channel. When I put a debug message in ipu_init_channel_buffer I saw that
>> phyaddr_1 is set to NULL.
>
> Correct, but then, when the second buffer is queued,
> ipu_update_channel_buffer() shall be called and then IPU_CHA_DB_MODE_SEL
> shall be set. Isn't this happening?
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
Hello,

sorry for the __very__ long timeout. The doublebuffering is indeed 
enabled when the second buffer is queued - my fault, should have read 
the code more carfully.

But in this way a new question arises:

in soc_camera.c, function soc_camera_streamon the subdev's s_stream 
handler is called first before videobuf_streamon gets called. This way 
the videosource is producing data which could produce a race condition 
with the idmac. Maybe I'm wrong but in some cases (especially whith 
enabled dev_dbg in ipu_idmac.c) we fail to get frames from the driver.

Thanks
Markus
