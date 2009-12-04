Return-path: <linux-media-owner@vger.kernel.org>
Received: from tac.ki.iif.hu ([193.6.222.43]:53075 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156AbZLDQLP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Dec 2009 11:11:15 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Jarod Wilson <jarod@redhat.com>,
	Jon Smirl <jonsmirl@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
References: <9e4733910912020930t3c9fe973k16fd353e916531a4@mail.gmail.com>
	<4B16BE6A.7000601@redhat.com>
	<20091202195634.GB22689@core.coreip.homeip.net>
	<2D11378A-041C-4B56-91FF-3E62F5F19753@wilsonet.com>
	<20091202201404.GD22689@core.coreip.homeip.net>
	<4B16CCD7.20601@redhat.com>
	<20091202205323.GF22689@core.coreip.homeip.net>
	<4B16D87F.7080701@redhat.com> <87tyw8ujsr.fsf@tac.ki.iif.hu>
	<4B17E874.5020003@redhat.com>
	<20091203173105.GA776@core.coreip.homeip.net>
Date: Fri, 04 Dec 2009 17:11:04 +0100
In-Reply-To: <20091203173105.GA776@core.coreip.homeip.net> (Dmitry Torokhov's
	message of "Thu, 3 Dec 2009 09:31:06 -0800")
Message-ID: <87pr6uafdz.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:

> On Thu, Dec 03, 2009 at 02:33:56PM -0200, Mauro Carvalho Chehab wrote:
>> Ferenc Wagner wrote:
>>> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
>> 
>> We should not forget that simple IR's don't have any key to select the address,
>> so the produced codes there will never have KEY_TV/KEY_DVD, etc.
>
> Wait, wait, KEY_TV, KEY_DVD, KEY_TAPE - they should be used to select
> media inputs in a device/application. My receiver accepts codes like
> that.

Sorry, my point wasn't the event names, I picked them for their
superficial correspondence to the TV, DVD, SAT etc. buttons found on
multifunction remotes.  Obviously I picked wrong.

I was also wrong to assume that remotes with such buttons are always
multifunction remotes in the sense that they are meant to control
separate devices.  As Mauro pointed out, (some) bundled remotes with
such buttons aren't; thus I wouldn't consider them multifunction at all.
They simply have some extra buttons labelled TV, DVD etc, which probably
shouldn't be mapped to KEY_TV, KEY_DVD etc. (since those events carry
different semantics) but should be mapped to something else.  Or not, if
these buttons change some internal decoder state instead, modifying the
mapping or destination input device of the other keys.

It's just a different scenario, where the kernel could reasonably give
rather different representations to simple applications aiming at
plug&play: letting through the function change events untouched, or
masking and using them internally.

True multifunction devices don't send such events, the TV, DVD etc
buttons on them change their internal state and the scan codes sent by
the other keys, if I understand this correctly.

I'd prefer if these two behaviours could be abstacted from, and the
input layer interface would provide destination selection events +
generic events, or (to be defined) device specific events only in either
case.  Is that possible or even reasonable?
-- 
Thanks,
Feri.

Ps: I'm writing this in the hope to clean up the landscape and possibly
help in choosing the best design.  I'm not at all familiar with IR, and
the above distinction was pretty surprising for me.  Also, I'm just
lurking here, so don't take me too seriously. :)
