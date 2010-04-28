Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f189.google.com ([209.85.221.189]:61915 "EHLO
	mail-qy0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab0D1EcX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 00:32:23 -0400
MIME-Version: 1.0
In-Reply-To: <20100424051206.GA3101@hardeman.nu>
References: <20100401145632.5631756f@pedra>
	 <t2z9e4733911004011844pd155bbe8g13e4cbcc1a5bf1f6@mail.gmail.com>
	 <20100402102011.GA6947@hardeman.nu>
	 <p2ube3a4a1004051349y11e3004bk1c71e3ab38d3f669@mail.gmail.com>
	 <20100407093205.GB3029@hardeman.nu>
	 <z2hbe3a4a1004231040uce51091fnf24b97de215e3ef1@mail.gmail.com>
	 <20100424051206.GA3101@hardeman.nu>
Date: Wed, 28 Apr 2010 00:32:22 -0400
Message-ID: <h2hbe3a4a1004272132y46e90a8ak862f20620053b1cc@mail.gmail.com>
Subject: Re: [PATCH 00/15] ir-core: Several improvements to allow adding LIRC
	and decoder plugins
From: Jarod Wilson <jarod@wilsonet.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: Jon Smirl <jonsmirl@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 24, 2010 at 1:12 AM, David Härdeman <david@hardeman.nu> wrote:
> On Fri, Apr 23, 2010 at 01:40:34PM -0400, Jarod Wilson wrote:
>> So now that I'm more or less done with porting the imon driver, I
>> think I'm ready to start tackling the mceusb driver. But I'm debating
>> on what approach to take with respect to lirc support. It sort of
>> feels like we should have lirc_dev ported as an ir "decoder"
>> driver/plugin before starting to port mceusb to ir-core, so that we
>> can maintain lirc compat and transmit support. Alternatively, I could
>> port mceusb without lirc support for now, leaving it to only use
>> in-kernel decoding and have no transmit support for the moment, then
>> re-add lirc support. I'm thinking that porting lirc_dev as, say,
>> ir-lirc-decoder first is probably the way to go though. Anyone else
>> want to share their thoughts on this?
>
> I think it would make sense to start with a mce driver without the TX
> and lirc bits first. Adding lirc rx support can be done as a separate
> "raw" decoder later (so its scope is outside the mce driver anyway) and
> TX support is not implemented in ir-core yet and we haven't had any
> discussion yet on which form it should take.

So after looking at folks feedback, I did settle on starting the
mceusb port first, my logic going more or less like this... Having a
well-supported general-purpose IR receiver functional is a Good Thing
for people wanting to work on protocol support (i.e., so they have a
way to actually test protocol support). Having an
already-ir-core-ified driver to test out an ir-lirc-decoder (lirc_dev
port) would also be rather helpful. So rather than trying to port
lirc_dev before there's anything that can actually make use of it,
give myself something to work with. I'm kind of thinking that
ir-lirc-decoder might actually be ir-lirc-codec, able to do xmit as
well, maintaining full compat with lirc userspace, and then we'd have
a separate input subsystem based xmit method at some point, which
might be the "preferred/blessed" route. This means ripping a bunch of
code out of lirc_mceusb.c only to put it back in later, but that's not
terribly painful. I've already got as far as having an mceusb.c that
has no lirc dependency, which builds, but doesn't actually do anything
useful yet (not wired up to ir-core). Should be able to get something
functional RSN, I hope...

-- 
Jarod Wilson
jarod@wilsonet.com
