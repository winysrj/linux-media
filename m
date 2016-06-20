Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.provo.novell.com ([137.65.250.81]:42796 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbcFTUHg (ORCPT
	<rfc822;groupwise-linux-media@vger.kernel.org:0:0>);
	Mon, 20 Jun 2016 16:07:36 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: peterz@infradead.org, mingo@kernel.org
Cc: davem@davemloft.net, cw00.choi@samsung.com,
	dougthompson@xmission.com, bp@alien8.de, mchehab@osg.samsung.com,
	gregkh@linuxfoundation.org, pfg@sgi.com, jikos@kernel.org,
	hans.verkuil@cisco.com, awalls@md.metrocast.net,
	dledford@redhat.com, sean.hefty@intel.com, kys@microsoft.com,
	heiko.carstens@de.ibm.com, James.Bottomley@HansenPartnership.com,
	sumit.semwal@linaro.org, schwidefsky@de.ibm.com,
	linux-kernel@vger.kernel.org, dave@stgolabs.net,
	linux-media@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 07/12] drivers/media: Employ atomic_fetch_inc()
Date: Mon, 20 Jun 2016 13:05:59 -0700
Message-Id: <1466453164-13185-8-git-send-email-dave@stgolabs.net>
In-Reply-To: <1466453164-13185-1-git-send-email-dave@stgolabs.net>
References: <1466453164-13185-1-git-send-email-dave@stgolabs.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have fetch_inc() we can stop using inc_return() - 1.

These are very similar to the existing OP-RETURN primitives we already
have, except they return the value of the atomic variable _before_
modification.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 drivers/media/pci/cobalt/cobalt-driver.c | 2 +-
 drivers/media/pci/cx18/cx18-driver.c     | 2 +-
 drivers/media/v4l2-core/v4l2-device.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index 8d6f04fc8013..70dfcb0c6a72 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -683,7 +683,7 @@ static int cobalt_probe(struct pci_dev *pci_dev,
 	int i;
 
 	/* FIXME - module parameter arrays constrain max instances */
-	i = atomic_inc_return(&cobalt_instance) - 1;
+	i = atomic_fetch_inc(&cobalt_instance);
 
 	cobalt = kzalloc(sizeof(struct cobalt), GFP_ATOMIC);
 	if (cobalt == NULL)
diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 260e462d91b4..5cb3408c6859 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -908,7 +908,7 @@ static int cx18_probe(struct pci_dev *pci_dev,
 	struct cx18 *cx;
 
 	/* FIXME - module parameter arrays constrain max instances */
-	i = atomic_inc_return(&cx18_instance) - 1;
+	i = atomic_fetch_inc(&cx18_instance);
 	if (i >= CX18_MAX_CARDS) {
 		printk(KERN_ERR "cx18: cannot manage card %d, driver has a "
 		       "limit of 0 - %d\n", i, CX18_MAX_CARDS - 1);
diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 06fa5f1b2cff..1bc5b68c2724 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -76,7 +76,7 @@ EXPORT_SYMBOL_GPL(v4l2_device_put);
 int v4l2_device_set_name(struct v4l2_device *v4l2_dev, const char *basename,
 						atomic_t *instance)
 {
-	int num = atomic_inc_return(instance) - 1;
+	int num = atomic_fetch_inc(instance);
 	int len = strlen(basename);
 
 	if (basename[len - 1] >= '0' && basename[len - 1] <= '9')
-- 
2.6.6

