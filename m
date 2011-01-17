Return-path: <mchehab@pedra>
Received: from smtprelay01.ispgateway.de ([80.67.18.43]:42368 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab1AQR2P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 12:28:15 -0500
Message-ID: <4D347C2B.5070200@tqsc.de>
Date: Mon, 17 Jan 2011 18:28:11 +0100
From: Markus Niebel <list-09_linux_media@tqsc.de>
Reply-To: list-09_linux_media@tqsc.de
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: mx3_camera and DMA / double buffering
References: <4CF7AE4A.7070107@tqsc.de> <Pine.LNX.4.64.1012022103270.26762@axis700.grange> <4CF91228.3030709@tqsc.de> <Pine.LNX.4.64.1012032105200.5693@axis700.grange> <4D34617D.9090301@tqsc.de> <Pine.LNX.4.64.1101171724360.16051@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1101171724360.16051@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am 17.01.2011 17:27, schrieb Guennadi Liakhovetski:
> On Mon, 17 Jan 2011, Markus Niebel wrote:
>
>> Hello,
>>
>> sorry for the __very__ long timeout. The doublebuffering is indeed enabled
>> when the second buffer is queued - my fault, should have read the code more
>> carfully.
>
> Good.
>
>> But in this way a new question arises:
>>
>> in soc_camera.c, function soc_camera_streamon the subdev's s_stream handler is
>> called first before videobuf_streamon gets called. This way the videosource is
>> producing data which could produce a race condition with the idmac.
>
> Starting the sensor before the host shouldn't cause any problems, because
> hosts should be capable of handling sensors, continuously streaming data.
> So, the order should be ok, if the mx3-camera driver gets problems with
> it, it has a bug and it should be fixed.
>
>> Maybe I'm
>> wrong but in some cases (especially whith enabled dev_dbg in ipu_idmac.c) we
>> fail to get frames from the driver.
>
> Sorry, what exactly do you mean? Capture doesn't start at all? Or it
> begins and then hangs? Or some fraims get dropped? Please, explain in more
> detail.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hello,

we see messages like this (with more logging output at higher possibility):

[   24.260000] dma dma0chan7: IDMAC irq 177, buf 1
[   24.260000] dma dma0chan7: IRQ on active buffer on channel 7, active 
1, ready 0, 0, current 80!

and calls from an application to select times out

when changing the order of calls in soc_camera_streamon 
(videobuf_streamon before v4l2_subdev_call(sd, video, s_stream, 1)
images always can be captured.

My assumption for the reason is based on the following:

1) Since CSI is enabled by idmac in ipu_init_channel, mx3_camera has no 
control over the data flow. As soon as the first buffer is queued with 
idmac it will filled - my thoughts are that this can interfere with the 
initial setup during submission of the first two buffers.

2) The freescale sample code (mxc_camera.c, not in mainline) enables the 
CSI after channel and buffers are configured.

Thanks
Markus

