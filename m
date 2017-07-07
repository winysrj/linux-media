Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:54325 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752415AbdGGNj0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 09:39:26 -0400
Message-ID: <1499434760.9610.7.camel@pengutronix.de>
Subject: Re: coda 2040000.vpu: firmware request failed
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jagan Teki <jagannadh.teki@gmail.com>
Cc: Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Date: Fri, 07 Jul 2017 15:39:20 +0200
In-Reply-To: <CAD6G_RQ-7uwTVLr27UTSvA50rLq-yRRTYKMmYQf7K1O8wf6HOA@mail.gmail.com>
References: <CAD6G_RQ-7uwTVLr27UTSvA50rLq-yRRTYKMmYQf7K1O8wf6HOA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jagan,

On Fri, 2017-07-07 at 18:15 +0530, Jagan Teki wrote:
> Hi,
> 
> I'm observing firmware request failure with i.MX6Q board, This is with
> latest linux-next (4.12) with firmware from, [1] and converted
> v4l-coda960-imx6q.bin using [2].
> 
> Log:
> ------
> coda 2040000.vpu: Direct firmware load for vpu_fw_imx6q.bin failed with error -2
> coda 2040000.vpu: Direct firmware load for vpu/vpu_fw_imx6q.bin failed
> with error -2
> coda 2040000.vpu: Direct firmware load for v4l-coda960-imx6q.bin
> failed with error -2

The error code is -ENOENT, so the firmware binary is not found where the
firmware loader code is looking. That could be caused by the coda driver
being probed before the file system containing the firmware binary is
mounted. Have you tried compiling the coda driver as a module
(CONFIG_VIDEO_CODA=m)?

> coda 2040000.vpu: firmware request failed
> 
> I've verified md4sum and VDDPU as well, hope these look OK.
> 
> # md5sum /lib/firmware/v4l-coda960-imx6q.bin
> af4971a37c7a3a50c99f7dfd36104c63  /lib/firmware/v4l-coda960-imx6q.bin
> # dmesg | grep regu | grep -i vddpu
> [    0.061552] vddpu: supplied by regulator-dummy
> 
> Did I missed any, request for help?
> 
> [1] http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/firmware-imx-3.0.35-4.0.0.bin
> [2] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/181101.html
> 
> thanks!

Note that converting the NXP provided firmware is not necessary anymore
since commits a1a87fa3a0cf ("[media] coda: add support for native order
firmware files with Freescale header") and 2ac7f08e3075 ("[media] coda:
add support for firmware files named as distributed by NXP").

Also there are newer firmware binaries available, see
https://patchwork.linuxtv.org/patch/42332/

regards
Philipp
