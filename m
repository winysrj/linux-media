Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:36841 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430AbcARP2z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 10:28:55 -0500
Subject: Re: [PATCH] media: Support Intersil/Techwell TW686x-based video
 capture cards
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
References: <1451183213-2733-1-git-send-email-ezequiel@vanguardiasur.com.ar>
 <569CE27F.6090702@xs4all.nl>
 <CAAEAJfCs1fipSadLj8WyxiJd9g7MCJj1KX5UdAPx1hPt16t0VA@mail.gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	=?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <569D04B1.4020802@xs4all.nl>
Date: Mon, 18 Jan 2016 16:28:49 +0100
MIME-Version: 1.0
In-Reply-To: <CAAEAJfCs1fipSadLj8WyxiJd9g7MCJj1KX5UdAPx1hPt16t0VA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/18/2016 04:20 PM, Ezequiel Garcia wrote:
> Hi Hans,
> 
> On 18 January 2016 at 10:02, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Ezequiel,
>>
>> Thanks for working on this! Do you know where I can get a board tw686x board?
>> I always like to have hardware to test the driver, if at all possible.
>>
> 
> No, I don't know. I have one to spare, and I could send it to you.
> 
>> See below for a review of this driver.

<snip>

>>> +     /*
>>> +      * This allows to detect device is not here,
>>> +      * and will be used by vb2_ops. The lock is really
>>> +      * important here.
>>> +      */
>>> +     spin_lock_irqsave(&dev->lock, flags);
>>> +     dev->pci_dev = NULL;
>>> +     spin_unlock_irqrestore(&dev->lock, flags);
>>
>> As you sure this is needed? Normally you can only come here if the module
>> is removed, which isn't possible as long as userspace is using it. And if
>> the module is removed, then vb2 shouldn't be called at all.
>>
>> The only exception would be if this is a hot-pluggable device, which is
>> quite unlikely for a PCI device. I don't believe any of the pci drivers
>> support that.
>>
> 
> A previous version of the driver didn't have that. However, under certain
> stress testing it was observed that the PCIe link goes down. I still have the
> traces for that:
> 
> [..]
> [21833.389031] pciehp 0000:13:01.0:pcie24: pcie_isr: intr_loc 100
> [21833.389035] pciehp 0000:13:01.0:pcie24: Data Link Layer State change
> [21833.389038] pciehp 0000:13:01.0:pcie24: slot(1-5): Link Down event
> [21833.389076] pciehp 0000:13:01.0:pcie24: Disabling
> domain:bus:device=0000:14:00
> [21833.389078] pciehp 0000:13:01.0:pcie24: pciehp_unconfigure_device:
> domain:bus:dev = 0000:14:00
> [21833.389103] TW686x 0000:14:00.0: removing
> [21833.416557] TW686x 0000:14:00.0: removed
> [..]
> 
> I have no idea why the link goes down (hardware issue?),
> but it's better to handle it gracefully :)

This definitely needs to be documented.

<snip>

>>> +             /* handle video stream */
>>> +             spin_lock_irqsave(&vc->qlock, flags);
>>> +             if (vc->curr_bufs[pb]) {
>>> +                     vb = &vc->curr_bufs[pb]->vb;
>>> +                     tw686x_buffer_copy(vc, pb, vb);
>>
>> You have to copy the data? It's not possible the program the DMA so that
>> it DMAs into the buffer itself? That's quite unusual for a PCI device.
>>
> 
> Yes, it's possible and I spent an enormous amount of time trying to make it work
> (originally using scatter-gather mode, and then with frame mode).
> 
> However, despite my many efforts it always stucked (sooner or later in
> the tests)
> into a hard machine freeze. There are two apparent sources for the freeze:
> 
> (1) To make the above work you need to program the registers so the chip DMAs
> into a new buffer each time the current DMA buffer is completed.
> 
> (2) Also, when a signal error is detected and/or signal is lost and recovered,
> the DMA channels are re-programmed as well.
> 
> It was only when all the registers write got removed and minimized to the bare
> minimum (registers are written before streaming starts and then stay mostly
> untouched) that I got a stable driver working fine for several weeks.
> 
> The ugly delay timer is meant to mitigate (2). And the buffer copy is
> to workaround (1).
> 
> Chip and board vendors couldn't provide any explanation for this
> behavior. I have
> two different boards (one with 1-chip, one with 2-chips and a PCIe switch),
> and the issues are present on both.
> 
> In any case, the vendor's Windows driver does the similar buffer-copy.
> 
> I understand that on some platforms this implementation could be too
> costly (it's
> completely cheap on any modern x86), and I intend to provide some option
> to provide "frame DMA-to-buffer" and "scatter-gather DMA".
> 
> However, I wanted to get this basic version merged first.
> 
> (Sorry, I should have included all this in the cover letter since
> it was pretty obvious you would ask :)

This too definitely needs to be documented in the code.

For both issues it is not enough to document that in the cover letter,
since future maintainers of the code will not see that. It really has to
be in the code itself.

These are typical workarounds for weird hardware behavior that isn't documented
anywhere and that future developers are inclined to remove if it isn't clearly
stated why they are needed.

Regards,

	Hans
