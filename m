Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40131 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1G2N2V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 09:28:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH] mt9p031: Aptina (Micron) MT9P031 5MP sensor driver
Date: Fri, 29 Jul 2011 15:28:22 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	shotty317@gmail.com
References: <CACKLOr1veNZ_6E3V_m1Tf+mxxUAKiRKDbboW-fMbRGUrLns_XA@mail.gmail.com> <201107291214.40779.laurent.pinchart@ideasonboard.com> <CACKLOr3VxSDUKzgWByH-qcWeA85QvY-0jY=bAogW8JZa3=v1nw@mail.gmail.com>
In-Reply-To: <CACKLOr3VxSDUKzgWByH-qcWeA85QvY-0jY=bAogW8JZa3=v1nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107291528.23734.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Friday 29 July 2011 14:31:12 javier Martin wrote:
> All right,
> it works like a charm for me.
> 
> It took me a bit to figure out that binning and skipping is controlled
> through ratio between cropping window size and actual format size but
> it is clear now.
> 
> Just one thing; both VFLIP (this one is my fault) and HFLIP controls
> change the pixel format of the image and it no longer is GRBG.
> 
> Given the following example image:
> 
> G R G R
> B G B G
> 
> If we apply VFLIP we'll have:
> 
> B G B G
> G R G R
> 
> And if we apply HFLIP we'll have:
> 
> R G R G
> G B G B
> 
> I am not sure how we could solve this issue, maybe through adjusting
> row and column start...

That's probably the easiest solution, yes.

> In any case the driver is OK for me and the issue with VFLIP and HFLIP
> could be solved later on.

OK. Thanks for the review.

-- 
Regards,

Laurent Pinchart
