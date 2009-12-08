Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935276AbZLHABD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2009 19:01:03 -0500
Message-ID: <4B1D9714.5060000@redhat.com>
Date: Mon, 07 Dec 2009 22:00:20 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jonsmirl@gmail.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <BDodf9W1qgB@lirc> <4B14EDE3.5050201@redhat.com>	<4B1524DD.3080708@redhat.com> <4B153617.8070608@redhat.com>	<A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com>	<4B17AA6A.9060702@redhat.com>	<20091203175531.GB776@core.coreip.homeip.net>	<20091203163328.613699e5@pedra>	<20091204100642.GD22570@core.coreip.homeip.net>	<20091204121234.5144836b@pedra>	<20091206070929.GB14651@core.coreip.homeip.net>	<4B1B8F83.5080009@redhat.com> <m31vj77t51.fsf@intrepid.localdomain>
In-Reply-To: <m31vj77t51.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Krzysztof Halasa wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 

>> struct input_keytable_entry {
>>  	u16	index;
>>  	u64	scancode;
>>  	u32	keycode;
>> } __attribute__ ((packed));
>>
>> (the attribute packed avoids needing a compat for 64 bits)
> 
> Maybe { u64 scancode; u32 keycode; u16 index; u16 reserved } would be a
> bit better, no alignment problems and we could eventually change
> "reserved" into something useful.
> 
> But I think, if we are going to redesign it, we better use scancodes of
> arbitrary length (e.g. protocol-dependent length). It should be opaque
> except for the protocol handler.

Yes, an opaque type for scancode at the userspace API can be better, but
passing a pointer to kernel will require some compat32 logic (as pointer
size is different on 32 and 64 bits).

We may use something like an u8[] with an arbitrary large number of bytes.
In this case, we need to take some care to avoid LSB/MSB troubles.

Cheers,
Mauro.
