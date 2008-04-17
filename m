Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3H5tQ2H023647
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 01:55:26 -0400
Received: from mxout10.netvision.net.il (mxout10.netvision.net.il
	[194.90.6.38])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3H5tADq022432
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 01:55:13 -0400
Received: from mail.linux-boards.com ([62.90.235.247])
	by mxout10.netvision.net.il
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JZG00JV7GJU0590@mxout10.netvision.net.il> for
	video4linux-list@redhat.com; Thu, 17 Apr 2008 08:57:31 +0300 (IDT)
Date: Thu, 17 Apr 2008 08:55:03 +0300
From: Mike Rapoport <mike@compulab.co.il>
In-reply-to: <Pine.LNX.4.64.0804091626140.5671@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Message-id: <4806E637.9030906@compulab.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <47F21593.7080507@compulab.co.il>
	<Pine.LNX.4.64.0804031708470.18539@axis700.grange>
	<47F872DE.60004@compulab.co.il>
	<Pine.LNX.4.64.0804091626140.5671@axis700.grange>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] pxa_camera: Add support for YUV modes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>



Guennadi Liakhovetski wrote:
> On Sun, 6 Apr 2008, Mike Rapoport wrote:
> 
>>>> +			DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
>>>> +#ifdef DEBUG
>>>> +			if (CISR & CISR_IFO_0) {
>>>> +				dev_warn(pcdev->dev, "FIFO overrun\n");
>>>> +				for (i = 0; i < channels; i++)
>>>> +					DDADR(pcdev->dma_chans[i]) =
>>>> +						pcdev->active->dmas[i].sg_dma;
>>>> +
>>>> +				CICR0 &= ~CICR0_ENB;
>>>> +				CIFR |= CIFR_RESET_F;
>>>> +				for (i = 0; i < channels; i++)
>>>> +					DCSR(pcdev->dma_chans[0]) = DCSR_RUN;
>>>> +				CICR0 |= CICR0_ENB;
>>>> +			} else {
>>>> +				for (i = 0; i < channels; i++)
>>>> +					DCSR(pcdev->dma_chans[0]) = DCSR_RUN;
>>>> +			}
>>> These three loops don't look right. At least because they use the same 
>>> index i. And you're iterating over channels inside a loop over channels, 
>>> and you have dma_chans[0] instead of [i]. Please fix.
>> Here I'm not quite sure what exactly should be done as I never got overruns.
>> For now I move this code out of the loop and in case of overrun re-enable
>> all three DMAs. BTW, the 'else' here is completely redundant, so I just removed it.
> 
> Mike, you probably saw the recent thread on this list, where the overrun 
> problem did come up: http://marc.info/?t=120732439600006&r=1&w=2 and my 
> last post in this thread with a patch. Could you, please, test it with 
> your YCbCr setup? Would be great, if you could test it with the 
> application, that fengxin quoted in his mail 
> http://marc.info/?l=linux-video&m=120762092820785&w=2, see if you too get 
> overruns with it, and see if my patch fixes them.

Sorry for the delay, and as far as I can see you've already have a fix. :)
If you'd like I can test it with YUV setup. I'll apreciate if you can send me
the entire updated pxa_camera.c, to save time on merge conflicts.

> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski
> 

-- 
Sincerely yours,
Mike.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
