Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C4ADC43444
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 13:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 390DE20874
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 13:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732690AbfAKNcG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 08:32:06 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:51405 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728591AbfAKNcG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 08:32:06 -0500
Received: from [IPv6:2001:983:e9a7:1:b51b:802b:6c83:309a] ([IPv6:2001:983:e9a7:1:b51b:802b:6c83:309a])
        by smtp-cloud8.xs4all.net with ESMTPA
        id hwupgtGOoNR5yhwuqgAVoS; Fri, 11 Jan 2019 14:32:04 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] add buf_out_validate callback to vb2 + two fixes
Message-ID: <b8c73d3c-5fbb-4c60-9637-6655fc3f2e79@xs4all.nl>
Date:   Fri, 11 Jan 2019 14:32:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNK3+yMYaiWxIvoIlRlH9jkOpAtiRHrPplHcFKHnD3GiJB6JIS21B2xdbRhZjP0km7io67khASMJQp5KypDobeNi5woY89FHgRgMBNYuraogPfg/AolP
 HTd85+LtYdf4sGp6Rpv/ffdyrFs/8dpfA3sqHOr7/k2VW17SbzUbKZoasDm6va5shgSVyJeVw3/hwM0oMQ/voYBbaAgcvaoiVqvqmqPOFYBkAzia3iZQ6msY
 QpV+rBnykhanXy293Po0GnKqgH/nfr4osyhhsqzSxLM=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The first three patches add the buf_out_validate callback to vb2 so video
output devices can validate the v4l2_buffer struct (specifically, validating
the field).

This fixes a v4l2-compliance failure.

The last two patches fix a vim2m bug and fix a vivid compliance bug.

With this pull request all v4l2-compliance tests succeed for vivid and vim2m.

Regards,

	Hans

The following changes since commit 1e0d0a5fd38192f23304ea2fc2b531fea7c74247:

  media: s5p-mfc: fix incorrect bus assignment in virtual child device (2019-01-07 14:39:36 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-buf_val

for you to fetch changes up to 1e89980a8651f6cddbe20f4e02c958dbf2f33d08:

  vivid: do not implement VIDIOC_S_PARM for output streams (2019-01-11 13:25:47 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (5):
      vb2: add buf_out_validate callback
      vim2m: add buf_out_validate callback
      vivid: add buf_out_validate callback
      vim2m: the v4l2_m2m_buf_copy_data args were swapped
      vivid: do not implement VIDIOC_S_PARM for output streams

 drivers/media/common/videobuf2/videobuf2-core.c | 14 +++++++++++---
 drivers/media/platform/vim2m.c                  | 29 +++++++++++++++++------------
 drivers/media/platform/vivid/vivid-core.c       |  2 +-
 drivers/media/platform/vivid/vivid-vid-out.c    | 23 ++++++++++++++++-------
 include/media/videobuf2-core.h                  |  5 +++++
 5 files changed, 50 insertions(+), 23 deletions(-)
