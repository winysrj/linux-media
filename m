Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:33753 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbZKTOdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 09:33:06 -0500
From: "Y, Kishore" <kishore.y@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Fri, 20 Nov 2009 20:03:08 +0530
Subject: RE: [PATCH] V4L2: clear buf when vrfb buf not allocated
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E94025433108C@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E7394043702BAA3@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Hiremath, Vaibhav
> Sent: Wednesday, November 18, 2009 8:44 PM
> To: Y, Kishore; linux-media@vger.kernel.org
> Cc: linux-omap@vger.kernel.org
> Subject: RE: [PATCH] V4L2: clear buf when vrfb buf not allocated
> 
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Y, Kishore
> > Sent: Wednesday, November 18, 2009 7:20 PM
> > To: linux-media@vger.kernel.org
> > Cc: linux-omap@vger.kernel.org
> > Subject: [PATCH] V4L2: clear buf when vrfb buf not allocated
> >
> > From 15246e4dfa6853d9aef48a4b8633f93efe40ed81 Mon Sep 17 00:00:00
> > 2001
> > From: Kishore Y <kishore.y@ti.com>
> > Date: Thu, 12 Nov 2009 20:47:58 +0530
> > Subject: [PATCH] V4L2: clear buf when vrfb buf not allocated
> >
> > 	buffer memory is set to 0 only for the first time
> > before the vrfb buffer is allocated
> >
> > Signed-off-by:  Kishore Y <kishore.y@ti.com>
> > ---
> > This patch is dependent on the patch
> > [PATCH 4/4] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver on top
> > of DSS2
> >
> >  drivers/media/video/omap/omap_vout.c |   10 +++++++---
> >  1 files changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/media/video/omap/omap_vout.c
> > b/drivers/media/video/omap/omap_vout.c
> > index 7092ef2..0a9fdd7 100644
> > --- a/drivers/media/video/omap/omap_vout.c
> > +++ b/drivers/media/video/omap/omap_vout.c
> > @@ -223,9 +223,11 @@ static int
> > omap_vout_allocate_vrfb_buffers(struct omap_vout_device *vout,
> >  		unsigned int *count, int startindex)
> >  {
> >  	int i, j;
> > +	int buffer_set;
> >
> >  	for (i = 0; i < *count; i++) {
> > -		if (!vout->smsshado_virt_addr[i]) {
> > +		buffer_set = vout->smsshado_virt_addr[i];
> > +		if (!buffer_set) {
> >  			vout->smsshado_virt_addr[i] =
> >  				omap_vout_alloc_buffer(vout->smsshado_size,
> >  						&vout->smsshado_phy_addr[i]);
> > @@ -247,8 +249,10 @@ static int
> > omap_vout_allocate_vrfb_buffers(struct omap_vout_device *vout,
> >  			*count = 0;
> >  			return -ENOMEM;
> >  		}
> > -		memset((void *) vout->smsshado_virt_addr[i], 0,
> > -				vout->smsshado_size);
> > +		if (!buffer_set) {
> > +			memset((void *) vout->smsshado_virt_addr[i], 0,
> > +					vout->smsshado_size);
> > +		}
> >  	}
> [Hiremath, Vaibhav] Why do we need this? Anyway if I understand correctly
> this function is getting called only once during REQBUF or probe, right?
> 
> If you are selecting static_vrfb_allocation through module_params, then
> anyway REQBUF won't call this function again, since the buffers are
> already allocated.
> 
> Thanks,
> Vaibhav
> 

[Kishore] omap_vout_vrfb_buffer_setup has been called from streamon to support stop-restart use case without calling REQBUF again. Due to the clear buffer we are unable to fill buffer in time before display and see green frame for the first time when streaming video.

> >  	return 0;
> >  }
> > --
> > 1.5.4.3
> >
> >
> > Regards,
> > Kishore Y
> > Ph:- +918039813085
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> > media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

