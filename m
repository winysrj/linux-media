Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:44152 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751430AbeEKFi0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 01:38:26 -0400
Received: by mail-ua0-f193.google.com with SMTP id h15-v6so2853288uan.11
        for <linux-media@vger.kernel.org>; Thu, 10 May 2018 22:38:25 -0700 (PDT)
Received: from mail-vk0-f48.google.com (mail-vk0-f48.google.com. [209.85.213.48])
        by smtp.gmail.com with ESMTPSA id j191-v6sm406394vke.6.2018.05.10.22.38.23
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 May 2018 22:38:23 -0700 (PDT)
Received: by mail-vk0-f48.google.com with SMTP id 203-v6so2589518vka.12
        for <linux-media@vger.kernel.org>; Thu, 10 May 2018 22:38:23 -0700 (PDT)
MIME-Version: 1.0
References: <1524674415-11598-1-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1524674415-11598-1-git-send-email-yong.zhi@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 11 May 2018 14:38:12 +0900
Message-ID: <CAAFQd5Cg2tfs6m-eeXy3z92OBgMDxd49jJ80+KDbn=_vQiu1sw@mail.gmail.com>
Subject: Re: [PATCH] media: intel-ipu3: cio2: Handle IRQs until INT_STS is cleared
To: Yong Zhi <yong.zhi@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        Cao Bing Bu <bingbu.cao@intel.com>,
        "Yeh, Andy" <andy.yeh@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 26, 2018 at 1:39 AM Yong Zhi <yong.zhi@intel.com> wrote:

> From: Bingbu Cao <bingbu.cao@intel.com>

> Interrupt behavior shows that some time the frame end and frame start
> of next frame is unstable and can range from several to hundreds
> of micro-sec. In the case of ~10us, isr may not clear next sof interrupt
> status in single handling, which prevents new interrupts from coming.

> Fix this by handling all pending IRQs before exiting isr, so
> any abnormal behavior results from very short interrupt status
> changes is protected.

> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>   drivers/media/pci/intel/ipu3/ipu3-cio2.c | 32
++++++++++++++++++++++----------
>   1 file changed, 22 insertions(+), 10 deletions(-)

In case you're waiting for me with this one:

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
