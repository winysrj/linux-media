Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 361C3C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 22:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 049B520842
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 22:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbfCFWnC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 17:43:02 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60828 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfCFWnA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 17:43:00 -0500
Received: from localhost.localdomain (unknown [IPv6:2804:431:9719:798c:6bb0:a97a:4a09:e6d8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: koike)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id E0C5827FF14;
        Wed,  6 Mar 2019 22:42:54 +0000 (GMT)
From:   Helen Koike <helen.koike@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        lkcamp@lists.libreplanetbr.org, andrealmeid@collabora.com,
        Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com
Subject: [PATCH 0/8] media: vimc: remove media bus code limitation
Date:   Wed,  6 Mar 2019 19:42:36 -0300
Message-Id: <20190306224244.21070-1-helen.koike@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

This patch series has several vimc fixes (that I am sending in the same
series only for convenience, let me know if you prefer them to be
sent separately from the series).

The last commit removes the vimc_pix_map_list[] that was mapping
pixelformats with media bus formats, but it turns out they are not
1-to-1 equivalent and it is really painful to add other formats.
Also, for the userspace, media bus formats don't really matter as long
as they match between links. So this patch allows any media bus format
to be configured independently of the final expected pixelformat.

The series depends on
"[PATCH] media: Introduce helpers to fill pixel format structs "

Thanks,
Helen


Helen Koike (8):
  media: vimc: deb: fix default sink bayer format
  media: vimc: stream: fix thread state before sleep
  media: vimc: cap: fix step width/height in enum framesize
  media: v4l2-common: add bayer formats in v4l2_format_info
  media: vimc: stream: cleanup frame field from struct vimc_stream
  media: vimc: stream: add docs to struct vimc_stream
  media: vimc: stream: init/terminate the first entity
  media: vimc: propagate pixel format in the stream

 drivers/media/platform/vimc/vimc-capture.c  |  80 +++--
 drivers/media/platform/vimc/vimc-common.c   | 307 ++++++++------------
 drivers/media/platform/vimc/vimc-common.h   |  13 +
 drivers/media/platform/vimc/vimc-debayer.c  |  80 +++--
 drivers/media/platform/vimc/vimc-scaler.c   |  60 ++--
 drivers/media/platform/vimc/vimc-sensor.c   |  48 +--
 drivers/media/platform/vimc/vimc-streamer.c |  39 +--
 drivers/media/platform/vimc/vimc-streamer.h |  22 +-
 drivers/media/v4l2-core/v4l2-common.c       |  22 ++
 9 files changed, 341 insertions(+), 330 deletions(-)

-- 
2.20.1

