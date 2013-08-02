Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:33762 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab3HBWm6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 18:42:58 -0400
Received: by mail-lb0-f176.google.com with SMTP id w10so833667lbi.35
        for <linux-media@vger.kernel.org>; Fri, 02 Aug 2013 15:42:57 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: hans.verkuil@cisco.com, linux-media@vger.kernel.org,
	Gregor Jasny <gjasny@googlemail.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2 0/2] Add support for V4L2_PIX_FMT_Y16, V4L2_PIX_FMT_RGB32 and V4L2_PIX_FMT_BGR32
Date: Sat,  3 Aug 2013 00:42:50 +0200
Message-Id: <1375483372-4354-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for 3 new formats.

v2: Includes feedback from Gregor Jasny
Gregor: Replaces rbg32 flag with bytesperpixes

Ricardo Ribalda Delgado (2):
  libv4lconvert: Support for Y16 pixel format
  libv4lconvert: Support for RGB32 and BGR32 format

 lib/libv4lconvert/libv4lconvert-priv.h |   11 ++++-
 lib/libv4lconvert/libv4lconvert.c      |   77 +++++++++++++++++++++++++++++---
 lib/libv4lconvert/rgbyuv.c             |   75 ++++++++++++++++++++++++++-----
 3 files changed, 145 insertions(+), 18 deletions(-)

-- 
1.7.10.4

