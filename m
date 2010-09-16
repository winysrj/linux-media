Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab0IPNuo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 09:50:44 -0400
Date: Thu, 16 Sep 2010 09:50:26 -0400
From: Jarod Wilson <jarod@redhat.com>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Anders Eriksson <aeriksson@fastmail.fm>,
	Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: [PATCH 2/4] imon: split mouse events to a separate input dev
Message-ID: <20100916135026.GC29829@redhat.com>
References: <20100916051932.GA23299@redhat.com>
 <20100916052245.GC23299@redhat.com>
 <d1cd45c6d862e80252cf82047455e9b6.squirrel@www.hardeman.nu>
 <20100916133437.GB29829@redhat.com>
 <71ca284f14c192e78cd103d19ae4c1b2.squirrel@www.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71ca284f14c192e78cd103d19ae4c1b2.squirrel@www.hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Sep 16, 2010 at 03:43:42PM +0200, David Härdeman wrote:
> On Thu, September 16, 2010 15:34, Jarod Wilson wrote:
> > On Thu, Sep 16, 2010 at 01:32:07PM +0200, David Härdeman wrote:
> >> On Thu, September 16, 2010 07:22, Jarod Wilson wrote:
> >> > This is a stab at separating the mouse (and front panel/knob) events
> >> > out to a separate input device. This is necessary in preparation for
> >> > the next patch which makes the rc-core input dev opaque to rc
> >> > drivers.
> >> >
> >> > I can't verify the correctness of the patch beyond the fact that it
> >> > compiles without warnings. The driver has resisted most of my
> >> > attempts at understanding it properly...for example, the double calls
> >> > to le64_to_cpu() and be64_to_cpu() which are applied in
> >> > imon_incoming_packet() and imon_panel_key_lookup() would amount
> >> > to a bswab64() call, irregardless of the cpu endianness, and I think
> >> > the code wouldn't have worked on a big-endian machine...
> >> >
> >> > Signed-off-by: David Härdeman <david@hardeman.nu>
> >> >
> >> > - Minor alterations to apply with minimal core IR changes
> >> > - Use timer for imon keys too, since its entirely possible for the
> >> >   receiver to miss release codes (either by way of another key being
> >> >   pressed while the first is held or by the remote pointing away from
> >> >   the recevier when the key is release. yes, I know, its ugly).
> >>
> >> Where's the additional timer usage exactly? I can't see any in the
> >> patch...
> >
> > For ktype == IMON_KEY_IMON in your original patch, keys were submitted
> > with ir_keydown_notimeout, and in this version, they're submitted with
> > plain old ir_keydown, which has a built-in timeout.
> 
> Oh, I see. But since you're not adding any timer to the driver code itself
> I do not consider the use of plain ir_keydown to be ugly at all (contrary
> to what your comment indicated).

Oh, sorry, that rant was about the receiver hardware, not the actual code
-- yes, the code gets much much cleaner here. :)

> Maybe a keyup hardware event is generated (handled via ir_keyup, good),
> maybe it isnt't (handled via ir-core timeout which calls ir_keyup
> eventually, good).

Yeah, its behaving much better for the specific cases Anssi mentioned in
the bug now. We also get the automatic release of a key that wasn't
released before pressing a second key, by way of the ir_keyup call in
ir_keydown.

-- 
Jarod Wilson
jarod@redhat.com

