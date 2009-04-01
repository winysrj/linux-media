Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38326 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753942AbZDAWgO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2009 18:36:14 -0400
Date: Thu, 2 Apr 2009 00:36:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Darius Augulis <augulis.darius@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: soc_camera_open() not called
In-Reply-To: <87r60cmd94.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0904012359260.5389@axis700.grange>
References: <49D37485.7030805@gmail.com> <49D3788D.2070406@gmail.com>
 <87zlf0cl7o.fsf@free.fr> <49D3AE13.9070201@gmail.com> <87r60cmd94.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 1 Apr 2009, Robert Jarzmik wrote:

> Darius Augulis <augulis.darius@gmail.com> writes:
> 
> >>> Darius Augulis wrote:
> >>>     
> >>>> Hi,
> >>>>
> >>>> I'm trying to launch mx1_camera based on new v4l and soc-camera tree.
> >>>> After loading mx1_camera module, I see that .add callback is not called.
> >>>> In debug log I see that soc_camera_open() is not called too.
> >>>> What should call this function? Is this my driver problem?
> >>>> p.s. loading sensor driver does not change situation.
> >>>>       
> >>
> >> Are you by any chance using last 2.6.29 kernel ?
> >> If so, would [1] be the answer to your question ?
> >>
> >> [1] http://lkml.org/lkml/2009/3/24/625
> 
> > thanks. it means we should expect soc-camera fix for this?
> > I'm using 2.6.29-git8, but seems it's not fixed yet.
> No, I don't think so.

You're right.

> The last time I checked there had to be an amendement to the patch which
> introduced the driver core regression, as it touches other areas as well
> (sound/soc and mtd from memory).
> 
> I think Guennadi can confirm this, as he's the one who raised the issue in the
> first place.

If Darius had followed the thread you referred to he would have come down 
to this message

http://lkml.org/lkml/2009/3/26/202

which provides a reply as to "what should be fixed," and yes, Ming Lei has 
already provided a patch to fix this, it should hit mainstream... some 
time before -rc1.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
