Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:35825 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753097AbdBCLHr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Feb 2017 06:07:47 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: mito.hulin@gmail.com, colin.king@canonical.com, matrandg@cisco.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.11] Various fixes
Message-ID: <5b979feb-8fa1-1919-8498-678f5ab63bdc@xs4all.nl>
Date: Fri, 3 Feb 2017 12:07:44 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just a bunch of various small fixes.

Regards,

	Hans

The following changes since commit d2180e0cf77dc7a7049671d5d57dfa0a228f83c1:

   [media] v4l: async: make v4l2 coexist with devicetree nodes in a dt overlay (2017-02-03 
08:05:16 -0200)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git for-v4.11d

for you to fetch changes up to 11afe5970d4ed0c0590a7133f10ecd88a71e4ba4:

   v4l2-ctrls.c: add NULL check (2017-02-03 11:54:43 +0100)

----------------------------------------------------------------
Colin Ian King (2):
       gspca_stv06xx: remove redundant check for err < 0
       saa7164: "first image" should be "second image" in error message

Hans Verkuil (1):
       v4l2-ctrls.c: add NULL check

Matej Hulín (1):
       media: radio-cadet, initialize timer with setup_timer

Mats Randgaard (3):
       tc358743: Do not read number of CSI lanes in use from chip
       tc358743: Disable HDCP with "manual HDCP authentication" bit
       tc358743: ctrl_detect_tx_5v should always be updated

  drivers/media/i2c/tc358743.c                     | 47 
++++++++++++++++++++---------------------------
  drivers/media/i2c/tc358743_regs.h                |  1 +
  drivers/media/pci/saa7164/saa7164-fw.c           |  2 +-
  drivers/media/radio/radio-cadet.c                |  8 ++------
  drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c |  3 ---
  drivers/media/v4l2-core/v4l2-ctrls.c             |  3 +++
  6 files changed, 27 insertions(+), 37 deletions(-)
