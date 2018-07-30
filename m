Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:44234 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728965AbeG3OG1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 10:06:27 -0400
Received: by mail-yw0-f195.google.com with SMTP id k18-v6so4266237ywm.11
        for <linux-media@vger.kernel.org>; Mon, 30 Jul 2018 05:31:41 -0700 (PDT)
Received: from mail-yb0-f173.google.com (mail-yb0-f173.google.com. [209.85.213.173])
        by smtp.gmail.com with ESMTPSA id n3-v6sm4385216ywb.70.2018.07.30.05.31.39
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Jul 2018 05:31:39 -0700 (PDT)
Received: by mail-yb0-f173.google.com with SMTP id s8-v6so4654161ybe.8
        for <linux-media@vger.kernel.org>; Mon, 30 Jul 2018 05:31:39 -0700 (PDT)
MIME-Version: 1.0
References: <20180730121057.31798-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20180730121057.31798-1-sakari.ailus@linux.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 30 Jul 2018 21:31:27 +0900
Message-ID: <CAAFQd5D=MDhtLC-rJHcJj+BaBE2LgNBboJrtjXONKeN4zvOxAQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] i2c: Fix pm_runtime_get_if_in_use() usage in sensor drivers
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Yeh, Andy" <andy.yeh@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        ping-chung.chen@intel.com, "Lai, Jim" <jim.lai@intel.com>,
        Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 30, 2018 at 9:12 PM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
>
> pm_runtime_get_if_in_use() returns -EINVAL if runtime PM is disabled. This
> should not be considered an error. Generally the driver has enabled
> runtime PM already so getting this error due to runtime PM being disabled
> will not happen.
>
> Instead of checking for lesser or equal to zero, check for zero only.
> Address this for drivers where this pattern exists.
>
> This patch has been produced using the following command:
>
> $ git grep -l pm_runtime_get_if_in_use -- drivers/media/i2c/ | \
>   xargs perl -i -pe 's/(pm_runtime_get_if_in_use\(.*\)) \<\= 0/!$1/'
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/i2c/ov13858.c | 2 +-
>  drivers/media/i2c/ov2685.c  | 2 +-
>  drivers/media/i2c/ov5670.c  | 2 +-
>  drivers/media/i2c/ov5695.c  | 2 +-
>  drivers/media/i2c/ov7740.c  | 2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)

Thanks!

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
