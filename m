Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35752 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752298AbcHXKqm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 06:46:42 -0400
Received: by mail-wm0-f66.google.com with SMTP id i5so2049572wmg.2
        for <linux-media@vger.kernel.org>; Wed, 24 Aug 2016 03:46:41 -0700 (PDT)
From: Johan Fjeldtvedt <jaffe1@gmail.com>
To: linux-media@vger.kernel.org
Cc: Johan Fjeldtvedt <jaffe1@gmail.com>
Subject: [PATCH] cec tools: exit when CEC device is disconnected 
Date: Wed, 24 Aug 2016 12:31:17 +0200
Message-Id: <1472034678-13813-1-git-send-email-jaffe1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When devices are disconnected, -EIO is currently returned by ioctl, but
this will be replaced by -ENODEV. When ioctl returns that, there is no
reason to let cec-ctl, cec-follower or cec-compliance run, so just exit
them.

This patch must be applied when the CEC framework has been changed to return
ENODEV instead of EIO when devices are disconnected.

Johan Fjeldtvedt (1):
  cec tools: exit if device is disconnected

 utils/cec-compliance/cec-compliance.h |  9 +++++++--
 utils/cec-ctl/cec-ctl.cpp             |  7 ++++++-
 utils/cec-follower/cec-processing.cpp | 14 ++++++++++++--
 3 files changed, 25 insertions(+), 5 deletions(-)

-- 
2.7.4

