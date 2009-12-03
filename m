Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbZLCQfu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 11:35:50 -0500
Message-ID: <4B17E874.5020003@redhat.com>
Date: Thu, 03 Dec 2009 14:33:56 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ferenc Wagner <wferi@niif.hu>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
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
References: <4B15852D.4050505@redhat.com>	<20091202093803.GA8656@core.coreip.homeip.net>	<4B16614A.3000208@redhat.com>	<20091202171059.GC17839@core.coreip.homeip.net>	<9e4733910912020930t3c9fe973k16fd353e916531a4@mail.gmail.com>	<4B16BE6A.7000601@redhat.com>	<20091202195634.GB22689@core.coreip.homeip.net>	<2D11378A-041C-4B56-91FF-3E62F5F19753@wilsonet.com>	<20091202201404.GD22689@core.coreip.homeip.net>	<4B16CCD7.20601@redhat.com>	<20091202205323.GF22689@core.coreip.homeip.net>	<4B16D87F.7080701@redhat.com> <87tyw8ujsr.fsf@tac.ki.iif.hu>
In-Reply-To: <87tyw8ujsr.fsf@tac.ki.iif.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ferenc Wagner wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
>> Dmitry Torokhov wrote:
>>

> The interesting thing is that input.h defines KEY_TV, KEY_PC, KEY_SAT,
> KEY_CD, KEY_TAPE etc., but no corresponding scan codes will ever be sent
> by any remote (ok, I'm stretching it a bit). 

Unfortunately, this is not true. Some IR's do send a keycode for TV/PC/SAT/CD, etc.

On those remotes, if you press TV and then press for example Channel UP
and press Radio, then press Channel UP, the channel UP code will be the same.

For example, on Hauppauge Grey IR, we have:

<TV>
[13425.128525] ir_g_keycode_from_table: em28xx IR (em28xx #0): scancode 0x1e1c keycode 0x179
[13425.136733] ir_input_key_event: em28xx IR (em28xx #0): key event code=377 down=1
[13425.144170] ir_input_key_event: em28xx IR (em28xx #0): key event code=377 down=0

<CHANNEL UP>
[13428.350223] ir_g_keycode_from_table: em28xx IR (em28xx #0): scancode 0x1e20 keycode 0x192
[13428.358434] ir_input_key_event: em28xx IR (em28xx #0): key event code=402 down=1
[13428.365871] ir_input_key_event: em28xx IR (em28xx #0): key event code=402 down=0

<Radio>
[13430.672266] ir_g_keycode_from_table: em28xx IR (em28xx #0): scancode 0x1e0c keycode 0x181
[13430.680473] ir_input_key_event: em28xx IR (em28xx #0): key event code=385 down=1
[13430.687913] ir_input_key_event: em28xx IR (em28xx #0): key event code=385 down=0

<CHANNEL UP>
[13433.697268] ir_g_keycode_from_table: em28xx IR (em28xx #0): scancode 0x1e20 keycode 0x192
[13433.705480] ir_input_key_event: em28xx IR (em28xx #0): key event code=402 down=1
[13433.712916] ir_input_key_event: em28xx IR (em28xx #0): key event code=402 down=0

In this IR, the address is bogus: it is always 0x1e. This scenario is very common with the
shipped IR's.

> Instead, a multifunction
> remote (or two distinct remotes) would send different scan codes[1],
> which should be mapped to KEY_PLAYCD and KEY_PLAYDVD for example.
> Btw. the former is already defined, besides the generic KEY_PLAY.
> 
> Even if all this worked, user space would need integration with
> hal/devicekit to open the new input devices appearing on the fly (if
> it's initiated by the arrival of a scan code belonging to some new
> protocol), and also be able to decide whether the new event source is
> for it or not.
> 
> Given that commodity home appliances manage not to be confused by
> multiple or multifunction remotes, decent software should be able to do
> so as well.
> 
> [1] scan codes in the broadest possible sense, containing vendor,
> address and whatever, and only treating the case which is possible to
> handle in principle.

I see two alternatives for it:
	1) to map a multifunction scancode Address=TV/command=channel up as two
separate events: KEY_TV | KEY_CHANNELUP and let some userspace program to
handle it (lirc or other programs that knows IR keycodes);

	2) to implement Jon's filter idea of splitting one evdev interface into
several evdevs interface, one for each address.

We should not forget that simple IR's don't have any key to select the address,
so the produced codes there will never have KEY_TV/KEY_DVD, etc.

Cheers,
Mauro.
