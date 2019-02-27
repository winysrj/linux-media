Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C43C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 17:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E56820842
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 17:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbfB0RIY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 12:08:24 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48020 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730607AbfB0RIU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 12:08:20 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id F192F2787A3
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 0/4] Add debug messages to v4l2-ctrls
Date:   Wed, 27 Feb 2019 14:07:02 -0300
Message-Id: <20190227170706.6258-1-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

v2:
  * Print the video device node name where possible, in v4l2-ctrls.c,
    by passing the struct video_device as a parameter.
  * Added a warning to dev_debug attribute store, to warn
    the user about V4L2_DEV_DEBUG_CTRL being a no-op for dev_debug.

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

 drivers/media/v4l2-core/v4l2-ctrls.c  | 93 +++++++++++++++++++++------
 drivers/media/v4l2-core/v4l2-dev.c    | 47 ++++++--------
 drivers/media/v4l2-core/v4l2-ioctl.c  |  8 +--
 drivers/media/v4l2-core/v4l2-subdev.c |  4 +-
 include/media/v4l2-ctrls.h            |  9 ++-
 include/media/v4l2-ioctl.h            |  2 +
 6 files changed, 110 insertions(+), 53 deletions(-)

-- 
2.20.1

