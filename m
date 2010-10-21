Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:28713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758159Ab0JUN4E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 09:56:04 -0400
Message-ID: <4CC04671.6000608@redhat.com>
Date: Thu, 21 Oct 2010 11:56:01 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC]  ir-rc5-decoder: don't wait for the end space to
 produce a code
References: <4CBF2477.9020008@redhat.com> <0C5A1128-33E7-4331-98EB-D36C1005F51F@wilsonet.com>
In-Reply-To: <0C5A1128-33E7-4331-98EB-D36C1005F51F@wilsonet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 21-10-2010 11:46, Jarod Wilson escreveu:
> On Oct 20, 2010, at 1:18 PM, Mauro Carvalho Chehab wrote:
> 
>> The RC5 decoding is complete at a BIT_END state. there's no reason
>> to wait for the next space to produce a code.
> 
> Well, if I'm reading things correctly here, I think the only true functional difference made to the decoder here was to skip the if
> (ev.pulse) break; check in STATE_FINISHED, no? In other words, this looks like it was purely an issue with the receiver data parsing,
> which was ending on a pulse instead of a space. I can make this guess in greater confidence having seen another patch somewhere that
> implements a different buffer parsing routine for the polaris devices though... ;)

This patch doesn't solve the Polaris issue ;)

While I made it in the hope that it would fix Polaris (it ended by not solving), I still think it can be kept, as
it speeds up a little bit the RC-5 output, by not waiting for the last space.

I'll be forwarding soon the polaris decoder fixes patch, and another mceusb patch I did,
improving data decode on debug mode.

> The mceusb portion of the patch is probably a worthwhile micro-optimization of its ir processing routine though -- 
> don't call ir_raw_event_handle if there's no event to handle. Lemme just go ahead and merge that part via my staging tree, 
> if you don't mind. (I've got a dozen or so IR patches that have been queueing up, planning on another pull req relatively soon).
> 

Oh! I didn't notice that this went into the patch... for sure it doesn't belong here.
Yes, it is just a cleanup for mceusb. Feel free to split it, adding a proper description for it
and preserving my SOB.

Thanks,
Mauro
