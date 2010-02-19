Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:56666 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab0BSAUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 19:20:23 -0500
Subject: Re: Documentation questions
From: Andy Walls <awalls@radix.net>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20100218211224.GA7879@selene>
References: <20100218211224.GA7879@selene>
Content-Type: text/plain
Date: Thu, 18 Feb 2010 19:19:27 -0500
Message-Id: <1266538767.3248.14.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-02-18 at 21:12 +0000, Hugo Mills wrote:
> Hi,
> 
> (Please cc: me, I'm not subscribed yet)
> 
>    After struggling to work out how stuff worked from the existing DVB
> API docs(+), I'm currently attempting to improve the API
> documentation, to cover the v5 API, and I've got a few questions:
> 
>  * Is anyone else working on docs right now? (i.e. am I wasting my time?)

About a year ago, I stated I was going to add the DVB API v5 additions.
Well, you see how far that has gotten: nowhere. :P

So please, your are welcome to help.

>  * Looking at the current kernel sources, the properties
> DTV_DISEQC_MASTER, DTV_DISEQC_SLAVE_REPLY, DTV_FE_CAPABILITY and
> DTV_FE_CAPABILITY_COUNT don't seem to be implemented. Is this actually
> the case, or have I missed something?
> 
>  * Most of the information in struct dvb_frontend_info doesn't seem to
> exist in the v5 API. Is there an expected way of getting this info (or
> isn't it considered useful any more?) Is FE_GET_INFO still recommended
> for that purpose in the v5 API?
>
>  * DTV_DELIVERY_SYSTEM is writable. What does this do? I would have
> thought it's a read-only property.
>
>  * Is there any way of telling which properties are useful for which
> delivery system types, or should I be going back to the relevant
> specifications for each type to get that information?

I have no comment on these at the moment.  I'd need to look into things
and get back to you.



>  * Is the "v5 API" for frontends only, or is there a similar key/value
> system in place/planned for the other DVB components such as demuxers?

As far as I know for the DVB v5 additions, that came from what was
originally called S2API, yes, they are only for frontends.

Some additional ioctl()'s related to the demux have been added as well
and are unrelated to the S2API additions.

Regards,
Andy

>    Thanks,
>    Hugo.
> 
> (+) Actually, the docs were pretty helpful, up to a point. Certainly
> better than some I've tried to read in the past. The biggest problem
> is the lack of coverage of the v5 API.
> 

