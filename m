Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E024C07E85
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 17:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C79D42086D
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 17:16:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C79D42086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbeLKRQi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 12:16:38 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:54180 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726313AbeLKRQi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 12:16:38 -0500
Received: from [IPv6:2001:983:e9a7:1:5434:d88b:a352:4c5a] ([IPv6:2001:983:e9a7:1:5434:d88b:a352:4c5a])
        by smtp-cloud9.xs4all.net with ESMTPA
        id Wle7gM50oMlDTWle8gEU2B; Tue, 11 Dec 2018 18:16:36 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Eddie James <eajames@linux.ibm.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.21] Add Aspeed Video Engine driver
Message-ID: <29f79cf8-db28-73bb-32d3-7c2a0bf2f6e5@xs4all.nl>
Date:   Tue, 11 Dec 2018 18:16:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNMO52XzIsU/GN907ZkfQEE7fLt+yyXna1EU66PczhfZhV2v3FG+evtK8MoijTDzZjraD/Oq0wcvIE8nv4Kki/8hW7L4OaQQPxCS1nsYCXGSrV84PJLj
 zxL9krbdICEVBRoh2IbO1l7/fSTe0jUiDlCpT2EVHHfy1dGy4SjOf0nMuUSrTVuD/UydyX6a6XoVhKpv0tA7tVKdUHHy0LKToNe4doMIewPw3eBp/bcChbYi
 aej42yHleaMwJVzNK5+yEQQHEwdevUmfaJ11HdT+EcG05wevsqagqN5HSiQMzO+QF7YH3Tavdbz3WTLfPDPmZw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

I hope there is still a possibility to get this new driver merged for 4.21.
This driver went through a few more revisions than expected, but v8 looks
solid to me.

Regards,

	Hans

The following changes since commit e159b6074c82fe31b79aad672e02fa204dbbc6d8:

  media: vimc: fix start stream when link is disabled (2018-12-07 13:08:41 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-aspeed

for you to fetch changes up to 9c4f50751e7cef9125d68b1c77c54534a457147e:

  media: platform: Add Aspeed Video Engine driver (2018-12-11 18:12:18 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Eddie James (2):
      dt-bindings: media: Add Aspeed Video Engine binding documentation
      media: platform: Add Aspeed Video Engine driver

 Documentation/devicetree/bindings/media/aspeed-video.txt |   26 +
 MAINTAINERS                                              |    8 +
 drivers/media/platform/Kconfig                           |    9 +
 drivers/media/platform/Makefile                          |    1 +
 drivers/media/platform/aspeed-video.c                    | 1729 +++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 1773 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/aspeed-video.txt
 create mode 100644 drivers/media/platform/aspeed-video.c
