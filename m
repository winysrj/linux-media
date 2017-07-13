Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41300 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750977AbdGMIrd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 04:47:33 -0400
Date: Thu, 13 Jul 2017 11:47:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@chromium.org>
Cc: "Zhi, Yong" <yong.zhi@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>,
        "Vijaykumar, Ramya" <ramya.vijaykumar@intel.com>
Subject: Re: [PATCH v4 3/3] intel-ipu3: cio2: Add new MIPI-CSI2 driver
Message-ID: <20170713084728.xpcngwjnuv2rnfng@valkosipuli.retiisi.org.uk>
References: <1499730214-9005-1-git-send-email-yong.zhi@intel.com>
 <1499730214-9005-4-git-send-email-yong.zhi@intel.com>
 <20170711103343.qynz4rps7fsx36bc@valkosipuli.retiisi.org.uk>
 <C193D76D23A22742993887E6D207B54D1ADD7EFB@ORSMSX106.amr.corp.intel.com>
 <CAAFQd5CKwWoiEZo9rBy1P3ioGJyScr8iG5iDpq_M+Wem6YAS9g@mail.gmail.com>
 <20170713082156.zbxnle22effcoarm@valkosipuli.retiisi.org.uk>
 <CAAFQd5CN=AK8N6MkJSj8+KGbDEQMmsP=bZq4wyz22Bjb8Y3hmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5CN=AK8N6MkJSj8+KGbDEQMmsP=bZq4wyz22Bjb8Y3hmg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Thu, Jul 13, 2017 at 05:31:33PM +0900, Tomasz Figa wrote:
> On Thu, Jul 13, 2017 at 5:21 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> >> >> +     ret = v4l2_async_notifier_register(&cio2->v4l2_dev, &cio2->notifier);
> >> >> +     if (ret) {
> >> >> +             cio2->notifier.num_subdevs = 0;
> >> >
> >> > No need to assign num_subdevs as 0.
> >> >
> >> > [YZ] _notifier_exit() will call _unregister() if this is not 0.
> >>
> >> You shouldn't call _exit() if _init() failed. I noticed that many
> >> error paths in your code does this. Please fix it.
> >
> > In general most functions that initialise and clean up something are
> > implemented so that the cleanup function can be called without calling the
> > corresponding init function. This eases driver implementation by reducing
> > complexity in error paths that are difficult to implement and test to begin
> > with, so I don't see anything wrong with that, quite the contrary.
> >
> > I.e. in this case you should call v4l2_async_notifier_unregister() without
> > checking the number of async sub-devices.
> >
> > There are exceptions to that though; not all the framework functions behave
> > this way. Of kernel APIs, e.g. kmalloc() and kfree() do this --- you can
> > pass a NULL pointer to kfree() and it does nothing.
> 
> I'd argue that most of the cleanup paths I've seen in the kernel are
> the opposite. If you properly check for errors in your code, it's
> actually very unlikely that you need to call a cleanup function
> without the init function called... That said, I've seen the pattern
> you describe too, so probably either there is no strict rule or it's
> not strictly enforced. (Still, judging by
> https://www.kernel.org/doc/html/v4.10/process/coding-style.html#centralized-exiting-of-functions,
> which mentions "one err bugs" and suggests "to split it up into two
> error labels", the pattern I'm arguing for might be the recommended
> default.)

I don't really see a problem here; the another label in the example is
needed to avoid referencing a NULL pointer. If there's a reason to add a
label, then a label is just added. :-)

You could check foo as well under a single label. I'd say that approach
generally scales better: if you can handle a difference in error handling
locally in error handling code, this is easier to maintain and easier to
get right in complex error handling code (whereas the example is very
simple); spreading that knowledge over much of the function has the
opposite effect: it's easy to e.g. to go to a wrong label and there have
been plenty of such bugs in the past.

I think we're getting to fine details here. :-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
