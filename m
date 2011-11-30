Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757961Ab1K3RId (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 12:08:33 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAUH8XJw030385
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 30 Nov 2011 12:08:33 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 2/5] [media] tm6000: add IR support for HVR-900H
Date: Wed, 30 Nov 2011 15:08:21 -0200
Message-Id: <1322672904-17340-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1322672904-17340-1-git-send-email-mchehab@redhat.com>
References: <1322672904-17340-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/tm6000/tm6000-cards.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/tm6000/tm6000-cards.c b/drivers/media/video/tm6000/tm6000-cards.c
index ec2578a..0b54132 100644
--- a/drivers/media/video/tm6000/tm6000-cards.c
+++ b/drivers/media/video/tm6000/tm6000-cards.c
@@ -351,6 +351,7 @@ static struct tm6000_board tm6000_boards[] = {
 		.tuner_addr   = 0xc2 >> 1,
 		.demod_addr   = 0x1e >> 1,
 		.type         = TM6010,
+		.ir_codes = RC_MAP_HAUPPAUGE,
 		.caps = {
 			.has_tuner    = 1,
 			.has_dvb      = 1,
-- 
1.7.7.3

