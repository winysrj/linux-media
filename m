Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:32315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934117Ab1CXUFN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 16:05:13 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2OK5CId031293
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 24 Mar 2011 16:05:13 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] drx397xD: remove unused DEBUG define
Date: Thu, 24 Mar 2011 16:05:08 -0400
Message-Id: <1300997108-4199-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/dvb/frontends/drx397xD.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/drx397xD.c b/drivers/media/dvb/frontends/drx397xD.c
index a05007c..235ac72 100644
--- a/drivers/media/dvb/frontends/drx397xD.c
+++ b/drivers/media/dvb/frontends/drx397xD.c
@@ -17,7 +17,6 @@
  * along with this program; If not, see <http://www.gnu.org/licenses/>.
  */
 
-#define DEBUG			/* uncomment if you want debugging output */
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-- 
1.7.1

