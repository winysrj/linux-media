Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbZKZVFI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 16:05:08 -0500
Message-ID: <4B0EED7D.90204@redhat.com>
Date: Thu, 26 Nov 2009 19:05:01 -0200
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
References: <200910200956.33391.jarod@redhat.com>	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>	<4B0AC65C.806@redhat.com> <m3zl6dq8ig.fsf@intrepid.localdomain>	<4B0E765C.2080806@redhat.com> <m3iqcxuotd.fsf@intrepid.localdomain>	<4B0ED238.6060306@redhat.com> <m3pr75rpqa.fsf@intrepid.localdomain>
In-Reply-To: <m3pr75rpqa.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Krzysztof Halasa wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
>> see include/linux/input.h:
>>
>> struct input_event {
>>         struct timeval time;
>>         __u16 type;
>>         __u16 code;
>>         __s32 value;
>> };
>>
>> extending the value to more than 32 bits require some changes at the
>> input layer, probably breaking kernel API.
> 
> Yeah, but that's a "key" space, not "raw code" space.
> Keys via input and raw codes via lirc and there is no problem.

No. All the other API functions there work with 32 bits for scancodes.

For example, the two ioctls to replace a scancode x key code are defined as:

#define EVIOCGKEYCODE           _IOR('E', 0x04, int[2])                 /* get keycode */
#define EVIOCSKEYCODE           _IOW('E', 0x04, int[2])                 /* set keycode */

We need to better analyze the API to see how this can be extended to
allow bigger widths.

(what's worse is that it is defined as "int" instead of "u32" - so the number
of bits is different on 32 and on 64 systems)

> The mapping tables for input layer need to have variable code widths,
> depending on the protocol, sure.
> 
>>> I don't think so. We can pass the space/mark data to all (configured,
>>> i.e. with active mapping) protocol handlers at once. Should a check
>>> fail, we ignore the data. Perhaps another protocol will make some sense
>>> out of it.
>> What happens if it succeeds on two protocol handlers?
> 
> We signal both and hope it isn't self-destruct button.
> We can't fix it no matter how hard we try.

We can fix. Just let the userspace select what protocol(s) is(are) enabled.

Cheers,
Mauro.
