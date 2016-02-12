Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48210 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbcBLW0b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 17:26:31 -0500
Subject: Re: tvp5150 regression after commit 9f924169c035
To: Wolfram Sang <wsa@the-dreams.de>
References: <56B204CB.60602@osg.samsung.com>
 <20160208105417.GD2220@tetsubishi> <56BE57FC.3020407@osg.samsung.com>
 <20160212222208.GD1529@katana>
Cc: linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	Tony Lindgren <tony@atomide.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56BE5C0C.3060703@osg.samsung.com>
Date: Fri, 12 Feb 2016 19:26:20 -0300
MIME-Version: 1.0
In-Reply-To: <20160212222208.GD1529@katana>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Wolfram,

On 02/12/2016 07:22 PM, Wolfram Sang wrote:
>
>> I'm adding Tony Lindgren to the cc list as well since he is the OMAP
>> maintainer and I see that has struggled lately with runtime PM issues
>> so maybe he has more ideas.
>
> Good idea. Did you try his patch which is in my for-current branch
> ("i2c: omap: Fix PM regression with deferred probe for
> pm_runtime_reinit")?
>

Yes I did but unfortunately it did not help in this case.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
