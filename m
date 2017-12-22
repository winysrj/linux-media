Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59056 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751522AbdLVMDa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Dec 2017 07:03:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 03/10] v4l: platform: Add Renesas CEU driver
Date: Fri, 22 Dec 2017 14:03:41 +0200
Message-ID: <12311953.yR0pctoD7P@avalon>
In-Reply-To: <20171221162702.GE27115@w540>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org> <12410142.shlMUBZBeR@avalon> <20171221162702.GE27115@w540>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Thursday, 21 December 2017 18:27:02 EET jacopo mondi wrote:
> On Mon, Dec 18, 2017 at 05:28:43PM +0200, Laurent Pinchart wrote:
> > On Monday, 18 December 2017 14:25:12 EET jacopo mondi wrote:
> >> On Mon, Dec 11, 2017 at 06:15:23PM +0200, Laurent Pinchart wrote:
> > 
> [snip]
> 
> >>>> +/**
> >>>> + * ceu_soft_reset() - Software reset the CEU interface
> >>>> + */
> >>>> +static int ceu_soft_reset(struct ceu_device *ceudev)
> >>>> +{
> >>>> +	unsigned int reset_done;
> >>>> +	unsigned int i;
> >>>> +
> >>>> +	ceu_write(ceudev, CEU_CAPSR, CEU_CAPSR_CPKIL);
> >>>> +
> >>>> +	reset_done = 0;
> >>>> +	for (i = 0; i < 1000 && !reset_done; i++) {
> >>>> +		udelay(1);
> >>>> +		if (!(ceu_read(ceudev, CEU_CSTSR) & CEU_CSTRST_CPTON))
> >>>> +			reset_done++;
> >>>> +	}
> >>> 
> >>> How many iterations does this typically require ? Wouldn't a sleep be
> >>> better than a delay ? As far as I can tell the ceu_soft_reset()
> >>> function is only called with interrupts disabled (in interrupt context)
> >>> from ceu_capture() in an error path, and that code should be reworked
> >>> to make it possible to sleep if a reset takes too long.
> >> 
> >> The HW manual does not provide any indication about absolute timings.
> >> I can empirically try and see, but that would just be a hint.
> > 
> > That's why I asked how many iterations it typically takes :-) A hint is
> > enough to start with, preferably on both SH and ARM SoCs.
> 
> I've seen only 0s when printing out how many cycles it takes to clear
> both registers. This means 1usec is enough, therefore I would keep using
> udelay here. Also, I would reduce the attempts to 100 here (or even
> 10), as if a single one is typically enough, 1000 is definitely an
> overkill.

I'd go for 10. This being said, please make sure you run tests where the reset 
is performed during capture in the middle of a frame, to see if it changes the 
number of iterations.

> >> Also, the reset function is called in many places (runtime_pm
> >> suspend/resume) s_stream(0) and in error path of ceu_capture().
> >> 
> >> In ceu_capture() we reset the interface if the previous frame was bad,
> >> and we do that before re-enabling the capture interrupt (so interrupts
> >> are not -disabled-, just the one we care about is not enabled yet..)
> > 
> > The ceu_capture() function is called from the driver's interrupt handler,
> > so interrupts are disabled in that code path.
> 
> I have removed that reset call from capture and re-worked the irq
> handler to manage state before calling capture().
> 
> >> But that's not big deal, as if we fail there, we are about to abort
> >> capture anyhow and so if we miss some spurious capture interrupt it's
> >> ok...
> >> 
> >> >> +	if (!reset_done) {
> >> >> +		v4l2_err(&ceudev->v4l2_dev, "soft reset time out\n");
> >> > 
> >> > How about dev_err() instead ?
> >> 
> >> Is dev_err/dev_dbg preferred over v4l2_err/v4l2_dbg? Is this because
> >> of dynamic debug?
> > 
> > Yes, and the fact that the V4L2 macros don't provide us anymore with much
> > compared to the dev_* macros.
> > 
> >>>> +
> >>>> +/**
> >>>> + * ceu_capture() - Trigger start of a capture sequence
> >>>> + *
> >>>> + * Return value doesn't reflect the success/failure to queue the new
> >>>> buffer,
> >>>> + * but rather the status of the previous capture.
> >>>> + */
> >>>> +static int ceu_capture(struct ceu_device *ceudev)
> >>>> +{
> >>>> +	struct v4l2_pix_format_mplane *pix = &ceudev->v4l2_pix;
> >>>> +	dma_addr_t phys_addr_top;
> >>>> +	u32 status;
> >>>> +
> >>>> +	/* Clean interrupt status and re-enable interrupts */
> >>>> +	status = ceu_read(ceudev, CEU_CETCR);
> >>>> +	ceu_write(ceudev, CEU_CEIER,
> >>>> +		  ceu_read(ceudev, CEU_CEIER) & ~CEU_CEIER_MASK);
> >>>> +	ceu_write(ceudev, CEU_CETCR, ~status & CEU_CETCR_MAGIC);
> >>>> +	ceu_write(ceudev, CEU_CEIER, CEU_CEIER_MASK);
> >>> 
> >>> I wonder why there's a need to disable and reenable interrupts here.
> >> 
> >> The original driver clearly said "The hardware is -very- picky about
> >> this sequence" and I got scared and nerver touched this.
> > 
> > How about experimenting to see how the hardware reacts ?
> 
> Turns out this was not needed at all, both on RZ and SH4. I captured
> several images without any issues in both platforms just clearing the
> interrupt state without disabling interrutps.

I wonder whether it could cause an issue when interrupts are raised by the 
hardware at the same time they are cleared by the driver. That's hard to test 
though.

What happens when an interrupt source is masked by the CEIER register, is it 
still reported by the status CETCR register (obviously without raising an 
interrupt to the CPU), or does it not get flagged at all ?

> >> Also, I very much dislike the CEU_CETRC_MAGIC mask, but again the old
> >> driver said "Acknoledge magical interrupt sources" and I was afraid to
> >> change it (I can rename it though, to something lioke CEU_CETCR_ALL_INT
> >> because that's what it is, a mask with all available interrupt source
> >> enabled).
> > 
> > I think renaming it is a good idea. Additionally, regardless of whether
> > there is any hidden interrupt source, the datasheet mentions for all
> > reserved bits that "The write  value  should always  be 0". They should
> > read as 0, but masking them would be an additional safeguard.
> 
> The HW manual is a bit confused (and confusing) on this point.
> Yes, there is the statement you have cited here, but there's also
> "to clear only the CPE bit to 0, write H'FFFF FFFE to CETCR" a few
> lines above, which clearly contradicts the "write 0 to reserved bits"
> thing.
> 
> In practice, I'm now writing to 0 only bits to be cleared, and thus
> writing 1s to everything else, reserved included. I haven't seen any
> issue both on RZ and SH4 platforms.
> 
> > Also not that on the RZ/A1 platform bit 22 is documented as reserved, so
> > you might want to compute the mask based on the CEU model.
> 
> While I can use the .data pointer of 'of_device_id' for OF based
> devices (RZ) to store the opportune IRQ mask, I'm not sure how to
> do that for platform devices. Can I assume (platform data == SH) in
> you opinion?

Yes you can.

> > If you have time you could add a debug print when an undocumented
> > interrupt is flagged and see if that happens for real.
> 
> It's not "undocumented interrupt sources" but "magical interrupt
> sources". It's very different :-D

:-)

> By the way, no, never seen any!

-- 
Regards,

Laurent Pinchart
