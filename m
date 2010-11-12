Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:48800 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab0KLOPZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 09:15:25 -0500
Message-ID: <4CDD4BF7.1070209@infradead.org>
Date: Fri, 12 Nov 2010 12:15:19 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
CC: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/6] rc-core: ir-core to rc-core conversion
References: <4CDAC730.4060303@infradead.org> <20101110220115.GA7302@hardeman.nu> <4CDBF596.6030206@infradead.org> <02f13638ea24016b5b3673b50940a91c@hardeman.nu> <4CDC1326.3030502@infradead.org> <20101111203501.GA8276@hardeman.nu> <AANLkTinjBOdnYfs=+HVxjaurbwEA33U2YwE0=bdz_Zto@mail.gmail.com> <4CDCBBF7.8050702@infradead.org> <20101112121252.GB14033@hardeman.nu> <4CDD3982.8070804@infradead.org> <20101112140858.GA15203@hardeman.nu>
In-Reply-To: <20101112140858.GA15203@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 12-11-2010 12:08, David Härdeman escreveu:
> On Fri, Nov 12, 2010 at 10:56:34AM -0200, Mauro Carvalho Chehab wrote:
>> Em 12-11-2010 10:12, David Härdeman escreveu:
>>> Shouldn't platform_data be const? And you'll break the refcounting
>>> done in rc_allocate_device() and rc_free_device() /
>>> rc_unregister_device().  Not to mention the silent bugs that may be
>>> introduced if anyone modifies rc_allocate_device() without noticing
>>> that one driver isn't using it.
>>
>> It will still be const. platform_data will pass a pointer to some struct.
>> The value of the pointer won't change. I don't see why this would break
>> refcounting, as what will happen is that the caller driver will call
>> rc_allocate_device() and fill some fields there, instead of ir_kbd_i2c.
> 
> I think I've misunderstood what you've been proposing for ir_kbd_i2c.
> That sounds like a good solution.
> 
>> I'm working on a patch for it right now.
> 
> Good, I'll just wait until the patches are available to comment :)

They are there already ;)

http://www.spinics.net/lists/linux-media/msg24987.html
http://www.spinics.net/lists/linux-media/msg24986.html

Tested with a i2c-based cx231xx device (Pixelview Hybrid).

Cheers,
Mauro
