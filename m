Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:36200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab0IPNew (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 09:34:52 -0400
Date: Thu, 16 Sep 2010 09:34:37 -0400
From: Jarod Wilson <jarod@redhat.com>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Anders Eriksson <aeriksson@fastmail.fm>,
	Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: [PATCH 2/4] imon: split mouse events to a separate input dev
Message-ID: <20100916133437.GB29829@redhat.com>
References: <20100916051932.GA23299@redhat.com>
 <20100916052245.GC23299@redhat.com>
 <d1cd45c6d862e80252cf82047455e9b6.squirrel@www.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d1cd45c6d862e80252cf82047455e9b6.squirrel@www.hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Sep 16, 2010 at 01:32:07PM +0200, David Härdeman wrote:
> On Thu, September 16, 2010 07:22, Jarod Wilson wrote:
> > This is a stab at separating the mouse (and front panel/knob) events
> > out to a separate input device. This is necessary in preparation for
> > the next patch which makes the rc-core input dev opaque to rc
> > drivers.
> >
> > I can't verify the correctness of the patch beyond the fact that it
> > compiles without warnings. The driver has resisted most of my
> > attempts at understanding it properly...for example, the double calls
> > to le64_to_cpu() and be64_to_cpu() which are applied in
> > imon_incoming_packet() and imon_panel_key_lookup() would amount
> > to a bswab64() call, irregardless of the cpu endianness, and I think
> > the code wouldn't have worked on a big-endian machine...
> >
> > Signed-off-by: David Härdeman <david@hardeman.nu>
> >
> > - Minor alterations to apply with minimal core IR changes
> > - Use timer for imon keys too, since its entirely possible for the
> >   receiver to miss release codes (either by way of another key being
> >   pressed while the first is held or by the remote pointing away from
> >   the recevier when the key is release. yes, I know, its ugly).
> 
> Where's the additional timer usage exactly? I can't see any in the patch...

For ktype == IMON_KEY_IMON in your original patch, keys were submitted
with ir_keydown_notimeout, and in this version, they're submitted with
plain old ir_keydown, which has a built-in timeout.

-- 
Jarod Wilson
jarod@redhat.com

