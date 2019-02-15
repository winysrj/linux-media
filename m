Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 228B8C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 21:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E420F222BE
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 21:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391701AbfBOVJb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 16:09:31 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:51020 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387600AbfBOVJa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 16:09:30 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id ukjdgvECyI8AWukjhg4seI; Fri, 15 Feb 2019 22:09:29 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] Small vicodec update
Message-ID: <f9c48c23-3950-f1c8-96b4-939f40c2e2a5@xs4all.nl>
Date:   Fri, 15 Feb 2019 22:09:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfIi4K01F0xamsy81OxkNmKopQHu9s1Makdm2J0ZcYXKKISdcGhDvT7ibHG3caQBB1fcVFIAIU/shM7o8BJ+kejJhY+DDHyJIDl/T9Ummb2P+0pxZZGMU
 DzEQ1E6E6nJeSQd/TzQVo7QoD0f0EBqdfdIQhZGowcdzAgijcOTgYDRdOaz8FPsx6YzSu9b/S43iyQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Just one patch for vicodec which will help a lot with the upcoming
stateless codec implementation in this driver which will need this
information.

Regards,

	Hans

The following changes since commit 6fd369dd1cb65a032f1ab9227033ecb7b759656d:

  media: vimc: fill in bus_info in media_device_info (2019-02-07 12:38:59 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1q

for you to fetch changes up to f887e6a8e4b12cdb29a95aa4c0a7a041b45f31b8:

  media: vicodec: Add a flag for I-frames in fwht header (2019-02-15 22:05:30 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Dafna Hirschfeld (1):
      media: vicodec: Add a flag for I-frames in fwht header

 drivers/media/platform/vicodec/codec-fwht.h      | 3 ++-
 drivers/media/platform/vicodec/codec-v4l2-fwht.c | 4 +++-
 drivers/media/platform/vicodec/vicodec-core.c    | 4 ++--
 3 files changed, 7 insertions(+), 4 deletions(-)
