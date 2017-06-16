Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35688 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751869AbdFPWyw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 18:54:52 -0400
Received: by mail-qk0-f193.google.com with SMTP id j126so382909qkj.2
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 15:54:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1497478767-10270-10-git-send-email-yong.zhi@intel.com>
References: <1497478767-10270-1-git-send-email-yong.zhi@intel.com> <1497478767-10270-10-git-send-email-yong.zhi@intel.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 17 Jun 2017 01:54:51 +0300
Message-ID: <CAHp75VfK7qL5j+hDZj-QKcqf85_JiBDG7N8XET4a59Kfet5z1g@mail.gmail.com>
Subject: Re: [PATCH v2 09/12] intel-ipu3: css hardware setup
To: Yong Zhi <yong.zhi@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        sakari.ailus@linux.intel.com, jian.xu.zheng@intel.com,
        tfiga@chromium.org, Rajmohan Mani <rajmohan.mani@intel.com>,
        tuukka.toivonen@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 15, 2017 at 1:19 AM, Yong Zhi <yong.zhi@intel.com> wrote:

Commit message.

> Signed-off-by: Yong Zhi <yong.zhi@intel.com>

> +static void writes(void *mem, ssize_t len, void __iomem *reg)
> +{
> +       while (len >= 4) {
> +               writel(*(u32 *)mem, reg);
> +               mem += 4;
> +               reg += 4;
> +               len -= 4;
> +       }
> +}

Again, I just looked into patches and first what I see is reinventing the wheel.

memcpy_toio()

-- 
With Best Regards,
Andy Shevchenko
