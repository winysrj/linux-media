Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32102.mail.mud.yahoo.com ([68.142.207.116]:41291 "HELO
	web32102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753993AbZELMOS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 08:14:18 -0400
Message-ID: <155082.98228.qm@web32102.mail.mud.yahoo.com>
References: <155119.7889.qm@web32103.mail.mud.yahoo.com> <Pine.LNX.4.64.0905071750050.9460@axis700.grange> <951499.48393.qm@web32102.mail.mud.yahoo.com> <Pine.LNX.4.64.0905120908220.5087@axis700.grange>
Date: Tue, 12 May 2009 05:14:18 -0700 (PDT)
From: Agustin <gatoguan-os@yahoo.com>
Subject: Re: [PATCH] dma: fix ipu_idmac.c to not discard the last queued buffer
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <Pine.LNX.4.64.0905120908220.5087@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Tue, 12 May 2009, Guennadi Liakhovetski wrote:

> 
> This also fixes the case of a single queued buffer, for example, when taking a
> single frame snapshot with the mx3_camera driver.
> 
> Reported-by: Agustin 
> Signed-off-by: Guennadi Liakhovetski

Signed-off-by: Agustin Ferrin Pozuelo

> ---
> 
> Subject: Re: Grabbing single stills on MX31 - Re: Solved? - Re: 
> soc-camera: timing out during capture - Re: Testing latest mx3_camera.c
> 
> On Mon, 11 May 2009, Agustin wrote:
> 
> > On Thu, 7 May 2009, Guennadi Liakhovetski wrote:
> > 
> > > On Thu, 7 May 2009, Agustin Ferrin Pozuelo wrote:
> > > > ...
> > > > I thought about the fact that I was only queuing one buffer, and that 
> > > > this might be a corner case as sample code uses a lot of them. And that 
> > > > in the older code that funny things could happen in the handler if we 
> > > > ran out of buffers, though they didn't happen.
> > > > 
> > > > So I have queued an extra buffer and voila, got it working.
> > > > 
> > > > So thanks again!
> > > > 
> > > > However, this could be a bug in ipu_idmac (or some other point), as 
> > > > using a single buffer is very plausible, specially when grabbing huge 
> > > > stills.
> > > 
> > > Great, thanks for testing and debugging! Ok, so, I will have to test this 
> > > case some time...
> 
> Agustin, does this patch fix your problem? Dan, please, pull it as soon as 
> we get a tested-by from Agustin.

Yes it works. And it happens to save 33% of system CPU time in addition to freeing a lot of memory bandwith. Timings after this fix:

  Vblank  /  real        /  user       / sys time:
   [any]  /  real 0.50s  /  user 0.00s / sys 0.22s

(Everything was for a 3888x1944x15bpp still)

> 
> > This workaround (queuing 2 buffers when needing only one) is having the 
> > side effect of greatly increasing the time taken.
> > 
> > I did several tests playing with camera vertical blanking and looking at 
> > capture times:
> > 
> >   Vblank / real             / user             / sys time:
> >        0 / real    0m 0.90s / user    0m 0.00s / sys     0m 0.34s
> >  1 frame / real    0m 1.04s / user    0m 0.00s / sys     0m 0.34s
> > 2 frames / real    0m 1.18s / user    0m 0.00s / sys     0m 0.33s
> > 2.5 (max)/ real    0m 1.23s / user    0m 0.00s / sys     0m 0.35s
> > 
> > I think the second frame is being captured altogether, and its dma 
> > transfer is not allowing any other process to run meanwhile. 
> > (VIDIOC_STREAMOFF is being called as soon as the first buffer is ready.)
> 
> I don't quite understand this. What exactly are you doing above? You 
> submit 2 buffers and change vertical blanking? Where do you change the 
> blanking - in the driver? How exactly?
> 
> > Do you think it will be too hard to fix?
> 
> The blanking issue or the 1-buffer problem?

Eh-eh, it was the same!
Thanks a lot!
--Agustín.

> 
> Thanks
> Guennadi
> 
> drivers/dma/ipu/ipu_idmac.c |    3 ++-
> 1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
> index 3a4deea..9a5bc1a 100644
> --- a/drivers/dma/ipu/ipu_idmac.c
> +++ b/drivers/dma/ipu/ipu_idmac.c
> @@ -1272,7 +1272,8 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
>     /* Other interrupts do not interfere with this channel */
>     spin_lock(&ichan->lock);
>     if (unlikely(chan_id != IDMAC_SDC_0 && chan_id != IDMAC_SDC_1 &&
> -             ((curbuf >> chan_id) & 1) == ichan->active_buffer)) {
> +             ((curbuf >> chan_id) & 1) == ichan->active_buffer &&
> +             !list_is_last(ichan->queue.next, &ichan->queue))) {
>         int i = 100;
> 
>         /* This doesn't help. See comment in ipu_disable_channel() */
> -- 
> 1.6.2.4

