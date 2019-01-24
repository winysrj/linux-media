Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD86C282C5
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 13:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DFC3218AE
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 13:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfAXN51 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 08:57:27 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:53067 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727596AbfAXN51 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 08:57:27 -0500
Received: from [IPv6:2001:420:44c1:2579:b544:2b8b:2897:10d8] ([IPv6:2001:420:44c1:2579:b544:2b8b:2897:10d8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id mfVRgJtu5BDyImfVVge9ZM; Thu, 24 Jan 2019 14:57:25 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Dafna Hirschfeld <dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] vicodec improvements/fixes
Message-ID: <5f390706-918a-334a-0037-17e8fedb8028@xs4all.nl>
Date:   Thu, 24 Jan 2019 14:57:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfE7V6k50fI8aZ56M8GaeTx4q27BoI/FznDUVOJN6LlApEH43leW9tzkB/1xjDS+vREKCqZHL21rQ7e0mqDArOOZRb2zKf6Om5VaN30JdMNIvzexzU3pk
 DG/9ZBGZuUl7ap11/Z2Pa2jzjmRdUHOpUYwsDBahUEw3payWEprfq5YkP0yY/LbkDpixXmFxzRgRUok403AB2qU/QLqrp6aIYF1hCAL90wWWU1vn81my7DL4
 dtMBdxY4wb0tvXUp4HuBg5AfguL6VN3ukV+BWmbmMXZ8mDIHMrB1UHglaHQ0Othg8ltu74YFidw7l4UMJm5GIg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This series fixes various vicodec issues and it now follows the
stateful codec API.

This ensures a good starting point for adding codec compliance tests
and starting work to support the stateless codec variant.

Regards,

	Hans

The following changes since commit 337e90ed028643c7acdfd0d31e3224d05ca03d66:

  media: imx-csi: Input connections to CSI should be optional (2019-01-21 16:46:02 -0200)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-vicodec

for you to fetch changes up to 8e2800103e23bad4f4679ffe4eab3d9b8aa0f5bd:

  media: vicodec: ensure comp frame pointer kept in range (2019-01-24 14:54:45 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Dafna Hirschfeld (7):
      media: vicodec: Add num_planes field to v4l2_fwht_pixfmt_info
      media: vicodec: add support for CROP and COMPOSE selection
      media: vicodec: use 3 bits for the number of components
      media: vicodec: Add pixel encoding flags to fwht header
      media: vicodec: Separate fwht header from the frame data
      media: vicodec: Add support for resolution change event.
      media: vicodec: ensure comp frame pointer kept in range

 drivers/media/platform/vicodec/codec-fwht.c      | 144 +++++++++-----
 drivers/media/platform/vicodec/codec-fwht.h      |  27 ++-
 drivers/media/platform/vicodec/codec-v4l2-fwht.c | 390 ++++++++++++++++++++++++------------
 drivers/media/platform/vicodec/codec-v4l2-fwht.h |  15 +-
 drivers/media/platform/vicodec/vicodec-core.c    | 633 ++++++++++++++++++++++++++++++++++++++++++++++-------------
 5 files changed, 890 insertions(+), 319 deletions(-)
