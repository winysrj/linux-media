Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:57993 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab2HPSSI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 14:18:08 -0400
Message-ID: <502D395C.8020003@iki.fi>
Date: Thu, 16 Aug 2012 21:18:04 +0300
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sebastian Reichel <sre@ring0.de>, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v3.7] [media] media: rc: Introduce RX51 IR transmitter
 driver
References: <E1T10iu-0000Xo-L8@www.linuxtv.org> <20120815160621.GV29636@valkosipuli.retiisi.org.uk> <502BFCA3.5040905@iki.fi> <20120816102328.GW29636@valkosipuli.retiisi.org.uk> <20120816112103.GA1429@earth.universe> <20120816163458.GA29636@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120816163458.GA29636@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/16/12 19:34, Sakari Ailus wrote:
> Hi Sebastian,
> 
> On Thu, Aug 16, 2012 at 01:21:04PM +0200, Sebastian Reichel wrote:
>> Hi,
>>
>>>> It was an requirement back then that this driver needs to be a module as
>>>> 99% of the N900 owners still don't even know they have this kind of
>>>> capability on their devices, so it doesn't make sense to keep the module
>>>> loaded unless the user actually needs it.
>>>
>>> I don't think that's so important --- currently the vast majority of the
>>> N900 users using the mainline kernel compile it themselves. It's more
>>> important to have a clean implementation at this point.
>>
>> I would like to enable this feature for the Debian OMAP kernel,
>> which is not only used for N900, but also for Pandaboard, etc.
> 
> Fair enough. Thanks for the info!
> 
> Timo: thinking this a little more, do you think the call is really needed?
> AFAIU it doesn't really achieve what it's supposed to, keeping the CPU from
> going to sleep. I noticed exactly the same problem you did, it was bad to
> the extent irsend failed due to a timeout unless I kept the CPU busy.

Yes, that's right. It's not really useful as is.

> So I think we can remove the call, which results in two things: the driver
> can be built as a module and the platform data does not contain a function
> pointer any longer.

Yeah, I agree. Although with the original N900 kernel the call did make
it work. But the power management implementation was different there
too. Maybe the proper fix for the problem is today something different
it was back then.

If I have time I'll see if I can figure out something..

-Timo

