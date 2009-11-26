Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:48400 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbZKZSY1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 13:24:27 -0500
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
	<4B0E765C.2080806@redhat.com>
Date: Thu, 26 Nov 2009 19:24:30 +0100
In-Reply-To: <4B0E765C.2080806@redhat.com> (Mauro Carvalho Chehab's message of
	"Thu, 26 Nov 2009 10:36:44 -0200")
Message-ID: <m3iqcxuotd.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> The issue I see is to support at the same time NEC and RC5 protocols. While
> this may work with some devices, for others, the hardware won't allow.

Sure. We can handle it for the "simple" devices at least.

>> I think the mapping should be: key = proto + group + raw code, while
>> key2 could be different_proto + different group (if any) + another code.
>
> This may work for protocols up to RC5, that uses either 8 or 16 bits.
> However, RC6 mode 6 codes can be 32 bits, and we have "only" 32 bits
> for a scancode. So, we don't have spare bits to represent a protocol, 
> if we consider RC6 mode 6 codes as well.

I don't see this limitation. The number of bits should depend on the
protocol.

> See above. Also, several protocols have a way to check if a keystroke were
> properly received. When handling just one protocol, we can use this to double
> check the key. However, on a multiprotocol mode, we'll need to disable this
> feature.

I don't think so. We can pass the space/mark data to all (configured,
i.e. with active mapping) protocol handlers at once. Should a check
fail, we ignore the data. Perhaps another protocol will make some sense
out of it.
-- 
Krzysztof Halasa
