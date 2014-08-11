Return-path: <linux-media-owner@vger.kernel.org>
Received: from waechter.wiz.at ([95.129.203.138]:41220 "EHLO waechter.wiz.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbaHKO63 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Aug 2014 10:58:29 -0400
From: Matthias Waechter <matthias@waechter.wiz.at>
To: linux-media@vger.kernel.org
Cc: Matthias Waechter <matthias@waechter.wiz.at>
Subject: [PATCH] Fixed reference counting int saa716x drivers
Date: Mon, 11 Aug 2014 16:50:36 +0200
Message-Id: <1407768636-11145-1-git-send-email-matthias@waechter.wiz.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without this patch applied, saa716x_core takes all reference counts and leaves the
specific modules like saa716x_budget without a use tick. This leads to the situation
that while the application is running, saa716x_budget still has a reference count of
zero and can be unloaded, which freezes the kernel immediately. It is necessary for
dvb_register_adapter to get a reference to the real adapter-specific module to avoid
this case.
---
 drivers/media/pci/saa716x/saa716x_adap.c    | 2 +-
 drivers/media/pci/saa716x/saa716x_budget.c  | 1 +
 drivers/media/pci/saa716x/saa716x_ff_main.c | 1 +
 drivers/media/pci/saa716x/saa716x_hybrid.c  | 1 +
 drivers/media/pci/saa716x/saa716x_priv.h    | 1 +
 5 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa716x/saa716x_adap.c b/drivers/media/pci/saa716x/saa716x_adap.c
index 0550a4d..807ab83 100644
--- a/drivers/media/pci/saa716x/saa716x_adap.c
+++ b/drivers/media/pci/saa716x/saa716x_adap.c
@@ -99,7 +99,7 @@ int saa716x_dvb_init(struct saa716x_dev *saa716x)
 		dprintk(SAA716x_DEBUG, 1, "dvb_register_adapter");
 		if (dvb_register_adapter(&saa716x_adap->dvb_adapter,
 					 "SAA716x dvb adapter",
-					 THIS_MODULE,
+					 saa716x->module,
 					 &saa716x->pdev->dev,
 					 adapter_nr) < 0) {
 
diff --git a/drivers/media/pci/saa716x/saa716x_budget.c b/drivers/media/pci/saa716x/saa716x_budget.c
index 9f46c61..c8efc05 100644
--- a/drivers/media/pci/saa716x/saa716x_budget.c
+++ b/drivers/media/pci/saa716x/saa716x_budget.c
@@ -73,6 +73,7 @@ static int saa716x_budget_pci_probe(struct pci_dev *pdev, const struct pci_devic
 	saa716x->verbose	= verbose;
 	saa716x->int_type	= int_type;
 	saa716x->pdev		= pdev;
+	saa716x->module		= THIS_MODULE;
 	saa716x->config		= (struct saa716x_config *) pci_id->driver_data;
 
 	err = saa716x_pci_init(saa716x);
diff --git a/drivers/media/pci/saa716x/saa716x_ff_main.c b/drivers/media/pci/saa716x/saa716x_ff_main.c
index 5916c80..04538ab 100644
--- a/drivers/media/pci/saa716x/saa716x_ff_main.c
+++ b/drivers/media/pci/saa716x/saa716x_ff_main.c
@@ -986,6 +986,7 @@ static int saa716x_ff_pci_probe(struct pci_dev *pdev, const struct pci_device_id
 	saa716x->verbose	= verbose;
 	saa716x->int_type	= int_type;
 	saa716x->pdev		= pdev;
+	saa716x->module		= THIS_MODULE;
 	saa716x->config		= (struct saa716x_config *) pci_id->driver_data;
 
 	err = saa716x_pci_init(saa716x);
diff --git a/drivers/media/pci/saa716x/saa716x_hybrid.c b/drivers/media/pci/saa716x/saa716x_hybrid.c
index 0229419..f76b123 100644
--- a/drivers/media/pci/saa716x/saa716x_hybrid.c
+++ b/drivers/media/pci/saa716x/saa716x_hybrid.c
@@ -63,6 +63,7 @@ static int saa716x_hybrid_pci_probe(struct pci_dev *pdev, const struct pci_devic
 	saa716x->verbose	= verbose;
 	saa716x->int_type	= int_type;
 	saa716x->pdev		= pdev;
+	saa716x->module		= THIS_MODULE;
 	saa716x->config		= (struct saa716x_config *) pci_id->driver_data;
 
 	err = saa716x_pci_init(saa716x);
diff --git a/drivers/media/pci/saa716x/saa716x_priv.h b/drivers/media/pci/saa716x/saa716x_priv.h
index 0c9355b..1665fe3 100644
--- a/drivers/media/pci/saa716x/saa716x_priv.h
+++ b/drivers/media/pci/saa716x/saa716x_priv.h
@@ -127,6 +127,7 @@ struct saa716x_adapter {
 struct saa716x_dev {
 	struct saa716x_config		*config;
 	struct pci_dev			*pdev;
+	struct module			*module;
 
 	int				num; /* device count */
 	int				verbose;
-- 
2.0.2

