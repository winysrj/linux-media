Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBFCBC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 12:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2EC920651
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 12:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbfAHMHH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 07:07:07 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:51785 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727295AbfAHMHH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 07:07:07 -0500
Received: from [IPv6:2001:420:44c1:2579:e5a0:705e:8afb:6231] ([IPv6:2001:420:44c1:2579:e5a0:705e:8afb:6231])
        by smtp-cloud9.xs4all.net with ESMTPA
        id gq9ugEKGuMWvEgq9ygNdbP; Tue, 08 Jan 2019 13:07:06 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] pwc: Don't use coherent DMA buffers for ISO
 transfer
Message-ID: <77707704-09f6-9b5f-33df-1cf4b28bd8d8@xs4all.nl>
Date:   Tue, 8 Jan 2019 13:07:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFCQ7IBlEYN0IAvtzI/lVPyAKJNW7fkmlnnUPDs7SnasWNG20hxN+1io1iF0mRHyB7zHp5czcyG2ZnyrA9giS9tD3w0YqjQaifcg7zKv9zMQ6iW+eSH8
 6mwFzxY/jS5t8w2TXZV/3VIR0PO9tdc3qfRajt0kO3Wos/zi4B99srNE57yQTBB2GjUaOko9P2/2sQubChPP7iyJhslhbtoy9OdoAIj7ulzW+46CwsGfO5rO
 bHPID0PVhAAEM8c4n43jea6h3NGxQTQqy8j86v8pFZP2iMeRbyEBYh0+hN6tIswk
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This pull requests supersedes the previous pull request for v4.21, which didn't
make it.

It's unchanged from the previous pull request, just rebased on top of v5.0-rc1.

The "dma-direct: provide a generic implementation of DMA_ATTR_NON_CONSISTENT"
discussion is about future work to help with cases like this, so this doesn't
block merging this PR.

Regards,

	Hans

The following changes since commit 1e0d0a5fd38192f23304ea2fc2b531fea7c74247:

  media: s5p-mfc: fix incorrect bus assignment in virtual child device (2019-01-07 14:39:36 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1a

for you to fetch changes up to b12e0617fead5caa8448b14ded05442851d70cb4:

  MAINTAINERS: added include/trace/events/pwc.h (2019-01-08 12:48:54 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (1):
      MAINTAINERS: added include/trace/events/pwc.h

Matwey V. Kornilov (2):
      media: usb: pwc: Introduce TRACE_EVENTs for pwc_isoc_handler()
      media: usb: pwc: Don't use coherent DMA buffers for ISO transfer

 MAINTAINERS                    |  1 +
 drivers/media/usb/pwc/pwc-if.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------
 include/trace/events/pwc.h     | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 122 insertions(+), 13 deletions(-)
 create mode 100644 include/trace/events/pwc.h
