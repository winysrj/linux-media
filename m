Return-path: <mchehab@pedra>
Received: from mout.perfora.net ([74.208.4.194]:51129 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab1BPGQq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 01:16:46 -0500
From: Stephen Wilson <wilsons@start.ca>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: =?utf-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>,
	Stephen Wilson <wilsons@start.ca>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] rc: do not enable remote controller adapters by default.
Date: Wed, 16 Feb 2011 01:16:12 -0500
Message-ID: <m3aahwa4ib.fsf@fibrous.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Having the RC_CORE config default to INPUT is almost equivalent to
saying "yes".  Default to "no" instead.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
---
 drivers/media/rc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 3785162..8842843 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -1,7 +1,7 @@
 menuconfig RC_CORE
 	tristate "Remote Controller adapters"
 	depends on INPUT
-	default INPUT
+	default n
 	---help---
 	  Enable support for Remote Controllers on Linux. This is
 	  needed in order to support several video capture adapters.
--
1.7.3.5
