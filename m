Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:23194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757063Ab0KRU7s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 15:59:48 -0500
Message-ID: <4CE593BF.4010908@redhat.com>
Date: Thu, 18 Nov 2010 18:59:43 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Apple remote support
References: <37bb20b43afce52964a95a72a725b0e4@hardeman.nu> <AANLkTimAx+D745-VxoUJ25ii+=Dm6rHb8OXs9_D69S1W@mail.gmail.com> <20101104193823.GA9107@hardeman.nu> <4CD30CE5.5030003@redhat.com> <da4aa0687909ae3843c682fbf446e452@hardeman.nu> <AANLkTin1Lu9cdnLeVfA8NDQFWkKzb6k+yCiSBqq6Otz6@mail.gmail.com> <4CE2743D.5040501@redhat.com> <20101116232636.GA28261@hardeman.nu> <20101118163304.GB16899@redhat.com> <20101118204319.GA8213@hardeman.nu> <20101118204952.GC16899@redhat.com>
In-Reply-To: <20101118204952.GC16899@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 18-11-2010 18:49, Jarod Wilson escreveu:
> On Thu, Nov 18, 2010 at 09:43:19PM +0100, David Härdeman wrote:
>> On Thu, Nov 18, 2010 at 11:33:04AM -0500, Jarod Wilson wrote:
>>> Mauro's suggestion, iirc, was that max scancode size should be a
>>> property of the keytable uploaded, and something set at load time (and
>>> probably exposed as a sysfs node, similar to protocols).
>>
>> I think that would be a step in the wrong direction. It would make the
>> keytables less flexible while providing no real advantages.

We can't simply just change NEC to 32 bits, as we'll break userspace ABI 
(as current NEC keycode tables use only 16 bits). So, an old table will not
worky anymore, if we do such change.

> I think it was supposed to be something you could update on the fly when
> uploading new keys, so its not entirely inflexible. Default keymap might
> be 24-bit NEC, then you upload 32-bit NEC codes, and the max scancode size
> would get updated at the same time. Of course, it probably wouldn't work
> terribly well to have a mix of 24-bit and 32-bit NEC codes in the same
> table.

There's another reason why it may be interesting to have the scancode size
stored somewhere. With the new flexible scancode size, some devices may have
bigger scancodes (I remember people mentioned some cases with 128 bits when 
we've discussed the getkeycodbig patches in the past). So, we'll need to
address some cases where the scancodes don't have 32 bits. I think that the
current maximum limit is 31 bits (as the search algorithm uses the signal
bit for some reason).

Cheers,
Mauro
