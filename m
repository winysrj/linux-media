Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63636 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751026AbdLSPiG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 10:38:06 -0500
Date: Tue, 19 Dec 2017 13:37:58 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
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
Message-ID: <20171219133758.6cf22460@vento.lan>
In-Reply-To: <20171219141235.mgiyoeeiyfn2z4zh@paasikivi.fi.intel.com>
References: <cover.1513625884.git.mchehab@s-opensource.com>
        <333b63fa1857f6819ce64666beba969c22e2f468.1513625884.git.mchehab@s-opensource.com>
        <20171219113927.i2srypzhigkijetf@valkosipuli.retiisi.org.uk>
        <1615432.c1z8s9p1mm@avalon>
        <20171219141235.mgiyoeeiyfn2z4zh@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 Dec 2017 16:12:35 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi Laurent,
> 
> On Tue, Dec 19, 2017 at 04:02:02PM +0200, Laurent Pinchart wrote:
> > And furthermore using enum types in the uAPI is a bad idea as the enum size is 
> > architecture-dependent. That's why we use integer types in structures used as 
> > ioctl arguments.  
> 
> I guess we have an argeement on that, enums are a no-go for uAPI, for
> reasons not related to the topic at hand.

Huh? We're not talking about uAPI. This is kAPI. Using enums there is OK.

Thanks,
Mauro
