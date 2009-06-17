Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:53246 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbZFQFRy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 01:17:54 -0400
From: "Shah, Hardik" <hardik.shah@ti.com>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	xie <yili.xie@gmail.com>
CC: v4l2_linux <linux-media@vger.kernel.org>
Date: Wed, 17 Jun 2009 10:47:50 +0530
Subject: RE: About V4l2 overlay sequence
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB0305A53F5E@dbde02.ent.ti.com>
References: <1244625185.8344.95.camel@xie>
 <5e9665e10906102245o68e32275tbae102d84bd1fb1e@mail.gmail.com>
In-Reply-To: <5e9665e10906102245o68e32275tbae102d84bd1fb1e@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Dongsoo, Nathaniel Kim
> Sent: Thursday, June 11, 2009 11:15 AM
> To: xie
> Cc: v4l2_linux
> Subject: Re: About V4l2 overlay sequence
> 
> It seems to be totally described in v4l2 api specification document.
> 
> The document is saying like this:
> VIDIOC_QUERYCAP
> video input and video standard ioctls
> VIDIOC_G_FBUF and VIDIOC_S_FBUF
> VIDIOC_G_FMT/S_FMT/TRY_FMT
> VIDIOC_OVERLAY
> 
> Take a look at the document for detailed usage.
> Cheers,
> 
> Nate
> 
> On Wed, Jun 10, 2009 at 6:13 PM, xie<yili.xie@gmail.com> wrote:
> > Dear all ~~
> >
> > With your help I have implemented the preview with capture interface ~~
> > Now i want to implement the preview with ovelay , and my camera support
> > s ovelay ~
> > Who can tell me where I can find the document about ovelay sequcence ~ ?
> > Or does there have a standard example source code ~ ?
> >
> > Thanks a lot ~
> >
> > Best regards
> >
[Shah, Hardik] You can also look at the OMAP display driver which is using this feature.  
http://arago-project.org/git/people/vaibhav/ti-psp-omap-video.git?p=people/vaibhav/ti-psp-omap-video.git;a=blob;f=drivers/media/video/omap/omap_vout.c;h=fc8ccd9f9e30e070e32fd37b5a4e7fd07e19d2e3;hb=refs/heads/ti_display

All the ioctls listed by Nate above are supported by this driver.  

Regards,
Hardik Shah
> >
> 
> 
> 
> --
> =
> DongSoo, Nathaniel Kim
> Engineer
> Mobile S/W Platform Lab.
> Digital Media & Communications R&D Centre
> Samsung Electronics CO., LTD.
> e-mail : dongsoo.kim@gmail.com
>           dongsoo45.kim@samsung.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

