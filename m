Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A704C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 08:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E8B720872
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 08:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbfAKIb2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 03:31:28 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:59724 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727536AbfAKIb2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 03:31:28 -0500
Received: from [IPv6:2001:983:e9a7:1:b51b:802b:6c83:309a] ([IPv6:2001:983:e9a7:1:b51b:802b:6c83:309a])
        by smtp-cloud8.xs4all.net with ESMTPA
        id hsDtgr1krNR5yhsDug95kT; Fri, 11 Jan 2019 09:31:26 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Thierry Reding <thierry.reding@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v5.0] v4l2-ioctl: Clear only per-plane reserved fields
Message-ID: <7b7507b5-f4d1-d95b-b77b-bd7a8044a5ef@xs4all.nl>
Date:   Fri, 11 Jan 2019 09:31:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfO+Zoa0fl7gcnyTrU4a2p+V4+D+cPjC1khUExSTTjcC7SXPTrBSTv/pKjI9D3aDJpaNFXESLOe0Iw0s3iGTT1xEGSphNL/UvqBy3qlP/ISzhZ6S20Iht
 IdeIXQ6NthncxmKz6rwUsYISH3A1i67J0uVtLVXUsNTPLU6VYKDsGD+my+HK/fHr+D0SiYTOqyrv53kWQeJb4vYj8zIxPngohZaCySp6O4LtQBesHXWxpxfX
 VZ+OB0PW+i9GgtCd5V3i8uLOT7+32Yz4wb26JdDJEjw0smdpuMonY+kRbbHizka1j/mw08JDZiIQ5iicw8wH315HFe37na6kgwSfvGClhHYGXX7L2OqnTIAx
 EcEvqhDt
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Three fixes for a bug introduced in 5.0.

The last patch (Validate num_planes for debug messages) is also backported
to kernels >= 4.12 (the oldest kernel for which it applies cleanly).

Regards,

	Hans


The following changes since commit 1e0d0a5fd38192f23304ea2fc2b531fea7c74247:

  media: s5p-mfc: fix incorrect bus assignment in virtual child device (2019-01-07 14:39:36 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.0a2

for you to fetch changes up to 8015f0ce4a3c533acfbb3a71f0d6659fa4120778:

  v4l: ioctl: Validate num_planes for debug messages (2019-01-11 09:17:40 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Sakari Ailus (2):
      v4l: ioctl: Validate num_planes before using it
      v4l: ioctl: Validate num_planes for debug messages

Thierry Reding (1):
      media: v4l2-ioctl: Clear only per-plane reserved fields

 drivers/media/v4l2-core/v4l2-ioctl.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)
