Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45921 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751713AbdLSRRC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 12:17:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: Re: [PATCH 2/8] media: v4l2-ioctl.h: convert debug into an enum of bits
Date: Tue, 19 Dec 2017 19:17:12 +0200
Message-ID: <2448808.QM7caob540@avalon>
In-Reply-To: <20171219133758.6cf22460@vento.lan>
References: <cover.1513625884.git.mchehab@s-opensource.com> <20171219141235.mgiyoeeiyfn2z4zh@paasikivi.fi.intel.com> <20171219133758.6cf22460@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tuesday, 19 December 2017 17:37:58 EET Mauro Carvalho Chehab wrote:
> Em Tue, 19 Dec 2017 16:12:35 +0200 Sakari Ailus escreveu:
> > On Tue, Dec 19, 2017 at 04:02:02PM +0200, Laurent Pinchart wrote:
> >> And furthermore using enum types in the uAPI is a bad idea as the enum
> >> size is architecture-dependent. That's why we use integer types in
> >> structures used as ioctl arguments.
> > 
> > I guess we have an argeement on that, enums are a no-go for uAPI, for
> > reasons not related to the topic at hand.
> 
> Huh? We're not talking about uAPI. This is kAPI. Using enums there is OK.

Sure, there's no disagreement about that. The point was that, as both uAPI and 
kAPI should be documented, and we can't use enums for uAPI, we need a way to 
document non-enum types, which we could then use to document the kAPI the same 
way.

-- 
Regards,

Laurent Pinchart
