Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884AbZKZWHw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 17:07:52 -0500
Message-ID: <4B0EFC30.80208@redhat.com>
Date: Thu, 26 Nov 2009 20:07:44 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com>	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>	<4B0AC65C.806@redhat.com> <m3zl6dq8ig.fsf@intrepid.localdomain>	<4B0E765C.2080806@redhat.com> <m3iqcxuotd.fsf@intrepid.localdomain>	<4B0ED238.6060306@redhat.com> <m3pr75rpqa.fsf@intrepid.localdomain>	<4B0EED7D.90204@redhat.com> <m3ljhtrn83.fsf@intrepid.localdomain>
In-Reply-To: <m3ljhtrn83.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Krzysztof Halasa wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
>> No. All the other API functions there work with 32 bits for scancodes.
> 
> We don't need them, do we? We need a new ioctl for changing key mappings
> anyway (a single ioctl for setting the whole table I think), and we can
> have arbitrary length of scan codes there.

Why do you want to replace everything into a single shot? Had you ever tried
to replace a scancode table with the current API?

$ wc ./keycodes/dib0700_rc_keys
 216  432 3541 ./keycodes/dib0700_rc_keys

This is the biggest table we have: 216 scancodes. It has codes for several 
different IR's bound together into the same table.

Let's replace the entire table (tested on a dib8076 reference design device):

$ time ./keytable ./keycodes/dib0700_rc_keys

real    0m0.029s
user    0m0.000s
sys     0m0.027s

Don't you think that 29ms to replace 216 codes to be fast enough, especially since
you only need to do it once after plugging a device?

Also, if you want to control your device with two different IR controllers, the better
is to allow adding new keycodes there, instead of just allowing the replacement
of the entire table.

Maybe we'll need some extensions there, for example to extend the size of the dynamic
table, but I don't see any timing issue here.

Cheers,
Mauro
