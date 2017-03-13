Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36562 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbdCMMyd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 08:54:33 -0400
From: Johan Hovold <johan@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 0/6] [media] fix missing endpoint sanity checks
Date: Mon, 13 Mar 2017 13:53:53 +0100
Message-Id: <20170313125359.29394-1-johan@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series fixes a number of NULL-pointer dereferences (and related
issues) due to missing endpoint sanity checks that can be triggered by a
malicious USB device.

Johan


Johan Hovold (6):
  [media] dib0700: fix NULL-deref at probe
  [media] usbvision: fix NULL-deref at probe
  [media] cx231xx-cards: fix NULL-deref at probe
  [media] cx231xx-audio: fix init error path
  [media] cx231xx-audio: fix NULL-deref at probe
  [media] gspca: konica: add missing endpoint sanity check

 drivers/media/usb/cx231xx/cx231xx-audio.c     | 42 +++++++++++++++++--------
 drivers/media/usb/cx231xx/cx231xx-cards.c     | 45 ++++++++++++++++++++++++---
 drivers/media/usb/dvb-usb/dib0700_core.c      |  3 ++
 drivers/media/usb/gspca/konica.c              |  3 ++
 drivers/media/usb/usbvision/usbvision-video.c |  9 +++++-
 5 files changed, 83 insertions(+), 19 deletions(-)

-- 
2.12.0
