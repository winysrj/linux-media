Return-path: <mchehab@pedra>
Received: from mx3.mail.elte.hu ([157.181.1.138]:44674 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab0HXIpw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Aug 2010 04:45:52 -0400
Date: Tue, 24 Aug 2010 10:45:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] V4L/DVB: mantis: Fix IR_CORE dependency
Message-ID: <20100824084528.GA26618@elte.hu>
References: <4C643A08.3000605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C643A08.3000605@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>


* Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Linus,
> 
> Please pull from:
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus
> 
> For 3 build fixes.
> 
> Cheers,
> Mauro.
> 
> The following changes since commit ad41a1e0cab07c5125456e8d38e5b1ab148d04aa:
> 
>   Merge branch 'io_remap_pfn_range' of git://www.jni.nu/cris (2010-08-12 10:17:19 -0700)
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus
> 
> Mauro Carvalho Chehab (2):
>       V4L/DVB: Fix IR_CORE dependencies
>       V4L/DVB: fix Kconfig to depends on VIDEO_IR
> 
> Randy Dunlap (1):
>       V4L/DVB: v4l2-ctrls.c: needs to include slab.h

FYI, there's one more IR_CORE related build bug which triggers 
frequently in randconfig tests - see the fix below.

Thanks,

	Ingo

------------------->
>From c56aef270d7ec01564c632c1f7ebab6b8f9f032c Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 24 Aug 2010 10:41:33 +0200
Subject: [PATCH] V4L/DVB: mantis: Fix IR_CORE dependency

This build bug triggers:

 drivers/built-in.o: In function `mantis_exit':
 (.text+0x377413): undefined reference to `ir_input_unregister'
 drivers/built-in.o: In function `mantis_input_init':
 (.text+0x3774ff): undefined reference to `__ir_input_register'

If MANTIS_CORE is enabled but IR_CORE is not. Add the correct
dependency.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/dvb/mantis/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/mantis/Kconfig b/drivers/media/dvb/mantis/Kconfig
index decdeda..fd0830e 100644
--- a/drivers/media/dvb/mantis/Kconfig
+++ b/drivers/media/dvb/mantis/Kconfig
@@ -1,6 +1,6 @@
 config MANTIS_CORE
 	tristate "Mantis/Hopper PCI bridge based devices"
-	depends on PCI && I2C && INPUT
+	depends on PCI && I2C && INPUT && IR_CORE
 
 	help
 	  Support for PCI cards based on the Mantis and Hopper PCi bridge.
