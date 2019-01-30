Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D68C282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 09:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 348CC21873
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 09:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbfA3JW0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 04:22:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:59670 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728298AbfA3JW0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 04:22:26 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2019 01:22:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,540,1539673200"; 
   d="scan'208";a="140031004"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga004.fm.intel.com with ESMTP; 30 Jan 2019 01:22:24 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id D7213203F8; Wed, 30 Jan 2019 11:22:23 +0200 (EET)
Date:   Wed, 30 Jan 2019 11:22:23 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org, chiranjeevi.rapolu@intel.com
Subject: Re: [PATCH 1/1] uvc: Avoid NULL pointer dereference at the end of
 streaming
Message-ID: <20190130092223.xs3m3wo4rnadwnjm@paasikivi.fi.intel.com>
References: <20190129214944.16875-1-sakari.ailus@linux.intel.com>
 <20190130091737.GB4336@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190130091737.GB4336@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On Wed, Jan 30, 2019 at 11:17:37AM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Tue, Jan 29, 2019 at 11:49:44PM +0200, Sakari Ailus wrote:
> > The UVC video driver converts the timestamp from hardware specific unit to
> > one known by the kernel at the time when the buffer is dequeued. This is
> > fine in general, but the streamoff operation consists of the following
> > steps (among other things):
> > 
> > 1. uvc_video_clock_cleanup --- the hardware clock sample array is
> >    released and the pointer to the array is set to NULL,
> > 
> > 2. buffers in active state are returned to the user and
> > 
> > 3. buf_finish callback is called on buffers that are prepared. buf_finish
> >    includes calling uvc_video_clock_update that accesses the hardware
> >    clock sample array.
> > 
> > The above is serialised by a queue specific mutex. Address the problem by
> > skipping the clock conversion if the hardware clock sample array is
> > already released.
> > 
> > Reported-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
> > Tested-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> The analysis looks good to me.
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> > ---
> > Hi Laurent,
> > 
> > This seems like something that's been out there for a while... I'll figure
> > out soon which stable kernels should receive it, if any.
> 
> Should I wait for the proper Fixes: and Cc:stable tags before queuing
> this patch then ?

Please do. I'll figure these out in a moment...

> 
> >  drivers/media/usb/uvc/uvc_video.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> > index 84525ff047450..a30c5e1893e72 100644
> > --- a/drivers/media/usb/uvc/uvc_video.c
> > +++ b/drivers/media/usb/uvc/uvc_video.c
> > @@ -676,6 +676,13 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
> >  	if (!uvc_hw_timestamps_param)
> >  		return;
> >  
> > +	/*
> > +	 * We may get called if there are buffers done but not dequeued by the
> > +	 * user. Just bail out in that case.
> > +	 */
> > +	if (!clock->samples)
> > +		return;
> > +
> >  	spin_lock_irqsave(&clock->lock, flags);
> >  
> >  	if (clock->count < clock->size)

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
