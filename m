Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F57C169C4
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 12:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5AAC2084C
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 12:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbfA2MTg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 07:19:36 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:56291 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727917AbfA2MTg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 07:19:36 -0500
Received: from [IPv6:2001:420:44c1:2579:1c83:9203:362b:bf24] ([IPv6:2001:420:44c1:2579:1c83:9203:362b:bf24])
        by smtp-cloud9.xs4all.net with ESMTPA
        id oSMUg1KVxRO5ZoSMXgNp7R; Tue, 29 Jan 2019 13:19:34 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] vb2 + cedrus fixes/improvements
Message-ID: <342f754a-0ef9-e534-7076-802875b53417@xs4all.nl>
Date:   Tue, 29 Jan 2019 13:19:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfEF1zU5OIYmEqiIZ+rAioydku/YyzYUrWGCpOW+xsAd08U1XTdZBo5fVmiZ8OaG220czs5pgMrc6K1obn3BNWieDbfF8NqjW9DdszHg5xhgEbaMkkG7j
 zKgHqPOgRm2+14YbizKDpCq75BVXECEZWdmMq/ld6tEgfjwzL8VfM3H0kFrcVuFzPfzWverd48BNDxdUswqiptbTtapRBHJTYeYI8AhubRvhIaCOvJfgBTWv
 FJohLQDaCNhRKFngB2CL+NyR5BR6xPr/C5zHxgMVhe3LwWlR1vXr4IQXWpc6f6+w2nGgOaSWZ4ZuSejeMERBYN85iqfd+28S/KD+FOwYm10=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The first two patches simplify the function to find buffers based on a
timestamp: the current code only considered DONE and DEQUEUED buffers,
but that is unnecessarily restrictive.

The next two patches keep dmabuf-based buffers mapped when they are
dequeued. This avoids having to re-map them if they are referenced as key
frames in a stateless codec. This patch has been in use by ChromeOS for
quite some time and it makes sense.

It is more efficient in general anyway since you don't want to have to
map a dmabuf every time you queue it if there is no need for it.

The next 5 patches fix v4l2-compliance bugs in vivid and vimc for output
field handling in requests.

The final patch fixes a vivid buf_prepare bug.

Regards,

	Hans

This PR supersedes https://patchwork.linuxtv.org/patch/54168/, adding
patch 'vivid: fix vid_out_buf_prepare()'.

The following changes since commit 337e90ed028643c7acdfd0d31e3224d05ca03d66:

  media: imx-csi: Input connections to CSI should be optional (2019-01-21 16:46:02 -0200)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1i3

for you to fetch changes up to ceae9b654c11f3d3490995f563529cf53ffdf7ac:

  vivid: fix vid_out_buf_prepare() (2019-01-29 13:15:46 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (7):
      vb2: vb2_find_timestamp: drop restriction on buffer state
      vb2: add buf_out_validate callback
      vim2m: add buf_out_validate callback
      vivid: add buf_out_validate callback
      cedrus: add buf_out_validate callback
      vb2: check that buf_out_validate is present
      vivid: fix vid_out_buf_prepare()

Paul Kocialkowski (2):
      Revert "media: cedrus: Allow using the current dst buffer as reference"
      media: cedrus: Remove completed item from TODO list (dma-buf references)

Pawel Osciak (1):
      media: vb2: Keep dma-buf buffers mapped until they are freed

 drivers/media/common/videobuf2/videobuf2-core.c   | 33 ++++++++++++++++++++++-----------
 drivers/media/common/videobuf2/videobuf2-v4l2.c   | 20 ++++++++++++--------
 drivers/media/platform/vim2m.c                    | 27 ++++++++++++++++-----------
 drivers/media/platform/vivid/vivid-vid-out.c      | 41 +++++++++++++++++++++++++++--------------
 drivers/staging/media/sunxi/cedrus/TODO           |  5 -----
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c   | 13 -------------
 drivers/staging/media/sunxi/cedrus/cedrus_dec.h   |  2 --
 drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c | 10 ++++------
 drivers/staging/media/sunxi/cedrus/cedrus_video.c |  9 +++++++++
 include/media/videobuf2-core.h                    |  5 +++++
 include/media/videobuf2-v4l2.h                    |  3 +--
 11 files changed, 96 insertions(+), 72 deletions(-)
