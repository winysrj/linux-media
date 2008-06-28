Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.adl2.internode.on.net ([203.16.214.181])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sph3r3@internode.on.net>) id 1KCRDh-0001Cc-37
	for linux-dvb@linuxtv.org; Sat, 28 Jun 2008 05:35:29 +0200
From: "Adam" <sph3r3@internode.on.net>
To: linux-dvb@linuxtv.org
Date: Sat, 28 Jun 2008 13:05:12 +0930
Message-id: <4865b170.2e5.6a9b.26067@internode.on.net>
MIME-Version: 1.0
Subject: [linux-dvb] DVICO FusionHDTV DVB-T Pro
Reply-To: sph3r3@internode.on.net
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Daniel Gimpelevich wrote:

> Looking at cx88-cards.c, I see that the definition there
for your
> card is quite broken. I'm amazed it ever worked at all
with such
> incomplete support.

There was some preliminary work in
http://linuxtv.org/hg/~pascoe/xc-test/ that got DVB-T
working with this card in 2.6.24.  Analog TV, composite,
svideo, remote controls, etc didn't work (or at least I was
told they wouldn't work and I never tried them).  Is that
what you mean by 'quite broken'?  I'm not familiar enough
with the linuxtv codebase to make judgements of what you
mean for myself, but am willing to learn.  All I've really
done is applied patches that Chris supplied me.

> Fundamental portions of the cx88 driver need to be redone,
and for
> your card, that will mean going back to Windows to see
what the
> vendor's driver is doing with GPIO in response to
different inputs,
> as well as some experimentation. If you're up for things
like that,
> you can start by:
> 1) Gathering GPIO register values in Windows with RegSpy
from
> dscaler.org, recording what they are with each card input
selected
> (DVB, analog TV, composite, S-video, FM radio, SCART,
etc.), as well
> as the values after closing all apps related to the card,
so that the
> card is idle.

Done, at least some preliminary (i.e. non-exhaustive)
results.  See answer to 3) below.

> 2) Applying this patch:
> http://thread.gmane.org/gmane.comp.video.video4linux/38536
> Note that with the card definition as it currently is,
this patch
> will make the card stop working altogether. You will need
to redo the
> card definition to include all the info gathered in #1
above.

What revision should I apply this patch to?

> 3) Reporting your findings from #1 and #2 above. I will be
submitting
> a patch to the tuner-core that will pave the way for some
real fixing
> of cx88, and info on as many cx88 cards as possible will
be a plus
> during that fixing.

Where should I report my findings?  On-list or off-list?

> 4) Testing future cutting-edge patches to see how they
affect the use
> of the card, before those patches make it into the tree.

Fine by me.

>
> Have fun!

Thanks,
Adam

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
