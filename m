Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756411Ab0BLPa7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 10:30:59 -0500
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o1CFUwcR024269
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 12 Feb 2010 10:30:58 -0500
Received: from [10.11.9.79] (vpn-9-79.rdu.redhat.com [10.11.9.79])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o1CFUtZv025111
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 12 Feb 2010 10:30:58 -0500
Message-ID: <4B75742F.3070609@redhat.com>
Date: Fri, 12 Feb 2010 13:30:55 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [Fwd: + timberdale-fix-mfd-build.patch added to -mm tree]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



-------- Mensagem original --------
Assunto: + timberdale-fix-mfd-build.patch added to -mm tree
Data: Thu, 11 Feb 2010 16:43:31 -0800
De: akpm@linux-foundation.org
Para: mm-commits@vger.kernel.org
CC: randy.dunlap@oracle.com, mchehab@redhat.com,        richard.rojfors@pelagicore.com, sameo@linux.intel.com


The patch titled
     timberdale: fix mfd build
has been added to the -mm tree.  Its filename is
     timberdale-fix-mfd-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timberdale: fix mfd build
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix mfd/timberdale build error -- add depends GPIOLIB.

include/linux/spi/max7301.h:14: error: field 'chip' has incomplete type
build-r7353.out:make[3]: *** [drivers/mfd/timberdale.o] Error 1

Repairs

commit ff7a26e08a16bb31158d830dbf60db2ff47019ab
Author:     Richard R<C3><B6>jfors <richard.rojfors@pelagicore.com>
AuthorDate: Thu Feb 4 08:18:52 2010 -0300
Commit:     Mauro Carvalho Chehab <mchehab@redhat.com>
CommitDate: Fri Feb 5 12:25:37 2010 -0200

    V4L/DVB: mfd: Add support for the timberdale FPGA

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Richard Rojfors <richard.rojfors@pelagicore.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/Kconfig~timberdale-fix-mfd-build drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~timberdale-fix-mfd-build
+++ a/drivers/mfd/Kconfig
@@ -382,7 +382,7 @@ config AB4500_CORE
 config MFD_TIMBERDALE
 	tristate "Support for the Timberdale FPGA"
 	select MFD_CORE
-	depends on PCI
+	depends on PCI && GPIOLIB
 	---help---
 	This is the core driver for the timberdale FPGA. This device is a
 	multifunction device which exposes numerous platform devices.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
msi-laptop-depends-on-rfkill.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
timberdale-fix-mfd-build.patch
i2c-fix-xiic-build-error.patch
mfgpt-move-clocksource-menu.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch
documentation-timers-split-txt-and-source-files.patch
documentation-laptop-split-txt-and-source-files.patch
documentation-fs-split-txt-and-source-files.patch
documentation-vm-split-txt-and-source-files.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch


-- 

Cheers,
Mauro
