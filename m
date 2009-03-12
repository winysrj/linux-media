Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:51879 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbZCLVhM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 17:37:12 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/4] pxa_camera: Fix overrun condition on last buffer
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
	<1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
	<1236282351-28471-3-git-send-email-robert.jarzmik@free.fr>
	<1236282351-28471-4-git-send-email-robert.jarzmik@free.fr>
	<1236282351-28471-5-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0903111930300.4818@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Thu, 12 Mar 2009 22:36:58 +0100
In-Reply-To: <Pine.LNX.4.64.0903111930300.4818@axis700.grange> (Guennadi Liakhovetski's message of "Wed\, 11 Mar 2009 19\:31\:15 +0100 \(CET\)")
Message-ID: <87bps61kzp.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
>> index 16bf0a3..dd56c35 100644
>> --- a/drivers/media/video/pxa_camera.c
>> +++ b/drivers/media/video/pxa_camera.c
>> @@ -734,14 +734,18 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
>>  		status & DCSR_ENDINTR ? "EOF " : "", vb, DDADR(channel));
>>  
>>  	if (status & DCSR_ENDINTR) {
>> -		if (camera_status & overrun) {
>> +		/*
>> +		 * It's normal if the last frame creates an overrun, as there
>> +		 * are no more DMA descriptors to fetch from QIF fifos
>> +		 */
>> +		if (camera_status & overrun
>> +		    && !list_is_last(pcdev->capture.next, &pcdev->capture)) {
>
> On a second look - didn't you want to test for ->active being the last?

Mmm, I'm not sure I get you right here. AFAICR pcdev->active has no direct link
with pcdev->capture (it has nothing to do with a list_head *). Of course with a
bit of "container_of" magic (or list_entry equivalent), I'll find it ...

If that list_is_last is not good, would you provide me with a better alternative
?

Cheers.

--
Robert
