Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1443 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751084AbdLSOMk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 09:12:40 -0500
Date: Tue, 19 Dec 2017 16:12:35 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: Re: [PATCH 2/8] media: v4l2-ioctl.h: convert debug into an enum of
 bits
Message-ID: <20171219141235.mgiyoeeiyfn2z4zh@paasikivi.fi.intel.com>
References: <cover.1513625884.git.mchehab@s-opensource.com>
 <333b63fa1857f6819ce64666beba969c22e2f468.1513625884.git.mchehab@s-opensource.com>
 <20171219113927.i2srypzhigkijetf@valkosipuli.retiisi.org.uk>
 <1615432.c1z8s9p1mm@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615432.c1z8s9p1mm@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Dec 19, 2017 at 04:02:02PM +0200, Laurent Pinchart wrote:
> And furthermore using enum types in the uAPI is a bad idea as the enum size is 
> architecture-dependent. That's why we use integer types in structures used as 
> ioctl arguments.

I guess we have an argeement on that, enums are a no-go for uAPI, for
reasons not related to the topic at hand.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
