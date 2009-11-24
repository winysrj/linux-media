Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44773 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934053AbZKXVIo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 16:08:44 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <mrh@ti.com>,
	Chaithrika U S <chaithrika@ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 35/38] move vpif_remove to .devexit.text
Date: Tue, 24 Nov 2009 22:07:30 +0100
Message-Id: <1259096853-18909-35-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1259096853-18909-34-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-6-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-7-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-8-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-9-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-10-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-11-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-12-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-13-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-14-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-15-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-16-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-17-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-18-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-19-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-20-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-21-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-22-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-23-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-24-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-25-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-26-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-27-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-28-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-29-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-30-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-31-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-32-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-33-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-34-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function vpif_remove is used only wrapped by __devexit_p so define
it using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Manjunath Hadli <mrh@ti.com>
Cc: Chaithrika U S <chaithrika@ti.com>
Cc: Muralidharan Karicheri <m-karicheri2@ti.com>
Cc: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
---
 drivers/media/video/davinci/vpif.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/davinci/vpif.c b/drivers/media/video/davinci/vpif.c
index 3b8eac3..1f532e3 100644
--- a/drivers/media/video/davinci/vpif.c
+++ b/drivers/media/video/davinci/vpif.c
@@ -266,7 +266,7 @@ fail:
 	return status;
 }
 
-static int vpif_remove(struct platform_device *pdev)
+static int __devexit vpif_remove(struct platform_device *pdev)
 {
 	iounmap(vpif_base);
 	release_mem_region(res->start, res_len);
-- 
1.6.5.2

