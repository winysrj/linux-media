Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:45502 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933780Ab0DHXE3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 19:04:29 -0400
Subject: [PATCH 1/4] Fix the drivers/media/dvb/ttpci/budget-ci.c conversion to
	ir-core
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Date: Fri, 09 Apr 2010 01:04:25 +0200
Message-ID: <20100408230425.14453.62639.stgit@localhost.localdomain>
In-Reply-To: <20100408230246.14453.97377.stgit@localhost.localdomain>
References: <20100408230246.14453.97377.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When I converted drivers/media/dvb/ttpci/budget-ci.c to use ir-core
I missed one line. This patch fixes that mistake.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/dvb/ttpci/budget-ci.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index 8950df1..4617143 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -225,8 +225,6 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 		break;
 	}
 
-	ir_input_init(input_dev, &budget_ci->ir.state, IR_TYPE_RC5);
-
 	error = ir_input_register(input_dev, ir_codes, NULL, MODULE_NAME);
 	if (error) {
 		printk(KERN_ERR "budget_ci: could not init driver for IR device (code %d)\n", error);

