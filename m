Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93068C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 11:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60BB82082B
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 11:51:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60BB82082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbeLELvp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 06:51:45 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:53976 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726924AbeLELvp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 06:51:45 -0500
Received: from [IPv6:2001:420:44c1:2579:69e7:fb8a:bb15:8970] ([IPv6:2001:420:44c1:2579:69e7:fb8a:bb15:8970])
        by smtp-cloud9.xs4all.net with ESMTPA
        id UViNgMXOeUylNUViRgwTcA; Wed, 05 Dec 2018 12:51:43 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.21] vicodec cleanup
Message-ID: <04db2f84-0812-5b8d-140a-2849a1b7e481@xs4all.nl>
Date:   Wed, 5 Dec 2018 12:51:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfHqZLfMl6GWEqYaBvS+k85Jiq4Z41Ex2YtzChegD/1n/HS4LahCEpeJnVCk83MardvPKFcMqPW9stvzryoGlmihWnAUq7dLfbODSSLyG2YJ8S9XnfMg6
 +nFv0pkineYhZWTG7HOePkHpbO6T7kr3OuGPdhhl7H5hPhv1b9mrjRdhtqgVt745BxfYbOCVviQAVcqUcf2GT2nN2pKijyYMNP+qehDjtADBQOJlKOQiqW8t
 ijDSqI624D3zBFgdDJ/lsZ45651TimR6ZpCKLsR51dqzKhv/YRXYyR0Iz553dSXu
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The following changes since commit b2e9a4eda11fd2cb1e6714e9ad3f455c402568ff:

  media: firewire: Fix app_info parameter type in avc_ca{,_app}_info (2018-12-05 05:34:33 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.21h

for you to fetch changes up to a1e9f0504e413d4ae9f7e8879be59253f676f429:

  media: vicodec: Change variable names (2018-12-05 12:44:42 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Dafna Hirschfeld (1):
      media: vicodec: Change variable names

 drivers/media/platform/vicodec/vicodec-core.c | 94 ++++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 48 insertions(+), 46 deletions(-)
