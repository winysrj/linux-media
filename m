Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailsec111.isp.belgacom.be ([195.238.20.107]:42275 "EHLO
	mailsec111.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756AbaL3KGa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Dec 2014 05:06:30 -0500
Date: Tue, 30 Dec 2014 11:06:28 +0100 (CET)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Message-ID: <598779387.288942.1419933988906.open-xchange@webmail.nmp.proximus.be>
In-Reply-To: <3892296.djnqqbsP0R@avalon>
References: <1419863387-24233-1-git-send-email-fabf@skynet.be> <1419863387-24233-10-git-send-email-fabf@skynet.be> <3892296.djnqqbsP0R@avalon>
Subject: Re: [PATCH 09/11 linux-next] [media] uvcvideo: remove unnecessary
 version.h inclusion
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> On 30 December 2014 at 00:42 Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>
>
> Hi Fabian,
>
> Thank you for the patch.
>
> On Monday 29 December 2014 15:29:43 Fabian Frederick wrote:
> > Based on versioncheck.
> >
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> Should I take the patch in my tree or do you plan to send a pull request for
> the whole series elsewhere ?
>
> > ---
> >  drivers/media/usb/uvc/uvc_v4l2.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> > b/drivers/media/usb/uvc/uvc_v4l2.c index 9c5cbcf..43e953f 100644
> > --- a/drivers/media/usb/uvc/uvc_v4l2.c
> > +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> > @@ -13,7 +13,6 @@
> >
> >  #include <linux/compat.h>
> >  #include <linux/kernel.h>
> > -#include <linux/version.h>
> >  #include <linux/list.h>
> >  #include <linux/module.h>
> >  #include <linux/slab.h>
>
> --
> Regards,
>
> Laurent Pinchart
>
Hi Laurent,

        Thanks for the ack, you can take the patch.
       
(Maybe Greg will try later to apply the whole patchset on linux-next.
It should not be a problem if some of them are already in.)

Regards,
Fabian
