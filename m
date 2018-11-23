Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:50030 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387633AbeKWVWZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 16:22:25 -0500
Date: Fri, 23 Nov 2018 11:38:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
cc: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCHv18 01/35] Documentation: v4l: document request API
In-Reply-To: <20181123075157.077758c0@coco.lan>
Message-ID: <alpine.DEB.2.21.1811231134100.2603@nanos.tec.linutronix.de>
References: <20180814142047.93856-1-hverkuil@xs4all.nl> <20180814142047.93856-2-hverkuil@xs4all.nl> <alpine.DEB.2.21.1811121048400.14703@nanos.tec.linutronix.de> <20181118115215.5ebc681c@coco.lan> <20181123075157.077758c0@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

On Fri, 23 Nov 2018, Mauro Carvalho Chehab wrote:
> > While we don't have it, we can't really use SPDX identifiers on media.
> > So, replace them by a license text.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > 
> > diff --git a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
> > index 0f8b31874002..60874a1f3d89 100644
> > --- a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
> > +++ b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
> > @@ -1,4 +1,15 @@
> > -.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
> > +.. SPDX License for this file: GPL-2.0 OR GFDL-1.1-or-later
> > +..
> > +.. For GPL-2.0, see LICENSES/preferred/GPL-2.0
> > +..
> > +.. For GFDL-1.1-or-later, see:
> > +..
> > +.. Permission is granted to copy, distribute and/or modify this document
> > +.. under the terms of the GNU Free Documentation License, Version 1.1 or
> > +.. any later version published by the Free Software Foundation, with no
> > +.. Invariant Sections, no Front-Cover Texts and no Back-Cover Texts.
> > +.. A copy of the license is included at
> > +.. Documentation/media/uapi/fdl-appendix.rst.

There is still an issue here.

The SPDX id for GFDL requires the license text to be in LICENSES/....

But the plain GFDL-1.1-or-later lacks the invariant/front/back parts which
are an exception to the license and require an exception ID along with the
corresponding file in LICENSES/..... again.

So no, this won't cut it. Please stay with free form license information
until this is resolved.

Kate, can you have a look into that please on the SPDX side?

Thanks,

	tglx
