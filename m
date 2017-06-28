Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38115 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751540AbdF1R7P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Jun 2017 13:59:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robb Glasser <rglasser@google.com>
Subject: Re: [media] uvcvideo: Prevent heap overflow in uvc driver
Date: Wed, 28 Jun 2017 20:59:17 +0300
Message-ID: <1797631.lsAEjhpLaU@avalon>
In-Reply-To: <20170628143643.GA30654@roeck-us.net>
References: <1495482484-32125-1-git-send-email-linux@roeck-us.net> <20170628143643.GA30654@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guenter,

On Wednesday 28 Jun 2017 07:36:43 Guenter Roeck wrote:
> On Mon, May 22, 2017 at 12:48:04PM -0700, Guenter Roeck wrote:
> > From: Robb Glasser <rglasser@google.com>
> > 
> > The size of uvc_control_mapping is user controlled leading to a
> > potential heap overflow in the uvc driver. This adds a check to verify
> > the user provided size fits within the bounds of the defined buffer
> > size.
> > 
> > Signed-off-by: Robb Glasser <rglasser@google.com>
> > [groeck: cherry picked from
> > 
> >  https://source.codeaurora.org/quic/la/kernel/msm-3.10
> >  commit b7b99e55bc7770187913ed092990852ea52d7892;
> >  updated subject]
> > 
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> > Fixes CVE-2017-0627.
> 
> Please do not apply this patch. It is buggy.

I apologize for not noticing the initial patch, even if it looks like it was 
all for the best. Will you send a new version ?

> >  drivers/media/usb/uvc/uvc_ctrl.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> > b/drivers/media/usb/uvc/uvc_ctrl.c index c2ee6e39fd0c..252ab991396f
> > 100644
> > --- a/drivers/media/usb/uvc/uvc_ctrl.c
> > +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> > @@ -1992,6 +1992,9 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain
> > *chain,
> >  	if (!found)
> >  		return -ENOENT;
> > 
> > +	if (ctrl->info.size < mapping->size)
> > +		return -EINVAL;
> > +
> > 
> >  	if (mutex_lock_interruptible(&chain->ctrl_mutex))
> >  		return -ERESTARTSYS;

-- 
Regards,

Laurent Pinchart
