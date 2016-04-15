Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:51080 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbcDORIJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 13:08:09 -0400
Date: Fri, 15 Apr 2016 10:08:04 -0700
From: Tony Lindgren <tony@atomide.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	=?utf-8?Q?Agust=C3=AD?= Fontquerni <af@iseebcn.com>
Subject: Re: tvp5150 regression after commit 9f924169c035
Message-ID: <20160415170804.GW5973@atomide.com>
References: <20160412223254.GK1526@katana>
 <570ECAB0.4050107@osg.samsung.com>
 <20160414111257.GG1533@katana>
 <570F9DF1.3070700@osg.samsung.com>
 <20160414141945.GA1539@katana>
 <570FA8D6.5070308@osg.samsung.com>
 <20160414151244.GM5973@atomide.com>
 <57102EE3.3020707@osg.samsung.com>
 <20160415145828.GT5973@atomide.com>
 <57111B76.8020106@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57111B76.8020106@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Javier Martinez Canillas <javier@osg.samsung.com> [160415 09:50]:
> On 04/15/2016 10:58 AM, Tony Lindgren wrote:
> > If you block PM runtime for I2C, then it blocks deeper idle states
> > for the whole device. Note that you can disable off mode during idle
> 
> Thanks again for this clarification.
> 
> > and suspend with:
> > 
> > # echo 0 > /sys/kernel/debug/pm_debug/enable_off_mode
> >
> 
> I see thought that enable_off_mode is 0 by default when booting the board:
> 
> # cat /sys/kernel/debug/pm_debug/enable_off_mode 
> 0

OK so you're not hitting off mode then.

> So if I understood your explanation correctly, that means that the glitch
> should not happen for the GPIO pins since the machine doesn't enter into
> deeper idle states that could cause the glitch from erratum 1.158?

Correct. But you could still have a dependency to some other
device driver that stays active if I2C keeps the whole system
from hitting retention mode during idle.

Regards,

Tony

