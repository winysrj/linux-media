Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:36628 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbcL1Vqr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Dec 2016 16:46:47 -0500
From: Colin King <colin.king@canonical.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] cobalt: fix spelling mistake: "Celcius" -> "Celsius"
Date: Wed, 28 Dec 2016 21:45:58 +0000
Message-Id: <20161228214558.7398-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in cobalt_info message. Anders Celsius
was the Swedish astronomer.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/pci/cobalt/cobalt-cpld.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-cpld.c b/drivers/media/pci/cobalt/cobalt-cpld.c
index 23c875f..bfcecef 100644
--- a/drivers/media/pci/cobalt/cobalt-cpld.c
+++ b/drivers/media/pci/cobalt/cobalt-cpld.c
@@ -71,9 +71,9 @@ static void cpld_info_ver3(struct cobalt *cobalt)
 	cobalt_info("\t\tMAXII program revision:  0x%04x\n",
 		    cpld_read(cobalt, 0x30));
 	cobalt_info("CPLD temp and voltage ADT7411 registers (read only)\n");
-	cobalt_info("\t\tBoard temperature:  %u Celcius\n",
+	cobalt_info("\t\tBoard temperature:  %u Celsius\n",
 		    cpld_read(cobalt, 0x34) / 4);
-	cobalt_info("\t\tFPGA temperature:   %u Celcius\n",
+	cobalt_info("\t\tFPGA temperature:   %u Celsius\n",
 		    cpld_read(cobalt, 0x38) / 4);
 	rd = cpld_read(cobalt, 0x3c);
 	tmp = (rd * 33 * 1000) / (483 * 10);
-- 
2.10.2

