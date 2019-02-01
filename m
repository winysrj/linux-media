Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E86CAC282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 14:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B829A218EA
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 14:58:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="uK/qFsmA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729837AbfBAO63 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 09:58:29 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:39640 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfBAO63 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2019 09:58:29 -0500
Received: from pendragon.ideasonboard.com (85-76-34-136-nat.elisa-mobile.fi [85.76.34.136])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 88E6D4F7
        for <linux-media@vger.kernel.org>; Fri,  1 Feb 2019 15:58:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1549033107;
        bh=CXzH4mizB1vBNGTgpJWzkA2LG8nKbTvQPnWsNri2qHs=;
        h=Date:From:To:Subject:From;
        b=uK/qFsmAPpo7Af/jy6jFg/8M9KMPYIRoD8tWBBdiOA6VjAIlgcbTcvJ2yEu/JSJrK
         4HOnXIyYwUqbPhij5DgjJTHzE+Ori7rhQ6orxmtwAnufMNuXvmJNnrBUP/UQo4ewdH
         HjTOlrSvTCikyPc3UsT8e0V4uzKovkUWPNNc44iM=
Date:   Fri, 1 Feb 2019 16:58:21 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     linux-media@vger.kernel.org
Subject: [GIT PULL FOR v5.1] UVC changes
Message-ID: <20190201145821.GA4359@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

The following changes since commit f0ef022c85a899bcc7a1b3a0955c78a3d7109106:

  media: vim2m: allow setting the default transaction time via parameter (2019-01-31 17:17:08 -0200)

are available in the Git repository at:

  git://linuxtv.org/pinchartl/media.git tags/uvc-next-20190201

for you to fetch changes up to 197f86622da4264aa4b0f3f57c9098ee110dbc78:

  media: uvcvideo: Avoid NULL pointer dereference at the end of streaming (2019-02-01 12:38:01 +0200)

----------------------------------------------------------------
UVC changes for v5.1

----------------------------------------------------------------
Alistair Strachan (1):
      media: uvcvideo: Fix 'type' check leading to overflow

Sakari Ailus (1):
      media: uvcvideo: Avoid NULL pointer dereference at the end of streaming

 drivers/media/usb/uvc/uvc_driver.c | 14 +++++++++++---
 drivers/media/usb/uvc/uvc_video.c  |  8 ++++++++
 2 files changed, 19 insertions(+), 3 deletions(-)

-- 
Regards,

Laurent Pinchart
