Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:45128 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751330AbdJERVS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Oct 2017 13:21:18 -0400
Received: by mail-wm0-f45.google.com with SMTP id q124so3444743wmb.0
        for <linux-media@vger.kernel.org>; Thu, 05 Oct 2017 10:21:17 -0700 (PDT)
MIME-Version: 1.0
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 5 Oct 2017 10:21:16 -0700
Message-ID: <CAJ+vNU1kx-mwBZZj=DrOX=Lq5+WuJS9gDj+N6rAaV+4XOW1zcA@mail.gmail.com>
Subject: IMX CSI max pixel rate
To: linux-media <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greetings,

I'm working on a HDMI receiver driver for the TDA1997x
(https://lwn.net/Articles/734692/) and wanted to throw an error if the
detected input resolution/vidout-output-bus-format exceeded the max
pixel rate of the SoC capture bus the chip connects to (in my case is
the IMX6 CSI which has a limit of 180MP/sec).

Any recommendations on where a dt property should live, its naming,
and location/naming and functions to validate the pixel rate or is
there even any interest in this sort of check?

Regards,

Tim
