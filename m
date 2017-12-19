Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44036 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753108AbdLSOFg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 09:05:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: Re: [PATCH 2/8] media: v4l2-ioctl.h: convert debug into an enum of bits
Date: Tue, 19 Dec 2017 16:05:46 +0200
Message-ID: <1829332.DyU8Vvd1sp@avalon>
In-Reply-To: <1615432.c1z8s9p1mm@avalon>
References: <cover.1513625884.git.mchehab@s-opensource.com> <20171219113927.i2srypzhigkijetf@valkosipuli.retiisi.org.uk> <1615432.c1z8s9p1mm@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, 19 December 2017 16:02:02 EET Laurent Pinchart wrote:
> On Tuesday, 19 December 2017 13:39:27 EET Sakari Ailus wrote:
> > Hi Mauro,
> > 
> > On Mon, Dec 18, 2017 at 05:53:56PM -0200, Mauro Carvalho Chehab wrote:
> > > The V4L2_DEV_DEBUG_IOCTL macros actually define a bitmask,
> > > but without using Kernel's modern standards. Also,
> > > documentation looks akward.
> > > 
> > > So, convert them into an enum with valid bits, adding
> > > the correspoinding kernel-doc documentation for it.
> > 
> > The pattern of using bits for flags is a well established one and I
> > wouldn't deviate from that by requiring the use of the BIT() macro. There
> > are no benefits that I can see from here but the approach brings
> > additional
> > risks: misuse of the flags and mimicing the same risky pattern.
> > 
> > I'd also like to echo Laurent's concern that code is being changed in odd
> > ways and not for itself, but due to deficiencies in documentation tools.
> > 
> > I believe the tooling has to be improved to address this properly. That
> > only needs to done once, compared to changing all flag definitions to
> > enums.
> 
> That's my main concern too. We really must not sacrifice code readability or
> writing ease in order to work around limitations of the documentation
> system. For this reason I'm strongly opposed to patches 2 and 5 in this
> series.

And I forgot to mention patch 8/8. Let's drop those three and improve the 
documentation system instead.

> > Another point I want to make is that the uAPI definitions cannot be
> > changed: enums are thus an option in kAPI only.
> 
> And furthermore using enum types in the uAPI is a bad idea as the enum size
> is architecture-dependent. That's why we use integer types in structures
> used as ioctl arguments.
> 
> > Improved KernelDoc tools would thus also allow improving uAPI macro
> > documentation --- which is more important anyway.

-- 
Regards,

Laurent Pinchart
