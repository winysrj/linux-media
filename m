Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:34806 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727188AbeJCQDp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2018 12:03:45 -0400
Received: by mail-yw1-f67.google.com with SMTP id m129-v6so1996414ywc.1
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2018 02:16:13 -0700 (PDT)
Received: from mail-yw1-f41.google.com (mail-yw1-f41.google.com. [209.85.161.41])
        by smtp.gmail.com with ESMTPSA id q126-v6sm290145ywf.7.2018.10.03.02.16.11
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Oct 2018 02:16:11 -0700 (PDT)
Received: by mail-yw1-f41.google.com with SMTP id l79-v6so1982330ywc.7
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2018 02:16:11 -0700 (PDT)
MIME-Version: 1.0
References: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
 <20180925114802.ywbboqlfxe56qeei@laureti-dev> <20180925123031.b6ay5piaqymi7kht@paasikivi.fi.intel.com>
In-Reply-To: <20180925123031.b6ay5piaqymi7kht@paasikivi.fi.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 3 Oct 2018 18:15:58 +0900
Message-ID: <CAAFQd5AYaXfRCfOduZhDRoMLFSOGMSdjWZBtW0hUhBJcA-GYcA@mail.gmail.com>
Subject: Re: [PATCH 0/5] Add units to controls
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: helmut.grohne@intenta.de,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Cao Bing Bu <bingbu.cao@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Grant Grundler <grundler@chromium.org>,
        ping-chung.chen@intel.com, "Yeh, Andy" <andy.yeh@intel.com>,
        "Lai, Jim" <jim.lai@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        snawrocki@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 25, 2018 at 9:30 PM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
[snip]
> On Tue, Sep 25, 2018 at 01:48:02PM +0200, Helmut Grohne wrote:
> > On Tue, Sep 25, 2018 at 12:14:29PM +0200, Sakari Ailus wrote:
[snip]
> > > Regarding Ricardo's suggestion --- I was thinking of adding a control flag
> > > (yes, there are a few bits available) to tell how to round the value. The
> > > user could use the TRY_EXT_CTRLS IOCTL to figure out the next (or
> > > previous) control value by incrementing the current value and setting the
> > > appropriate flag. This is out of the scope of this set though.
> >
> > This approach sounds really useful to me. Having control over the
> > rounding would allow reading supported control values with reasonable
> > effort. With such an approach, a very sparsely populated control becomes
> > feasible and with integer64 controls that'd likely allow representing
> > most exponential controls with linear values. If going this route, I
> > don't see an application of V4L2_CTRL_FLAG_EXPONENTIAL.
>
> Yes, I think the flag can be dropped as I suggested.

Wouldn't that be just a duplicate of menu controls? Integer controls
are supposed to be described by min, max and step and any value
matching those should be valid.

Rather than introducing such tricky semantics, perhaps it would make
more sense to allow controls to be of different type, depending on the
driver? A driver that supports a contiguous range, would report the
control as INTEGER, while one that doesn't, would report it as
INTEGER_MENU.

Putting that aside, V4L2_CTRL_FLAG_EXPONENTIAL would actually make it
easier to enumerate the supported values to the userspace. Just one
QUERYCTRL would be needed, instead of 1 ioctl for each possible value.
(Although for the exponential case I wouldn't expect too many values
indeed...)

>
> >
> > Thus, I think that control over the rounding is tightly related to this
> > patchset and needs to be discussed together.
>
> It addresses some of the same problem area but the implementation is
> orthogonal to this.
>
> Providing that would probably make the base field less useful: the valid
> control values could be enumerated by the user using TRY_EXT_CTRLS without
> the need to tell the valid values are powers of e.g. two.
>
> I don't really have a strong opinion on that actually when it comes to the
> API itself. The imx208 driver could proceed to use linear relation between
> the control value and the digital gain. My worry is just the driver
> implementation: this may not be entirely trivial. There's still no way to
> address this problem in a generic way otherwise.

What's not trivial for the imx208 driver? It just registers an integer
control with a range from 0 to 4 and takes (1 << ctrl->val) as the
value for the hardware.

Best regards,
Tomasz
