Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:53175 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751989AbcLJUsV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Dec 2016 15:48:21 -0500
Subject: [PATCH 1/4] [media] bt8xx: One function call less in
 bttv_input_init() after error detection
To: linux-media@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <d9a0777b-8ea7-3f7d-4fa2-b16468c4a1a4@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <e20a6835-a404-e894-d0d0-a408bfcd7fb6@users.sourceforge.net>
Date: Sat, 10 Dec 2016 21:48:06 +0100
MIME-Version: 1.0
In-Reply-To: <d9a0777b-8ea7-3f7d-4fa2-b16468c4a1a4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 10 Dec 2016 09:29:24 +0100

The kfree() function was called in one case by the
bttv_input_init() function during error handling
even if the passed variable contained a null pointer.

This issue was detected by using the Coccinelle software.

* Split a condition check for resource allocation failures so that
  each pointer from these function calls will be checked immediately.

  See also background information:
  Topic "CWE-754: Improper check for unusual or exceptional conditions"
  Link: https://cwe.mitre.org/data/definitions/754.html

  Fixes: d8b4b5822f51e2142b731b42c81e3f03eec475b2 ("[media] ir-core: make struct rc_dev the primary interface")

* Adjust a jump target according to the Linux coding style convention.

* Delete an initialisation for the variable "err" at the beginning
  which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/pci/bt8xx/bttv-input.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index 4da720e4867e..9187993d23ea 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -418,15 +418,20 @@ int bttv_input_init(struct bttv *btv)
 	struct bttv_ir *ir;
 	char *ir_codes = NULL;
 	struct rc_dev *rc;
-	int err = -ENOMEM;
+	int err;
 
 	if (!btv->has_remote)
 		return -ENODEV;
 
-	ir = kzalloc(sizeof(*ir),GFP_KERNEL);
+	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
+	if (!ir)
+		return -ENOMEM;
+
 	rc = rc_allocate_device();
-	if (!ir || !rc)
-		goto err_out_free;
+	if (!rc) {
+		err = -ENOMEM;
+		goto free_ir;
+	}
 
 	/* detect & configure */
 	switch (btv->c.type) {
@@ -569,6 +574,7 @@ int bttv_input_init(struct bttv *btv)
 	btv->remote = NULL;
  err_out_free:
 	rc_free_device(rc);
+free_ir:
 	kfree(ir);
 	return err;
 }
-- 
2.11.0

