Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35161 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755987AbdDPRf5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Apr 2017 13:35:57 -0400
Received: by mail-wm0-f43.google.com with SMTP id w64so22137196wma.0
        for <linux-media@vger.kernel.org>; Sun, 16 Apr 2017 10:35:56 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: guennadi.liakhovetski@intel.com, hans.verkuil@cisco.com,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 0/7] ov2640 fixes and improvements
Date: Sun, 16 Apr 2017 19:35:39 +0200
Message-Id: <20170416173546.4317-1-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

First 5 patches are minor fixes/cleanups/improvements which I came
across while testing Hans Verkuils patches and trying to figure out 
what's going wrong with vflip control.
Patch 6 finally fixes the vflip bug.
Patch 7 adds support for 2 new pixel formats.

Frank Schäfer (7):
  ov2640: fix init sequence alignment
  ov2640: improve banding filter register definitions/documentation
  ov2640: add information about DSP register 0xc7
  ov2640: add missing write to size change preamble
  ov2640: fix duplicate width+height returning from ov2640_select_win()
  ov2640: fix vflip control
  ov2640: add support for MEDIA_BUS_FMT_YVYU8_2X8 and
    MEDIA_BUS_FMT_VYUY8_2X8

 drivers/media/i2c/ov2640.c | 96 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 67 insertions(+), 29 deletions(-)

-- 
2.12.2
