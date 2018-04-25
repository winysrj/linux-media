Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:52504 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbeDYAgv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 20:36:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Edgar Thier <info@edgarthier.net>
Subject: Re: a 4.16 kernel with Debian 9.4 "stretch" causes a log explosion
Date: Wed, 25 Apr 2018 03:37:05 +0300
Message-ID: <13495678.ygx19VKxpQ@avalon>
In-Reply-To: <alpine.DEB.2.20.1804112130030.25028@axis700.grange>
References: <alpine.DEB.2.20.1804110911021.18053@axis700.grange> <2838ba6c-7425-f45f-d121-e519093ab842@ideasonboard.com> <alpine.DEB.2.20.1804112130030.25028@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wednesday, 11 April 2018 22:33:43 EEST Guennadi Liakhovetski wrote:
> On Wed, 11 Apr 2018, Kieran Bingham wrote:
> > On 11/04/18 18:06, Guennadi Liakhovetski wrote:
> >  <snip>
> >  
> >>>>> Just figured out this commit
> >>>>> 
> >>>>> From: Edgar Thier <info@edgarthier.net>
> >>>>> Date: Thu, 12 Oct 2017 03:54:17 -0400
> >>>>> Subject: [PATCH] media: uvcvideo: Apply flags from device to actual
> >>>>> properties
> >>>>> 
> >>>>> as the culprit. Without it everything is back to normal.
> >>>> 
> >>>> I've already investigated and fixed this:
> >>>> 
> >>>> Please apply:
> >>>> 	https://patchwork.kernel.org/patch/10299735/
> >> 
> >> Great, thanks! That seems to fix my problem.
> > 
> > Fantastic. I'm glad it helped.
> > 
> >  - Can I call that a Tested-by: ? :-D
> 
> Now you officially can - I replied to the patch.

Thank you. I've picked the tag and sent a pull request to Mauro.

-- 
Regards,

Laurent Pinchart
