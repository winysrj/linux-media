Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbZKZQfu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 11:35:50 -0500
Message-ID: <4B0EAE5B.6050507@redhat.com>
Date: Thu, 26 Nov 2009 14:35:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph>  <m3einork1o.fsf@intrepid.localdomain>	 <1259025275.3871.55.camel@palomino.walls.org> <4B0E81C8.7050203@redhat.com> <1259243300.3062.61.camel@palomino.walls.org>
In-Reply-To: <1259243300.3062.61.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Thu, 2009-11-26 at 11:25 -0200, Mauro Carvalho Chehab wrote:

>> I'm not sure if all the existing hardware for TX currently supports only
>> raw pulse/code sequencies, but I still think that, even on the Tx case, 
>> it is better to send scancodes to the driver, and let it do the conversion
>> to raw pulse/code, if the hardware requires pulse/code instead of scancodes. 
> 
> That seems like a decision which will create a lots of duplicative code
> in the kernel.  Add it's just busy-work to write such code when a
> userspace application in common use already handles the protocols and
> sends raw pulses to hardware that expects raw pulses.

I don't see how this would create lots of duplicative code.

>> However, as we have green field,
>> I would add the protocol explicitly for each scancode to be transmitted, like:
>>
>> struct ir_tx {
>> 	enum ir_protocol proto;
>> 	u32 scancode;
>> };
>>
>> Eventually, we might have a protocol "raw" and some extra field to allow passing
>> a raw pulse/code sequence instead of a scancode.
> 
> I think you would have to.  32 bits is really not enough for all
> protocols, and it is already partial encoding of information anyway.
> 
> If the Tx driver has to break them down into pulses anyway, 

Do all Tx drivers need handle pulse by pulse, or there are some that works
only with scancodes?

> why not have fields with more meaningful names
> 
> 	mode
> 	toggle
> 	customer code (or system code or address),
> 	information (or command)
> 
> According to
> 
> 	http://slycontrol.ru/scr/kb/rc6.htm
> 
> the "information" field could be up to 128 bits.

Seems fine to me.

> (Not that I'm going to put any RC-6 Mode 6A decoding/encoding in the
> kernel.)		
> 
> Regards,
> Andy
> 
>> Cheers,
>> Mauro.
> 
> 

