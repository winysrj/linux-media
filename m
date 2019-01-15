Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F229C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C0EA20651
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbfAOO1g (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 09:27:36 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:57803 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726863AbfAOO1g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 09:27:36 -0500
Received: from [IPv6:2001:983:e9a7:1:415f:b492:6ed4:23a7] ([IPv6:2001:983:e9a7:1:415f:b492:6ed4:23a7])
        by smtp-cloud7.xs4all.net with ESMTPA
        id jPgkg88ZhBDyIjPglgxiyQ; Tue, 15 Jan 2019 15:27:35 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] Two fixes
Message-ID: <037f911a-56ac-6774-1cf8-fbdceb6f7d12@xs4all.nl>
Date:   Tue, 15 Jan 2019 15:27:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOKwkZG3E28TwkCp1ul1W085zt8FIzk6XyI7QAdwPlY6O+CUKatoLLEBko8j4OmT9uollMW7Xye6I3fooLWanI5QGR3ksgJ/6sQMfl9Es5VONqtymK+S
 hv/TazS/QVxRWjq2LUnaaBphDEhL93wM97Jkm+8lf/tx+qe1A59Yhn/4IJqp8mrgw5DtbQLAQyeb27STrP1eBYLcrRZ8zBIJXwsithJjMDRL6PYieCAjvosi
 U5S0OG6euWmB4mPRMdRb7lU3d0U+U6yckduxojEY5Wk=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The following changes since commit 1e0d0a5fd38192f23304ea2fc2b531fea7c74247:

  media: s5p-mfc: fix incorrect bus assignment in virtual child device (2019-01-07 14:39:36 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1e

for you to fetch changes up to cad36e96af6247b671de17e3573b336c5798e160:

  vim2m: the v4l2_m2m_buf_copy_data args were swapped (2019-01-15 15:24:01 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (2):
      vivid: do not implement VIDIOC_S_PARM for output streams
      vim2m: the v4l2_m2m_buf_copy_data args were swapped

 drivers/media/platform/vim2m.c            | 2 +-
 drivers/media/platform/vivid/vivid-core.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
marune: ~/work/src/v4l/media-git $
