Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbZK0Bqb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 20:46:31 -0500
Message-ID: <4B0F2F50.5050102@redhat.com>
Date: Thu, 26 Nov 2009 23:45:52 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jarod Wilson <jarod@wilsonet.com>, Andy Walls <awalls@radix.net>,
	Christoph Bartelmus <lirc@bartelmus.de>, khc@pm.waw.pl,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph> <1259024037.3871.36.camel@palomino.walls.org> <6D934408-B713-49B6-A197-46CE663455AC@wilsonet.com> <4B0E889C.9060405@redhat.com> <4B0EBBB5.5090303@wilsonet.com> <4B0EBF99.1070404@redhat.com> <20091126235057.GG6936@core.coreip.homeip.net>
In-Reply-To: <20091126235057.GG6936@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov wrote:
> On Thu, Nov 26, 2009 at 03:49:13PM -0200, Mauro Carvalho Chehab wrote:
>> Dmitry,
>>
>> While lirc is basically a series of input drivers, considering that they have lots
>> in common with the input drivers at V4L/DVB and that we'll need to work on
>> some glue to merge both, do you mind if I add the lirc drivers at drivers/staging from
>> my trees? 
>>
> 
> Mauro,
> 
> I would not mind if you will be pushing it to staging, however I am not
> sure we have an agreement on what exactly the interface that we will be
> using. I would hate to get something in that will need to be reworked
> again.

I understand your concerns.

IMHO, we should be really careful with API's when migrating from staging to the
right place, but I'm not that much concerned with staging. We already have several 
drivers there with bad behaviors and even with some API's there that will go to /dev/null.

For example there's a V4L2 driver there (staging/go7007) that has their own private
API to handle compressed streams. I won't ack moving it from staging while
it has their own private extensions for something that are part of V4L2 API.

Also, staging drivers without progress for a few kernel cycles will be moved to /dev/null,
so I don't see much sense of denying a driver to go there.

Anyway, I'll add it there only when you feel comfortable about that and send us your ack.

-

>From what I heard on the comments, I think we have already a consensus of some points:
	1) all IR's should implement the standard evdev interface;
	2) IR's with raw interfaces will implement a raw pulse/space IR interface. 
The proposal is to use lirc API interface for raw pulse/code TX and RX.

Do you think we'll need to better detail the IR raw interface API before accepting 
the patches for staging? If so, what level of details do you want?

Cheers,
Mauro.
