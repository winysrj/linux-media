Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54604 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758883Ab2FUX2y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 19:28:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jean-philippe francois <jp.francois@cynove.com>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] omap3isp: preview: Add support for non-GRBG Bayer patterns
Date: Fri, 22 Jun 2012 01:29:05 +0200
Message-ID: <1495058.aP2aaavdWk@avalon>
In-Reply-To: <CAGGh5h2NoojuguvRfQRsYx2xX1eRzXWw-sJYdnDgquWqoGbD-w@mail.gmail.com>
References: <1340029853-2648-1-git-send-email-laurent.pinchart@ideasonboard.com> <CAGGh5h2NoojuguvRfQRsYx2xX1eRzXWw-sJYdnDgquWqoGbD-w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Philippe,

On Thursday 21 June 2012 15:35:52 jean-philippe francois wrote:
> 2012/6/18 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > Rearrange the CFA interpolation coefficients table based on the Bayer
> > pattern. Modifying the table during streaming isn't supported anymore,
> > but didn't make sense in the first place anyway.
> > 
> > Support for non-Bayer CFA patterns is dropped as they were not correctly
> > supported, and have never been tested.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  drivers/media/video/omap3isp/isppreview.c |  118 ++++++++++++++----------
> >  1 files changed, 67 insertions(+), 51 deletions(-)
> > 
> > Jean-Philippe,
> > 
> > Could you please test this patch on your hardware ?
> 
> Hi,
> 
> I have applied it on top of your omap3isp-next branch, but my board is
> oopsing right after the boot. I will try to get rid of this oops, but if you
> eventually now another tree that includes the changes necessary for this
> patch to apply, it could perhaps save me some time.

The patch should apply on top of the omap3isp-omap3isp-next branch that I've 
just pushed to my linuxtv tree.

> Here is a oops, in case somebody can point me to a patch, but the oops
> is not very specific :
> 
> <6>Total of 96 interrupts on 1 active controller
> <4>omap_hwmod: arm_fck: missing clockdomain for arm_fck.
> <4>omap_hwmod: gpt1_fck: missing clockdomain for gpt1_fck.
> <6>OMAP clockevent source: GPTIMER1 at 32768 Hz
> <6>sched_clock: 32 bits at 32kHz, resolution 30517ns, wraps every
> 131071999ms <1>Unable to handle kernel NULL pointer dereference at virtual
> address 00000000 <1>pgd = c0004000
> <1>[00000000] *pgd=00000000
> <0>Internal error: Oops: 80000005 [#1] PREEMPT ARM
> <d>Modules linked in:
> CPU: 0    Not tainted  (3.4.0-rc3 #2)
> PC is at 0x0
> LR is at __irq_svc+0x40/0x70
> pc : [<00000000>]    lr : [<c000e280>]    psr: 000001d3
> sp : c0461f88  ip : 0000000f  fp : 00000000
> r10: 00000000  r9 : 413fc082  r8 : 80004059
> r7 : c0461fbc  r6 : ffffffff  r5 : 00000153  r4 : c04367e0
> r3 : c0010108  r2 : c0461fd0  r1 : c046b00c  r0 : c0461f88
> Flags: nzcv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
> Control: 10c5387d  Table: 80004019  DAC: 00000015
> <0>Process swapper (pid: 0, stack limit = 0xc04602e8)
> <0>Stack: (0xc0461f88 to 0xc0462000)
> <0>1f80:                   00007735 000001d3 01ffffff c0468118 00000000
> c046808c <0>1fa0: c0456ec0 c046b004 80004059 413fc082 00000000 00000000
> 0000000f c0461fd0 <0>1fc0: c0010108 c04367e0 00000153 ffffffff 00000000
> 00000000 c04364fc 00000000 <0>1fe0: 00000000 c0456ec4 00000000 10c53c7d
> c046808c 8000803c 00000000 00000000 [<c000e280>] (__irq_svc+0x40/0x70) from
> [<c04367e0>] (start_kernel+0x138/0x254) [<c04367e0>]
> (start_kernel+0x138/0x254) from [<8000803c>] (0x8000803c) <0>Code: bad PC
> value

-- 
Regards,

Laurent Pinchart

