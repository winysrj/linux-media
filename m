Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11262 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752557AbeC0PS4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 11:18:56 -0400
Date: Tue, 27 Mar 2018 23:18:11 +0800
From: kbuild test robot <lkp@intel.com>
To: tskd08@gmail.com
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [RFC PATCH] dvb-usb/friio, dvb-usb-v2/gl861: friio_props can be
 static
Message-ID: <20180327151811.GA82916@lkp-sb04>
References: <20180326180652.5385-4-tskd08@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180326180652.5385-4-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Fixes: 7d9f3a71c6fc ("dvb-usb/friio, dvb-usb-v2/gl861: decompose friio")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 gl861.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/gl861.c b/drivers/media/usb/dvb-usb-v2/gl861.c
index bc18ca3..ef64411 100644
--- a/drivers/media/usb/dvb-usb-v2/gl861.c
+++ b/drivers/media/usb/dvb-usb-v2/gl861.c
@@ -572,7 +572,7 @@ static struct dvb_usb_device_properties gl861_props = {
 	}
 };
 
-struct dvb_usb_device_properties friio_props = {
+static struct dvb_usb_device_properties friio_props = {
 	.driver_name = KBUILD_MODNAME,
 	.owner = THIS_MODULE,
 	.adapter_nr = adapter_nr,
