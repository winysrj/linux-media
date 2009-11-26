Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbZKZTIq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 14:08:46 -0500
Message-ID: <4B0ED238.6060306@redhat.com>
Date: Thu, 26 Nov 2009 17:08:40 -0200
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
References: <200910200956.33391.jarod@redhat.com>	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>	<4B0AC65C.806@redhat.com> <m3zl6dq8ig.fsf@intrepid.localdomain>	<4B0E765C.2080806@redhat.com> <m3iqcxuotd.fsf@intrepid.localdomain>
In-Reply-To: <m3iqcxuotd.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Krzysztof Halasa wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
>> The issue I see is to support at the same time NEC and RC5 protocols. While
>> this may work with some devices, for others, the hardware won't allow.
> 
> Sure. We can handle it for the "simple" devices at least.
> 
>>> I think the mapping should be: key = proto + group + raw code, while
>>> key2 could be different_proto + different group (if any) + another code.
>> This may work for protocols up to RC5, that uses either 8 or 16 bits.
>> However, RC6 mode 6 codes can be 32 bits, and we have "only" 32 bits
>> for a scancode. So, we don't have spare bits to represent a protocol, 
>> if we consider RC6 mode 6 codes as well.
> 
> I don't see this limitation. The number of bits should depend on the
> protocol.

see include/linux/input.h:

struct input_event {
        struct timeval time;
        __u16 type;
        __u16 code;
        __s32 value;
};

extending the value to more than 32 bits require some changes at the input layer,
probably breaking kernel API.

> 
>> See above. Also, several protocols have a way to check if a keystroke were
>> properly received. When handling just one protocol, we can use this to double
>> check the key. However, on a multiprotocol mode, we'll need to disable this
>> feature.
> 
> I don't think so. We can pass the space/mark data to all (configured,
> i.e. with active mapping) protocol handlers at once. Should a check
> fail, we ignore the data. Perhaps another protocol will make some sense
> out of it.

What happens if it succeeds on two protocol handlers?

Cheers,
Mauro.
