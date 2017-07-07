Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:35949 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbdGGMpD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 08:45:03 -0400
MIME-Version: 1.0
From: Jagan Teki <jagannadh.teki@gmail.com>
Date: Fri, 7 Jul 2017 18:15:02 +0530
Message-ID: <CAD6G_RQ-7uwTVLr27UTSvA50rLq-yRRTYKMmYQf7K1O8wf6HOA@mail.gmail.com>
Subject: coda 2040000.vpu: firmware request failed
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm observing firmware request failure with i.MX6Q board, This is with
latest linux-next (4.12) with firmware from, [1] and converted
v4l-coda960-imx6q.bin using [2].

Log:
------
coda 2040000.vpu: Direct firmware load for vpu_fw_imx6q.bin failed with error -2
coda 2040000.vpu: Direct firmware load for vpu/vpu_fw_imx6q.bin failed
with error -2
coda 2040000.vpu: Direct firmware load for v4l-coda960-imx6q.bin
failed with error -2
coda 2040000.vpu: firmware request failed

I've verified md4sum and VDDPU as well, hope these look OK.

# md5sum /lib/firmware/v4l-coda960-imx6q.bin
af4971a37c7a3a50c99f7dfd36104c63  /lib/firmware/v4l-coda960-imx6q.bin
# dmesg | grep regu | grep -i vddpu
[    0.061552] vddpu: supplied by regulator-dummy

Did I missed any, request for help?

[1] http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/firmware-imx-3.0.35-4.0.0.bin
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/181101.html

thanks!
-- 
Jagan Teki
Free Software Engineer | www.openedev.com
U-Boot, Linux | Upstream Maintainer
Hyderabad, India.
