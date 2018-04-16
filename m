Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:58600 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754381AbeDPJuD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 05:50:03 -0400
Date: Mon, 16 Apr 2018 12:49:59 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: jacopo@jmondi.org, "Yeh, Andy" <andy.yeh@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org, Alan Chiang <alanx.chiang@intel.com>
Subject: Re: [RESEND PATCH v7 2/2] media: dw9807: Add dw9807 vcm driver
Message-ID: <20180416094959.izqxmwecnffunmb4@paasikivi.fi.intel.com>
References: <1523375324-27856-1-git-send-email-andy.yeh@intel.com>
 <1523375324-27856-3-git-send-email-andy.yeh@intel.com>
 <20180412085701.GJ20945@w540>
 <20180412095710.tqcpyix6sn772siw@paasikivi.fi.intel.com>
 <CAAFQd5Dm6tNoC2VskAK6DDdm4WrRSe71XckmCtX7zFMpoTn_UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5Dm6tNoC2VskAK6DDdm4WrRSe71XckmCtX7zFMpoTn_UQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 16, 2018 at 04:30:46AM +0000, Tomasz Figa wrote:
> On Thu, Apr 12, 2018 at 6:57 PM Sakari Ailus <sakari.ailus@linux.intel.com>
> wrote:
> 
> > Hi Jacopo,
> 
> > On Thu, Apr 12, 2018 at 10:57:01AM +0200, jacopo mondi wrote:
> > ...
> > > > +           if (MAX_RETRY == ++retry) {
> > > > +                   dev_err(&client->dev,
> > > > +                           "Cannot do the write operation because
> VCM is busy\n");
> > >
> > > Nit: this is over 80 cols, it's fine, but I think you can really
> > > shorten the error messag without losing context.
> 
> > dev_warn() or dev_info() might be more appropriate actually. Or even
> > dev_dbg(). This isn't a grave problem; just a sign the user space is
> trying
> > to move the lens before it has reached its previous target position.
> 
> On the other hand, we print this only if we reach MAX_RETRY, which probably
> means that the lens is stuck or some other unexpected failure.

MAX_RETRY is only ten, so I'd expect you could hit this if you're tring to
move the lens again very quickly. It usually takes several ms (but could
well be more than 10 ms) to reach the target position. This depends on the
lens and the driver, too, and I don't know the properties of this driver
(nor the lens).

> 
> 
> > >
> > > > +                   return -EIO;
> > > > +           }
> > > > +           usleep_range(DW9807_CTRL_DELAY_US, DW9807_CTRL_DELAY_US +
> 10);
> > >
> > > mmm, I wonder if a sleep range of 10usecs is really a strict
> > > requirement. Have a look at Documentation/timers/timers-howto.txt.
> > > With such a small range you're likely fire some unrequired interrupt.
> 
> > If the user is trying to tell where to move the lens next, no time should
> > be wasted on waiting. It'd perhaps rather make sense to return an error
> > (-EBUSY): the user application (as well as the application developer)
> would
> > know about the attempt to move the lens too fast and could take an
> informed
> > decision on what to do next. This could include changing the target
> > position, waiting more or changing the program to adjust the 3A loop
> > behaviour.
> 
> Actually, shouldn't we wait for the lens to finish moving after we set the
> position? If we don't do it, we risk the userspace requesting a capture
> with the lens still moving.

For that purpose I'd add a new control. The user process shouldn't wait in
the kernel for just the sake of this. In order to meaningfully control the
focussing process, the user space would have to know some properties of the
lens anyway, so this information would primarily be useful for checking
things are working out as expected.

> 
> If "time wasted on waiting" is a concern here, userspace could as well just
> have a separate thread for controlling the lens (as something that is
> expected to take time due to physical limitations).

That's up to the user space implementation.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
