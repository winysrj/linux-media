Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB62CC43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 11:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B03B020657
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 11:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbfAJLxR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 06:53:17 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:34442 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727619AbfAJLxR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 06:53:17 -0500
Received: from [IPv6:2001:420:44c1:2579:595e:33cd:95d8:785f] ([IPv6:2001:420:44c1:2579:595e:33cd:95d8:785f])
        by smtp-cloud9.xs4all.net with ESMTPA
        id hYtcgamPkMWvEhYtfgX0pT; Thu, 10 Jan 2019 12:53:15 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Thierry Reding <thierry.reding@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v5.0] v4l2-ioctl: Clear only per-plane reserved fields
Message-ID: <aeae73cd-5073-4a34-17fa-c7901711c9ae@xs4all.nl>
Date:   Thu, 10 Jan 2019 12:53:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfMjchduOAdxs5iKEjFaG9eQoyzSyV/3GJpGofQkBxAT0GqfkQB4ZSFxknjg8pms0JtvhRTiw7GA9vzkqOYrm0nHdpN9xKUgaucO/gxZBJi0qNAmHyZ3U
 qfgSHbLwZTS/mx6gTVT4KPu//XCqfcGB64TDYDRxND3r7IH+GsfD6cn5WCr9IYfA+eI84CQfVOksjI86rXysx6NEjI3uj5y2Hey70BdARNe+7kpOdr+SWadS
 +FqmKfJjXIVCeW6vHl4taBKg4gMX4NatWmd8BJRJmZ6ncxdd+IX25lcW464pOYV93+Ru2zFqDtSU4c/PPyw9UEAy0W3D8hV8OAxpbXN3SSs=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Fix for a nasty little bug.

Thanks Thierry for finding this!

Regards,

	Hans

The following changes since commit 1e0d0a5fd38192f23304ea2fc2b531fea7c74247:

  media: s5p-mfc: fix incorrect bus assignment in virtual child device (2019-01-07 14:39:36 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.0a

for you to fetch changes up to b8ee4a126c857638a4696b8b24b4c555ef7fedb7:

  media: v4l2-ioctl: Clear only per-plane reserved fields (2019-01-10 12:50:36 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Thierry Reding (1):
      media: v4l2-ioctl: Clear only per-plane reserved fields

 drivers/media/v4l2-core/v4l2-ioctl.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)
