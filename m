Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30880 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab2K0Rft (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 12:35:49 -0500
Date: Tue, 27 Nov 2012 20:35:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Douglas Bagnall <douglas@paradise.net.nz>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/2] [media] rc: unlock on error in store_protocols()
Message-ID: <20121127173530.GF1059@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This error path is missing the unlock.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 601d1ac1..759a40a 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -890,7 +892,8 @@ static ssize_t store_protocols(struct device *device,
 
 		if (i == ARRAY_SIZE(proto_names)) {
 			IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 
 		count++;
