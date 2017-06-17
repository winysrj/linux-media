Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:33744 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752066AbdFQTGo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Jun 2017 15:06:44 -0400
Received: by mail-qk0-f193.google.com with SMTP id u8so2481973qka.0
        for <linux-media@vger.kernel.org>; Sat, 17 Jun 2017 12:06:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170617184348.GW12407@valkosipuli.retiisi.org.uk>
References: <1497478767-10270-1-git-send-email-yong.zhi@intel.com>
 <1497478767-10270-10-git-send-email-yong.zhi@intel.com> <CAHp75VfK7qL5j+hDZj-QKcqf85_JiBDG7N8XET4a59Kfet5z1g@mail.gmail.com>
 <20170617184348.GW12407@valkosipuli.retiisi.org.uk>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 17 Jun 2017 22:06:42 +0300
Message-ID: <CAHp75VcOnGuz5s1Y9ZU=Tgrz3wNHfG_APZbd=_HESpRm6BdAGg@mail.gmail.com>
Subject: Re: [PATCH v2 09/12] intel-ipu3: css hardware setup
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Yong Zhi <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        sakari.ailus@linux.intel.com,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Rajmohan Mani <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 17, 2017 at 9:43 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Sat, Jun 17, 2017 at 01:54:51AM +0300, Andy Shevchenko wrote:
>> On Thu, Jun 15, 2017 at 1:19 AM, Yong Zhi <yong.zhi@intel.com> wrote:

>> > +static void writes(void *mem, ssize_t len, void __iomem *reg)
>> > +{
>> > +       while (len >= 4) {
>> > +               writel(*(u32 *)mem, reg);
>> > +               mem += 4;
>> > +               reg += 4;
>> > +               len -= 4;
>> > +       }
>> > +}
>>
>> Again, I just looked into patches and first what I see is reinventing the wheel.
>>
>> memcpy_toio()

> That doesn't quite work: the hardware only supports 32-bit access.
>
> So the answer is writesl().

Makes sense!

-- 
With Best Regards,
Andy Shevchenko
