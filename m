Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:39366 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbZCITQb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2009 15:16:31 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/4] pxa_camera: Fix overrun condition on last buffer
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
	<1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
	<1236282351-28471-3-git-send-email-robert.jarzmik@free.fr>
	<1236282351-28471-4-git-send-email-robert.jarzmik@free.fr>
	<1236282351-28471-5-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0903091236540.3992@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 09 Mar 2009 20:16:18 +0100
In-Reply-To: <Pine.LNX.4.64.0903091236540.3992@axis700.grange> (Guennadi Liakhovetski's message of "Mon\, 9 Mar 2009 12\:39\:42 +0100 \(CET\)")
Message-ID: <87zlfuse0t.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> On Thu, 5 Mar 2009, Robert Jarzmik wrote:
>
>> The last buffer queued will often overrun, as the DMA chain
>> is finished, and the time the dma irq handler is activated,
>
> s/and the time/and during the time/ ?
If you wish, or might be simply "and before the dma irq handler is
activated". As you see fit.

>> +		if (camera_status & overrun
>> +		    && !list_is_last(pcdev->capture.next, &pcdev->capture)) {
>>  			dev_dbg(pcdev->dev, "FIFO overrun! CISR: %x\n",
>>  				camera_status);
>>  			pxa_camera_stop_capture(pcdev);
>>  			pxa_camera_start_capture(pcdev);
>>  			goto out;
>>  		}
>> -
>>  		buf->active_dma &= ~act_dma;
>
> This empty like removal doesn't belong to the fix, I'll remove it when 
> committing, and amend the commit message as above. Please, comment if you 
> disagree.
I totally agree with you, remove that "removal" :)

Cheers.

--
Robert
