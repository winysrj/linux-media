Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752232AbeAEShs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Jan 2018 13:37:48 -0500
Received: from mail-qt0-f179.google.com (mail-qt0-f179.google.com [209.85.216.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55D4721928
        for <linux-media@vger.kernel.org>; Fri,  5 Jan 2018 18:37:48 +0000 (UTC)
Received: by mail-qt0-f179.google.com with SMTP id g9so6775474qth.9
        for <linux-media@vger.kernel.org>; Fri, 05 Jan 2018 10:37:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1515174543-31121-1-git-send-email-akinobu.mita@gmail.com>
References: <1515174543-31121-1-git-send-email-akinobu.mita@gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Fri, 5 Jan 2018 12:37:27 -0600
Message-ID: <CAL_JsqJOH+dU8wSQo5YCQbbhzrsWBX4OZfMV5xX89F5CmdQ5Rg@mail.gmail.com>
Subject: Re: [PATCH] media: ov9650: support device tree probing
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 5, 2018 at 11:49 AM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> The ov9650 driver currently only supports legacy platform data probe.
> This change adds device tree probing.
>
> There has been an attempt to add device tree support for ov9650 driver
> by Hugues Fruchet as a part of the patchset that adds support of OV9655
> camera (http://www.spinics.net/lists/linux-media/msg117903.html), but
> it wasn't merged into mainline because creating a separate driver for
> OV9655 is preferred.
>
> This is very similar to Hugues's patch, but not supporting new device.
>
> Cc: H. Nikolaus Schaller <hns@goldelico.com>
> Cc: Hugues Fruchet <hugues.fruchet@st.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  .../devicetree/bindings/media/i2c/ov9650.txt       |  35 +++++++

Please split bindings and send to the DT list.

>  drivers/media/i2c/ov9650.c                         | 107 ++++++++++++++++-----
>  2 files changed, 117 insertions(+), 25 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov9650.txt
