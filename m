Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:60352 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZIXVFF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2009 17:05:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Paulo Assis <pj.assis@gmail.com>
Subject: Re: [Linux-uvc-devel] [PATCH] uvc: kmalloc failure ignored in uvc_ctrl_add_ctrl()
Date: Thu, 24 Sep 2009 23:06:34 +0200
Cc: Roel Kluin <roel.kluin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org
References: <4AB43041.6050001@gmail.com> <200909240820.54291.laurent.pinchart@ideasonboard.com> <59cf47a80909240150w3127ed51j48f81e157b49dc0c@mail.gmail.com>
In-Reply-To: <59cf47a80909240150w3127ed51j48f81e157b49dc0c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909242306.34733.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 24 September 2009 10:50:39 Paulo Assis wrote:
> Laurent,
> 
> > That's not enough to prevent a kernel crash. The driver can try to
> > dereference ctrl->data if ctrl->info isn't NULL. You should only set
> > ctrl->info if allocationg succeeds. Something like
> >
> >        ctrl->data = kmalloc(ctrl->info->size * UVC_CTRL_NDATA,
> > GFP_KERNEL); if (ctrl->data == NULL)
> >                return -ENOMEM;
> >
> >        ctrl->info = info;
> 
> Without reading any code this doesn't seem correct, how can you use
> ctrl->info->size if you haven't set ctrl->info yet?
> 
> Did you mean something like this:
> 
>  ctrl->data = kmalloc(info->size * UVC_CTRL_NDATA, GFP_KERNEL);
>  if (ctrl->data == NULL)
>          return -ENOMEM;
> 
>  ctrl->info = info;
> 
> 
> Like I said I haven't read the code but this looks better.

Oops, you're right. My bad. Thanks for catching this.

-- 
Regards,

Laurent Pinchart
