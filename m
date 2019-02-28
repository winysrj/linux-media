Return-Path: <SRS0=4gsG=RD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F369AC43381
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 12:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C75F1214D8
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 12:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732019AbfB1M6i (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 28 Feb 2019 07:58:38 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:35798 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726232AbfB1M6h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Feb 2019 07:58:37 -0500
Received: from [IPv6:2001:983:e9a7:1:28f6:efa6:3b03:d09a] ([IPv6:2001:983:e9a7:1:28f6:efa6:3b03:d09a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id zLGlgBisWLMwIzLGmgcbht; Thu, 28 Feb 2019 13:58:36 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] imx7: fix sparse/smatch warnings/errors
Message-ID: <8eed3592-949e-3353-2199-5381df0ea6ae@xs4all.nl>
Date:   Thu, 28 Feb 2019 13:58:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfAKKlr7xOqQUhmcZAblM1bqk34BhSiSs+uy0H1QigNYxzhkFD9yji5EpgVuX3RCiwxbRrGZ65GcFEn0O/O63fH8aagMPRS+nLSavwvqcgAnhJp4ZDsF2
 uGiiI9LiijKC+dsbRPzFcBc5DymC8qQGZyspiIan8mrjaGukwryr1Jaz4pP2tGdYT162PeUFlw8euFBpdZYz8R2TAWyuc5zGl4XGCdialQHMAGE2xWRzQ3rj
 AHKrCXKdkZrUURztfnhfFo0AF6ZOREG1hrF6QHeN1sQ=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



The following changes since commit 9fabe1d108ca4755a880de43f751f1c054f8894d:

  media: ipu3-mmu: fix some kernel-doc macros (2019-02-19 09:00:42 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1s

for you to fetch changes up to d3d18960c43db81feae1c171a4a61ada939388dc:

  media: imx7_mipi_csis: remove internal ops (2019-02-28 13:36:44 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Rui Miguel Silva (1):
      media: imx7_mipi_csis: remove internal ops

 drivers/staging/media/imx/imx7-mipi-csis.c | 27 ---------------------------
 1 file changed, 27 deletions(-)
