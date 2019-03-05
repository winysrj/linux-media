Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD49C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 09:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99036206DD
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 09:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbfCEJ6y (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 04:58:54 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:45308 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727327AbfCEJ6x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 04:58:53 -0500
Received: from test-no.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 16qVhtdVBLMwI16qYhrcsL; Tue, 05 Mar 2019 10:58:51 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>
Subject: [PATCHv2 0/9] Various core and virtual driver fixes
Date:   Tue,  5 Mar 2019 10:58:38 +0100
Message-Id: <20190305095847.21428-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfFzhTw3k5Jbvjup+58vNRQQ/1cnhj0/gTLxIy7XmmsZVoYsS8r7I92QuYzssZYqYQtu1/wI3qpNyVie6aSBDsFH8eKxUOgQ1Fdy1rUEHodsyVnuX/QUb
 TvE8Cj7+rY+KZAW2ecV0Fbx+bWLTHUTJn1dN+/ZjHDyRvD/ff51eVznBm3qHEGTyaKAAZ2LlJjJ92/E2nJ8+rrHxgY4M5VpAaWikJsyV/u2U18BkdwCGEkMf
 0NT/NJb79X7scIlV14n/xnLDn5ZAotcSNuKBdWPOn4U=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Various fixes for bugs that I found while working on the
regression test-media script.

The CONFIG_DEBUG_KOBJECT_RELEASE=y option in particular found
a bunch of bugs where things were not released in the right
order.

Note that the first two patches are not bug fixes, but they
help debugging kobjects. Without this the object name is just
(null), which makes it hard to figure out what the object is.

Changes since v1:

- Dropped 'v4l2-device: v4l2_device_release_subdev_node can't
  reference sd' and replaced it with 'v4l2-subdev: add release()
  internal op'.
- Added 'v4l2-subdev: handle module refcounting here'.
- Added 'vimc: use new release op'.

With these changes I can run the test-media script without errors
(except for a known vimc 'do not call blocking ops when !TASK_RUNNING;'
error, waiting for a patch from Helen that fixes this).

Regards,

	Hans

Hans Verkuil (9):
  cec: fill in cec chardev kobject to ease debugging
  media-devnode: fill in media chardev kobject to ease debugging
  vivid: use vzalloc for dev->bitmap_out
  media-entity: set ent_enum->bmap to NULL after freeing it
  vim2m: replace devm_kzalloc by kzalloc
  v4l2-subdev: add release() internal op
  v4l2-subdev: handle module refcounting here
  vimc: free vimc_cap_device when the last user disappears
  vimc: use new release op

 drivers/media/cec/cec-core.c                 |  1 +
 drivers/media/media-devnode.c                |  1 +
 drivers/media/media-entity.c                 | 29 +---------------
 drivers/media/platform/vim2m.c               | 35 ++++++++++++--------
 drivers/media/platform/vimc/vimc-capture.c   | 13 ++++++--
 drivers/media/platform/vimc/vimc-common.c    |  2 ++
 drivers/media/platform/vimc/vimc-common.h    |  2 ++
 drivers/media/platform/vimc/vimc-debayer.c   | 15 +++++++--
 drivers/media/platform/vimc/vimc-scaler.c    | 15 +++++++--
 drivers/media/platform/vimc/vimc-sensor.c    | 19 ++++++++---
 drivers/media/platform/vivid/vivid-vid-out.c | 14 +++++---
 drivers/media/v4l2-core/v4l2-device.c        | 19 ++++++++---
 drivers/media/v4l2-core/v4l2-subdev.c        | 22 +++++-------
 include/media/media-entity.h                 | 24 --------------
 include/media/v4l2-subdev.h                  |  4 +++
 15 files changed, 116 insertions(+), 99 deletions(-)

-- 
2.20.1

