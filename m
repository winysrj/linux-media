Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f194.google.com ([209.85.167.194]:36938 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728375AbeKTWuY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 17:50:24 -0500
Received: by mail-oi1-f194.google.com with SMTP id y23so1317137oia.4
        for <linux-media@vger.kernel.org>; Tue, 20 Nov 2018 04:21:32 -0800 (PST)
MIME-Version: 1.0
References: <CAOMZO5DP8JEMfjXJ8Hihm684+3=pOoCo1Gz7kt-TnCB7h-8EvA@mail.gmail.com>
 <20181120121521.e5e3wwwvcyl6xwrm@paasikivi.fi.intel.com>
In-Reply-To: <20181120121521.e5e3wwwvcyl6xwrm@paasikivi.fi.intel.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 20 Nov 2018 10:21:21 -0200
Message-ID: <CAOMZO5A1-GzCjFdgjEdcq18c31o09EG9NFL4tfPK0QzkM4PEUA@mail.gmail.com>
Subject: Re: 'bad remote port parent' warnings
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tue, Nov 20, 2018 at 10:15 AM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:

> Where's the DT source for the board?

Board dts is arch/arm/boot/dts/imx6qdl-wandboard.dtsi

SoC dtsi is arch/arm/boot/dts/imx6q.dtsi

Also, since 4.20-rc the following errors are seen:

[    3.449564] imx-ipuv3 2400000.ipu: driver could not parse
port@1/endpoint@0 (-22)
[    3.457342] imx-ipuv3-csi: probe of imx-ipuv3-csi.1 failed with error -22
[    3.464498] imx-ipuv3 2800000.ipu: driver could not parse
port@0/endpoint@0 (-22)
[    3.472120] imx-ipuv3-csi: probe of imx-ipuv3-csi.4 failed with error -22

which were not present in 4.19.

Log from 4.19:
https://storage.kernelci.org/stable/linux-4.19.y/v4.19.2/arm/imx_v6_v7_defconfig/lab-baylibre-seattle/boot-imx6q-wandboard.html

Log from 4.20-rc3:
https://storage.kernelci.org/mainline/master/v4.20-rc3/arm/imx_v6_v7_defconfig/lab-baylibre-seattle/boot-imx6q-wandboard.html

Thanks
