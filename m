Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:63688 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3H3M2a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 08:28:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dinesh Ram <Dinesh.Ram@cern.ch>
Subject: Re: [PATCH v2 6/6] si4713 : Added MAINTAINERS entry for radio-usb-si4713 driver
Date: Fri, 30 Aug 2013 14:28:08 +0200
Cc: Dinesh Ram <dinram@cisco.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <C40DBE54484849439FC5081A05AEF5F5979DEBB7@PLOXCHG23.cern.ch>
In-Reply-To: <C40DBE54484849439FC5081A05AEF5F5979DEBB7@PLOXCHG23.cern.ch>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308301428.08442.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri 30 August 2013 14:14:09 Dinesh Ram wrote:
> Hans Verkuil <hverkuil@xs4all.nl> will maintain the USB driver for si4713
> 
> Signed-off-by: Dinesh Ram <dinram@cisco.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  MAINTAINERS | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b2618ce..ddd4d5f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7412,7 +7412,7 @@ L:	linux-media@vger.kernel.org
>  T:	git git://linuxtv.org/media_tree.git
>  W:	http://linuxtv.org
>  S:	Odd Fixes
> -F:	drivers/media/radio/si4713-i2c.?
> +F:	drivers/media/radio/si4713/si4713.?
>  
>  SI4713 FM RADIO TRANSMITTER PLATFORM DRIVER
>  M:	Eduardo Valentin <edubezval@gmail.com>
> @@ -7420,7 +7420,15 @@ L:	linux-media@vger.kernel.org
>  T:	git git://linuxtv.org/media_tree.git
>  W:	http://linuxtv.org
>  S:	Odd Fixes
> -F:	drivers/media/radio/radio-si4713.h
> +F:	drivers/media/radio/si4713/radio-platform-si4713.c
> +
> +SI4713 FM RADIO TRANSMITTER USB DRIVER
> +M:	Hans Verkuil <hverkuil@xs4all.nl>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +W:	http://linuxtv.org
> +S:	Maintained
> +F:	drivers/media/radio/si4713/radio-usb-si4713.c
>  
>  SIANO DVB DRIVER
>  M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
> -- 1.8.4.rc2 
> ________________________________________
> From: Hans Verkuil [hverkuil@xs4all.nl]
> Sent: 30 August 2013 14:07
> To: Dinesh Ram
> Cc: linux-media@vger.kernel.org; Dinesh Ram
> Subject: Re: [PATCH 6/6] si4713 : Added MAINTAINERS entry for radio-usb-si4713 driver
> 
> On Fri 30 August 2013 13:28:24 Dinesh Ram wrote:
> > Hans Verkuil <hverkuil@xs4all.nl> will maintain the USB driver for si4713
> >
> > Signed-off-by: Dinesh Ram <dinram@cisco.com>
> > ---
> >  MAINTAINERS | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index b2618ce..ddd4d5f 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -7412,7 +7412,7 @@ L:      linux-media@vger.kernel.org
> >  T:   git git://linuxtv.org/media_tree.git
> >  W:   http://linuxtv.org
> >  S:   Odd Fixes
> > -F:   drivers/media/radio/si4713-i2c.?
> > +F:   drivers/media/radio/si4713/si4713.?
> >
> >  SI4713 FM RADIO TRANSMITTER PLATFORM DRIVER
> >  M:   Eduardo Valentin <edubezval@gmail.com>
> > @@ -7420,7 +7420,15 @@ L:     linux-media@vger.kernel.org
> >  T:   git git://linuxtv.org/media_tree.git
> >  W:   http://linuxtv.org
> >  S:   Odd Fixes
> > -F:   drivers/media/radio/radio-si4713.h
> > +F:   drivers/media/radio/si4713/radio-platform-si4713.c
> > +
> > +KEENE FM RADIO TRANSMITTER DRIVER
> 
> You forgot to update the driver description! This is the SiLabs si4713 EVB
> driver, not Keene.
> 
> Can you make a v2 of this patch fixing this?
> 
> Regards,
> 
>         Hans
> 
> > +M:   Hans Verkuil <hverkuil@xs4all.nl>
> > +L:   linux-media@vger.kernel.org
> > +T:   git git://linuxtv.org/media_tree.git
> > +W:   http://linuxtv.org
> > +S:   Maintained
> > +F:   drivers/media/radio/si4713/radio-usb-si4713.c
> >
> >  SIANO DVB DRIVER
> >  M:   Mauro Carvalho Chehab <m.chehab@samsung.com>
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
