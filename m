Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2635 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861AbZKINLt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 08:11:49 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: Finished my email backlog, let me know if I missed anything
Date: Mon, 9 Nov 2009 14:11:48 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <200911051730.53642.hverkuil@xs4all.nl> <19F8576C6E063C45BE387C64729E73940436F93B96@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940436F93B96@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911091411.48040.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vaibhav,

I've reviewed these patches, see comments below.

On Friday 06 November 2009 07:49:47 Hiremath, Vaibhav wrote:
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Hans Verkuil
> > Sent: Thursday, November 05, 2009 10:01 PM
> > To: linux-media@vger.kernel.org
> > Subject: Finished my email backlog, let me know if I missed anything
> > 
> > Hi all,
> > 
> > As I've been away/busy for a few weeks I had a large pile of pending
> > emails.
> > I went through it all today, but if I missed anything then please
> > remind me.
> > 
> [Hiremath, Vaibhav] Hans, there are some patches which I posted which need to be merged. Can you have look at it?
> 
> VPFE - 6 patches

I discovered that vpif_display.c does not compile at all due to a duplicate
config pointer. This is both in our tree and in 2.6.32-rc6.

I've made a patch for that. If you're OK with it then I pass it on to Mauro.

I also noticed that vpif_capture.c/h were missing in v4l-dvb, so I copied them
from 2.6.32-rc6.

>  - Davinci VPFE Capture: Specify device pointer in videobuf_queue_dma_contig_init

OK.

> - Davinci VPFE Capture:Replaced IRQ_VDINT1 with vpfe_dev->ccdc_irq1

OK.

> - Davinci VPFE Capture: Add support for Control ioctls[note: posting again]

Waiting for your new post.

> - TVP514x:Switch to automode for s_input/querystd

Reviewed. See comments in the review of this particular patch.

> - Davinci VPFE Capture: Take i2c adapter id through platform data

OK, but I split up the original patch into two: first adding the new field,
then the arch patch can be applied, and then the final vpfe_capture.c change
can be done. This ensures that a bisect will hopefully still work.

> 
> OMAP - 2 patches
> 
> - V4L2: Added CID's V4L2_CID_ROTATE/BG_COLOR

OK.

> - v4l2 doc: Added S/G_ROTATE, S/G_BG_COLOR information

OK.

> - V4L2: Add Capability and Flag field for Croma Key

Missing documentation!

BTW: the correct place to find the doc sources is in
linux/Documentation/DocBook/v4l/ in the master v4l-dvb mercurial repository.

> - OMAP2/3 V4L2:Add support for OMAP2/3 V4L2 driver ontop of DSS2[Note: need to repost again]

I wait for the repost and review it then.

My tree with all the pending patches is available here:

http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-vaibhav

Regards,

	Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
