Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51752 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab1BNNZh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 08:25:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: balbi@ti.com
Subject: Re: [PATCH v6 07/10] omap3isp: CCP2/CSI2 receivers
Date: Mon, 14 Feb 2011 14:25:41 +0100
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com> <1297686097-9804-8-git-send-email-laurent.pinchart@ideasonboard.com> <20110214123739.GZ2549@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110214123739.GZ2549@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102141425.42043.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Felipe,

On Monday 14 February 2011 13:37:39 Felipe Balbi wrote:
> On Mon, Feb 14, 2011 at 01:21:34PM +0100, Laurent Pinchart wrote:
> > The OMAP3 ISP CCP2 and CSI2 receivers provide an interface to connect
> > serial MIPI sensors to the device.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > Signed-off-by: David Cohen <dacohen@gmail.com>
> > Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> > Signed-off-by: Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
> > Signed-off-by: Tuukka Toivonen <tuukkat76@gmail.com>
> > Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> > Signed-off-by: Antti Koskipaa <akoskipa@gmail.com>
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > Signed-off-by: RaniSuneela <r-m@ti.com>
> > Signed-off-by: Atanas Filipov <afilipov@mm-sol.com>
> > Signed-off-by: Gjorgji Rosikopulos <grosikopulos@mm-sol.com>
> > Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
> > Signed-off-by: Nayden Kanchev <nkanchev@mm-sol.com>
> > Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> > Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> > Signed-off-by: Dominic Curran <dcurran@ti.com>
> > Signed-off-by: Ilkka Myllyperkio <ilkka.myllyperkio@sofica.fi>
> > Signed-off-by: Pallavi Kulkarni <p-kulkarni@ti.com>
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> checkpatch still complains a bit about this one:
> 
> CHECK: struct mutex definition without comment
> #1368: FILE: drivers/media/video/omap3-isp/ispqueue.h:157:
> +	struct mutex lock;
> 
> CHECK: spinlock_t definition without comment
> #1369: FILE: drivers/media/video/omap3-isp/ispqueue.h:158:
> +	spinlock_t irqlock;
> 
> WARNING: please, no space before tabs
> #2723: FILE: drivers/media/video/omap3-isp/ispvideo.h:49:
> + * ^Ibits. Identical to @code if the format is 10 bits wide or less.$
> 
> WARNING: please, no space before tabs
> #2725: FILE: drivers/media/video/omap3-isp/ispvideo.h:51:
> + * ^Iformat. Identical to @code if the format is not DPCM compressed.$
> 
> CHECK: spinlock_t definition without comment
> #2762: FILE: drivers/media/video/omap3-isp/ispvideo.h:88:
> +	spinlock_t lock;
> 
> CHECK: struct mutex definition without comment
> #2823: FILE: drivers/media/video/omap3-isp/ispvideo.h:149:
> +	struct mutex mutex;
> 
> CHECK: struct mutex definition without comment
> #2840: FILE: drivers/media/video/omap3-isp/ispvideo.h:166:
> +	struct mutex stream_lock;
> 
> total: 0 errors, 2 warnings, 5 checks, 2806 lines checked
> 
> /home/balbi/tst.diff has style problems, please review.  If any of these
> errors are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> 
> does it make sense to fix those ?

I guess it does :-) I'll fix them.

-- 
Regards,

Laurent Pinchart
