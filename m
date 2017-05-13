Return-path: <linux-media-owner@vger.kernel.org>
Received: from bubo.tul.cz ([147.230.16.1]:47440 "EHLO bubo.tul.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751687AbdEMGi1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 13 May 2017 02:38:27 -0400
Subject: Re: [RFC] [PATCH 0/4] [media] pxa_camera: Fixing bugs and missing
 colorformats
To: Robert Jarzmik <robert.jarzmik@free.fr>
References: <19820fae-fae3-9579-8f37-5b515e0edb66@tul.cz>
 <34b6ce27-7567-a654-4276-ae522b44f781@tul.cz> <87o9vbz4pp.fsf@belgarion.home>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
From: Petr Cvek <petr.cvek@tul.cz>
Message-ID: <c2c51214-71ad-7c32-5d19-63e731852781@tul.cz>
Date: Sat, 13 May 2017 08:40:06 +0200
MIME-Version: 1.0
In-Reply-To: <87o9vbz4pp.fsf@belgarion.home>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne 2.5.2017 v 16:57 Robert Jarzmik napsal(a):
> Petr Cvek <petr.cvek@tul.cz> writes:
> 
>> Dne 1.5.2017 v 06:20 Petr Cvek napsal(a):
>>> This patchset is just a grouping of a few bugfixes I've found during
>>> the ov9640 sensor support re-adding. 
>>
>> P.S. I've manually calculated every format variant for the image size
>> calculation functions, but still these functions are not too robust (for every
>> hypothetical bps/packing/layout combination). For example:
>>
>> MEDIA_BUS_FMT_Y8_1X8
>> 	.name			= "Grey",
>> 	.bits_per_sample	= 8,
>> 	.packing		= PXA_MBUS_PACKING_NONE,
>> 	.order			= PXA_MBUS_ORDER_LE,
>> 	.layout			= PXA_MBUS_LAYOUT_PACKED,
>>
>> seems to me as a little bit misleading. The better solution would be to have something like bytes_per_line and image_size coefficients. Is my idea worth a try?
>>
>> Anyway the .order field seems to be unused (it is a pxa_camera defined structure). I'm for removing it (I can create a patch and test it on the real hardware). Unless there are plans for it.
>>
>> The pxa_camera_get_formats() could be probably simplified even up to the point
>> of a removal of the soc_camera_format_xlate structure. If no one works on it (in
>> like 2 months) I can try to simplify it.

> 
> Let's see what new ideas can provide, new blood etc ...
> 

OK a problem, probably some kind of race condition. I was trying to add RGB888 mode (and make patchset v2) and wanted to debug it on the runtime (OT: sensor probably does not support it) but I've found probably some race condition :-/.

It seems that buffer DMA chaining works only until all buffers are filled for the first time (ffmpeg allocates 32 buffers BTW, for Magician it is more than RAM size, I've forced it to 4 so the problem is more often).

pxa27x-camera pxa27x-camera.0: (omitted from log)
	pxac_vb2_queue_setup(vq=c39472d0 nbufs=2 num_planes=0 size=153600)
	pxac_vb2_init(nb_channels=1)
	pxac_vb2_init(nb_channels=1)
	pxac_vb2_prepare (vb=c1a4dbe0) nb_channels=1 size=153600
	pxac_vb2_prepare (vb=c0f33ce0) nb_channels=1 size=153600
	pxac_vb2_queue(vb=c1a4dbe0) nb_channels=1 size=153600 active=  (null)
	pxa_dma_add_tail_buf (channel=0) : submit vb=c1a4dbe0 cookie=18
	pxac_vb2_queue(vb=c0f33ce0) nb_channels=1 size=153600 active=  (null)
	pxa_dma_add_tail_buf (channel=0) : submit vb=c0f33ce0 cookie=19
	pxac_vb2_start_streaming(count=2) active=  (null)
	pxa_camera_start_capture S:00008358 0:800003ff
	Camera interrupt status 0x9119
	Camera interrupt status 0x0
	pxa_dma_start_channels (channel=0)
	camera dma irq, cisr=0x8318 dma=1
	pxa_camera_wakeup dequeued buffer (buf=0xc1a4dbe0)
	pxa_camera_check_link_miss : top queued buffer=c0f33ce0, is_dma_stopped=0 19 19
		//I added two parameters: "19" "19" are last_submitted and last_issued (DMA cookies)
	pxac_vb2_prepare (vb=c1a4dbe0) nb_channels=1 size=153600
	pxac_vb2_queue(vb=c1a4dbe0) nb_channels=1 size=153600 active=c0f33ce0
	pxa_dma_add_tail_buf (channel=0) : submit vb=c1a4dbe0 cookie=20
	camera dma irq, cisr=0x8318 dma=1
	pxa_camera_wakeup dequeued buffer (buf=0xc0f33ce0)
	pxa_camera_check_link_miss : top queued buffer=c1a4dbe0, is_dma_stopped=0 20 20
	pxac_vb2_prepare (vb=c0f33ce0) nb_channels=1 size=153600
	pxac_vb2_queue(vb=c0f33ce0) nb_channels=1 size=153600 active=c1a4dbe0
	pxa_dma_add_tail_buf (channel=0) : submit vb=c0f33ce0 cookie=21
	camera dma irq, cisr=0x8318 dma=1
	pxa_camera_wakeup dequeued buffer (buf=0xc1a4dbe0)
	pxa_camera_check_link_miss : top queued buffer=c0f33ce0, is_dma_stopped=0 21 21
	pxac_vb2_prepare (vb=c1a4dbe0) nb_channels=1 size=153600
	pxac_vb2_queue(vb=c1a4dbe0) nb_channels=1 size=153600 active=c0f33ce0
	pxa_dma_add_tail_buf (channel=0) : submit vb=c1a4dbe0 cookie=22
	camera dma irq, cisr=0x8318 dma=1
	pxa_camera_wakeup dequeued buffer (buf=0xc0f33ce0)
	pxa_camera_check_link_miss : top queued buffer=c1a4dbe0, is_dma_stopped=0 22 22
	pxac_vb2_prepare (vb=c0f33ce0) nb_channels=1 size=153600
	pxac_vb2_queue(vb=c0f33ce0) nb_channels=1 size=153600 active=c1a4dbe0
	pxa_dma_add_tail_buf (channel=0) : submit vb=c0f33ce0 cookie=23
	camera dma irq, cisr=0x8318 dma=1
	pxa_camera_wakeup dequeued buffer (buf=0xc1a4dbe0)
	pxa_camera_check_link_miss : top queued buffer=c0f33ce0, is_dma_stopped=0 23 23
	camera dma irq, cisr=0x8318 dma=1
	pxa_camera_wakeup dequeued buffer (buf=0xc0f33ce0)
	pxa_dma_stop_channels (channel=0)
	pxa_camera_stop_capture
		//called because pcdev->capture list is empty
	pxa_camera_check_link_miss : top queued buffer=  (null), is_dma_stopped=0 23 23
		//cannot call pxa_camera_start_capture, because the condition is false (from both variables)
		//there is no new buffer to where save the capture
		//is_dma_stopped is negative, and I think it's a bug as DMA was stopped by pxa_dma_stop_channels()
		//(i thought DMA is stopped when both cookies are equal, maybe the variable has only a bad name)
	pxac_vb2_prepare (vb=c1a4dbe0) nb_channels=1 size=153600
	pxac_vb2_queue(vb=c1a4dbe0) nb_channels=1 size=153600 active=  (null)
	pxa_dma_add_tail_buf (channel=0) : submit vb=c1a4dbe0 cookie=24
	pxac_vb2_prepare (vb=c0f33ce0) nb_channels=1 size=153600
	pxac_vb2_queue(vb=c0f33ce0) nb_channels=1 size=153600 active=  (null)
	pxa_dma_add_tail_buf (channel=0) : submit vb=c0f33ce0 cookie=25
		//these functions have no way of calling pxa_camera_start_capture() and re-enable the controller

This problem was fixed by addition of the next function at the end of pxac_vb2_queue() function:
	if (!pcdev->active) {
		pxa_camera_start_capture(pcdev);
	}

With this patch it seems it won't stop after short time.

There maybe a similar dmaengine conversion problems as in MCI (tasklet taking longer to start, dma callbacks, ...).

Can you test it?

I tested it with buildroot built mplayer version 1.3.0-6.3.0 (v4l2 support) and with this command:

	mplayer -nosound -vo fbdev -tv noaudio:driver=v4l2:outfmt=0x59555956:width=320:height=240 -vf rotate=1 tv://

the problem presents itself by "v4l2: select timeout" at the mplayer output. A ffmpeg seems to have similar problem. The parameters of size, pixel format, and output type show only a small impact (most likely system load and size of the transmitted data).

The second problem seems to be a same problem. When playing/encoding the data from the sensor (with or without previous fix) and calling (probably) anything on v4l2 the drivers stops in a same way. I discovered it by trying to use the CONFIG_VIDEO_ADV_DEBUG interface to realtime poking the sensor.

You should be able to recreate that by starting the stream (mplayer or ffmpeg) and run:
	v4l2-ctl -n
or reading registers, running v4l2-compliance etc... 

best regards,
Petr
