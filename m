Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:33842 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbcHAUle (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2016 16:41:34 -0400
Received: by mail-lf0-f47.google.com with SMTP id l69so123932777lfg.1
        for <linux-media@vger.kernel.org>; Mon, 01 Aug 2016 13:41:33 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Mon, 1 Aug 2016 22:41:30 +0200
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 2/3] soc-camera/rcar-vin: remove obsolete driver
Message-ID: <20160801204130.GF3672@bigcity.dyn.berto.se>
References: <1470038065-30789-1-git-send-email-hverkuil@xs4all.nl>
 <1470038065-30789-3-git-send-email-hverkuil@xs4all.nl>
 <3585190.qMTDhgQKz3@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3585190.qMTDhgQKz3@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-08-01 11:31:11 +0300, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Monday 01 Aug 2016 09:54:24 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > This driver has been replaced by the non-soc-camera rcar-vin driver.
> > The soc-camera framework is being deprecated, so drop this older
> > rcar-vin driver in favor of the newer version that does not rely on
> > this deprecated framework.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Cc: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> I'm all for removal of dead code :-)
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> But please get Niklas' ack to confirm that the new driver supports all the 
> feature available in the old one.

I'm all for removing this code. And I do believe the new driver supports 
(almost, see 1) all features this one do. There are however two known 
issues with the new driver which maybe should be resolved before the old 
one is removed.

1. The soc-camera driver call g_std to determine video standard if field 
   is V4L2_FIELD_INTERLACED. The new driver dose not.

   I'm preparing a patch which restores this functionality and hope to 
   post it soon.

2. There is a error in the DT parsing code where of_node_put() is called 
   twice resulting in a nice backtrace while booting if the debug config 
   options are enabled.

   There is a fix for this in the Gen3 enablement series but maybe I 
   should break it out from there and post it separately?

I would like to solve issue no 1 before we remove the soc-camera driver, 
hopefully we can do so shortly.

> 
> > ---
> >  drivers/media/platform/soc_camera/Kconfig    |   10 -
> >  drivers/media/platform/soc_camera/Makefile   |    1 -
> >  drivers/media/platform/soc_camera/rcar_vin.c | 1970 -----------------------
> >  3 files changed, 1981 deletions(-)
> >  delete mode 100644 drivers/media/platform/soc_camera/rcar_vin.c
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
