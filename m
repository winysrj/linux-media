Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:36785 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754140AbcAVSjA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2016 13:39:00 -0500
Date: Fri, 22 Jan 2016 19:38:30 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Arnd Bergmann <arnd@arndb.de>
cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Tapasweni Pathak <tapaswenipathak@gmail.com>
Subject: drivers/staging/media/lirc/lirc_parallel.c:163:22-33: WARNING:
 Unsigned expression compared with zero: timeelapsed > 0 (fwd)
Message-ID: <alpine.DEB.2.10.1601221937320.2502@hadrien>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maybe != 0 would be better?  I don't have a strong opinion about it.

julia

---------- Forwarded message ----------
Date: Sat, 23 Jan 2016 02:33:48 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: drivers/staging/media/lirc/lirc_parallel.c:163:22-33: WARNING: Unsigned
     expression compared with zero: timeelapsed > 0

CC: kbuild-all@01.org
CC: linux-kernel@vger.kernel.org
TO: Arnd Bergmann <arnd@arndb.de>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
CC: Tapasweni Pathak <tapaswenipathak@gmail.com>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   3e1e21c7bfcfa9bf06c07f48a13faca2f62b3339
commit: 0dbf41a3c88e229009a9f5fd2a89835569fa3451 [media] staging: media: lirc: Replace timeval with ktime_t in lirc_parallel.c
date:   7 weeks ago
:::::: branch date: 15 hours ago
:::::: commit date: 7 weeks ago

>> drivers/staging/media/lirc/lirc_parallel.c:163:22-33: WARNING: Unsigned expression compared with zero: timeelapsed > 0

git remote add linus https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
git remote update linus
git checkout 0dbf41a3c88e229009a9f5fd2a89835569fa3451
vim +163 drivers/staging/media/lirc/lirc_parallel.c

0dbf41a3 drivers/staging/media/lirc/lirc_parallel.c Arnd Bergmann   2015-11-25  147  	ktime_t kt, now, timeout;
805a8966 drivers/staging/lirc/lirc_parallel.c       Jarod Wilson    2010-07-26  148  	unsigned int level, newlevel, timeelapsed, newtimer;
805a8966 drivers/staging/lirc/lirc_parallel.c       Jarod Wilson    2010-07-26  149  	int count = 0;
805a8966 drivers/staging/lirc/lirc_parallel.c       Jarod Wilson    2010-07-26  150
0dbf41a3 drivers/staging/media/lirc/lirc_parallel.c Arnd Bergmann   2015-11-25  151  	kt = ktime_get();
0dbf41a3 drivers/staging/media/lirc/lirc_parallel.c Arnd Bergmann   2015-11-25  152  	/* wait max. 1 sec. */
0dbf41a3 drivers/staging/media/lirc/lirc_parallel.c Arnd Bergmann   2015-11-25  153  	timeout = ktime_add_ns(kt, NSEC_PER_SEC);
805a8966 drivers/staging/lirc/lirc_parallel.c       Jarod Wilson    2010-07-26  154  	level = lirc_get_timer();
805a8966 drivers/staging/lirc/lirc_parallel.c       Jarod Wilson    2010-07-26  155  	do {
805a8966 drivers/staging/lirc/lirc_parallel.c       Jarod Wilson    2010-07-26  156  		newlevel = lirc_get_timer();
805a8966 drivers/staging/lirc/lirc_parallel.c       Jarod Wilson    2010-07-26  157  		if (level == 0 && newlevel != 0)
805a8966 drivers/staging/lirc/lirc_parallel.c       Jarod Wilson    2010-07-26  158  			count++;
805a8966 drivers/staging/lirc/lirc_parallel.c       Jarod Wilson    2010-07-26  159  		level = newlevel;
0dbf41a3 drivers/staging/media/lirc/lirc_parallel.c Arnd Bergmann   2015-11-25  160  		now = ktime_get();
0dbf41a3 drivers/staging/media/lirc/lirc_parallel.c Arnd Bergmann   2015-11-25  161  	} while (count < 1000 && (ktime_before(now, timeout)));
0dbf41a3 drivers/staging/media/lirc/lirc_parallel.c Arnd Bergmann   2015-11-25  162  	timeelapsed = ktime_us_delta(now, kt);
805a8966 drivers/staging/lirc/lirc_parallel.c       Jarod Wilson    2010-07-26 @163  	if (count >= 1000 && timeelapsed > 0) {
805a8966 drivers/staging/lirc/lirc_parallel.c       Jarod Wilson    2010-07-26  164  		if (default_timer == 0) {
805a8966 drivers/staging/lirc/lirc_parallel.c       Jarod Wilson    2010-07-26  165  			/* autodetect timer */
805a8966 drivers/staging/lirc/lirc_parallel.c       Jarod Wilson    2010-07-26  166  			newtimer = (1000000*count)/timeelapsed;
cc38b8e9 drivers/staging/media/lirc/lirc_parallel.c YAMANE Toshiaki 2012-11-08  167  			pr_info("%u Hz timer detected\n", newtimer);
805a8966 drivers/staging/lirc/lirc_parallel.c       Jarod Wilson    2010-07-26  168  			return newtimer;
381d7f79 drivers/staging/media/lirc/lirc_parallel.c Zheng Di        2014-07-06  169  		}
805a8966 drivers/staging/lirc/lirc_parallel.c       Jarod Wilson    2010-07-26  170  		newtimer = (1000000*count)/timeelapsed;
805a8966 drivers/staging/lirc/lirc_parallel.c       Jarod Wilson    2010-07-26  171  		if (abs(newtimer - default_timer) > default_timer/10) {

:::::: The code at line 163 was first introduced by commit
:::::: 805a8966659563df68ea7bbd94241dafd645c725 V4L/DVB: staging/lirc: add lirc_parallel driver

:::::: TO: Jarod Wilson <jarod@redhat.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
