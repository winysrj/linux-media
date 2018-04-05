Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:40568 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751165AbeDEMaa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 08:30:30 -0400
Received: by mail-ot0-f181.google.com with SMTP id j8-v6so19422536ota.7
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2018 05:30:30 -0700 (PDT)
MIME-Version: 1.0
From: Ibtsam Ul-Haq <ibtsam.haq.0x01@gmail.com>
Date: Thu, 5 Apr 2018 14:30:29 +0200
Message-ID: <CAPQseg3c+jVBRv7nu9BZXFi2V+afrDUq+YR-0jEDGevgwa-NWw@mail.gmail.com>
Subject: IMX6 Media dev node not created
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greetings everyone,

I'm running Linux 4.14.31 on an IMX6 QuadPlus based Phytec board
(PCM-058). I have connected an mt9p031 sensor to ipu1_csi0. The
problem is that I am not seeing the /dev/media0 node.

I have already read the fix mentioned in a previous discussion:

https://www.spinics.net/lists/linux-media/msg121965.html

and that does not seem to be the problem in my case as I do get the
"ipu1_csi0_mux" registered. Running a grep on dmesg I get:

[    3.235383] imx-media: Registered subdev ipu1_vdic
[    3.241134] imx-media: Registered subdev ipu2_vdic
[    3.246830] imx-media: Registered subdev ipu1_ic_prp
[    3.252115] imx-media: Registered subdev ipu1_ic_prpenc
[    3.266991] imx-media: Registered subdev ipu1_ic_prpvf
[    3.280228] imx-media: Registered subdev ipu2_ic_prp
[    3.285580] imx-media: Registered subdev ipu2_ic_prpenc
[    3.299335] imx-media: Registered subdev ipu2_ic_prpvf
[    3.350034] imx-media: Registered subdev ipu1_csi0
[    3.363017] imx-media: Registered subdev ipu1_csi1
[    3.375523] imx-media: Registered subdev ipu2_csi0
[    3.388615] imx-media: Registered subdev ipu2_csi1
[    3.560351] imx-media: Registered subdev ipu1_csi0_mux
[    3.566151] imx-media: Registered subdev ipu2_csi1_mux
[   10.525497] imx-media: Registered subdev mt9p031 0-0048
[   10.530816] imx-media capture-subsystem: Entity type for entity
mt9p031 0-0048 was not initialized!
[   10.569201] mt9p031 0-0048: MT9P031 detected at address 0x48
[   10.582895] imx-media: Registered subdev mt9p031 0-005d
[   10.588335] imx-media capture-subsystem: Entity type for entity
mt9p031 0-005d was not initialized!
[   10.618795] mt9p031 0-005d: MT9P031 not detected, wrong version 0xfffffffa

Also my config does appear to have the required options activated;
running "zcat /proc/config.gz | egrep 'VIDEO_MUX|MUX_MMIO|VIDEO_IMX'"
I get:

# CONFIG_MDIO_BUS_MUX_MMIOREG is not set
CONFIG_VIDEO_MUX=y
CONFIG_VIDEO_IMX_VDOA=m
CONFIG_VIDEO_IMX_MEDIA=y
CONFIG_VIDEO_IMX_CSI=y
CONFIG_MUX_MMIO=y

I would really appreciate if anyone could help me trying to find out
what went wrong and why the /dev/media0 node is not showing up.

Many thanks and best regards,
Ibtsam Haq
