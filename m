Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:36415 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbbBBPkr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 10:40:47 -0500
Date: Mon, 02 Feb 2015 13:40:39 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	linux-kernel@vger.kernel.org,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Dave Airlie <airlied@linux.ie>
Subject: Re: [RESEND PATCH v2] [media] Add RGB444_1X12 and RGB565_1X16 media
 bus formats
Message-id: <20150202134039.2257bc68.m.chehab@samsung.com>
In-reply-to: <20150202163207.6111bc5d@bbrezillon>
References: <1420544615-18788-1-git-send-email-boris.brezillon@free-electrons.com>
 <20150202125755.5bf5ecc9.m.chehab@samsung.com>
 <20150202163207.6111bc5d@bbrezillon>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 02 Feb 2015 16:32:07 +0100
Boris Brezillon <boris.brezillon@free-electrons.com> escreveu:

> Hi Mauro,
> 
> On Mon, 02 Feb 2015 12:57:55 -0200
> Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:
> 
> > Em Tue,  6 Jan 2015 12:43:35 +0100
> > Boris Brezillon <boris.brezillon@free-electrons.com> escreveu:
> > 
> > > Add RGB444_1X12 and RGB565_1X16 format definitions and update the
> > > documentation.
> > > 
> > > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > > Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > ---
> > > Hi Mauro, Sakari,
> > > 
> > > This patch has been rejected as 'Not Applicable'.
> > > Is there anyting wrong in it ?
> > 
> > I was expecting that this patch would be merged together with the
> > remaining series, via the DRM tree. That's basically why I gave
> > my ack:
> > 	https://lkml.org/lkml/2014/11/3/661
> > 
> > HINT: when a subsystem maintainer gives an ack, that likely means that
> > he expects that the patch will be applied via some other tree.
> 
> My bad, I thought this would go into the media tree since this single
> patch is not exactly related to a DRM feature (except the fact that I
> was planning to use it in my DRM driver).
> Actually, I didn't send it to the DRM maintainer or dri-devel ML in the
> first place :-(.
> Can you reconsider taking it in the media tree ?
> I you can't, I'll ask Dave (just added him in Cc) to take it into the
> DRM tree.

I really prefer if you submit this together with the DRM series.

We don't apply API changes at media, except if the API change is
needed by some driver that it is also submitted in the same series.

I don't mind applying it via media, but in this case, I'll apply
together with the remaining DRM drivers, and will require DRM
maintainer's ack. So, it is probably easier to just apply this 
change via the DRM subtree than the reverse.

Regards,
Mauro
