Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A6AC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 09:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB6B120851
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 09:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfAQJ1H (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 04:27:07 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:36230 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725965AbfAQJ1H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 04:27:07 -0500
Received: from [IPv6:2001:983:e9a7:1:89e8:8b49:35c9:423f] ([IPv6:2001:983:e9a7:1:89e8:8b49:35c9:423f])
        by smtp-cloud9.xs4all.net with ESMTPA
        id k3x1gUdFQaxzfk3x2gksab; Thu, 17 Jan 2019 10:27:05 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>, petrcvekcz@gmail.com
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] soc_ov9640: rename ov9640.h to soc_ov9640.h
Message-ID: <4cfd150c-ba3c-f886-a121-23d48dcd0e89@xs4all.nl>
Date:   Thu, 17 Jan 2019 10:27:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfH+/HDzEYMGX1ge6cBWqV/8NwR00CFu74rlcN5SJ52SJNvtcxZ+PTDaC9nlpp8TQ7TKAyM3/gLCQa7aQejY9PVm9oLitXPspD5uX5bf8dcXlbW/N79kR
 OGjmzGOQ+aWxvthQWC/RFk/q9IVVQ7PqYlZdLScg68dCJJqlZyQhhQPVhLX31XfS7AmK5JSnYGwYDb7ip6lqqQIZ5OYAJiHauomOf0oFrcJfrCli11sszbgv
 bgMIJ8wtu8tiEEsE2IlDObFSGK56jiJlRACnk4O6EAsdHtHCBh2MDwn8eS056n9foujO5lr1Xdw11OlI9bOs37vRvD+5GYpfSwv2IYRN/USC2vGu8WpQtwfQ
 ZGo72COu
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This avoids confusion with the non-soc-camera ov9640.h.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
Having two headers by the same name caused a daily build error. Fix this by
renaming the soc_camera ov9640.h header.

BTW, is there any reason why the soc_camera ov9640 driver can't be
removed altogether? It's not used anywhere anymore.
---
 drivers/media/i2c/soc_camera/soc_ov9640.c               | 2 +-
 drivers/media/i2c/soc_camera/{ov9640.h => soc_ov9640.h} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/media/i2c/soc_camera/{ov9640.h => soc_ov9640.h} (100%)

diff --git a/drivers/media/i2c/soc_camera/soc_ov9640.c b/drivers/media/i2c/soc_camera/soc_ov9640.c
index eb91b8240083..0d3de48de0e4 100644
--- a/drivers/media/i2c/soc_camera/soc_ov9640.c
+++ b/drivers/media/i2c/soc_camera/soc_ov9640.c
@@ -32,7 +32,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>

-#include "ov9640.h"
+#include "soc_ov9640.h"

 #define to_ov9640_sensor(sd)	container_of(sd, struct ov9640_priv, subdev)

diff --git a/drivers/media/i2c/soc_camera/ov9640.h b/drivers/media/i2c/soc_camera/soc_ov9640.h
similarity index 100%
rename from drivers/media/i2c/soc_camera/ov9640.h
rename to drivers/media/i2c/soc_camera/soc_ov9640.h
-- 
2.20.1

