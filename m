Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31941 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753419AbdKXJRT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 04:17:19 -0500
Date: Fri, 24 Nov 2017 11:17:16 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Jacob Chen <jacob-chen@iotwrt.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: notifier is skipped in some situations
Message-ID: <20171124091716.jasz6rkusazcwhpd@paasikivi.fi.intel.com>
References: <CAFLEztQg2R0oLcSfRKsQGFWTC1pTzPVqoksdKtGAYEYV6nAf9A@mail.gmail.com>
 <20171124085511.pehj5kwvykpzc25a@paasikivi.fi.intel.com>
 <CAAFQd5DowE=EdLkTi3q02hcKr_tr7GqKOZbKGYaz6uvvzEACHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5DowE=EdLkTi3q02hcKr_tr7GqKOZbKGYaz6uvvzEACHw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Fri, Nov 24, 2017 at 06:03:26PM +0900, Tomasz Figa wrote:
> Hi Sakari,
> 
> We have the following graph:
> 
>     ISP (registers notifier for v4l2_dev)
> 
>      |
> 
>     PHY (registers notifier for v4l2_subdev, just like sensors for
> flash/focuser)
> 
>   |       \
> 
> sensor0   sensor1
> 
> ...
> 
> Both ISP and PHY are completely separate drivers not directly aware of
> each other, since we have several different PHY IP blocks that we need
> to support and some of them are multi-functional, such as CSI+DSI PHY
> and need to be supported by drivers independent from the ISP driver.

That should work fine. In the above case there are two notifiers, indeed,
but they're not expecting the *same* sub-devices.

What this could be about is that in some version of the set I disabled the
complete callback on the sub-notifiers for two reasons: there was no need
seen for them and the complete callback is problematic in general (there's
been discussion on that, mostly related to earlier versions of the fwnode
parsing patchset, on #v4l and along the Renesas rcar-csi2 patchsets).

> 
> Best regards,
> Tomasz
> 
> 
> On Fri, Nov 24, 2017 at 5:55 PM, Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> > Hi Jacob,
> >
> > On Fri, Nov 24, 2017 at 09:00:14AM +0800, Jacob Chen wrote:
> >> Hi Sakari,
> >>
> >> I encountered a problem when using async sub-notifiers.
> >>
> >> It's like that:
> >>     There are two notifiers, and they are waiting for one subdev.
> >>     When this subdev is probing, only one notifier is completed and
> >> the other one is skipped.
> >
> > Do you have a graph that has two master drivers (that register the
> > notifier) and both are connected to the same sub-device? Could you provide
> > exact graph you have?
> >
> >>
> >> I found that in v15 of patch "v4l: async: Allow binding notifiers to
> >> sub-devices", "v4l2_async_notifier_complete" is replaced by
> >> v4l2_async_notifier_call_complete, which make it only complete one
> >> notifier.
> >>
> >> Why is it changed? Can this be fixed?
> >
> > --
> > Sakari Ailus
> > sakari.ailus@linux.intel.com

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
