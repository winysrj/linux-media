Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59800 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab0JPEMd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 00:12:33 -0400
Subject: Re: [PATCH 2/5] IR: extend ir_raw_event and do refactoring
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
In-Reply-To: <4CB91C05.3040904@infradead.org>
References: <1287158799-21486-1-git-send-email-maximlevitsky@gmail.com>
	 <1287158799-21486-3-git-send-email-maximlevitsky@gmail.com>
	 <4CB91C05.3040904@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Oct 2010 06:11:46 +0200
Message-ID: <1287202306.5156.2.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2010-10-16 at 00:29 -0300, Mauro Carvalho Chehab wrote:
> Em 15-10-2010 13:06, Maxim Levitsky escreveu:
> > Add new event types for timeout & carrier report
> > Move timeout handling from ir_raw_event_store_with_filter to
> > ir-lirc-codec, where it is really needed.
> > Now lirc bridge ensures proper gap handling.
> > Extend lirc bridge for carrier & timeout reports
> > 
> > Note: all new ir_raw_event variables now should be initialized
> > like that: DEFINE_IR_RAW_EVENT(ev);
> > 
> > To clean an existing event, use init_ir_raw_event(&ev);
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > Acked-by: Jarod Wilson <jarod@redhat.com>
> 
> 
> Applying patch patches/lmml_257371_2_5_ir_extend_ir_raw_event_and_do_refactoring.patch
> patching file drivers/media/IR/ene_ir.c
> patching file drivers/media/IR/ir-core-priv.h
> Hunk #1 succeeded at 88 (offset 6 lines).
> Hunk #2 succeeded at 121 (offset 6 lines).
> patching file drivers/media/IR/ir-jvc-decoder.c
> patching file drivers/media/IR/ir-lirc-codec.c
> Hunk #3 FAILED at 139.
> Hunk #4 FAILED at 167.
> Hunk #7 succeeded at 330 (offset 3 lines).
> 2 out of 7 hunks FAILED -- rejects in file drivers/media/IR/ir-lirc-codec.c
> patching file drivers/media/IR/ir-nec-decoder.c
> patching file drivers/media/IR/ir-raw-event.c
> patching file drivers/media/IR/ir-rc5-decoder.c
> patching file drivers/media/IR/ir-rc6-decoder.c
> patching file drivers/media/IR/ir-sony-decoder.c
> patching file drivers/media/IR/mceusb.c
> patching file drivers/media/IR/streamzap.c
> Hunk #1 FAILED at 170.
> Hunk #2 FAILED at 215.
> Hunk #3 FAILED at 233.
> Hunk #4 succeeded at 373 (offset -139 lines).
> 3 out of 4 hunks FAILED -- rejects in file drivers/media/IR/streamzap.c
> patching file include/media/ir-core.h
> Hunk #3 succeeded at 165 (offset 1 line).
> Patch patches/lmml_257371_2_5_ir_extend_ir_raw_event_and_do_refactoring.patch does not apply (enforce with -f)
> Patch didn't apply. Aborting
> 
> Too much fails for me... -EABORTING...
> 
> I won't apply this patch... there are two copies of it, and it has several broken hunks.
> 
> 
> Please fix.

Not surprising as v4l tree got many changes and that patch touches many
places.

Will redo that really against the media_tree :-)
Sorry!

Best regards,
	Maxim Levitsky



