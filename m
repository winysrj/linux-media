Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f174.google.com ([209.85.213.174]:36782 "EHLO
        mail-yb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752615AbdFNABc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 20:01:32 -0400
Received: by mail-yb0-f174.google.com with SMTP id t7so11984594yba.3
        for <linux-media@vger.kernel.org>; Tue, 13 Jun 2017 17:01:32 -0700 (PDT)
Received: from mail-yb0-f182.google.com (mail-yb0-f182.google.com. [209.85.213.182])
        by smtp.gmail.com with ESMTPSA id r133sm2170482ywg.25.2017.06.13.17.01.30
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Jun 2017 17:01:30 -0700 (PDT)
Received: by mail-yb0-f182.google.com with SMTP id t7so11984427yba.3
        for <linux-media@vger.kernel.org>; Tue, 13 Jun 2017 17:01:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1497385036-1002-4-git-send-email-yong.zhi@intel.com>
References: <1497385036-1002-1-git-send-email-yong.zhi@intel.com> <1497385036-1002-4-git-send-email-yong.zhi@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 14 Jun 2017 09:01:09 +0900
Message-ID: <CAAFQd5BQsha1K3pCGpfJiuuA5Uy_ZAVhDbbUJqAumXSGpV=sWQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] intel-ipu3: cio2: Add new MIPI-CSI2 driver
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>,
        "Mohandass, Divagar" <divagar.mohandass@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Wed, Jun 14, 2017 at 5:17 AM, Yong Zhi <yong.zhi@intel.com> wrote:
> This patch adds CIO2 CSI-2 device driver for
> Intel's IPU3 camera sub-system support.
>
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/media/pci/Kconfig                |    2 +
>  drivers/media/pci/Makefile               |    3 +-
>  drivers/media/pci/intel/Makefile         |    5 +
>  drivers/media/pci/intel/ipu3/Kconfig     |   17 +
>  drivers/media/pci/intel/ipu3/Makefile    |    1 +
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 1779 ++++++++++++++++++++++++++++++
>  drivers/media/pci/intel/ipu3/ipu3-cio2.h |  434 ++++++++
>  7 files changed, 2240 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/pci/intel/Makefile
>  create mode 100644 drivers/media/pci/intel/ipu3/Kconfig
>  create mode 100644 drivers/media/pci/intel/ipu3/Makefile
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.h
>

I quickly checked the code and it doesn't seem to have most of my
comments from v2 addressed. It's not a very good practice to send new
version without addressing or at least replying to all the comments -
it's the best way to lose track of necessary changes. Please make sure
that all the comments are taken care of.

Best regards,
Tomasz
