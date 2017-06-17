Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40188 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752298AbdFQSqR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Jun 2017 14:46:17 -0400
Date: Sat, 17 Jun 2017 21:45:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Tomasz Figa <tfiga@chromium.org>, "Zhi, Yong" <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Subject: Re: [PATCH v2 12/12] intel-ipu3: imgu top level pci device
Message-ID: <20170617184543.GX12407@valkosipuli.retiisi.org.uk>
References: <1497478767-10270-1-git-send-email-yong.zhi@intel.com>
 <1497478767-10270-13-git-send-email-yong.zhi@intel.com>
 <CAHp75VdFnawkkE8Bhb8ZbzG2JmODw-a10_wOwSOpuNbTaN2BCA@mail.gmail.com>
 <C193D76D23A22742993887E6D207B54D079A0A0B@ORSMSX106.amr.corp.intel.com>
 <CAAFQd5A10VY3q0Q8Qxs3d3f99Y78_4YaC+9b+=c3fiogag_xfA@mail.gmail.com>
 <CAHp75VeryyZq4m9sc6AkGPSX4rYwW_EWnJ-YN6A=5Rb5y7uGYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VeryyZq4m9sc6AkGPSX4rYwW_EWnJ-YN6A=5Rb5y7uGYA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 17, 2017 at 11:37:11AM +0300, Andy Shevchenko wrote:
> On Sat, Jun 17, 2017 at 9:32 AM, Tomasz Figa <tfiga@chromium.org> wrote:
> > On Sat, Jun 17, 2017 at 9:00 AM, Zhi, Yong <yong.zhi@intel.com> wrote:
> >>> On Thu, Jun 15, 2017 at 1:19 AM, Yong Zhi <yong.zhi@intel.com> wrote:
> 
> >>> > +       /* Set Power */
> >>> > +       r = pm_runtime_get_sync(dev);
> >>> > +       if (r < 0) {
> >>> > +               dev_err(dev, "failed to set imgu power\n");
> >>>
> >>> > +               pm_runtime_put(dev);
> >>>
> >>> I'm not sure it's a right thing to do.
> >>> How did you test runtime PM counters in this case?
> >>>
> >>> > +               return r;
> >>> > +       }
> 
> >> Actually I have not tested the error case, what the right way to do in your opinion? there is no checking of this function return in lot of the driver code, or simply returning the error code, I also saw examples to call either pm_runtime_put() or pm_runtime_put_noidle() in this case.
> >
> > Instead of speculating, if we inspect pm_runtime_get_sync() [1], we
> > can see that it always causes the runtime PM counter to increment, but
> > it never decrements it, even in case of error. So to keep things
> > balanced, you need to call pm_runtime_put() in error path.
> >
> > It shouldn't matter if it's pm_runtime_put() or
> > pm_runtime_put_noidle(), because of runtime PM semantics, which are
> > explicitly specified [2] that after an error, no hardware state change
> > is attempted until the state is explicitly reset by the driver with
> > either pm_runtime_set_active() or pm_runtime_set_suspended().
> >
> > So, as far as I didn't miss some even more obscure bits of the runtime
> > PM framework, current code is fine.
> 
> Indeed. Thanks for explanation. PM runtime is hard :-)
> Previously I didn't meet (and actually never used) check for returning
> code of pm_runtime_get*().

Yeah, depending on what is actually done it might fail.

pm_runtime_put() isn't wrong but pn_runtime_put_noidle() is sufficient:
powering the device on just failed so it's already off.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
