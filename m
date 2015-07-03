Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:36720 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbbGCTPR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2015 15:15:17 -0400
Received: by qkei195 with SMTP id i195so78333840qke.3
        for <linux-media@vger.kernel.org>; Fri, 03 Jul 2015 12:15:16 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: dale.hamel@srvthe.net, michael@stegemann.it,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH v3 0/2] stk1160: Frame scaling and "de-verbosification"
Date: Fri,  3 Jul 2015 16:11:40 -0300
Message-Id: <1435950702-2462-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've removed the driver verbosity and fixed the frame scale implementation.
In addition to the usual mplayer/vlc/qv4l2, it's now tested with v4l2-compliance
on media_tree master branch.

$ v4l2-compliance -s -f:
Total: 131, Succeeded: 131, Failed: 0, Warnings: 5

Thanks,

Ezequiel Garcia (2):
  stk1160: Reduce driver verbosity
  stk1160: Add frame scaling support

 drivers/media/usb/stk1160/stk1160-core.c |   5 +-
 drivers/media/usb/stk1160/stk1160-reg.h  |  34 +++++
 drivers/media/usb/stk1160/stk1160-v4l.c  | 217 ++++++++++++++++++++++++++-----
 drivers/media/usb/stk1160/stk1160.h      |   1 -
 4 files changed, 216 insertions(+), 41 deletions(-)

-- 
2.4.3

