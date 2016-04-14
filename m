Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56924 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729AbcDNNl0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 09:41:26 -0400
Subject: Re: tvp5150 regression after commit 9f924169c035
To: Wolfram Sang <wsa@the-dreams.de>
References: <20160208105417.GD2220@tetsubishi>
 <56BE57FC.3020407@osg.samsung.com> <20160212221352.GY3500@atomide.com>
 <56BE5C97.9070607@osg.samsung.com> <20160212224018.GZ3500@atomide.com>
 <56BE65F0.8040600@osg.samsung.com> <20160212234623.GB3500@atomide.com>
 <56BE993B.3010804@osg.samsung.com> <20160412223254.GK1526@katana>
 <570ECAB0.4050107@osg.samsung.com> <20160414111257.GG1533@katana>
Cc: Tony Lindgren <tony@atomide.com>, linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <570F9DF1.3070700@osg.samsung.com>
Date: Thu, 14 Apr 2016 09:41:05 -0400
MIME-Version: 1.0
In-Reply-To: <20160414111257.GG1533@katana>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Wolfram,

On 04/14/2016 07:12 AM, Wolfram Sang wrote:
> 
>> I'll write what I found so far in case someone with better knowledge about
>> the runtime PM API and the OMAP I2C controller driver can have an idea of
>> what could be causing this.
> 
> Thanks for the summary. I got no other reports like this, I wonder about

Yes, I also wonder why I'm the only one facing this issue... maybe no one
else is using the tvp5150 driver on an OMAP board with mainline?

> that. That being said, can you try this patch if it makes a change?
> 
> http://patchwork.ozlabs.org/patch/609280/
> 

Unfortunately it doesn't help, I just tried today's -next (next-20160414)
that already has the mentioned patch but the issue is still present.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
