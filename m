Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728003AbeK2RA0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 12:00:26 -0500
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/68] media: ipu3-cio2: Unregister device nodes first, then release resources
Date: Thu, 29 Nov 2018 00:54:55 -0500
Message-Id: <20181129055559.159228-4-sashal@kernel.org>
In-Reply-To: <20181129055559.159228-1-sashal@kernel.org>
References: <20181129055559.159228-1-sashal@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 32388d6ef7cffc7d8291b67f8dfa26acd45217fd ]

While there are issues related to object lifetime management, unregister
the media device first, followed immediately by other device nodes when
the driver is being unbound. Only then the resources needed by the driver
may be released. This is slightly safer.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Bingbu Cao <bingbu.cao@intel.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 29027159eced..ca1a4d8e972e 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1846,12 +1846,12 @@ static void cio2_pci_remove(struct pci_dev *pci_dev)
 	struct cio2_device *cio2 = pci_get_drvdata(pci_dev);
 	unsigned int i;
 
+	media_device_unregister(&cio2->media_dev);
 	cio2_notifier_exit(cio2);
-	cio2_fbpt_exit_dummy(cio2);
 	for (i = 0; i < CIO2_QUEUES; i++)
 		cio2_queue_exit(cio2, &cio2->queue[i]);
+	cio2_fbpt_exit_dummy(cio2);
 	v4l2_device_unregister(&cio2->v4l2_dev);
-	media_device_unregister(&cio2->media_dev);
 	media_device_cleanup(&cio2->media_dev);
 	mutex_destroy(&cio2->lock);
 }
-- 
2.17.1
