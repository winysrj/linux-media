Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:42730 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751151AbeDPEa7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 00:30:59 -0400
Received: by mail-ua0-f175.google.com with SMTP id o34so9255741uae.9
        for <linux-media@vger.kernel.org>; Sun, 15 Apr 2018 21:30:59 -0700 (PDT)
Received: from mail-ua0-f169.google.com (mail-ua0-f169.google.com. [209.85.217.169])
        by smtp.gmail.com with ESMTPSA id x56sm2687755uax.8.2018.04.15.21.30.57
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Apr 2018 21:30:57 -0700 (PDT)
Received: by mail-ua0-f169.google.com with SMTP id u4so9249538uaf.10
        for <linux-media@vger.kernel.org>; Sun, 15 Apr 2018 21:30:57 -0700 (PDT)
MIME-Version: 1.0
References: <1523375324-27856-1-git-send-email-andy.yeh@intel.com>
 <1523375324-27856-3-git-send-email-andy.yeh@intel.com> <20180412085701.GJ20945@w540>
 <20180412095710.tqcpyix6sn772siw@paasikivi.fi.intel.com>
In-Reply-To: <20180412095710.tqcpyix6sn772siw@paasikivi.fi.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 16 Apr 2018 04:30:46 +0000
Message-ID: <CAAFQd5Dm6tNoC2VskAK6DDdm4WrRSe71XckmCtX7zFMpoTn_UQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v7 2/2] media: dw9807: Add dw9807 vcm driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: jacopo@jmondi.org, "Yeh, Andy" <andy.yeh@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org, Alan Chiang <alanx.chiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 12, 2018 at 6:57 PM Sakari Ailus <sakari.ailus@linux.intel.com>
wrote:

> Hi Jacopo,

> On Thu, Apr 12, 2018 at 10:57:01AM +0200, jacopo mondi wrote:
> ...
> > > +           if (MAX_RETRY == ++retry) {
> > > +                   dev_err(&client->dev,
> > > +                           "Cannot do the write operation because
VCM is busy\n");
> >
> > Nit: this is over 80 cols, it's fine, but I think you can really
> > shorten the error messag without losing context.

> dev_warn() or dev_info() might be more appropriate actually. Or even
> dev_dbg(). This isn't a grave problem; just a sign the user space is
trying
> to move the lens before it has reached its previous target position.

On the other hand, we print this only if we reach MAX_RETRY, which probably
means that the lens is stuck or some other unexpected failure.


> >
> > > +                   return -EIO;
> > > +           }
> > > +           usleep_range(DW9807_CTRL_DELAY_US, DW9807_CTRL_DELAY_US +
10);
> >
> > mmm, I wonder if a sleep range of 10usecs is really a strict
> > requirement. Have a look at Documentation/timers/timers-howto.txt.
> > With such a small range you're likely fire some unrequired interrupt.

> If the user is trying to tell where to move the lens next, no time should
> be wasted on waiting. It'd perhaps rather make sense to return an error
> (-EBUSY): the user application (as well as the application developer)
would
> know about the attempt to move the lens too fast and could take an
informed
> decision on what to do next. This could include changing the target
> position, waiting more or changing the program to adjust the 3A loop
> behaviour.

Actually, shouldn't we wait for the lens to finish moving after we set the
position? If we don't do it, we risk the userspace requesting a capture
with the lens still moving.

If "time wasted on waiting" is a concern here, userspace could as well just
have a separate thread for controlling the lens (as something that is
expected to take time due to physical limitations).

Best regards,
Tomasz
