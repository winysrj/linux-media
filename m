Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:30196 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbcGNJbv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 05:31:51 -0400
Received: from [10.47.79.81] ([10.47.79.81])
	(authenticated bits=0)
	by aer-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id u6E9VX0P007921
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 14 Jul 2016 09:31:35 GMT
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH] vivid: fix typo causing incorrect CEC physical addresses
Message-ID: <57875BF4.4070202@cisco.com>
Date: Thu, 14 Jul 2016 11:31:32 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix typo in vivid that caused all HDMI outputs to have the same
physical address.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 9966828..7f93713 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -1232,7 +1232,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 				goto unreg_dev;
 			}
 			bus_cnt++;
-			if (bus_cnt <= in_type_counter[HDMI])
+			if (bus_cnt <= out_type_counter[HDMI])
 				cec_s_phys_addr(adap, bus_cnt << 12, false);
 			else
 				cec_s_phys_addr(adap, 0x1000, false);
