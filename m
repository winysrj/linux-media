Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526C7C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 13:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B56B20823
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 13:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfARNAQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 08:00:16 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:60183 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726062AbfARNAQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 08:00:16 -0500
Received: from [IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c] ([IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c])
        by smtp-cloud8.xs4all.net with ESMTPA
        id kTksgl339NR5ykTktgWXQo; Fri, 18 Jan 2019 14:00:15 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v5.0] imx: Disable CSI immediately after last EOF
Message-ID: <6194066e-b3fd-0df8-74ac-807f3d655c5f@xs4all.nl>
Date:   Fri, 18 Jan 2019 14:00:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOWcNpfadR30Q91PTbt4ZTRSGUxYPAKGzEagtYm+zzF4EfFEZtyiqZfHiiXhtL7Z0eyx9s3NS/POglhd39ZrnK+qqMMfYybHMzwsxSvieKXDq66L7uDt
 kdrRIO8zIkMb6sxQJ3HZtiOyalU5w8+7VN+o+sTJmR1OF1UuPoMpOR+Hs7HRnP3sMd/o9fOgEOp3mE+uAzpaLPMxdLTYlFPlX61ca1vuCQUyVAJqYUerjtqw
 nw4ci7vITcdIpuAJzTqETimQfPp88J+/B6TTA302P6PwIb4fhiHNAItDN+PcKZPF2ndkqannH8oAzcFQLYJpt5eSBKR1PVhHbLNejKDmy607uJTixkD7M5cL
 +zhvFoVs
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Two related fixes for the imx driver for 5.0 and stable for 4.13 and up.

Regards,

	Hans

The following changes since commit e8f9b16d72631870e30a3d8e4ee9f1c097bc7ba0:

  media: remove soc_camera ov9640 (2019-01-17 09:01:11 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.0c

for you to fetch changes up to 3faf506050bb2ff6134f2cd9aa328518986da267:

  media: imx: prpencvf: Disable CSI immediately after last EOF (2019-01-18 13:55:13 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Steve Longerbeam (2):
      media: imx: csi: Disable CSI immediately after last EOF
      media: imx: prpencvf: Disable CSI immediately after last EOF

 drivers/staging/media/imx/imx-ic-prpencvf.c | 26 +++++++++++++++++---------
 drivers/staging/media/imx/imx-media-csi.c   |  6 ++++--
 2 files changed, 21 insertions(+), 11 deletions(-)
