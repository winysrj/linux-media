Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D9CBC65BAF
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 17:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C367B20879
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 17:39:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C367B20879
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbeLLRjR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 12:39:17 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:46111 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727681AbeLLRjQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 12:39:16 -0500
Received: from [IPv6:2001:983:e9a7:1:d5c3:7636:7173:44a0] ([IPv6:2001:983:e9a7:1:d5c3:7636:7173:44a0])
        by smtp-cloud8.xs4all.net with ESMTPA
        id X8Tagkue3uDWoX8TbgJBDU; Wed, 12 Dec 2018 18:39:15 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     "Matwey V. Kornilov" <matwey@sai.msu.ru>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.21] pwc: Don't use coherent DMA buffers for ISO
 transfer
Message-ID: <9ec9a25a-9303-be27-f341-148f973bce99@xs4all.nl>
Date:   Wed, 12 Dec 2018 18:39:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfKUQuvQdCYme5BGUzBo/Y041xNb1tnIUqA3bRHa2e4OmnxGb3zsIGktPbgWVUAWz5BCBXK5IOSjkoujjBTqmirefDp+73qoMqb5Vf5OAONmV4lj5J7nW
 d493tlJWHkP3RpG3kiAwJRI7vDqzGOWm9V34RLLUDRyiruCiJJw8eNyYB4ovbGW5CPsIvuhy4SRoXQS/RKtkEm1oNJtx3QTtwSmIUH3Qv2+e+/U4PBR8PP63
 WIrgeLV+h7tU1tvqoDqe/PIcVdlmctZWwy0X81OWDGi9dO0aTtpwZ+PJqCUbRoD6EX/IrlS0PEhvRvkhGsqMfg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Mauro, hopefully this can still be merged for 4.21.

Regards,

	Hans

The following changes since commit e159b6074c82fe31b79aad672e02fa204dbbc6d8:

  media: vimc: fix start stream when link is disabled (2018-12-07 13:08:41 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-pwc

for you to fetch changes up to bfab401eacacd7a39c62072ce29446a51bba977d:

  MAINTAINERS: added include/trace/events/pwc.h (2018-12-12 18:34:29 +0100)

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
