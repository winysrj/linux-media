Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:35841 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbdFQGcm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Jun 2017 02:32:42 -0400
Received: by mail-yw0-f176.google.com with SMTP id l75so26864676ywc.3
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 23:32:42 -0700 (PDT)
Received: from mail-yw0-f180.google.com (mail-yw0-f180.google.com. [209.85.161.180])
        by smtp.gmail.com with ESMTPSA id 203sm1827995ywk.62.2017.06.16.23.32.40
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Jun 2017 23:32:41 -0700 (PDT)
Received: by mail-yw0-f180.google.com with SMTP id v7so26844160ywc.2
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 23:32:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <C193D76D23A22742993887E6D207B54D079A0A0B@ORSMSX106.amr.corp.intel.com>
References: <1497478767-10270-1-git-send-email-yong.zhi@intel.com>
 <1497478767-10270-13-git-send-email-yong.zhi@intel.com> <CAHp75VdFnawkkE8Bhb8ZbzG2JmODw-a10_wOwSOpuNbTaN2BCA@mail.gmail.com>
 <C193D76D23A22742993887E6D207B54D079A0A0B@ORSMSX106.amr.corp.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Sat, 17 Jun 2017 15:32:20 +0900
Message-ID: <CAAFQd5A10VY3q0Q8Qxs3d3f99Y78_4YaC+9b+=c3fiogag_xfA@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] intel-ipu3: imgu top level pci device
To: "Zhi, Yong" <yong.zhi@intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 17, 2017 at 9:00 AM, Zhi, Yong <yong.zhi@intel.com> wrote:
> Hi, Andy,
>
>> -----Original Message-----
>> From: Andy Shevchenko [mailto:andy.shevchenko@gmail.com]
>> Sent: Friday, June 16, 2017 3:59 PM
>> To: Zhi, Yong <yong.zhi@intel.com>
>> Cc: Linux Media Mailing List <linux-media@vger.kernel.org>;
>> sakari.ailus@linux.intel.com; Zheng, Jian Xu <jian.xu.zheng@intel.com>;
>> tfiga@chromium.org; Mani, Rajmohan <rajmohan.mani@intel.com>;
>> Toivonen, Tuukka <tuukka.toivonen@intel.com>
>> Subject: Re: [PATCH v2 12/12] intel-ipu3: imgu top level pci device
>>
>> On Thu, Jun 15, 2017 at 1:19 AM, Yong Zhi <yong.zhi@intel.com> wrote:
>>
>> Commit message.
>>
>> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
>>
>> > +       /* Set Power */
>> > +       r =3D pm_runtime_get_sync(dev);
>> > +       if (r < 0) {
>> > +               dev_err(dev, "failed to set imgu power\n");
>>
>> > +               pm_runtime_put(dev);
>>
>> I'm not sure it's a right thing to do.
>> How did you test runtime PM counters in this case?
>>
>> > +               return r;
>> > +       }
>>
>
> Actually I have not tested the error case, what the right way to do in yo=
ur opinion? there is no checking of this function return in lot of the driv=
er code, or simply returning the error code, I also saw examples to call ei=
ther pm_runtime_put() or pm_runtime_put_noidle() in this case.

Instead of speculating, if we inspect pm_runtime_get_sync() [1], we
can see that it always causes the runtime PM counter to increment, but
it never decrements it, even in case of error. So to keep things
balanced, you need to call pm_runtime_put() in error path.

It shouldn't matter if it's pm_runtime_put() or
pm_runtime_put_noidle(), because of runtime PM semantics, which are
explicitly specified [2] that after an error, no hardware state change
is attempted until the state is explicitly reset by the driver with
either pm_runtime_set_active() or pm_runtime_set_suspended().

So, as far as I didn't miss some even more obscure bits of the runtime
PM framework, current code is fine.

[1] http://elixir.free-electrons.com/linux/v4.11.6/source/include/linux/pm_=
runtime.h#L235
and the main part:
http://elixir.free-electrons.com/linux/v4.11.6/source/drivers/base/power/ru=
ntime.c#L1027

[2] http://elixir.free-electrons.com/linux/v4.11.6/source/Documentation/pow=
er/runtime_pm.txt#L128

Best regards,
Tomasz
