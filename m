Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57192 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732090AbeHCQcl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 12:32:41 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Trival spelling mistake fixes
Date: Fri,  3 Aug 2018 15:35:57 +0100
Message-Id: <20180803143601.4211-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Four Trival spelling mistake fixes

Colin Ian King (4):
  media: au0828: fix spelling mistake: "completition" -> "completion"
  media: cx231xx: fix spelling mistake: "completition" -> "completion"
  media: dvb-usb-v2: fix spelling mistake: "completition" ->
    "completion"
  media: dvb-usb: fix spelling mistake: "completition" -> "completion"

 drivers/media/usb/au0828/au0828-video.c   | 2 +-
 drivers/media/usb/cx231xx/cx231xx-audio.c | 4 ++--
 drivers/media/usb/cx231xx/cx231xx-vbi.c   | 2 +-
 drivers/media/usb/dvb-usb-v2/usb_urb.c    | 4 ++--
 drivers/media/usb/dvb-usb/usb-urb.c       | 4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

-- 
2.17.1
