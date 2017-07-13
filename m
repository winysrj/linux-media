Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40954 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751079AbdGMIWC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 04:22:02 -0400
Date: Thu, 13 Jul 2017 11:21:57 +0300
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
Message-ID: <20170713082156.zbxnle22effcoarm@valkosipuli.retiisi.org.uk>
References: <1499730214-9005-1-git-send-email-yong.zhi@intel.com>
 <1499730214-9005-4-git-send-email-yong.zhi@intel.com>
 <20170711103343.qynz4rps7fsx36bc@valkosipuli.retiisi.org.uk>
 <C193D76D23A22742993887E6D207B54D1ADD7EFB@ORSMSX106.amr.corp.intel.com>
 <CAAFQd5CKwWoiEZo9rBy1P3ioGJyScr8iG5iDpq_M+Wem6YAS9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAFQd5CKwWoiEZo9rBy1P3ioGJyScr8iG5iDpq_M+Wem6YAS9g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz and Yong,

On Thu, Jul 13, 2017 at 01:51:18PM +0900, Tomasz Figa wrote:
> Hi Yong,
> 
> On Thu, Jul 13, 2017 at 8:20 AM, Zhi, Yong <yong.zhi@intel.com> wrote:
> > Hi, Sakari,
> >
> > Thanks for the time spent on code review, acks to all the comments, except two places:
> >
> >> +/* .complete() is called after all subdevices have been located */
> >> +static int cio2_notifier_complete(struct v4l2_async_notifier *notifier)
> >> +{
> >> +     struct cio2_device *cio2 = container_of(notifier, struct cio2_device,
> >> +                                             notifier);
> >> +     struct sensor_async_subdev *s_asd;
> >> +     struct fwnode_handle *fwn_remote, *fwn_endpt, *fwn_remote_endpt;
> >> +     struct cio2_queue *q;
> >> +     struct fwnode_endpoint remote_endpt;
> >> +     unsigned int i, pad;
> >> +     int ret;
> >> +
> >> +     for (i = 0; i < notifier->num_subdevs; i++) {
> >> +             s_asd = container_of(cio2->notifier.subdevs[i],
> >> +                                     struct sensor_async_subdev,
> >> +                                     asd);
> >> +
> >> +             fwn_remote = s_asd->asd.match.fwnode.fwnode;
> >> +             fwn_endpt = (struct fwnode_handle *)
> >> +                                     s_asd->vfwn_endpt.base.local_fwnode;
> >
> > Why do you need a cast?
> >
> > [YZ] With a cast results in compilation warning:
> 
> (I think you mean "without".)
> 
> >
> > drivers/media/pci/ipu3/ipu3-cio2.c:1298:13: warning: assignment discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
> >    fwn_endpt = /*(struct fwnode_handle *)*/
> 
> This is a sign that the code is doing something wrong (in this case
> probably trying to write to a const pointer), so casting just silences
> the unfixed error.

Indeed. The right thing to do would be to make fwn_endpt const.

In that case though I don't think that variable is really used for anything
useful; the same goes for remote_endpt and fwn_remote_endpt. This looks
like leftovers from development time.

Could these be removed, or did I miss something?

> 
> >
> >> +     ret = v4l2_async_notifier_register(&cio2->v4l2_dev, &cio2->notifier);
> >> +     if (ret) {
> >> +             cio2->notifier.num_subdevs = 0;
> >
> > No need to assign num_subdevs as 0.
> >
> > [YZ] _notifier_exit() will call _unregister() if this is not 0.
> 
> You shouldn't call _exit() if _init() failed. I noticed that many
> error paths in your code does this. Please fix it.

In general most functions that initialise and clean up something are
implemented so that the cleanup function can be called without calling the
corresponding init function. This eases driver implementation by reducing
complexity in error paths that are difficult to implement and test to begin
with, so I don't see anything wrong with that, quite the contrary.

I.e. in this case you should call v4l2_async_notifier_unregister() without
checking the number of async sub-devices.

There are exceptions to that though; not all the framework functions behave
this way. Of kernel APIs, e.g. kmalloc() and kfree() do this --- you can
pass a NULL pointer to kfree() and it does nothing.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
