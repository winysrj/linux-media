Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463AbZKZOF6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 09:05:58 -0500
Message-ID: <4B0E8B32.3020509@redhat.com>
Date: Thu, 26 Nov 2009 12:05:38 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Andy Walls <awalls@radix.net>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph>	<1259024037.3871.36.camel@palomino.walls.org> <m3k4xe7dtz.fsf@intrepid.localdomain>
In-Reply-To: <m3k4xe7dtz.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Krzysztof Halasa wrote:
> Andy Walls <awalls@radix.net> writes:
> 
>> I would also note that RC-6 Mode 6A, used by most MCE remotes, was
>> developed by Philips, but Microsoft has some sort of licensing interest
>> in it and it is almost surely encumbered somwhow:
> 
> I don't know about legal problems in some countries but from the
> technical POV handling the protocol in the kernel is more efficient
> or (/and) simpler.

A software licensing from Microsoft won't apply to Linux kernel, so I'm
assuming that you're referring to some patent that they could be filled
about RC6 mode 6A.

I don't know if is there any US patent pending about it (AFAIK, only US
accepts software patents), but there are some prior-art for IR key
decoding. So, I don't see what "innovation" RC6 would be adding. 
If it is some new way to transmit waves, the patent issues
aren't related to software, and the device manufacturer had already handled
it when they made their devices. If it is just a new keytable, this issue 
could be easily solved by loading the keytable via userspace.

Also, assuming that you can use the driver only with a hardware that comes
with a licensed software, the user has already the license for using it.

Do you have any details on what patents they are claiming?

Cheers,
Mauro.
