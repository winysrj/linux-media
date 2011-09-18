Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:48182 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756136Ab1IRSpR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 14:45:17 -0400
Message-ID: <4E763C3C.3050909@xenotime.net>
Date: Sun, 18 Sep 2011 11:45:16 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Arnd Bergmann <arnd@arndb.de>, Jean Delvare <khali@linux-fr.org>,
	Luciano Coelho <coelho@ti.com>, matti.j.aaltonen@nokia.com,
	johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
	sameo@linux.intel.com, mchehab@infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Tony Lindgren <tony@atomide.com>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] misc: remove CONFIG_MISC_DEVICES
References: <20110829102732.03f0f05d.rdunlap@xenotime.net> <201109021643.14275.arnd@arndb.de> <20110905144134.2c80c4b9@endymion.delvare> <201109051619.35553.arnd@arndb.de> <4E760A31.8030807@xenotime.net> <20110918152835.GA30696@kroah.com>
In-Reply-To: <20110918152835.GA30696@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/18/2011 08:28 AM, Greg KH wrote:
> On Sun, Sep 18, 2011 at 08:11:45AM -0700, Randy Dunlap wrote:
>> On 09/05/2011 07:19 AM, Arnd Bergmann wrote:
>>> I think it would simply be more consistent to have it enabled all
>>> the time. Well, even better would be to move the bulk of the misc
>>> drivers to a proper location sorted by their subsystems. A lot of them
>>> should never have been merged in their current state IMHO.
>>
>>
>> If it's clear where they belong, then sure, they should be somewhere
>> other than drivers/misc/, but I don't see that it's clear for several
>> of them.
>>
>>
>>> I think I should finally do what has been  talked about a few times and
>>> formally become the maintainer of drivers/char and drivers/misc ;-)
>>>
>>> The problem is that I'm not actually a good maintainer, but maybe it's
>>> better to just have someone instead of falling back to Andrew or
>>> some random subsystem maintainer to send any patches for drivers/misc.
>>
>> We have fallbacks to Andrew and/or GregKH currently, but GregKH is not
>> consistent or timely with applying drivers/misc/ patches.  It deserves better.
>> [added him to Cc: list]
> 
> I do try to handle patches sent to me for misc/ in time for the
> different merge windows as that directory contains drivers that have
> moved out of the staging/ directory.
> 
> But yes, I'm not the overall drivers/misc/ maintainer, do we really need
> one?  If so, I can easily start maintaining a development tree for it to
> keep it separate for the different driver authors to send me stuff and
> start tracking it more "for real" if Arnd doesn't want to do it.

We need for the patches to be applied in a timely manner.
Sometimes when there is no real maintainer, that does not happen.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
