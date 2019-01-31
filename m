Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43220C169C4
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 14:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C56A20869
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 14:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfAaOLB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 31 Jan 2019 09:11:01 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:57009 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726977AbfAaOLB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Jan 2019 09:11:01 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id pD3QgDSd3NR5ypD3TgQYck; Thu, 31 Jan 2019 15:11:00 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] Various fixes
Message-ID: <c7e9ed04-49c5-3a2d-aecb-98648d0e1ab9@xs4all.nl>
Date:   Thu, 31 Jan 2019 15:10:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGX1DgNgvpeQuhu1p/i0FqGTEfHiCrIZZw2IpJF4o+nrtBgFJGPC/6mo53s1Dmuw2Zghj9B8MeXfUWWxYrr7MN3O31VfJyqfshNW/hcQgG7Y+2pcf1rA
 X7CpiOsCqBm6un/jwgdmSkxCQHuQA6DyIzpgxOqUknqgtBf1i7cSRCQkDuAV3cnEJZ0XSiwlL2PmsA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The following changes since commit 560c053deb94ff65b22a87f28e8e2fab5940555c:

  media: vivid: fix vid_out_buf_prepare() (2019-01-31 09:32:05 -0200)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1k

for you to fetch changes up to 277a309f78411c5c4bc088c72dc19281f53f81a4:

  vicodec: support SOURCE_CHANGE event for decoders only (2019-01-31 15:08:58 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (5):
      videobuf2: remove unused variable
      vicodec: check type in g/s_selection
      vicodec: fill in bus_info in media_device_info
      vim2m: fill in bus_info in media_device_info
      vicodec: support SOURCE_CHANGE event for decoders only

Philipp Zabel (1):
      media: imx-pxp: fix duplicated if condition

 drivers/media/common/videobuf2/videobuf2-core.c |  1 -
 drivers/media/platform/imx-pxp.c                |  2 +-
 drivers/media/platform/vicodec/vicodec-core.c   | 18 +++++++++++++++---
 drivers/media/platform/vim2m.c                  |  2 ++
 4 files changed, 18 insertions(+), 5 deletions(-)
