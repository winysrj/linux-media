Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:42118 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbeJLMV6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 08:21:58 -0400
Received: by mail-yb1-f196.google.com with SMTP id p74-v6so4489594ybc.9
        for <linux-media@vger.kernel.org>; Thu, 11 Oct 2018 21:51:23 -0700 (PDT)
MIME-Version: 1.0
References: <1537929738-27745-1-git-send-email-bingbu.cao@intel.com>
In-Reply-To: <1537929738-27745-1-git-send-email-bingbu.cao@intel.com>
From: Tomasz Figa <tfiga@google.com>
Date: Fri, 12 Oct 2018 13:51:10 +0900
Message-ID: <CAAFQd5Cv1r_d01ZM2z4wwyGNtrgXnfVivGXxqoVO5eiCQhPauQ@mail.gmail.com>
Subject: Re: [PATCH v7] media: add imx319 camera sensor driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Cao Bing Bu <bingbu.cao@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        bingbu.cao@linux.intel.com,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Rapolu, Chiranjeevi" <chiranjeevi.rapolu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wed, Sep 26, 2018 at 11:38 AM <bingbu.cao@intel.com> wrote:
>
> From: Bingbu Cao <bingbu.cao@intel.com>
>
> Add a v4l2 sub-device driver for the Sony imx319 image sensor.
> This is a camera sensor using the i2c bus for control and the
> csi-2 bus for data.
>
> This driver supports following features:
> - manual exposure and analog/digital gain control support
> - vblank/hblank control support
> -  4 test patterns control support
> - vflip/hflip control support (will impact the output bayer order)
> - support following resolutions:
>     - 3264x2448, 3280x2464 @ 30fps
>     - 1936x1096, 1920x1080 @ 60fps
>     - 1640x1232, 1640x922, 1296x736, 1280x720 @ 120fps
> - support 4 bayer orders output (via change v/hflip)
>     - SRGGB10(default), SGRBG10, SGBRG10, SBGGR10
>
> Cc: Tomasz Figa <tfiga@chromium.org>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
>
> ---
>
> This patch is based on sakari's media-tree git:
> https://git.linuxtv.org/sailus/media_tree.git/log/?h=for-4.20-1
>
> Changes from v5:
>  - add some comments for gain calculation
>  - use lock to protect the format
>  - fix some style issues
>
> Changes from v4 to v5:
>  - use single PLL for all internal clocks
>  - change link frequency to 482.4MHz
>  - adjust frame timing for 2x2 binning modes
>    and enlarge frame readout time
>  - get CSI-2 link frequencies and external clock
>    from firmware

If I remember correctly, that was suggested by you. Why do we need to
specify link frequency in firmware if it's fully configured by the
driver, with the only external dependency being the external clock?

We're having problems with firmware listing the link frequency from v4
and we can't easily change it anymore to report the new one. I feel
like this dependency on the firmware here is unnecessary, as long as
the external clock frequency matches.

Best regards,
Tomasz
