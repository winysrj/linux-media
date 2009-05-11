Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32102.mail.mud.yahoo.com ([68.142.207.116]:27267 "HELO
	web32102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751018AbZEKQzM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 12:55:12 -0400
Message-ID: <951499.48393.qm@web32102.mail.mud.yahoo.com>
References: <155119.7889.qm@web32103.mail.mud.yahoo.com> <Pine.LNX.4.64.0905071750050.9460@axis700.grange>
Date: Mon, 11 May 2009 09:55:10 -0700 (PDT)
From: Agustin <gatoguan-os@yahoo.com>
Subject: Grabbing single stills on MX31 - Re: Solved? - Re: soc-camera: timing out during capture - Re: Testing latest mx3_camera.c
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>
In-Reply-To: <Pine.LNX.4.64.0905071750050.9460@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Thu, 7 May 2009, Guennadi Liakhovetski wrote:

> 
> On Thu, 7 May 2009, Agustin Ferrin Pozuelo wrote:
> > ...
> > I thought about the fact that I was only queuing one buffer, and that 
> > this might be a corner case as sample code uses a lot of them. And that 
> > in the older code that funny things could happen in the handler if we 
> > ran out of buffers, though they didn't happen.
> > 
> > So I have queued an extra buffer and voila, got it working.
> > 
> > So thanks again!
> > 
> > However, this could be a bug in ipu_idmac (or some other point), as 
> > using a single buffer is very plausible, specially when grabbing huge 
> > stills.
> 
> Great, thanks for testing and debugging! Ok, so, I will have to test this 
> case some time...

Guennadi,

This workaround (queuing 2 buffers when needing only one) is having the side effect of greatly increasing the time taken.

I did several tests playing with camera vertical blanking and looking at capture times:

    Vblank / real / user / sys time:
             0 / real    0m 0.90s / user    0m 0.00s / sys     0m 0.34s
  1 frame / real    0m 1.04s / user    0m 0.00s / sys     0m 0.34s
2 frames / real    0m 1.18s / user    0m 0.00s / sys     0m 0.33s
2.5 (max)/ real    0m 1.23s / user    0m 0.00s / sys     0m 0.35s

I think the second frame is being captured altogether, and its dma transfer is not allowing any other process to run meanwhile. (VIDIOC_STREAMOFF is being called as soon as the first buffer is ready.)

Do you think it will be too hard to fix?

Regards,
--Agustín.

