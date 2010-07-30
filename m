Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39565 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab0G3Ty3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 15:54:29 -0400
Subject: Re: [PATCH 06/13] IR: nec decoder: fix repeat.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Christoph Bartelmus <lirc@bartelmus.de>
In-Reply-To: <4C5329D3.3020801@redhat.com>
References: <1280489933-20865-1-git-send-email-maximlevitsky@gmail.com>
	 <1280489933-20865-7-git-send-email-maximlevitsky@gmail.com>
	 <4C5329D3.3020801@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 22:54:24 +0300
Message-ID: <1280519664.3159.2.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-07-30 at 16:36 -0300, Mauro Carvalho Chehab wrote: 
> Em 30-07-2010 08:38, Maxim Levitsky escreveu:
> > Repeat space is 4 units, not 8.
> > Current code would never trigger a repeat.
> 
> Yes, this fixed the issue:
> 
> Jul 30 16:53:52 agua kernel: [24343.507577] ir_getkeycode: unknown key for scancode 0x0009
> Jul 30 16:53:52 agua kernel: [24343.507588] ir_nec_decode: Repeat last key
> Jul 30 16:53:52 agua kernel: [24343.507590] ir_nec_decode: NEC scancode 0x0009
> Jul 30 16:53:52 agua kernel: [24343.507592] ir_getkeycode: unknown key for scancode 0x0009
> Jul 30 16:53:52 agua kernel: [24343.507595] ir_nec_decode: Repeat last key
> Jul 30 16:53:52 agua kernel: [24343.724242] ir_nec_decode: NEC scancode 0x0009
> Jul 30 16:53:52 agua kernel: [24343.724246] ir_getkeycode: unknown key for scancode 0x0009
> Jul 30 16:53:52 agua kernel: [24343.724257] ir_nec_decode: Repeat last key
> Jul 30 16:53:52 agua kernel: [24343.724259] ir_nec_decode: NEC scancode 0x0009
> Jul 30 16:53:52 agua kernel: [24343.724261] ir_getkeycode: unknown key for scancode 0x0009
> Jul 30 16:53:52 agua kernel: [24343.724264] ir_nec_decode: Repeat last key
> Jul 30 16:53:53 agua kernel: [24343.937576] ir_nec_decode: NEC scancode 0x0009
> Jul 30 16:53:53 agua kernel: [24343.937580] ir_getkeycode: unknown key for scancode 0x0009
> Jul 30 16:53:53 agua kernel: [24343.937592] ir_nec_decode: Repeat last key
> Jul 30 16:53:53 agua kernel: [24343.937594] ir_nec_decode: NEC scancode 0x0009
> Jul 30 16:53:53 agua kernel: [24343.937596] ir_getkeycode: unknown key for scancode 0x0009
> Jul 30 16:53:53 agua kernel: [24343.937599] ir_nec_decode: Repeat last key
> 
> > 
> > However that isn't true for NECX, so repeat there
> > must be handled differently.
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> 
> Please preserve Andy's reviewed-by: when re-submitting a patch.

Yep, sorry about that!
Although, if I change a patch, I shouldn't preserve signed-off,
reviewed-by, lines, right?

Best regards,
Maxim Levitsky


> 
> > ---
> >  drivers/media/IR/ir-nec-decoder.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
> > index 52e0f37..1c0cf03 100644
> > --- a/drivers/media/IR/ir-nec-decoder.c
> > +++ b/drivers/media/IR/ir-nec-decoder.c
> > @@ -20,7 +20,7 @@
> >  #define NEC_HEADER_PULSE	(16 * NEC_UNIT)
> >  #define NECX_HEADER_PULSE	(8  * NEC_UNIT) /* Less common NEC variant */
> >  #define NEC_HEADER_SPACE	(8  * NEC_UNIT)
> > -#define NEC_REPEAT_SPACE	(8  * NEC_UNIT)
> > +#define NEC_REPEAT_SPACE	(4  * NEC_UNIT)
> >  #define NEC_BIT_PULSE		(1  * NEC_UNIT)
> >  #define NEC_BIT_0_SPACE		(1  * NEC_UNIT)
> >  #define NEC_BIT_1_SPACE		(3  * NEC_UNIT)
> 


