Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:36246 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750863AbdFPW6b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 18:58:31 -0400
Received: by mail-qk0-f174.google.com with SMTP id g83so2098992qkb.3
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 15:58:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1497478767-10270-13-git-send-email-yong.zhi@intel.com>
References: <1497478767-10270-1-git-send-email-yong.zhi@intel.com> <1497478767-10270-13-git-send-email-yong.zhi@intel.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 17 Jun 2017 01:58:30 +0300
Message-ID: <CAHp75VdFnawkkE8Bhb8ZbzG2JmODw-a10_wOwSOpuNbTaN2BCA@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] intel-ipu3: imgu top level pci device
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

> +       /* Set Power */
> +       r = pm_runtime_get_sync(dev);
> +       if (r < 0) {
> +               dev_err(dev, "failed to set imgu power\n");

> +               pm_runtime_put(dev);

I'm not sure it's a right thing to do.
How did you test runtime PM counters in this case?

> +               return r;
> +       }

-- 
With Best Regards,
Andy Shevchenko
