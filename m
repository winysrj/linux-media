Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35175 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbeJSX5X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 19:57:23 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com
Cc: akinobu.mita@gmail.com, enrico.scholz@sigma-chemnitz.de,
        linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 0/4] media: mt9m111 features
Date: Fri, 19 Oct 2018 17:50:23 +0200
Message-Id: <20181019155027.28682-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

the purpose of this series is to support the pixclk polarity and the
framerate selection. I picked the patches form Michael and Enrico,
ported them to 4.19 and did some adjustments.

I tested the framrate and pixckl selection on a custom arm based board.

Enrico Scholz (1):
  media: mt9m111: allow to setup pixclk polarity

Marco Felsch (1):
  media: mt9m111: add s_stream callback

Michael Grzeschik (2):
  media: mt9m111: add streaming check to set_fmt
  media: mt9m111: add support to select formats and fps for {Q,SXGA}

 drivers/media/i2c/mt9m111.c | 221 +++++++++++++++++++++++++++++++++++-
 1 file changed, 220 insertions(+), 1 deletion(-)

-- 
2.19.0
