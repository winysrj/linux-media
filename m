Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37028 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751578AbdLSLja (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 06:39:30 -0500
Date: Tue, 19 Dec 2017 13:39:27 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: Re: [PATCH 2/8] media: v4l2-ioctl.h: convert debug into an enum of
 bits
Message-ID: <20171219113927.i2srypzhigkijetf@valkosipuli.retiisi.org.uk>
References: <cover.1513625884.git.mchehab@s-opensource.com>
 <333b63fa1857f6819ce64666beba969c22e2f468.1513625884.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <333b63fa1857f6819ce64666beba969c22e2f468.1513625884.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Dec 18, 2017 at 05:53:56PM -0200, Mauro Carvalho Chehab wrote:
> The V4L2_DEV_DEBUG_IOCTL macros actually define a bitmask,
> but without using Kernel's modern standards. Also,
> documentation looks akward.
> 
> So, convert them into an enum with valid bits, adding
> the correspoinding kernel-doc documentation for it.

The pattern of using bits for flags is a well established one and I
wouldn't deviate from that by requiring the use of the BIT() macro. There
are no benefits that I can see from here but the approach brings additional
risks: misuse of the flags and mimicing the same risky pattern.

I'd also like to echo Laurent's concern that code is being changed in odd
ways and not for itself, but due to deficiencies in documentation tools.

I believe the tooling has to be improved to address this properly. That
only needs to done once, compared to changing all flag definitions to
enums.

Another point I want to make is that the uAPI definitions cannot be
changed: enums are thus an option in kAPI only. Improved KernelDoc tools
would thus also allow improving uAPI macro documentation --- which is more
important anyway.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
