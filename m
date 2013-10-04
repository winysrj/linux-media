Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1170 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab3JDOCN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 10:02:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 14/14] siano: fix sparse warnings
Date: Fri,  4 Oct 2013 16:01:52 +0200
Message-Id: <1380895312-30863-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/common/siano/smsdvb-main.c:47:5: warning: symbol 'sms_to_guard_interval_table' was not declared. Should it be static?
drivers/media/common/siano/smsdvb-main.c:54:5: warning: symbol 'sms_to_code_rate_table' was not declared. Should it be static?
drivers/media/common/siano/smsdvb-main.c:63:5: warning: symbol 'sms_to_hierarchy_table' was not declared. Should it be static?
drivers/media/common/siano/smsdvb-main.c:70:5: warning: symbol 'sms_to_modulation_table' was not declared. Should it be static?
drivers/media/common/siano/smscoreapi.c:925:35: warning: cast to restricted __le32
drivers/media/common/siano/smscoreapi.c:926:28: warning: cast to restricted __le32

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/common/siano/smscoreapi.c  | 4 ++--
 drivers/media/common/siano/smsdvb-main.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index a142f79..9df2410 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -922,8 +922,8 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 	u32 i, *ptr;
 	u8 *payload = firmware->payload;
 	int rc = 0;
-	firmware->start_address = le32_to_cpu(firmware->start_address);
-	firmware->length = le32_to_cpu(firmware->length);
+	firmware->start_address = le32_to_cpup((__le32 *)&firmware->start_address);
+	firmware->length = le32_to_cpup((__le32 *)&firmware->length);
 
 	mem_address = firmware->start_address;
 
diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 63676a8..85151ef 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -44,14 +44,14 @@ module_param_named(debug, sms_dbg, int, 0644);
 MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
 
 
-u32 sms_to_guard_interval_table[] = {
+static u32 sms_to_guard_interval_table[] = {
 	[0] = GUARD_INTERVAL_1_32,
 	[1] = GUARD_INTERVAL_1_16,
 	[2] = GUARD_INTERVAL_1_8,
 	[3] = GUARD_INTERVAL_1_4,
 };
 
-u32 sms_to_code_rate_table[] = {
+static u32 sms_to_code_rate_table[] = {
 	[0] = FEC_1_2,
 	[1] = FEC_2_3,
 	[2] = FEC_3_4,
@@ -60,14 +60,14 @@ u32 sms_to_code_rate_table[] = {
 };
 
 
-u32 sms_to_hierarchy_table[] = {
+static u32 sms_to_hierarchy_table[] = {
 	[0] = HIERARCHY_NONE,
 	[1] = HIERARCHY_1,
 	[2] = HIERARCHY_2,
 	[3] = HIERARCHY_4,
 };
 
-u32 sms_to_modulation_table[] = {
+static u32 sms_to_modulation_table[] = {
 	[0] = QPSK,
 	[1] = QAM_16,
 	[2] = QAM_64,
-- 
1.8.3.2

