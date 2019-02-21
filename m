Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E42A3C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 14:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9F362075A
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 14:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfBUOVz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 09:21:55 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:33445 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725943AbfBUOVy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 09:21:54 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id wpETg3zIdLMwIwpEXg1DU9; Thu, 21 Feb 2019 15:21:53 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 1/7] cec: fill in cec chardev kobject to ease debugging
Date:   Thu, 21 Feb 2019 15:21:42 +0100
Message-Id: <20190221142148.3412-2-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
References: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfF/W7JxDLn8MB+8RnEhiNskRdAaqR3BnAjlrXDx/EDJH5Weq+94+6hZT4LowC2PXasOxagP5mSsST35eDroaydRgz7rdztYGjzyOK5HUXwN6a2hEBSDh
 zdBTfz1UGPadHwG9xaiz7IZ03Hw7X7PrJVlXpBMVrC6obT6nmQz/j+nh0NMZYEjfV1rBPzJqK6UeZv/qjhjUb3E//QJfWJrlMsnrIIb+KI9715xYQGUW4vs3
 R1bjzRlyfisjEamYf7f2iJwHzsWSIvz6tOXHEJ+pJpJI6bDQddRSmU9ZDZDsvRhyRBsdJxW4IJzwz6tdue81Aw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The cec chardev kobject has no name, which made it hard to
debug when kobject debugging is turned on.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/cec/cec-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index cc875dabd765..f5d1578e256a 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -126,6 +126,7 @@ static int __must_check cec_devnode_register(struct cec_devnode *devnode,
 	/* Part 2: Initialize and register the character device */
 	cdev_init(&devnode->cdev, &cec_devnode_fops);
 	devnode->cdev.owner = owner;
+	kobject_set_name(&devnode->cdev.kobj, "cec%d", devnode->minor);
 
 	ret = cdev_device_add(&devnode->cdev, &devnode->dev);
 	if (ret) {
-- 
2.20.1

