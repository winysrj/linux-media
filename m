Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:51181 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab1DMGL1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2011 02:11:27 -0400
Date: Wed, 13 Apr 2011 08:11:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Aguirre, Sergio" <saaguirre@ti.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [soc_camera] Dynamic crop window change while streaming (Zoom
 case)?
In-Reply-To: <BANLkTikQ=z+ggR0XR5Ej-=X4MezJ7sOwjA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1104130805450.3565@axis700.grange>
References: <BANLkTikQ=z+ggR0XR5Ej-=X4MezJ7sOwjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sergio

On Tue, 12 Apr 2011, Aguirre, Sergio wrote:

> Hi Guennadi,
> 
> I was wondering what's the stand on allowing soc_camera host drivers to have
> internal scalers...

please, have a look at this thread for patches

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/30932

and (optionally) at this one for a discussion:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/30910/focus=30922

If no objections are raised, these patches might end up in 2.6.40.

Thanks
Guennadi

> It looks possible, but however I see one important blocker for being able to
> change window rectangle while streaming (for example, when attempting to do
> zoom in/out during streaming). See here:
> 
> in soc_camera.c::soc_camera_s_crop()
> 
> ...
> 	/* If get_crop fails, we'll let host and / or client drivers decide */
> 	ret = ici->ops->get_crop(icd, &current_crop);
> 
> 	/* Prohibit window size change with initialised buffers */
> 	if (ret < 0) {
> 		dev_err(&icd->dev,
> 			"S_CROP denied: getting current crop failed\n");
> 	} else if (icd->vb_vidq.bufs[0] &&
> 		   (a->c.width != current_crop.c.width ||
> 		    a->c.height != current_crop.c.height)) {
> 		dev_err(&icd->dev,
> 			"S_CROP denied: queue initialised and sizes differ\n");
> 		ret = -EBUSY;
> 	} else {
> 		ret = ici->ops->set_crop(icd, a);
> 	}
> ...
> 
> Now, I don't want to move just yet to a Media Controller implementation in my
> omap4 camera driver, since I don't intend yet to exploit the full HW, which
> is easly 2x more complicated than omap3. But I want to start with a simplistic
> driver which Pandaboard community can take (which don't need any advanced
> features, just being able to receive frames.) and i just want to know how
> complicated is to just offer the scaler functionality still.
> 
> Regards,
> Sergio
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
