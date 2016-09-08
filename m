Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43889 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941747AbcIHMEY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 25/47] [media] v4l2-subdev.rst: get rid of legacy functions
Date: Thu,  8 Sep 2016 09:03:47 -0300
Message-Id: <376816d53c99adcb78a4f5cb6c855255dc322f6d.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two warnings that are due to functions that has long
gone:

	Documentation/media/kapi/v4l2-subdev.rst:417: WARNING: c:func reference target not found: v4l2_i2c_new_subdev_cfg
	Documentation/media/kapi/v4l2-subdev.rst:436: WARNING: c:func reference target not found: v4l2_i2c_new_probed_subdev

Update the documentation to remove those.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-subdev.rst | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
index fcecce01a35c..e1f0b726e438 100644
--- a/Documentation/media/kapi/v4l2-subdev.rst
+++ b/Documentation/media/kapi/v4l2-subdev.rst
@@ -412,19 +412,7 @@ later date. It differs between i2c drivers and as such can be confusing.
 To see which chip variants are supported you can look in the i2c driver code
 for the i2c_device_id table. This lists all the possibilities.
 
-There are two more helper functions:
-
-:c:func:`v4l2_i2c_new_subdev_cfg`: this function adds new irq and
-platform_data arguments and has both 'addr' and 'probed_addrs' arguments:
-if addr is not 0 then that will be used (non-probing variant), otherwise the
-probed_addrs are probed.
-
-For example: this will probe for address 0x10:
-
-.. code-block:: c
-
-	struct v4l2_subdev *sd = v4l2_i2c_new_subdev_cfg(v4l2_dev, adapter,
-			  "module_foo", "chipid", 0, NULL, 0, I2C_ADDRS(0x10));
+There are one more helper function:
 
 :c:func:`v4l2_i2c_new_subdev_board` uses an :c:type:`i2c_board_info` struct
 which is passed to the i2c driver and replaces the irq, platform_data and addr
@@ -433,9 +421,10 @@ arguments.
 If the subdev supports the s_config core ops, then that op is called with
 the irq and platform_data arguments after the subdev was setup.
 
-The older :c:func:`v4l2_i2c_new_subdev` and
-:c:func:`v4l2_i2c_new_probed_subdev` functions will call ``s_config`` as
-well, but with irq set to 0 and platform_data set to ``NULL``.
+The :c:func:`v4l2_i2c_new_subdev` function will call
+:c:func:`v4l2_i2c_new_subdev_board`, internally filling a
+:c:type:`i2c_board_info` structure using the ``client_type`` and the
+``addr`` to fill it.
 
 V4L2 sub-device functions and data structures
 ---------------------------------------------
-- 
2.7.4


