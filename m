Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C96C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 13:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCDDF20874
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 13:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731822AbfAKN1q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 08:27:46 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:56487 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731063AbfAKN1q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 08:27:46 -0500
Received: from [IPv6:2001:983:e9a7:1:b51b:802b:6c83:309a] ([IPv6:2001:983:e9a7:1:b51b:802b:6c83:309a])
        by smtp-cloud8.xs4all.net with ESMTPA
        id hwqdgtEPLNR5yhwqegAUce; Fri, 11 Jan 2019 14:27:44 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v5.0] vim2m: only cancel work if it is for right
 context
Message-ID: <3710a5ba-d7aa-b908-dde5-44f1cb53ea6a@xs4all.nl>
Date:   Fri, 11 Jan 2019 14:27:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfG8kLVNP1BxwWtiTLIrsHdwUSCjNSMzBZSreO14WTVS0bcj8O5wzTE9dyeq2/nBLeKz3fA+afFGs7rOX6wYKIIB/vcjfuwcF3qqr5PG8fVKe/byg3MEq
 iSHwaPKX53tsk4LuFIbren075jdkbttLxVlPho3qG0lbMOyyBWaCn4WK0trNfuvaxt8iR+tFeLAYWHcPUvIt68GGt0vmK616JYHOEdy5QAetT8MkRlX2d8ns
 Hwyl5cmc5fBYbSwgbZTA/l8eolPjwh3Kjnbstao2mGM=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Fix vim2m bug introduced in 4.20.

Regards,

	Hans

The following changes since commit 1e0d0a5fd38192f23304ea2fc2b531fea7c74247:

  media: s5p-mfc: fix incorrect bus assignment in virtual child device (2019-01-07 14:39:36 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.0b

for you to fetch changes up to 7477a577a4aae4365da7c8df994414d90d5b93c2:

  vim2m: only cancel work if it is for right context (2019-01-11 13:27:00 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (1):
      vim2m: only cancel work if it is for right context

 drivers/media/platform/vim2m.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
