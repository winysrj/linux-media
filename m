Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.uni-paderborn.de ([131.234.142.9]:32706 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab0DSNPn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Apr 2010 09:15:43 -0400
Message-ID: <4BCC577B.1090905@hni.uni-paderborn.de>
Date: Mon, 19 Apr 2010 15:15:39 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: pxa_camera + ov9655: image shifted on first capture after reset
References: <4BC81EEF.3000107@hni.uni-paderborn.de> <4BC836FD.8010301@cam.ac.uk>
In-Reply-To: <4BC836FD.8010301@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jonathan Cameron schrieb:
> On 04/16/10 09:25, Stefan Herbrechtsmeier wrote:
>   
>> Hi,
>>
>> I have updated my ov9655 driver to kernel 2.6.33 and
>> did some test regarding the image shift problem on pxa.
>> (http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/10773/focus=11810)
>>
>>
>> - The image was shifted 32 pixels (64 bytes) to the right
>>  or rather the first 32 pixels belongs to the previous image.
>> - The image was only shifted on the first capture after reset.
>>   It doesn't matter whether I previous change the resolution with v4l2-ctl.
>> - On big images (1280 x 1024) the shift disappears after some images,
>>   but not on small images (320 x 240).
>>
>> It looks like the FIFO was not cleared at start capture
> Sounds reasonable.  Similar problem seen with ov7670 attached to pxa271.
> I've never taken the time to try and track it down.
>   
I have fix the bug by moving the reset FIFO from 
pxa_camera_start_capture to pxa_camera_irq
in front of the DMA activation after an end of frame interrupt.

I will send a patch tomorrow.

Regards,
    Stefan
