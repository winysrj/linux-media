Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:40867 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752759AbeEGP53 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 11:57:29 -0400
Received: by mail-wr0-f195.google.com with SMTP id v60-v6so29278675wrc.7
        for <linux-media@vger.kernel.org>; Mon, 07 May 2018 08:57:28 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org, Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH 0/4] media: ov2680: follow up from initial version
Date: Mon,  7 May 2018 16:56:51 +0100
Message-Id: <20180507155655.1555-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry I have Out-of-Office some part of last week, I had v6 of the original
series ready but since I have received the notification from patchwork that the
v5 was accepted, I am sending this as a follow up tha address Fabio comments.

- this adds the power supplies to this sensor
- fix gpio polarity and naming.

Cheers,
   Rui


Rui Miguel Silva (4):
  media: ov2680: dt: add voltage supplies as required
  media: ov2680: dt: rename gpio to reset and fix polarity
  media: ov2680: rename powerdown gpio and fix polarity
  media: ov2680: add regulators to supply control

 .../devicetree/bindings/media/i2c/ov2680.txt  | 18 ++++--
 drivers/media/i2c/ov2680.c                    | 55 +++++++++++++++----
 2 files changed, 57 insertions(+), 16 deletions(-)

-- 
2.17.0
