Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr730101.outbound.protection.outlook.com ([40.107.73.101]:45808
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726612AbeKMPae (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 10:30:34 -0500
From: <Yasunari.Takiguchi@sony.com>
To: <narmstrong@baylibre.com>
CC: <mchehab@kernel.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Yasunari.Takiguchi@sony.com>
Subject: RE: [PATCH 0/2] sony-cxd2880: add optional vcc regulator
Date: Tue, 13 Nov 2018 05:34:00 +0000
Message-ID: <02699364973B424C83A42A84B04FDA850B32C810@JPYOKXMS113.jp.sony.com>
References: <1541681410-8187-1-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1541681410-8187-1-git-send-email-narmstrong@baylibre.com>
Content-Language: ja-JP
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Neil,

I am not familiar to this vcc function 
but I check this compile is ok.

Acked-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

> -----Original Message-----
> From: Neil Armstrong [mailto:narmstrong@baylibre.com]
> Sent: Thursday, November 8, 2018 9:50 PM
> To: Takiguchi, Yasunari (SSS)
> Cc: Neil Armstrong; mchehab@kernel.org; linux-media@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: [PATCH 0/2] sony-cxd2880: add optional vcc regulator
> 
> This patchset adds an optional VCC regulator to the bindings and driver
> to
> make sure power is enabled to the module before starting attaching to
> the device.
> 
> Neil Armstrong (2):
>   media: cxd2880-spi: Add optional vcc regulator
>   media: sony-cxd2880: add optional vcc regulator to bindings
> 
>  .../devicetree/bindings/media/spi/sony-cxd2880.txt       |  4 ++++
>  drivers/media/spi/cxd2880-spi.c                          | 16
> ++++++++++++++++
>  2 files changed, 20 insertions(+)
> 
> --
> 2.7.4
