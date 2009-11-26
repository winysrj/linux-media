Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:40619 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZKZV1E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 16:27:04 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com>
	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>
	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>
	<4B0AC65C.806@redhat.com> <m3zl6dq8ig.fsf@intrepid.localdomain>
	<4B0E765C.2080806@redhat.com> <m3iqcxuotd.fsf@intrepid.localdomain>
	<4B0ED238.6060306@redhat.com> <m3pr75rpqa.fsf@intrepid.localdomain>
	<4B0EED7D.90204@redhat.com>
Date: Thu, 26 Nov 2009 22:27:08 +0100
In-Reply-To: <4B0EED7D.90204@redhat.com> (Mauro Carvalho Chehab's message of
	"Thu, 26 Nov 2009 19:05:01 -0200")
Message-ID: <m3ljhtrn83.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> No. All the other API functions there work with 32 bits for scancodes.

We don't need them, do we? We need a new ioctl for changing key mappings
anyway (a single ioctl for setting the whole table I think), and we can
have arbitrary length of scan codes there.

> (what's worse is that it is defined as "int" instead of "u32" - so the number
> of bits is different on 32 and on 64 systems)

Most (all?) 64-bit systems use 32-bit ints (and 64-bit longs).
u32 and similar are for sure better.

>> We signal both and hope it isn't self-destruct button.
>> We can't fix it no matter how hard we try.
>
> We can fix. Just let the userspace select what protocol(s) is(are) enabled.

Sure, I meant the situation when both protocols (and scan codes) where
enabled and configured. If we don't use RCx in the mapping table, we
don't pass anything to RCx routine. If we have RCx but don't have the
scan code in question, we don't find the key in the table and thus we
ignore it again.
-- 
Krzysztof Halasa
