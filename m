Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26CEBC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 08:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5BF120859
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 08:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbfAOIQH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 03:16:07 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:54496 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726022AbfAOIQH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 03:16:07 -0500
Received: from [IPv6:2001:983:e9a7:1:415f:b492:6ed4:23a7] ([IPv6:2001:983:e9a7:1:415f:b492:6ed4:23a7])
        by smtp-cloud8.xs4all.net with ESMTPA
        id jJtEgIkmqNR5yjJtFgKVJX; Tue, 15 Jan 2019 09:16:05 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] Various fixes
Message-ID: <0251b6cf-9084-2bf9-d61b-17926e1d718b@xs4all.nl>
Date:   Tue, 15 Jan 2019 09:16:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfB+KtW6y7pzAzDljoapqMiWVweI2GCE0rpUMbHT8DmRHBZMQ5NuaGphJI7QFb75m6OCSuHPnJ2nuSlrHE/qaKimiOK2tjeyR1UQTah2pAwwMRzjTSeOd
 J0KqpKRtHzL7wEvmk+DceWJiWxuvFeruaTBaLsqIWgusIWNaMUoQG4hUQbZ0XlVFv8ek9e+DTW9PzPRZTAbtJsF9KtX3nSavchIgKd3kFaf3LOaE7jLQPlsB
 M4HnW/lXGCp2oMxwIKE9oxPJ2pleSr4FdDBn0kLuld4/MiYD5oWQk1x9B0uPec1HCKxjVd/70McM6AqQRg4teg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Most notably Sakari's patch which adds V4L2_BUF_TYPE_META_OUTPUT to the
V4L2_TYPE_IS_OUTPUT define.

The other two are vivid fixes to make it pass the media regression test
I'm working on.

Regards,

	Hans

The following changes since commit 1e0d0a5fd38192f23304ea2fc2b531fea7c74247:

  media: s5p-mfc: fix incorrect bus assignment in virtual child device (2019-01-07 14:39:36 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1d

for you to fetch changes up to 635891d4e3afdf9447f5cd6fd77735dca8e24850:

  vivid: take data_offset into account for video output (2019-01-15 09:12:56 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (2):
      vivid: disable VB2_USERPTR if dma_contig was configured
      vivid: take data_offset into account for video output

Sakari Ailus (1):
      v4l: uAPI: V4L2_BUF_TYPE_META_OUTPUT is an output buffer type

 drivers/media/platform/vivid/vivid-core.c    | 20 +++++++++++++++-----
 drivers/media/platform/vivid/vivid-vid-out.c | 16 ++++++++++------
 include/uapi/linux/videodev2.h               |  3 ++-
 3 files changed, 27 insertions(+), 12 deletions(-)
