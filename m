Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:36031 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752410AbdFQIhM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Jun 2017 04:37:12 -0400
Received: by mail-qt0-f195.google.com with SMTP id s33so14142799qtg.3
        for <linux-media@vger.kernel.org>; Sat, 17 Jun 2017 01:37:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAFQd5A10VY3q0Q8Qxs3d3f99Y78_4YaC+9b+=c3fiogag_xfA@mail.gmail.com>
References: <1497478767-10270-1-git-send-email-yong.zhi@intel.com>
 <1497478767-10270-13-git-send-email-yong.zhi@intel.com> <CAHp75VdFnawkkE8Bhb8ZbzG2JmODw-a10_wOwSOpuNbTaN2BCA@mail.gmail.com>
 <C193D76D23A22742993887E6D207B54D079A0A0B@ORSMSX106.amr.corp.intel.com> <CAAFQd5A10VY3q0Q8Qxs3d3f99Y78_4YaC+9b+=c3fiogag_xfA@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 17 Jun 2017 11:37:11 +0300
Message-ID: <CAHp75VeryyZq4m9sc6AkGPSX4rYwW_EWnJ-YN6A=5Rb5y7uGYA@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] intel-ipu3: imgu top level pci device
To: Tomasz Figa <tfiga@chromium.org>
Cc: "Zhi, Yong" <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 17, 2017 at 9:32 AM, Tomasz Figa <tfiga@chromium.org> wrote:
> On Sat, Jun 17, 2017 at 9:00 AM, Zhi, Yong <yong.zhi@intel.com> wrote:
>>> On Thu, Jun 15, 2017 at 1:19 AM, Yong Zhi <yong.zhi@intel.com> wrote:

>>> > +       /* Set Power */
>>> > +       r =3D pm_runtime_get_sync(dev);
>>> > +       if (r < 0) {
>>> > +               dev_err(dev, "failed to set imgu power\n");
>>>
>>> > +               pm_runtime_put(dev);
>>>
>>> I'm not sure it's a right thing to do.
>>> How did you test runtime PM counters in this case?
>>>
>>> > +               return r;
>>> > +       }

>> Actually I have not tested the error case, what the right way to do in y=
our opinion? there is no checking of this function return in lot of the dri=
ver code, or simply returning the error code, I also saw examples to call e=
ither pm_runtime_put() or pm_runtime_put_noidle() in this case.
>
> Instead of speculating, if we inspect pm_runtime_get_sync() [1], we
> can see that it always causes the runtime PM counter to increment, but
> it never decrements it, even in case of error. So to keep things
> balanced, you need to call pm_runtime_put() in error path.
>
> It shouldn't matter if it's pm_runtime_put() or
> pm_runtime_put_noidle(), because of runtime PM semantics, which are
> explicitly specified [2] that after an error, no hardware state change
> is attempted until the state is explicitly reset by the driver with
> either pm_runtime_set_active() or pm_runtime_set_suspended().
>
> So, as far as I didn't miss some even more obscure bits of the runtime
> PM framework, current code is fine.

Indeed. Thanks for explanation. PM runtime is hard :-)
Previously I didn't meet (and actually never used) check for returning
code of pm_runtime_get*().

> [1] http://elixir.free-electrons.com/linux/v4.11.6/source/include/linux/p=
m_runtime.h#L235
> and the main part:
> http://elixir.free-electrons.com/linux/v4.11.6/source/drivers/base/power/=
runtime.c#L1027
>
> [2] http://elixir.free-electrons.com/linux/v4.11.6/source/Documentation/p=
ower/runtime_pm.txt#L128


--=20
With Best Regards,
Andy Shevchenko
