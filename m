Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A41C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 17:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DABFE20881
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 17:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548697359;
	bh=uksaXLgZR4CcvzXReguvlIiyqaxIV61NpWhAqSkrdFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=jBYcez5F/2T6xOGPcQzwdf3KrgbLzn+AKZkp8y1oxvFtKsnCQvQL+5vlhGpnpi9ii
	 uyrM6dnwFWJzunpaRMFbia6ACrnfbiOAsbvy/M0RfQRaojD77AHcmGir5076ekaQMn
	 Xh6yV9l4pvh2yJaKPVxFMsR/epzXE1ld8Bd76Wbk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbfA1PuL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:50:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727590AbfA1PuK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 10:50:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11BB420880;
        Mon, 28 Jan 2019 15:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548690609;
        bh=uksaXLgZR4CcvzXReguvlIiyqaxIV61NpWhAqSkrdFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dD9x52znGLnAS53YXrPvEuAoWft8JlT1hmEz3VmxSEKbbC1wDy47cZ9RuEAuo10/R
         gYEphGbGJuGdvit67onW7cMcgBBriUr3WHlNQ+ZzjVnS1RW7prFkz9FZ6NHIT83iW3
         DQ/9PrXBbAOqHtmUCt5VL51GT2cCm30xbKSuSMbM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 140/304] media: v4l2-device: Link subdevices to their parent devices if available
Date:   Mon, 28 Jan 2019 10:40:57 -0500
Message-Id: <20190128154341.47195-140-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Tomasz Figa <tfiga@chromium.org>

[ Upstream commit ee494cf377e142f65f202fadf0d859f8e12119fb ]

Currently v4l2_device_register_subdev_nodes() does not initialize the
dev_parent field of the video_device structs it creates for subdevices
being registered. This leads to __video_register_device() falling back
to the parent device of associated v4l2_device struct, which often does
not match the physical device the subdevice is registered for.

Due to the problem above, the links between real devices and v4l-subdev
nodes cannot be obtained from sysfs, which might be confusing for the
userspace trying to identify the hardware.

Fix this by initializing the dev_parent field of the video_device struct
with the value of dev field of the v4l2_subdev struct. In case of
subdevices without a parent struct device, the field will be NULL and the
old behavior will be preserved by the semantics of
__video_register_device().

Signed-off-by: Tomasz Figa <tfiga@chromium.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index df0ac38c4050..e0ddb9a52bd1 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -247,6 +247,7 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 
 		video_set_drvdata(vdev, sd);
 		strscpy(vdev->name, sd->name, sizeof(vdev->name));
+		vdev->dev_parent = sd->dev;
 		vdev->v4l2_dev = v4l2_dev;
 		vdev->fops = &v4l2_subdev_fops;
 		vdev->release = v4l2_device_release_subdev_node;
-- 
2.19.1

