Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:44670 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752900AbbBBPcL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 10:32:11 -0500
Date: Mon, 2 Feb 2015 16:32:07 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
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
Message-ID: <20150202163207.6111bc5d@bbrezillon>
In-Reply-To: <20150202125755.5bf5ecc9.m.chehab@samsung.com>
References: <1420544615-18788-1-git-send-email-boris.brezillon@free-electrons.com>
	<20150202125755.5bf5ecc9.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, 02 Feb 2015 12:57:55 -0200
Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:

> Em Tue,  6 Jan 2015 12:43:35 +0100
> Boris Brezillon <boris.brezillon@free-electrons.com> escreveu:
> 
> > Add RGB444_1X12 and RGB565_1X16 format definitions and update the
> > documentation.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> > Hi Mauro, Sakari,
> > 
> > This patch has been rejected as 'Not Applicable'.
> > Is there anyting wrong in it ?
> 
> I was expecting that this patch would be merged together with the
> remaining series, via the DRM tree. That's basically why I gave
> my ack:
> 	https://lkml.org/lkml/2014/11/3/661
> 
> HINT: when a subsystem maintainer gives an ack, that likely means that
> he expects that the patch will be applied via some other tree.

My bad, I thought this would go into the media tree since this single
patch is not exactly related to a DRM feature (except the fact that I
was planning to use it in my DRM driver).
Actually, I didn't send it to the DRM maintainer or dri-devel ML in the
first place :-(.
Can you reconsider taking it in the media tree ?
I you can't, I'll ask Dave (just added him in Cc) to take it into the
DRM tree.

Thanks.

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
