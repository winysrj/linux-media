Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m39EUr33021512
	for <video4linux-list@redhat.com>; Wed, 9 Apr 2008 10:30:53 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m39EUL8M002442
	for <video4linux-list@redhat.com>; Wed, 9 Apr 2008 10:30:21 -0400
Date: Wed, 9 Apr 2008 16:30:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Mike Rapoport <mike@compulab.co.il>
In-Reply-To: <47F872DE.60004@compulab.co.il>
Message-ID: <Pine.LNX.4.64.0804091626140.5671@axis700.grange>
References: <47F21593.7080507@compulab.co.il>
	<Pine.LNX.4.64.0804031708470.18539@axis700.grange>
	<47F872DE.60004@compulab.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

On Sun, 6 Apr 2008, Mike Rapoport wrote:

> >> +			DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
> >> +#ifdef DEBUG
> >> +			if (CISR & CISR_IFO_0) {
> >> +				dev_warn(pcdev->dev, "FIFO overrun\n");
> >> +				for (i = 0; i < channels; i++)
> >> +					DDADR(pcdev->dma_chans[i]) =
> >> +						pcdev->active->dmas[i].sg_dma;
> >> +
> >> +				CICR0 &= ~CICR0_ENB;
> >> +				CIFR |= CIFR_RESET_F;
> >> +				for (i = 0; i < channels; i++)
> >> +					DCSR(pcdev->dma_chans[0]) = DCSR_RUN;
> >> +				CICR0 |= CICR0_ENB;
> >> +			} else {
> >> +				for (i = 0; i < channels; i++)
> >> +					DCSR(pcdev->dma_chans[0]) = DCSR_RUN;
> >> +			}
> > 
> > These three loops don't look right. At least because they use the same 
> > index i. And you're iterating over channels inside a loop over channels, 
> > and you have dma_chans[0] instead of [i]. Please fix.
> 
> Here I'm not quite sure what exactly should be done as I never got overruns.
> For now I move this code out of the loop and in case of overrun re-enable
> all three DMAs. BTW, the 'else' here is completely redundant, so I just removed it.

Mike, you probably saw the recent thread on this list, where the overrun 
problem did come up: http://marc.info/?t=120732439600006&r=1&w=2 and my 
last post in this thread with a patch. Could you, please, test it with 
your YCbCr setup? Would be great, if you could test it with the 
application, that fengxin quoted in his mail 
http://marc.info/?l=linux-video&m=120762092820785&w=2, see if you too get 
overruns with it, and see if my patch fixes them.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
