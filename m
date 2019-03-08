Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98575C4360F
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 13:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73AAB20661
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 13:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfCHN4j (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:56:39 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:41465 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726774AbfCHN4b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Mar 2019 08:56:31 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id 2Fz7hPu8XI8AW2FzAhLWF0; Fri, 08 Mar 2019 14:56:29 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>
Subject: [PATCHv4 0/9] Various core and virtual driver fixes
Date:   Fri,  8 Mar 2019 14:56:16 +0100
Message-Id: <20190308135625.11278-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfMkFTmyjMU2hHdAguZQQehE/b9G11feedKhp9igmh0C2kTpAJE4tQy/5K06GSwWOZVktOUL+8lWEUUMa2PiHBsY0cmNN2ujUoJ2Mb2wf5Kl/gvMbaCab
 iUUi4sgij+u1Itm0fv/370MGQnbrUXG33CQmHYRTD7anQ7yLY/eE58Cq26QJO2TTdpXiIthCgFtw8GiZ3QZsQ2ft1C7VKXC5xp+wnfs7HXjagmHclpTRxXZa
 HXb6zoHP4r7p5PD60iTh5m8OM9roQrogZL7CSWuj/yU=
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

Changes since v3:

- Dropped patch 4/9 (media-entity: set ent_enum->bmap to NULL after freeing it)
- Added patch 7/9 (vimc: zero the media_device on probe)

With these changes I can run the test-media script without errors
(except for a known vimc 'do not call blocking ops when !TASK_RUNNING;'
error, a patch for this from Helen has been posted).

Many thanks to Laurent for reviewing this series!

Regards,

	Hans

Hans Verkuil (9):
  cec: fill in cec chardev kobject to ease debugging
  media-devnode: fill in media chardev kobject to ease debugging
  vivid: use vzalloc for dev->bitmap_out
  vim2m: replace devm_kzalloc by kzalloc
  v4l2-subdev: add release() internal op
  v4l2-subdev: handle module refcounting here
  vimc: zero the media_device on probe
  vimc: free vimc_cap_device when the last user disappears
  vimc: use new release op

 drivers/media/cec/cec-core.c                 |  1 +
 drivers/media/media-devnode.c                |  1 +
 drivers/media/media-entity.c                 | 28 ----------------
 drivers/media/platform/vim2m.c               | 35 ++++++++++++--------
 drivers/media/platform/vimc/vimc-capture.c   | 13 ++++++--
 drivers/media/platform/vimc/vimc-common.c    |  2 ++
 drivers/media/platform/vimc/vimc-common.h    |  2 ++
 drivers/media/platform/vimc/vimc-core.c      |  2 ++
 drivers/media/platform/vimc/vimc-debayer.c   | 15 +++++++--
 drivers/media/platform/vimc/vimc-scaler.c    | 15 +++++++--
 drivers/media/platform/vimc/vimc-sensor.c    | 19 ++++++++---
 drivers/media/platform/vivid/vivid-vid-out.c | 14 +++++---
 drivers/media/v4l2-core/v4l2-device.c        | 19 ++++++++---
 drivers/media/v4l2-core/v4l2-subdev.c        | 22 +++++-------
 include/media/media-entity.h                 | 24 --------------
 include/media/v4l2-subdev.h                  | 15 ++++++++-
 16 files changed, 127 insertions(+), 100 deletions(-)

-- 
2.20.1

