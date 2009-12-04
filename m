Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175AbZLDG5m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Dec 2009 01:57:42 -0500
Date: Thu, 3 Dec 2009 22:57:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Subject: linux-next i386 allmodconfig
Message-Id: <20091203225737.1613b137.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ERROR: "__divdf3" [drivers/media/dvb/frontends/atbm8830.ko] undefined!
ERROR: "__adddf3" [drivers/media/dvb/frontends/atbm8830.ko] undefined!
ERROR: "__fixunsdfsi" [drivers/media/dvb/frontends/atbm8830.ko] undefined!
ERROR: "__udivdi3" [drivers/media/dvb/frontends/atbm8830.ko] undefined!
ERROR: "__floatsidf" [drivers/media/dvb/frontends/atbm8830.ko] undefined!
ERROR: "__muldf3" [drivers/media/dvb/frontends/atbm8830.ko] undefined!
ERROR: "__adddf3" [drivers/media/common/tuners/max2165.ko] undefined!
ERROR: "__fixunsdfsi" [drivers/media/common/tuners/max2165.ko] undefined!
ERROR: "__floatsidf" [drivers/media/common/tuners/max2165.ko] undefined!

would be nice to get that fixed up before merging.
