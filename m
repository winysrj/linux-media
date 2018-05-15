Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34351 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752265AbeEOP7E (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 11:59:04 -0400
Message-ID: <1526399190.31771.2.camel@suse.com>
Subject: Re: [PATCH] [Patch v2] usbtv: Fix refcounting mixup
From: Oliver Neukum <oneukum@suse.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, ben.hutchings@codethink.co.uk,
        gregkh@linuxfoundation.org, mchehab@s-opensource.com,
        linux-media@vger.kernel.org
Cc: stable@vger.kernel.org
In-Reply-To: <85dd974b-c251-47a5-600d-77b009e2dfcd@xs4all.nl>
References: <20180515130744.19342-1-oneukum@suse.com>
         <85dd974b-c251-47a5-600d-77b009e2dfcd@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 May 2018 17:46:30 +0200
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag, den 15.05.2018, 16:28 +0200 schrieb Hans Verkuil:
> On 05/15/18 15:07, Oliver Neukum wrote:
> > The premature free in the error path is blocked by V4L
> > refcounting, not USB refcounting. Thanks to
> > Ben Hutchings for review.
> > 
> > [v2] corrected attributions
> > 
> > Signed-off-by: Oliver Neukum <oneukum@suse.com>
> > Fixes: 50e704453553 ("media: usbtv: prevent double free in error case")
> > CC: stable@vger.kernel.org
> > Reported-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
> > ---
> >  drivers/media/usb/usbtv/usbtv-core.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
> > index 5095c380b2c1..4a03c4d66314 100644
> > --- a/drivers/media/usb/usbtv/usbtv-core.c
> > +++ b/drivers/media/usb/usbtv/usbtv-core.c
> > @@ -113,7 +113,8 @@ static int usbtv_probe(struct usb_interface *intf,
> >  
> >  usbtv_audio_fail:
> >  	/* we must not free at this point */
> > -	usb_get_dev(usbtv->udev);
> > +	v4l2_device_get(&usbtv->v4l2_dev);
> 
> This is very confusing. I think it is much better to move the

Yes. It confused me.

> v4l2_device_register() call from usbtv_video_init to this probe function.

Yes, but it is called here. So you want to do it after registering the
audio?

	Regards
		Oliver
