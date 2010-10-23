Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56611 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab0JWCCO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 22:02:14 -0400
Received: by fxm16 with SMTP id 16so1242557fxm.19
        for <linux-media@vger.kernel.org>; Fri, 22 Oct 2010 19:02:13 -0700 (PDT)
Subject: Re: [PATCH RFC]  ir-rc5-decoder: don't wait for the end space to
 produce a code
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4CC23CD7.1000907@redhat.com>
References: <4CBF2477.9020008@redhat.com>
	 <0C5A1128-33E7-4331-98EB-D36C1005F51F@wilsonet.com>
	 <4CC04671.6000608@redhat.com> <1287797114.4948.2.camel@maxim-laptop>
	 <4CC23CD7.1000907@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Oct 2010 04:02:09 +0200
Message-ID: <1287799329.11999.5.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 2010-10-22 at 23:39 -0200, Mauro Carvalho Chehab wrote:
> Em 22-10-2010 23:25, Maxim Levitsky escreveu:
> > On Thu, 2010-10-21 at 11:56 -0200, Mauro Carvalho Chehab wrote:
> >> Em 21-10-2010 11:46, Jarod Wilson escreveu:
> >>> On Oct 20, 2010, at 1:18 PM, Mauro Carvalho Chehab wrote:
> >>>
> >>>> The RC5 decoding is complete at a BIT_END state. there's no reason
> >>>> to wait for the next space to produce a code.
> >>>
> >>> Well, if I'm reading things correctly here, I think the only true functional difference made to the decoder here was to skip the if
> >>> (ev.pulse) break; check in STATE_FINISHED, no? In other words, this looks like it was purely an issue with the receiver data parsing,
> >>> which was ending on a pulse instead of a space. I can make this guess in greater confidence having seen another patch somewhere that
> >>> implements a different buffer parsing routine for the polaris devices though... ;)
> >>
> >> This patch doesn't solve the Polaris issue ;)
> >>
> >> While I made it in the hope that it would fix Polaris (it ended by not solving), I still think it can be kept, as
> >> it speeds up a little bit the RC-5 output, by not waiting for the last space.
> >>
> >> I'll be forwarding soon the polaris decoder fixes patch, and another mceusb patch I did,
> >> improving data decode on debug mode.
> >>
> >>> The mceusb portion of the patch is probably a worthwhile micro-optimization of its ir processing routine though -- 
> >>> don't call ir_raw_event_handle if there's no event to handle. Lemme just go ahead and merge that part via my staging tree, 
> >>> if you don't mind. (I've got a dozen or so IR patches that have been queueing up, planning on another pull req relatively soon).
> >>>
> >>
> >> Oh! I didn't notice that this went into the patch... for sure it doesn't belong here.
> >> Yes, it is just a cleanup for mceusb. Feel free to split it, adding a proper description for it
> >> and preserving my SOB.
> > 
> > No need in this patch.
> > My patch resolves the issue genericly by making the driver send the
> > timeout message at the end of the data among the current length of the
> > space (which will continue to grow).
> > 
> > Just make mceusb send the timeout sample.
> 
> 
> Hmm... now, a RC6(0) remote is also being decoded as a RC5 remote. Could this be due to
> your patches?
Very unlikely.
Probably the remote is really RC5

RC5 and RC6 just differ too much.
And besides mceusb doesn't even send the timeouts yet.
Still you could revert and see if it helps.

The only patch that has any potential of breaking anything is the
'[PATCH 1/3] IR: extend ir_raw_event and do refactoring'

Note that I tried going the way this patch does.
And it really doesn't work.



Best regards,
	Maxim Levitsky

