Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF0D9C4360F
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 13:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9BB520661
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 13:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfCHN4c (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:56:32 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:54474 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726786AbfCHN4b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Mar 2019 08:56:31 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id 2Fz7hPu8XI8AW2FzBhLWF9; Fri, 08 Mar 2019 14:56:29 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv4 1/9] cec: fill in cec chardev kobject to ease debugging
Date:   Fri,  8 Mar 2019 14:56:17 +0100
Message-Id: <20190308135625.11278-2-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308135625.11278-1-hverkuil-cisco@xs4all.nl>
References: <20190308135625.11278-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfMkFTmyjMU2hHdAguZQQehE/b9G11feedKhp9igmh0C2kTpAJE4tQy/5K06GSwWOZVktOUL+8lWEUUMa2PiHBsY0cmNN2ujUoJ2Mb2wf5Kl/gvMbaCab
 iUUi4sgij+u1ItSs8QSqekoY3d/k5RbL1FAMxmJCMj2UVMRrEYkP1pa6IrkOJq2iHEAUoRK69Y2KuZSoG0wy9SMw29r8a/3scRKsCPIIy48lr7mT+Ilay0qo
 /QECdk+HUNQRge3IlcXVA5SBbJdNJWdGSLZvFQAoUzETNMnODmMBFvLmplkyAnkCsC9yQeMoAYnXrCoCyifHFA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The cec chardev kobject has no name, which made it hard to
debug when kobject debugging is turned on.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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

