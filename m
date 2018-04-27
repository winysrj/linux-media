Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37773 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757142AbeD0LoQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 07:44:16 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, hans.verkuil@cisco.com, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 0/2] Use gpio_is_valid()
Date: Fri, 27 Apr 2018 17:13:59 +0530
Message-Id: <cover.1524828993.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the manual validity checks for the GPIO with the
gpio_is_valid().

Arvind Yadav (2):
  [PATCH 1/2] [media] platform: Use gpio_is_valid()
  [PATCH 2/2] [media] sta2x11: Use gpio_is_valid() and remove unnecessary check

 drivers/media/pci/sta2x11/sta2x11_vip.c | 31 +++++++++++++++----------------
 drivers/media/platform/via-camera.c     |  2 +-
 2 files changed, 16 insertions(+), 17 deletions(-)

-- 
1.9.1
