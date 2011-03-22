Return-path: <mchehab@pedra>
Received: from canardo.mork.no ([148.122.252.1]:55750 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab1CVNWW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 09:22:22 -0400
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH] [media] mantis: trivial module parameter documentation fix
Date: Tue, 22 Mar 2011 14:22:17 +0100
Message-Id: <1300800137-9142-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The default for "verbose" is 0.  Update description to match.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/media/dvb/mantis/hopper_cards.c |    2 +-
 drivers/media/dvb/mantis/mantis_cards.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/mantis/hopper_cards.c b/drivers/media/dvb/mantis/hopper_cards.c
index 70e73af..1402062 100644
--- a/drivers/media/dvb/mantis/hopper_cards.c
+++ b/drivers/media/dvb/mantis/hopper_cards.c
@@ -44,7 +44,7 @@
 
 static unsigned int verbose;
 module_param(verbose, int, 0644);
-MODULE_PARM_DESC(verbose, "verbose startup messages, default is 1 (yes)");
+MODULE_PARM_DESC(verbose, "verbose startup messages, default is 0 (no)");
 
 #define DRIVER_NAME	"Hopper"
 
diff --git a/drivers/media/dvb/mantis/mantis_cards.c b/drivers/media/dvb/mantis/mantis_cards.c
index 40da225..05cbb9d 100644
--- a/drivers/media/dvb/mantis/mantis_cards.c
+++ b/drivers/media/dvb/mantis/mantis_cards.c
@@ -52,7 +52,7 @@
 
 static unsigned int verbose;
 module_param(verbose, int, 0644);
-MODULE_PARM_DESC(verbose, "verbose startup messages, default is 1 (yes)");
+MODULE_PARM_DESC(verbose, "verbose startup messages, default is 0 (no)");
 
 static int devs;
 
-- 
1.7.2.5

