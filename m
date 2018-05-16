Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47004 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751182AbeEPJXs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 05:23:48 -0400
Message-ID: <1526462623.25281.5.camel@suse.com>
Subject: Re: [PATCH] [Patch v2] usbtv: Fix refcounting mixup
From: Oliver Neukum <oneukum@suse.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, ben.hutchings@codethink.co.uk,
        gregkh@linuxfoundation.org, mchehab@s-opensource.com,
        linux-media@vger.kernel.org
Cc: stable@vger.kernel.org
Date: Wed, 16 May 2018 11:23:43 +0200
In-Reply-To: <1ee4b00d-9a55-92cf-e708-1e0c60ca4bfd@xs4all.nl>
References: <20180515130744.19342-1-oneukum@suse.com>
         <85dd974b-c251-47a5-600d-77b009e2dfcd@xs4all.nl>
         <1526399190.31771.2.camel@suse.com>
         <1ee4b00d-9a55-92cf-e708-1e0c60ca4bfd@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag, den 15.05.2018, 18:01 +0200 schrieb Hans Verkuil:
> On 05/15/2018 05:46 PM, Oliver Neukum wrote:
> > Am Dienstag, den 15.05.2018, 16:28 +0200 schrieb Hans Verkuil:
> > > On 05/15/18 15:07, Oliver Neukum wrote:

> > > >  usbtv_audio_fail:
> > > >  	/* we must not free at this point */
> > > > -	usb_get_dev(usbtv->udev);
> > > > +	v4l2_device_get(&usbtv->v4l2_dev);
> > > 
> > > This is very confusing. I think it is much better to move the
> > 
> > Yes. It confused me.
> > 
> > > v4l2_device_register() call from usbtv_video_init to this probe function.
> > 
> > Yes, but it is called here. So you want to do it after registering the
> > audio?
> 
> No, before. It's a global data structure, so this can be done before the
> call to usbtv_video_init() as part of the top-level initialization of the
> driver.

Eh, but we cannot create a V4L device before the first device
is connected and we must certainly create multiple V4L devices if
multiple physical devices are connected.

Maybe I am dense. Please elaborate.
It seem to me that the driver is confusing because it uses
multiple refcounts.

	Regards
		Oliver
