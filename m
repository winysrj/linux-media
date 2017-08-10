Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:34685 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751361AbdHJHA2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 03:00:28 -0400
Received: by mail-yw0-f182.google.com with SMTP id s143so53348166ywg.1
        for <linux-media@vger.kernel.org>; Thu, 10 Aug 2017 00:00:27 -0700 (PDT)
Received: from mail-yw0-f174.google.com (mail-yw0-f174.google.com. [209.85.161.174])
        by smtp.gmail.com with ESMTPSA id k132sm2005804ywb.43.2017.08.10.00.00.26
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Aug 2017 00:00:26 -0700 (PDT)
Received: by mail-yw0-f174.google.com with SMTP id u207so53376905ywc.3
        for <linux-media@vger.kernel.org>; Thu, 10 Aug 2017 00:00:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <47f8b8293a5ea31c2cec771398fbcdaf0f8fe808.1502315473.git.chiranjeevi.rapolu@intel.com>
References: <1502306262-30400-1-git-send-email-chiranjeevi.rapolu@intel.com> <47f8b8293a5ea31c2cec771398fbcdaf0f8fe808.1502315473.git.chiranjeevi.rapolu@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 10 Aug 2017 16:00:05 +0900
Message-ID: <CAAFQd5BwCxB7pDokX0qAuGaRoMLt8YV_e0-QPxafhee7iN4gTQ@mail.gmail.com>
Subject: Re: [PATCH v2] media: ov5670: Fix incorrect frame timing reported to user
To: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chiranjeevi,

On Thu, Aug 10, 2017 at 6:59 AM, Chiranjeevi Rapolu
<chiranjeevi.rapolu@intel.com> wrote:
> Previously, pixel-rate/(pixels-per-line * lines-per-frame) was
> yielding incorrect frame timing for the user.
>
> OV sensor is using internal timing and this requires
> conversion (internal timing -> PPL) for correct HBLANK calculation.
>
> Now, change pixels-per-line domain from internal sensor clock to
> pixels domain. Set HBLANK read-only because fixed PPL is used for all
> resolutions. And, use more accurate link-frequency 422.4MHz instead of
> rounding down to 420MHz.
>
> Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
> ---
> Changes in v2:
>         - Change subject to reflect frame timing info.
>         - Change OV5670_DEF_PPL so that it doesn't convey a register default
>           value. And, add more comments to it.
>  drivers/media/i2c/ov5670.c | 45 +++++++++++++++++++++++----------------------
>  1 file changed, 23 insertions(+), 22 deletions(-)

Okay, the numbers in this version finally make sense. Thanks for
figuring this out.

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
