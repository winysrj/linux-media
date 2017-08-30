Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36175 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbdH3Hum (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 03:50:42 -0400
Received: by mail-wm0-f50.google.com with SMTP id u126so4584727wmg.1
        for <linux-media@vger.kernel.org>; Wed, 30 Aug 2017 00:50:42 -0700 (PDT)
Date: Wed, 30 Aug 2017 09:50:35 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Brian Starkey <brian.starkey@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        jonathan.chai@arm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: DRM Format Modifiers in v4l2
Message-ID: <20170830075035.ojzhefm3ysqzigkg@phenom.ffwll.local>
References: <20170821155203.GB38943@e107564-lin.cambridge.arm.com>
 <CAKMK7uFdQPUomZDCp_ak6sTsUayZuut4us08defjKmiy=24QnA@mail.gmail.com>
 <47128f36-2990-bd45-ead9-06a31ed8cde0@xs4all.nl>
 <20170824111430.GB25711@e107564-lin.cambridge.arm.com>
 <ba202456-4bc6-733e-4950-88ce64ca990e@xs4all.nl>
 <20170824122647.GA28829@e107564-lin.cambridge.arm.com>
 <1503943642.3316.7.camel@ndufresne.ca>
 <CAKMK7uGaQ+9cZ2PyLkwC06Qpch3AK+Tkr4SZFZVLfUqUFKyygQ@mail.gmail.com>
 <20170829094701.GB26907@e107564-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829094701.GB26907@e107564-lin.cambridge.arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 29, 2017 at 10:47:01AM +0100, Brian Starkey wrote:
> On Mon, Aug 28, 2017 at 10:49:07PM +0200, Daniel Vetter wrote:
> > On Mon, Aug 28, 2017 at 8:07 PM, Nicolas Dufresne <nicolas@ndufresne.ca> wrote:
> > > Le jeudi 24 ao??t 2017 ?? 13:26 +0100, Brian Starkey a ??crit :
> > > > > What I mean was: an application can use the modifier to give buffers from
> > > > > one device to another without needing to understand it.
> > > > >
> > > > > But a generic video capture application that processes the video itself
> > > > > cannot be expected to know about the modifiers. It's a custom HW specific
> > > > > format that you only use between two HW devices or with software written
> > > > > for that hardware.
> > > > >
> > > > 
> > > > Yes, makes sense.
> > > > 
> > > > > >
> > > > > > However, in DRM the API lets you get the supported formats for each
> > > > > > modifier as-well-as the modifier list itself. I'm not sure how exactly
> > > > > > to provide that in a control.
> > > > >
> > > > > We have support for a 'menu' of 64 bit integers: V4L2_CTRL_TYPE_INTEGER_MENU.
> > > > > You use VIDIOC_QUERYMENU to enumerate the available modifiers.
> > > > >
> > > > > So enumerating these modifiers would work out-of-the-box.
> > > > 
> > > > Right. So I guess the supported set of formats could be somehow
> > > > enumerated in the menu item string. In DRM the pairs are (modifier +
> > > > bitmask) where bits represent formats in the supported formats list
> > > > (commit db1689aa61bd in drm-next). Printing a hex representation of
> > > > the bitmask would be functional but I concede not very pretty.
> > > 
> > > The problem is that the list of modifiers depends on the format
> > > selected. Having to call S_FMT to obtain this list is quite
> > > inefficient.
> > > 
> > > Also, be aware that DRM_FORMAT_MOD_SAMSUNG_64_32_TILE modifier has been
> > > implemented in V4L2 with a direct format (V4L2_PIX_FMT_NV12MT). I think
> > > an other one made it the same way recently, something from Mediatek if
> > > I remember. Though, unlike the Intel one, the same modifier does not
> > > have various result depending on the hardware revision.
> > 
> > Note on the intel modifers: On most recent platforms (iirc gen9) the
> > modifier is well defined and always describes the same byte layout. We
> > simply didn't want to rewrite our entire software stack for all the
> > old gunk platforms, hence the language. I guess we could/should
> > describe the layout in detail, but atm we're the only ones using it.
> > 
> > On your topic of v4l2 encoding the drm fourcc+modifier combo into a
> > special v4l fourcc: That's exactly the mismatch I was thinking of.
> > There's other examples of v4l2 fourcc being more specific than their
> > drm counters (e.g. specific way the different planes are laid out).
> 
> I'm not entirely clear on the v4l2 fourccs being more specific than
> DRM ones - do you mean e.g. NV12 vs NV12M? Specifically in the case of
> multi-planar formats I think it's a non-issue because modifiers are
> allowed to alter the number of planes and the meanings of them. Also
> V4L2 NV12M is a superset of NV12 - so NV12M would always be able to
> describe a DRM NV12 buffer.
> 
> I don't see the "special v4l2 format already exists" case as a problem
> either. It would be up to any drivers that already have special
> formats to decide if they want to also support it via a more generic
> modifiers API or not.
> 
> The fact is, adding special formats for each combination is
> unmanageable - we're talking dozens in the case of our hardware.

Hm right, we can just remap the special combos to the drm-fourcc +
modifier style. Bonus point if v4l does that in the core so not everyone
has to reinvent that wheel :-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
