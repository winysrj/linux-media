Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:43080 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab3HANFD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Aug 2013 09:05:03 -0400
Received: by mail-lb0-f173.google.com with SMTP id 10so1508658lbf.18
        for <linux-media@vger.kernel.org>; Thu, 01 Aug 2013 06:05:01 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: hans.verkuil@cisco.com, linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 0/2] Add support for V4L2_PIX_FMT_Y16, V4L2_PIX_FMT_RGB32 and V4L2_PIX_FMT_BGR32
Date: Thu,  1 Aug 2013 15:04:52 +0200
Message-Id: <1375362294-30741-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for 3 new formats.

Ricardo Ribalda Delgado (2):
  libv4lconvert: Support for Y16 pixel format
  libv4lconvert: Support for RGB32 and BGR32 format

 lib/libv4lconvert/libv4lconvert-priv.h |   11 +++-
 lib/libv4lconvert/libv4lconvert.c      |   77 +++++++++++++++++++++++--
 lib/libv4lconvert/rgbyuv.c             |   96 ++++++++++++++++++++++++++++----
 3 files changed, 166 insertions(+), 18 deletions(-)

-- 
1.7.10.4

