Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:47034 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752452AbeFKPKw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 11:10:52 -0400
From: Colin King <colin.king@canonical.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-media@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] cx18: remove redundant zero check on retval
Date: Mon, 11 Jun 2018 16:10:45 +0100
Message-Id: <20180611151045.22535-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The check for a zero retval is redundant as all paths that lead to
this point have set retval to an error return value that is non-zero.
Remove the redundant check.

Detected by CoverityScan, CID#102589 ("Logically dead code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/firewire/firedtv-fw.c  | 3 +++
 drivers/media/pci/cx18/cx18-driver.c | 2 --
 drivers/regulator/vctrl-regulator.c  | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/firewire/firedtv-fw.c b/drivers/media/firewire/firedtv-fw.c
index 92f4112d2e37..eed55be21836 100644
--- a/drivers/media/firewire/firedtv-fw.c
+++ b/drivers/media/firewire/firedtv-fw.c
@@ -271,6 +271,9 @@ static int node_probe(struct fw_unit *unit, const struct ieee1394_device_id *id)
 
 	name_len = fw_csr_string(unit->directory, CSR_MODEL,
 				 name, sizeof(name));
+	if (name_len < 0)
+		return name_len;
+
 	for (i = ARRAY_SIZE(model_names); --i; )
 		if (strlen(model_names[i]) <= name_len &&
 		    strncmp(name, model_names[i], name_len) == 0)
diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 8f314ca320c7..0c389a3fb4e5 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -1134,8 +1134,6 @@ static int cx18_probe(struct pci_dev *pci_dev,
 free_workqueues:
 	destroy_workqueue(cx->in_work_queue);
 err:
-	if (retval == 0)
-		retval = -ENODEV;
 	CX18_ERR("Error %d on initialization\n", retval);
 
 	v4l2_device_unregister(&cx->v4l2_dev);
diff --git a/drivers/regulator/vctrl-regulator.c b/drivers/regulator/vctrl-regulator.c
index 78de002037c7..044e5a5ca163 100644
--- a/drivers/regulator/vctrl-regulator.c
+++ b/drivers/regulator/vctrl-regulator.c
@@ -340,7 +340,7 @@ static int vctrl_init_vtable(struct platform_device *pdev)
 		}
 	}
 
-	if (rdesc->n_voltages == 0) {
+	if (rdesc->n_voltages <= 0) {
 		dev_err(&pdev->dev, "invalid configuration\n");
 		return -EINVAL;
 	}
-- 
2.17.0
