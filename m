Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:35948 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbdFPWwp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 18:52:45 -0400
Received: by mail-qk0-f181.google.com with SMTP id g83so2038945qkb.3
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 15:52:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1497478767-10270-9-git-send-email-yong.zhi@intel.com>
References: <1497478767-10270-1-git-send-email-yong.zhi@intel.com> <1497478767-10270-9-git-send-email-yong.zhi@intel.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 17 Jun 2017 01:52:43 +0300
Message-ID: <CAHp75Vff3tQE4NdsLJDO=7b7_5O3XW360qxOw4nbeE3i+usvhQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/12] intel-ipu3: params: compute and program ccs
To: Yong Zhi <yong.zhi@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        sakari.ailus@linux.intel.com, jian.xu.zheng@intel.com,
        tfiga@chromium.org, Rajmohan Mani <rajmohan.mani@intel.com>,
        tuukka.toivonen@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 15, 2017 at 1:19 AM, Yong Zhi <yong.zhi@intel.com> wrote:
> A collection of routines that are mainly responsible
> to calculate the acc parameters.

> +static unsigned int ipu3_css_scaler_get_exp(unsigned int counter,
> +                                           unsigned int divider)
> +{
> +       unsigned int i = 0;
> +
> +       while (counter <= divider / 2) {
> +               divider /= 2;
> +               i++;
> +       }
> +
> +       return i;

We have a lot of different helpers including one you may use instead
of this function.

It's *highly* recommended you learn what we have under lib/ (and not
only there) in kernel bewfore submitting a new version.

-- 
With Best Regards,
Andy Shevchenko
