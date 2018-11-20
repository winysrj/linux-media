Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f175.google.com ([209.85.167.175]:44067 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728432AbeKTWj5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 17:39:57 -0500
Received: by mail-oi1-f175.google.com with SMTP id p82-v6so1271267oih.11
        for <linux-media@vger.kernel.org>; Tue, 20 Nov 2018 04:11:08 -0800 (PST)
MIME-Version: 1.0
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 20 Nov 2018 10:10:57 -0200
Message-ID: <CAOMZO5DP8JEMfjXJ8Hihm684+3=pOoCo1Gz7kt-TnCB7h-8EvA@mail.gmail.com>
Subject: 'bad remote port parent' warnings
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On a imx6q-wandboard running linux-next 20181120 there the following warnings:

[    4.327794] video-mux 20e0000.iomuxc-gpr:ipu1_csi0_mux: bad remote
port parent
[    4.336118] video-mux 20e0000.iomuxc-gpr:ipu2_csi1_mux: bad remote
port parent

Is there anything we should do to prevent this from happening?

Thanks,

Fabio Estevam
