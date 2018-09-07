Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:60476 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726717AbeIGVRE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Sep 2018 17:17:04 -0400
From: Paul Kocialkowski <contact@paulk.fr>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, linux-sunxi@googlegroups.com,
        Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Paul Kocialkowski <contact@paulk.fr>
Subject: [PATCH 2/2] media: cedrus: Add TODO file with tasks to complete before unstaging
Date: Fri,  7 Sep 2018 18:33:47 +0200
Message-Id: <20180907163347.32312-3-contact@paulk.fr>
In-Reply-To: <20180907163347.32312-1-contact@paulk.fr>
References: <20180907163347.32312-1-contact@paulk.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the elements listed are complete, the Cedrus driver will be ready
to move out of the staging area of the kernel.

Signed-off-by: Paul Kocialkowski <contact@paulk.fr>
---
 drivers/staging/media/sunxi/cedrus/TODO | 7 +++++++
 1 file changed, 7 insertions(+)
 create mode 100644 drivers/staging/media/sunxi/cedrus/TODO

diff --git a/drivers/staging/media/sunxi/cedrus/TODO b/drivers/staging/media/sunxi/cedrus/TODO
new file mode 100644
index 000000000000..ec277ece47af
--- /dev/null
+++ b/drivers/staging/media/sunxi/cedrus/TODO
@@ -0,0 +1,7 @@
+Before this stateless decoder driver can leave the staging area:
+* The Request API needs to be stabilized;
+* The codec-specific controls need to be thoroughly reviewed to ensure they
+  cover all intended uses cases;
+* Userspace support for the Request API needs to be reviewed;
+* Another stateless decoder driver should be submitted;
+* At least one stateless encoder driver should be submitted.
-- 
2.18.0
