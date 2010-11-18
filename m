Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:17289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756939Ab0KRQdI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 11:33:08 -0500
Date: Thu, 18 Nov 2010 11:33:04 -0500
From: Jarod Wilson <jarod@redhat.com>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Apple remote support
Message-ID: <20101118163304.GB16899@redhat.com>
References: <20101101215635.GA4808@hardeman.nu>
 <AANLkTi=c_g7nxCFWsVMYM-tJr68V1iMzhSyJ7=g9VLnR@mail.gmail.com>
 <37bb20b43afce52964a95a72a725b0e4@hardeman.nu>
 <AANLkTimAx+D745-VxoUJ25ii+=Dm6rHb8OXs9_D69S1W@mail.gmail.com>
 <20101104193823.GA9107@hardeman.nu>
 <4CD30CE5.5030003@redhat.com>
 <da4aa0687909ae3843c682fbf446e452@hardeman.nu>
 <AANLkTin1Lu9cdnLeVfA8NDQFWkKzb6k+yCiSBqq6Otz6@mail.gmail.com>
 <4CE2743D.5040501@redhat.com>
 <20101116232636.GA28261@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101116232636.GA28261@hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Nov 17, 2010 at 12:26:36AM +0100, David Härdeman wrote:
> On Tue, Nov 16, 2010 at 10:08:29AM -0200, Mauro Carvalho Chehab wrote:
...
> >Also, changing the current tables to 32 bits will break userspace API, as all
> >userspace keytables for NEC will stop working, all due to a few vendors that 
> >decided to abuse on the NEC protocol. This doesn't sound fair.
> 
> The NEC protocol is hardly a standard. There's lot's of variations out
> there. And intentionally throwing away information inside the kernel
> doesn't sound fair either.
> 
> >Considering that the new setkeycode/getkeycode ioctls support a variable
> >size for scancodes, it seems to me that the proper solution is properly
> >add support for variable-size scancode tables. By doing this, one of the
> >properties for a scancode table is the size of the scancode. The NEC decoding
> >logic can take the scancode size into account, when deciding to check checksum
> >or not.
> 
> With that approach you'd have to have the same scancode mangling code in
> each driver which generates NEC scancodes as well as in the nec raw
> decoder.
> 
> One suggestion would be to use a full 32-bit scancode table, but use the
> size from the ioctl to determine how to generate the scancode to be
> inserted into the table. So if the ioctl was called with a 2 byte
> scancode, assume NEC with addr(8 bits) + cmd(8 bits); 3 byte -> NEC
> Extended with addr(16 bits) + cmd(8 bits); 4 byte -> 32 bit scancode.
> 
> That way the nec decoder and other scancode drivers can be kept simple,
> the scancode table has a full 32 bit scancode for all keys and userspace
> won't see the difference (though I still think we should use the new
> large scancode API to let userspace properly indicate the protocol along
> with the scancode in the future).

I hacked together a semi-nasty variant of this, which I already know Mauro
isn't too keen on, but its perhaps a step in the right direction. At
least, its hopefully better than a modparam approach... ;)

http://git.kernel.org/?p=linux/kernel/git/jarod/linux-2.6-ir.git;a=commitdiff;h=a2eabcb44fa72e98a912c05a23659d0c946a17e5
http://git.kernel.org/?p=linux/kernel/git/jarod/linux-2.6-ir.git;a=commitdiff;h=164dc9cf5dec582bda5f7a059957ac2da2b0c1aa

Mauro's suggestion, iirc, was that max scancode size should be a property
of the keytable uploaded, and something set at load time (and probably
exposed as a sysfs node, similar to protocols). However, the one issue I
see there is that if someone loads a 16-bit keytable, then does a single
scancode replacement with something much larger, how are we going to
handle that?

-- 
Jarod Wilson
jarod@redhat.com

