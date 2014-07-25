Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62197 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935021AbaGYRsG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 13:48:06 -0400
Received: by mail-wi0-f170.google.com with SMTP id f8so1472014wiw.3
        for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 10:48:05 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 0/4] some em28xx-v4l cleanup patches
Date: Fri, 25 Jul 2014 19:48:54 +0200
Message-Id: <1406310538-5001-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series consists of 4 cleanup patches for the em28xx-v4l module.

Frank Schäfer (4):
  em28xx-v4l: simplify some pointers in em28xx_init_camera()
  em28xx-v4l: get rid of struct em28xx_fh
  em28xx-v4l: simplify em28xx_v4l2_open() by using v4l2_fh_open()
  em28xx-v4l: get rid of field "users" in struct em28xx_v4l2

 drivers/media/usb/em28xx/em28xx-camera.c |   4 +-
 drivers/media/usb/em28xx/em28xx-video.c  | 113 ++++++++++++-------------------
 drivers/media/usb/em28xx/em28xx.h        |   8 ---
 3 files changed, 47 insertions(+), 78 deletions(-)

-- 
1.8.4.5

