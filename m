Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:42210 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbZLDQXf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2009 11:23:35 -0500
Date: Fri, 4 Dec 2009 08:21:34 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: linux-next i386 allmodconfig
Message-Id: <20091204082134.419e9580.randy.dunlap@oracle.com>
In-Reply-To: <20091203225737.1613b137.akpm@linux-foundation.org>
References: <20091203225737.1613b137.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 3 Dec 2009 22:57:37 -0800 Andrew Morton wrote:

> ERROR: "__divdf3" [drivers/media/dvb/frontends/atbm8830.ko] undefined!
> ERROR: "__adddf3" [drivers/media/dvb/frontends/atbm8830.ko] undefined!
> ERROR: "__fixunsdfsi" [drivers/media/dvb/frontends/atbm8830.ko] undefined!
> ERROR: "__udivdi3" [drivers/media/dvb/frontends/atbm8830.ko] undefined!
> ERROR: "__floatsidf" [drivers/media/dvb/frontends/atbm8830.ko] undefined!
> ERROR: "__muldf3" [drivers/media/dvb/frontends/atbm8830.ko] undefined!
> ERROR: "__adddf3" [drivers/media/common/tuners/max2165.ko] undefined!
> ERROR: "__fixunsdfsi" [drivers/media/common/tuners/max2165.ko] undefined!
> ERROR: "__floatsidf" [drivers/media/common/tuners/max2165.ko] undefined!
> 
> would be nice to get that fixed up before merging.
> --

Already reported and patches sent to me & tested/acked.

---
~Randy
