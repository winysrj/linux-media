Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4689 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab3CDJFh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 04:05:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	linux@arm.linux.org.uk, Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 10/11] davinci/dm644x_ccdc: fix compiler warning
Date: Mon,  4 Mar 2013 10:05:04 +0100
Message-Id: <82ceff23cb7321a9f84f76ae1ed956b2829a45d6.1362387265.git.hans.verkuil@cisco.com>
In-Reply-To: <1362387905-3666-1-git-send-email-hverkuil@xs4all.nl>
References: <1362387905-3666-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <b14bb5bd725678bc0fadfa241b462b5d6487f099.1362387265.git.hans.verkuil@cisco.com>
References: <b14bb5bd725678bc0fadfa241b462b5d6487f099.1362387265.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/platform/davinci/dm644x_ccdc.c: In function ‘validate_ccdc_param’:
drivers/media/platform/davinci/dm644x_ccdc.c:233:32: warning: comparison between ‘enum ccdc_gama_width’ and ‘enum ccdc_data_size’ [-Wenum-compare]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/davinci/dm644x_ccdc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
index 318e805..41f0a80 100644
--- a/drivers/media/platform/davinci/dm644x_ccdc.c
+++ b/drivers/media/platform/davinci/dm644x_ccdc.c
@@ -230,7 +230,7 @@ static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
 	if (ccdcparam->alaw.enable) {
 		if ((ccdcparam->alaw.gama_wd > CCDC_GAMMA_BITS_09_0) ||
 		    (ccdcparam->alaw.gama_wd < CCDC_GAMMA_BITS_15_6) ||
-		    (ccdcparam->alaw.gama_wd < ccdcparam->data_sz)) {
+		    (ccdcparam->alaw.gama_wd < (unsigned)ccdcparam->data_sz)) {
 			dev_dbg(ccdc_cfg.dev, "\nInvalid data line select");
 			return -1;
 		}
-- 
1.7.10.4

