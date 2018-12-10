Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6751C5CFFE
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 20:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AECC420821
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 20:42:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AECC420821
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbeLJUmW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 15:42:22 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:33207 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727598AbeLJUmW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 15:42:22 -0500
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MIdW9-1gisRL3YBR-00Ehbx; Mon, 10 Dec 2018 21:42:10 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Ettore Chimenti <ek5.chimenti@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: seco-cec: fix RC_CORE dependency
Date:   Mon, 10 Dec 2018 21:41:40 +0100
Message-Id: <20181210204208.2223571-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Pyr2z/JPJNokWqHGPq/aD0EypsRv48+YISaicVzZoAvAsQWAQTG
 Hhp8iD5wFDGiixfWA7mKnUrvXwPXHHX1gbKn6hPRK6nrb1FQjzR/xlEa5pRANT8cuyk4F9k
 3xlOhkpHb3yClYAsV8Umfk3wgOGbxrZL1FgJcoMLDbRc6zh79Hobd2dudy81b/Ru81EMdxR
 MfkkFHRjo4h6V4lE3Ma8Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:X/PAKrcotEQ=:cvvOBf2vOZ2e5m/Q6lgWoS
 4k1WDEf8/UmK5oObTilF0OqCaPHwImZPAQtlZ/sM3wp9FzIoBVfISwmjBjeLGpeDDA4sL/gg4
 2hwBPyr6qncyuYn/KD/5kQu2Ac7oQS+1c2ZBlqZ9awoGfZn+zHlxd29cu30oGkTphAni9kRvh
 StmNsiDfaC0m/iulJxttDkgDLWCZG046yNBT3s1l1acfhz7k7FqGQJeg64bkHI5cmzTjgVvZ4
 DUfP2bKOuUy/BV2xhoeEqy1eNVHQk7cp8Ue7X5PdGm/IUaqOYx4AiLYeuHAoqDCzu9Wvy6XlO
 8NSoSsViknJOsvsvXZcXG6a351E6IbZDhXtIgNk7MyWSs4HaEebRjuECw+BUOGMyWqAOTcAVP
 HfLf+bdsVW4hYaKIkWxYcsy2e7hGPRgLkaBuq8pwhHbP2AhL8oJO5lWNT/Jd56D4zKSKMPM+9
 q/oKY4nsyC2lR36FhBDAZ7EINY5eaoVeTBW9TPDZ2IBumuQTveF5+3JrMChb8pPwHzll2q5DE
 Rik9FLuX/+2zObY1VyzWFlw7ll1EV5qiU5obVm2udPz0uRTAZjJjIAsvxZ4nYA9ssV3GLHRH2
 Kl0q5vDFlVyv2QUuypPKKhvK822jyUQD5qKYUPFbvK6GpChnCYeUuMc3pXw0Y8GtGpAoncsEf
 Y8hTrDw6mPMjRC+VpcGcIsw9KG9g6aQAim8qIvI/MyD29D7XbM3S3CbZGnH+G9kgRbXT0DuvP
 tUnYr4dVPt88nsCqIpltLXW1CKY9KS1zfVJ0AA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

All other drivers that need RC_CORE have a dependency rather than using
'select', so we should do the same here to avoid circular dependencies
as well as this warning about missing dependencies:

WARNING: unmet direct dependencies detected for RC_CORE
  Depends on [n]: INPUT [=n]
  Selected by [y]:
  - VIDEO_SECO_RC [=y] && MEDIA_SUPPORT [=y] && CEC_PLATFORM_DRIVERS [=y] && VIDEO_SECO_CEC [=y]

Fixes: daef95769b3a ("media: seco-cec: add Consumer-IR support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index ea3306341edf..d501c6b3b380 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -641,7 +641,7 @@ config VIDEO_SECO_CEC
 config VIDEO_SECO_RC
 	bool "SECO Boards IR RC5 support"
 	depends on VIDEO_SECO_CEC
-	select RC_CORE
+	depends on RC_CORE
 	help
 	  If you say yes here you will get support for the
 	  SECO Boards Consumer-IR in seco-cec driver.
-- 
2.20.0

