Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38060C4360F
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 14:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF42B206A3
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 14:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfBUOVz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 09:21:55 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:45737 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725820AbfBUOVy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 09:21:54 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id wpETg3zIdLMwIwpEWg1DTq; Thu, 21 Feb 2019 15:21:53 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>
Subject: [PATCH 0/7] Various core and virtual driver fixes
Date:   Thu, 21 Feb 2019 15:21:41 +0100
Message-Id: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfF/W7JxDLn8MB+8RnEhiNskRdAaqR3BnAjlrXDx/EDJH5Weq+94+6hZT4LowC2PXasOxagP5mSsST35eDroaydRgz7rdztYGjzyOK5HUXwN6a2hEBSDh
 zdBTfz1UGPadH2bXKiOMDCCAlZ4+EsHglmqqKdExdSzWtKc47/MfY+3OCFX8pWb4dgh29xxVCmKoX/QJ9hciUoJLMBydIVQvdhtp9i4cQfaTT5BUg+AiNS3g
 hsSs2N5VxSuEkPbD6GBweJv9c5fe6WmY3XS+U9acOmY=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Various fixes for bugs that I found while working on the
regression test-media script.

The CONFIG_DEBUG_KOBJECT_RELEASE=y option in particular found
a bunch of bugs where things were not released in the right
order.

Note that the first two patches are not bug fixes, but they
help debugging kobjects. Without this the object name is just
(null), which makes it hard to figure out what the object is.

Regards,

	Hans

Hans Verkuil (7):
  cec: fill in cec chardev kobject to ease debugging
  media-devnode: fill in media chardev kobject to ease debugging
  vivid: use vzalloc for dev->bitmap_out
  media-entity: set ent_enum->bmap to NULL after freeing it
  vim2m: replace devm_kzalloc by kzalloc
  v4l2-device: v4l2_device_release_subdev_node can't reference sd
  vimc: free vimc_cap_device when the last user disappears

 drivers/media/cec/cec-core.c                 |  1 +
 drivers/media/media-devnode.c                |  1 +
 drivers/media/media-entity.c                 |  1 +
 drivers/media/platform/vim2m.c               | 20 +++++++++++++++-----
 drivers/media/platform/vimc/vimc-capture.c   | 13 ++++++++++---
 drivers/media/platform/vivid/vivid-vid-out.c | 14 +++++++++-----
 drivers/media/v4l2-core/v4l2-device.c        | 10 ++--------
 7 files changed, 39 insertions(+), 21 deletions(-)

-- 
2.20.1

