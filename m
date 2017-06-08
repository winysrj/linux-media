Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:33028 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751450AbdFHIaL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 04:30:11 -0400
Received: by mail-yw0-f171.google.com with SMTP id 63so10734331ywr.0
        for <linux-media@vger.kernel.org>; Thu, 08 Jun 2017 01:30:10 -0700 (PDT)
Received: from mail-yw0-f176.google.com (mail-yw0-f176.google.com. [209.85.161.176])
        by smtp.gmail.com with ESMTPSA id t14sm2160391ywf.32.2017.06.08.01.30.09
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Jun 2017 01:30:09 -0700 (PDT)
Received: by mail-yw0-f176.google.com with SMTP id e142so2692714ywa.1
        for <linux-media@vger.kernel.org>; Thu, 08 Jun 2017 01:30:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1496695157-19926-6-git-send-email-yong.zhi@intel.com>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com> <1496695157-19926-6-git-send-email-yong.zhi@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 8 Jun 2017 17:29:48 +0900
Message-ID: <CAAFQd5BH-MwPBdsJEmz1-fF3W0rQ5HwSbHWuu24RSeP7EjhR5Q@mail.gmail.com>
Subject: Re: [PATCH 05/12] intel-ipu3: css: tables
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Tue, Jun 6, 2017 at 5:39 AM, Yong Zhi <yong.zhi@intel.com> wrote:
> Coeff, config parameters etc const definitions for
> IPU3 programming.
>
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-tables.c | 9621 ++++++++++++++++++++++++++++
>  drivers/media/pci/intel/ipu3/ipu3-tables.h |   82 +
>  2 files changed, 9703 insertions(+)
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-tables.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-tables.h

I wonder if this patch really reached the mailing list. It seems to
not be present on patchwork.linuxtv.org. Possibly due to size
restrictions.

Best regards,
Tomasz
