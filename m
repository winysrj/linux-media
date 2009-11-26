Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760395AbZKZMgv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 07:36:51 -0500
Message-ID: <4B0E765C.2080806@redhat.com>
Date: Thu, 26 Nov 2009 10:36:44 -0200
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
References: <200910200956.33391.jarod@redhat.com>	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>	<4B0AC65C.806@redhat.com> <m3zl6dq8ig.fsf@intrepid.localdomain>
In-Reply-To: <m3zl6dq8ig.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Krzysztof Halasa wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
>> If you see patch 3/3, of the lirc submission series, you'll notice a driver
>> that has hardware decoding, but, due to lirc interface, the driver generates
>> pseudo pulse/space code for it to work via lirc interface.
> 
> IOW the driver generates artificial pulse code for lircd?
> I think - pure bloat. lircd can get events from input layer without
> problems. Perhaps I misunderstood?

lircd supports input layer interface. Yet, patch 3/3 exports both devices
that support only pulse/space raw mode and devices that generate scan
codes via the raw mode interface. It does it by generating artificial
pulse codes.
> 
>> It is very bad to have two interfaces for the same thing, because people
>> may do things like that.
> 
> I think having a "raw" scan code interface + the key code "cooked" mode
> is beneficial. For remotes lacking the raw interface only the latter
> could be used.

It sounds an interesting idea.

>> Are you meaning that we should do more than one RC per input event
>> interface?
> 
> I think so. Why not?
> 
> For example, one of my remotes generates codes from at least two RC5
> groups (in only one "mode"). Currently a remote is limited to only one
> RC5 group.

Yet, both are RC5. This can already be handled by the input layer.
See dvb-usb implementation.

The issue I see is to support at the same time NEC and RC5 protocols. While
this may work with some devices, for others, the hardware won't allow.

> 
> I think the mapping should be: key = proto + group + raw code, while
> key2 could be different_proto + different group (if any) + another code.

This may work for protocols up to RC5, that uses either 8 or 16 bits.
However, RC6 mode 6 codes can be 32 bits, and we have "only" 32 bits
for a scancode. So, we don't have spare bits to represent a protocol, 
if we consider RC6 mode 6 codes as well.

>> If so, why do you think we need to handle more than one IR protocol at
>> the same time?
> 
> Why not?
> There are X-in-1 remotes on the market for years. They can "speak" many
> protocols at once. One may want to have a protocol to handle DVD apps
> while another for DVB etc.
> And someone may want to use several different remotes, why not?
> Personally I use two different remotes (both set to speak RC5 but what
> if I couldn't set the protocol?). Sure, it requires a bit of hackery
> (not with pulse code and lircd).
> 
>> I think this will just make the driver more complex without need.
> 
> Not much more, and there is a need.

See above. Also, several protocols have a way to check if a keystroke were
properly received. When handling just one protocol, we can use this to double
check the key. However, on a multiprotocol mode, we'll need to disable this
feature.

PS.: For those following those discussions that want to know more about
IR protocols, a good reference is at:
	http://www.sbprojects.com/knowledge/ir/ir.htm

Unfortunately, it doesn't describe RC6 mode 6.

Cheers,
Mauro.
