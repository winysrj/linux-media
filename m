Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:56581 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752041AbdJTHZk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 03:25:40 -0400
Received: by mail-pf0-f196.google.com with SMTP id b85so9811551pfj.13
        for <linux-media@vger.kernel.org>; Fri, 20 Oct 2017 00:25:40 -0700 (PDT)
From: Jaejoong Kim <climbbb.kim@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, Jaejoong Kim <climbbb.kim@gmail.com>
Subject: [PATCH 0/2] media: usb: remove duplicate & operation
Date: Fri, 20 Oct 2017 16:25:26 +0900
Message-Id: <1508484328-11018-1-git-send-email-climbbb.kim@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

usb_endpoint_maxp() has an inline keyword and searches for bits[10:0]
by & operation with 0x7ff. So, we can remove the duplicate & operation
with 0x7ff.

Jaejoong Kim (2):
  media: usb: uvc: remove duplicate & operation
  media: usb: usbtv: remove duplicate & operation

 drivers/media/usb/usbtv/usbtv-core.c | 2 +-
 drivers/media/usb/uvc/uvc_video.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.7.4
