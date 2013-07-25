Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23231 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab3GYQrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 12:47:25 -0400
Date: Thu, 25 Jul 2013 19:46:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] bt8xx: info leak in ca_get_slot_info()
Message-ID: <20130725164621.GA6945@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

p_ca_slot_info was allocated with kmalloc() so we need to clear it
before passing it to the user.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/pci/bt8xx/dst_ca.c b/drivers/media/pci/bt8xx/dst_ca.c
index 0e788fc..6b9dc3f 100644
--- a/drivers/media/pci/bt8xx/dst_ca.c
+++ b/drivers/media/pci/bt8xx/dst_ca.c
@@ -302,8 +302,11 @@ static int ca_get_slot_info(struct dst_state *state, struct ca_slot_info *p_ca_s
 		p_ca_slot_info->flags = CA_CI_MODULE_READY;
 		p_ca_slot_info->num = 1;
 		p_ca_slot_info->type = CA_CI;
-	} else
+	} else {
 		p_ca_slot_info->flags = 0;
+		p_ca_slot_info->num = 0;
+		p_ca_slot_info->type = 0;
+	}
 
 	if (copy_to_user(arg, p_ca_slot_info, sizeof (struct ca_slot_info)))
 		return -EFAULT;
