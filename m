Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47645 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbZLDSdn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2009 13:33:43 -0500
Message-ID: <4B195605.3030706@infradead.org>
Date: Fri, 04 Dec 2009 16:33:41 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org
Subject: Re: linux-next i386 allmodconfig
References: <20091203225737.1613b137.akpm@linux-foundation.org> <20091204082134.419e9580.randy.dunlap@oracle.com>
In-Reply-To: <20091204082134.419e9580.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Randy Dunlap wrote:
> On Thu, 3 Dec 2009 22:57:37 -0800 Andrew Morton wrote:
> 
>> ERROR: "__divdf3" [drivers/media/dvb/frontends/atbm8830.ko] undefined!
>> ERROR: "__adddf3" [drivers/media/dvb/frontends/atbm8830.ko] undefined!
>> ERROR: "__fixunsdfsi" [drivers/media/dvb/frontends/atbm8830.ko] undefined!
>> ERROR: "__udivdi3" [drivers/media/dvb/frontends/atbm8830.ko] undefined!
>> ERROR: "__floatsidf" [drivers/media/dvb/frontends/atbm8830.ko] undefined!
>> ERROR: "__muldf3" [drivers/media/dvb/frontends/atbm8830.ko] undefined!
>> ERROR: "__adddf3" [drivers/media/common/tuners/max2165.ko] undefined!
>> ERROR: "__fixunsdfsi" [drivers/media/common/tuners/max2165.ko] undefined!
>> ERROR: "__floatsidf" [drivers/media/common/tuners/max2165.ko] undefined!
>>
>> would be nice to get that fixed up before merging.
>> --
> 
> Already reported and patches sent to me & tested/acked.

I should be adding it at linux-next later today.

Cheers,
Mauro
