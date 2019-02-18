Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF968C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 20:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B5052177E
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 20:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbfBRUPr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 15:15:47 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:40850 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbfBRUPr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 15:15:47 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id C28B027F7BE
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 0/4] Add debug messages to v4l2-ctrls
Date:   Mon, 18 Feb 2019 17:15:24 -0300
Message-Id: <20190218201528.21545-1-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Even though the goal was fairly simple (adding debug to v4l2-ctrls)
it ended up spanning this little patchset.

The motivation for this cleanup is being able to turn on/off
debugging messages in v4l2-ctrls.c, using a knob common to the
videodev driver's core.

So, in addition to the dev_debug attribute, this series introduces
a debug module parameter, and a new debug level, which enables
v4l2-ctrl debugging.

Having this is quite useful when bringing-up stateless codecs,
using the Request API.

Ezequiel Garcia (4):
  media: v4l: Simplify dev_debug flags
  media: v4l: Improve debug dprintk macro
  media: v4l: Add a module parameter to control global debugging
  media: v4l: ctrls: Add debug messages

 drivers/media/v4l2-core/v4l2-ctrls.c | 63 +++++++++++++++++++++++-----
 drivers/media/v4l2-core/v4l2-dev.c   | 48 ++++++++++-----------
 include/media/v4l2-ioctl.h           |  2 +
 3 files changed, 78 insertions(+), 35 deletions(-)

-- 
2.20.1

