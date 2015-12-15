Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:51863 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbbLOKmA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 05:42:00 -0500
Date: Tue, 15 Dec 2015 08:41:53 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v5 1/3] [media] media-device: check before unregister if
 mdev was registered
Message-ID: <20151215084153.1f54d561@recife.lan>
In-Reply-To: <566B5DFB.3020100@osg.samsung.com>
References: <1449874629-8973-1-git-send-email-javier@osg.samsung.com>
	<1449874629-8973-2-git-send-email-javier@osg.samsung.com>
	<566B5DFB.3020100@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 11 Dec 2015 16:36:27 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> On 12/11/2015 03:57 PM, Javier Martinez Canillas wrote:
> > Most media functions that unregister, check if the corresponding register
> > function succeed before. So these functions can safely be called even if a
> > registration was never made or the component as already been unregistered.
> > 
> > Add the same check to media_device_unregister() function for consistency.
> > 
> > This will also allow to split the media_device_register() function in an
> > initialization and registration functions without the need to change the
> > generic cleanup functions and error code paths for all the media drivers.
> > 
> > Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > ---
> > 
> > Changes in v5: None
> > Changes in v4: None
> > Changes in v3: None
> > Changes in v2:
> > - Reword the documentation for media_device_unregister(). Suggested by Sakari.
> > - Added Sakari's Acked-by tag for patch #1.
> > 
> >  drivers/media/media-device.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index c12481c753a0..11c1c7383361 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -577,6 +577,8 @@ EXPORT_SYMBOL_GPL(__media_device_register);
> >   * media_device_unregister - unregister a media device
> >   * @mdev:	The media device
> >   *
> > + * It is safe to call this function on an unregistered
> > + * (but initialised) media device.
> >   */
> >  void media_device_unregister(struct media_device *mdev)
> >  {
> > @@ -584,6 +586,10 @@ void media_device_unregister(struct media_device *mdev)
> >  	struct media_entity *next;
> >  	struct media_interface *intf, *tmp_intf;
> >  
> > +	/* Check if mdev was ever registered at all */
> > +	if (!media_devnode_is_registered(&mdev->devnode))
> > +		return;
> 
> This is a good check, however, this check will not prevent
> media_device_unregister() from getting run twice by two
> different drivers. i.e media_devnode gets unregistered
> towards the end of at the end of media_device_unregister().
> 
> In an example case, if bridge driver and snd-usb-aduio both
> call media_device_unregister(), this check won't help prevent
> media_device_unregister() being done only once. I think we
> need a different state variable in struct media_device
> to ensure unregister is done only once.

True. We need move the spin_lock() code to be called before
calling media_device_is_registered().

I'm sending such patches.

Thanks for reporting it.

Regards,
Mauro

