Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43576 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab0ATPFo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 10:05:44 -0500
Message-ID: <4B571BC0.5000204@infradead.org>
Date: Wed, 20 Jan 2010 13:05:36 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Patrick Boettcher <pboettcher@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories
References: <4B55445A.10300@infradead.org>	 <201001190853.11050.hverkuil@xs4all.nl>	 <201001190910.39479.pboettcher@kernellabs.com>	 <1263944295.5229.16.camel@palomino.walls.org>  <4B56788B.907@infradead.org> <1263960514.5229.123.camel@palomino.walls.org>
In-Reply-To: <1263960514.5229.123.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Wed, 2010-01-20 at 01:29 -0200, Mauro Carvalho Chehab wrote: 
>> Andy Walls wrote:
>>> On Tue, 2010-01-19 at 09:10 +0100, Patrick Boettcher wrote:
>>>
>>>> BTW: I just made a clone of the git-tree - 365MB *ouff*.
>>> Assuming 53.333 kbps download speed, 0% overhead, no compression:
>>>
>>> 365 MiB * 2^20 bytes/MiB * 8 bits/byte / 53333 bits/sec / 3600 sec/hr =
>>> 15.95 hours
>> It is an one time download, since, once you got it, the updates are cheap.
>>
>> Btw, it is a way small than a single CD needed for you to install Linux.
>>
>> If you want to get it and you're not willing to pay to a decent Internet
>> connection,
> 
> If only I could pay for a *decent* one.
> 
> If I just want bandwidth at a poor level of service, poor reliability
> and high cost, then I'll pay for the local cable TV internet service.
> 
> I'm in one of the white areas on the map on page 33 of:
> 
> http://www.tccsmd.org/downloads/Broadband%20Final%20Report.pdf
> 
> I don't really have options for getting a good value for my dollar on
> broadband internet.
> 
> (The residential broadband deployment in the US is just terrible IMO.)

Rural areas are more problematic. Here, in Brazil, we have a good coverage at
low and fixed cost via cellular (about US$40,00/mo for 1Mb bandwidth). Yet, on
rural areas, there's no 3G support, so it drops to EDGE or 2G speed. I have
one of this, plus a xDSL link.

>> just ask someone to get it for you and save on a CD.
> 
> Nah.  Next time I head to the library, I'll just bring a laptop along:
> free WiFi.

Yeah, this should work. After you've pulled the tree, the updates are not that
bad.

>> Of course you can also keep using -hg.
> 
> That was my plan.
> 
> Regards,
> Andy
> 
>> Cheers,
>> Mauro
> 

