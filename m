Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36915 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754799AbcHVJFQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 05:05:16 -0400
Received: by mail-wm0-f48.google.com with SMTP id i5so132536986wmg.0
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2016 02:05:11 -0700 (PDT)
From: Johan Fjeldtvedt <jaffe1@gmail.com>
To: linux-media@vger.kernel.org
Cc: Johan Fjeldtvedt <jaffe1@gmail.com>
Subject: [PATCHv2 0/4] pulse8-cec: Add support for storing and optionally restoring config
Date: Mon, 22 Aug 2016 11:04:50 +0200
Message-Id: <1471856694-14182-1-git-send-email-jaffe1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds support for storing the CEC adapter config in the Pulse-Eight
dongle's persistent memory, and to optionally restore it when the device
is (re)connected. This allows the dongle to continue operating with the
same settings when the PC is suspended.

Changes in v2:
 - Fix checkpatch warnings and spelling error
 - Add missing break
 - Don't propagate internal error code to user space

Johan Fjeldtvedt (4):
  cec: allow configuration both from within driver and from user space
  pulse8-cec: serialize communication with adapter
  pulse8-cec: add notes about behavior in autonomous mode
  pulse8-cec: sync configuration with adapter

 drivers/staging/media/cec/cec-adap.c          |   4 -
 drivers/staging/media/pulse8-cec/pulse8-cec.c | 341 +++++++++++++++++++++-----
 2 files changed, 283 insertions(+), 62 deletions(-)

-- 
2.7.4

