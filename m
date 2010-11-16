Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:57293 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab0KPX0k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 18:26:40 -0500
Date: Wed, 17 Nov 2010 00:26:36 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@wilsonet.com>, Jarod Wilson <jarod@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Apple remote support
Message-ID: <20101116232636.GA28261@hardeman.nu>
References: <AANLkTimLU1TUn6nY4pr2pWNJp1hviyx=NiXYUQLSQA0e@mail.gmail.com>
 <20101101215635.GA4808@hardeman.nu>
 <AANLkTi=c_g7nxCFWsVMYM-tJr68V1iMzhSyJ7=g9VLnR@mail.gmail.com>
 <37bb20b43afce52964a95a72a725b0e4@hardeman.nu>
 <AANLkTimAx+D745-VxoUJ25ii+=Dm6rHb8OXs9_D69S1W@mail.gmail.com>
 <20101104193823.GA9107@hardeman.nu>
 <4CD30CE5.5030003@redhat.com>
 <da4aa0687909ae3843c682fbf446e452@hardeman.nu>
 <AANLkTin1Lu9cdnLeVfA8NDQFWkKzb6k+yCiSBqq6Otz6@mail.gmail.com>
 <4CE2743D.5040501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CE2743D.5040501@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Nov 16, 2010 at 10:08:29AM -0200, Mauro Carvalho Chehab wrote:
>Em 15-11-2010 02:11, Jarod Wilson escreveu:
>> Gives us support for using the full 32-bit codes right now w/o having
>> to change any tables yet, but does require a modparam to skip the
>> checksum checks, unless its an apple remote which we already know the
>> vendor bytes for. I do think I'm ultimately leaning towards just
>> doing the full 32 bits for all nec extended though -- optionally, we
>> might include a modparam to *enable* the checksum check for those
>> that want strict compliance (but I'd still say use the full 32 bits).
>> The only issue I see with going to the full 32 right now is that we
>> have all these nec tables with only 24 bits, and we don't know ...
>> oh, wait, no, nevermind... We *do* know the missing 8 bits, since
>> they have to fulfill the checksum check for command ^ not_command. So
>> yeah, I'd say 32-bit scancodes for all nec extended, don't enforce
>> the checksum by default with a module option (or sysfs knob) to
>> enable checksum compliance.
>
>A modprobe parameter for it doesn't seem right. Users should not need to
>do any manual hack for ther RC to work, if the keycode table is ok.

Agreed. There are already too many weird driver-specific modparams in
use as is.

>Also, changing the current tables to 32 bits will break userspace API, as all
>userspace keytables for NEC will stop working, all due to a few vendors that 
>decided to abuse on the NEC protocol. This doesn't sound fair.

The NEC protocol is hardly a standard. There's lot's of variations out
there. And intentionally throwing away information inside the kernel
doesn't sound fair either.

>Considering that the new setkeycode/getkeycode ioctls support a variable
>size for scancodes, it seems to me that the proper solution is properly
>add support for variable-size scancode tables. By doing this, one of the
>properties for a scancode table is the size of the scancode. The NEC decoding
>logic can take the scancode size into account, when deciding to check checksum
>or not.

With that approach you'd have to have the same scancode mangling code in
each driver which generates NEC scancodes as well as in the nec raw
decoder.

One suggestion would be to use a full 32-bit scancode table, but use the
size from the ioctl to determine how to generate the scancode to be
inserted into the table. So if the ioctl was called with a 2 byte
scancode, assume NEC with addr(8 bits) + cmd(8 bits); 3 byte -> NEC
Extended with addr(16 bits) + cmd(8 bits); 4 byte -> 32 bit scancode.

That way the nec decoder and other scancode drivers can be kept simple,
the scancode table has a full 32 bit scancode for all keys and userspace
won't see the difference (though I still think we should use the new
large scancode API to let userspace properly indicate the protocol along
with the scancode in the future).


-- 
David Härdeman
