Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BED7C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 17:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09DC120C01
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 17:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732628AbfBRREI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 12:04:08 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:54866 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731720AbfBRREI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 12:04:08 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id vmKpgcHdC4HFnvmKsg0ego; Mon, 18 Feb 2019 18:04:06 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] Various fixes
Message-ID: <5db97ea4-c423-2f86-d4ba-c58e04dfe180@xs4all.nl>
Date:   Mon, 18 Feb 2019 18:04:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGyuDUcJq+6n8AAdI3NpRK91XElg9fjwAwRbGe/Z5FUAbm/bK8xei9uwUop9xyWrRNqL9jZlwVuPvoweXa/mP1/hYSNnhp9jl2UvkXznYhQmOYwfRXyq
 0UyX3qYjf/E3K9tOW44/57oEyrFZSH262bQ2UiAO/fbBbtWMnaw3J3Tn5vIjJPbTk5YqhlaD3TtXdA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The following changes since commit 16597c2744f79aaf5f9ec0107be477639985bf44:

  media: i2c: adv748x: Remove PAGE_WAIT (2019-02-18 11:25:30 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1r2

for you to fetch changes up to 69bcb353abb07b1ad061f70ef9ba738e84488350:

  media: cx25840: mark pad sig_types to fix cx231xx init (2019-02-18 18:01:30 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Cody P Schafer (1):
      media: cx25840: mark pad sig_types to fix cx231xx init

Colin Ian King (1):
      wl128x: fix spelling mistake: "Swtich" -> "Switch"

Hans Verkuil (2):
      vivid: two unregistration fixes
      vimc: fix memory leak

 drivers/media/i2c/cx25840/cx25840-core.c  | 3 ++-
 drivers/media/i2c/cx25840/cx25840-core.h  | 1 -
 drivers/media/platform/vimc/vimc-core.c   | 2 ++
 drivers/media/platform/vivid/vivid-core.c | 4 +---
 drivers/media/radio/wl128x/fmdrv_common.c | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)
