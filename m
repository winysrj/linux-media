Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35575 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbeJIODt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 10:03:49 -0400
Received: by mail-pl1-f196.google.com with SMTP id f8-v6so328240plb.2
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2018 23:48:25 -0700 (PDT)
From: Sam Bobrowicz <sam@elite-embedded.com>
To: linux-media@vger.kernel.org
Cc: Sam Bobrowicz <sam@elite-embedded.com>
Subject: [PATCH 0/4] ov5640: small fixes for compatibility
Date: Mon,  8 Oct 2018 23:47:58 -0700
Message-Id: <1539067682-60604-1-git-send-email-sam@elite-embedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches include fixes for some minor annoyances and also help 
increase compatibility with some CSI2 drivers.

Based on latest media_tree commit: "media: ov5640: fix framerate update"

Sam Bobrowicz (4):
  media: ov5640: fix resolution update
  media: ov5640: fix get_light_freq on auto
  media: ov5640: Don't access ctrl regs when off
  media: ov5640: Add additional media bus formats

 drivers/media/i2c/ov5640.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

-- 
2.7.4
