Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37508 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935106AbdGTRUW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 13:20:22 -0400
Received: by mail-wm0-f51.google.com with SMTP id g127so32956554wmd.0
        for <linux-media@vger.kernel.org>; Thu, 20 Jul 2017 10:20:22 -0700 (PDT)
MIME-Version: 1.0
From: Naman Jain <nsahula.photo.sharing@gmail.com>
Date: Thu, 20 Jul 2017 22:50:21 +0530
Message-ID: <CAPD8ABV6hve8kJ1wPncy2cGn3C_82enHVZKo3nzn9+8L2ZjtZg@mail.gmail.com>
Subject: Adv7180 driver configuration problem
To: lars@metafoo.de
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I need to configure adv7281m in renesas SOC which uses rcar-csi as
bridge(csi receiver) and rcar- vin as dma engine.

I have done the configuration in device tree as mention in DT bindings.

When i start the streaming (continuous capture), i am getting

rcar.csi2: timeout reading the PHY clock lane

further probing the data lanes on adv7281m, i am seeing incorrect
voltages in HS mode.
