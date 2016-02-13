Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48234 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbcBMCrh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 21:47:37 -0500
Subject: Re: tvp5150 regression after commit 9f924169c035
To: Tony Lindgren <tony@atomide.com>
References: <56B204CB.60602@osg.samsung.com>
 <20160208105417.GD2220@tetsubishi> <56BE57FC.3020407@osg.samsung.com>
 <20160212221352.GY3500@atomide.com> <56BE5C97.9070607@osg.samsung.com>
 <20160212224018.GZ3500@atomide.com> <56BE65F0.8040600@osg.samsung.com>
 <20160212234623.GB3500@atomide.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Message-ID: <56BE993B.3010804@osg.samsung.com>
Date: Fri, 12 Feb 2016 23:47:23 -0300
MIME-Version: 1.0
In-Reply-To: <20160212234623.GB3500@atomide.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Tony,

On 02/12/2016 08:46 PM, Tony Lindgren wrote:

[snip]

>
> OK I doubt it's the GPIO driver if reverting 9f924169c035
> helps.
>

Right, sorry. I first thought the problem was with the OMAP GPIO
driver but then found that reverting 9f924169c035 caused the issue
to go away which indicates the problem is somehow related to I2C.

I forgot that and got confused again when answering to your email.

> I do see some GPIO regressions in current Linux next though,
> but sounds like you're using v4.5-rc series.
>

Yes, I'm testing with v4.5-rc and not linux-next.

>> It seems that is not related but I hope that given you were
>> looking at the runtime PM core lately, maybe you can figure
>> out what we are missing.
>>
>> I'm far from being familiar with the runtime PM framework
>> but I've looked and can't figure out why Wolfram's commit
>> make this driver to fail and reverting his commit make its
>> work again.
>
> No idea. What kind of PM runtime use case has that one been
> tested with?
>

Nothing special, the driver just fails to probe. What the driver
does is to toggle some pins (Power Down and Reset) in the tvp5150
chip to put it in an operational state and then attempts to read
an I2C register to detect the chip version and this is what fails.

> Regards,
>
> Tony
>

I'll try to find some time next week to dig deeper on this. Just
thought that may be related to the issue you found but it seems
that's not the case.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
