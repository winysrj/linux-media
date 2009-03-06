Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40454 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754565AbZCFSzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 13:55:31 -0500
Date: Fri, 6 Mar 2009 19:55:42 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: robert.jarzmik@free.fr
cc: mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH 1/4] pxa_camera: Remove YUV planar formats hole
In-Reply-To: <1028158815.2045371236327963888.JavaMail.root@zimbra20-e3.priv.proxad.net>
Message-ID: <Pine.LNX.4.64.0903061953170.5665@axis700.grange>
References: <1028158815.2045371236327963888.JavaMail.root@zimbra20-e3.priv.proxad.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 6 Mar 2009, robert.jarzmik@free.fr wrote:

> ----- Mail Original -----
> De: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>

(hm, there's something strange about this and following emails in this 
thread, I didn't get them directly, only over the mailing list... strange)

> À: "Trent Piepho" <xyzzy@speakeasy.org>
> Cc: "Robert Jarzmik" <robert.jarzmik@free.fr>, mike@compulab.co.il, "Linux Media Mailing List" <linux-media@vger.kernel.org>
> Envoyé: Jeudi 5 Mars 2009 23h15:03 GMT +01:00 Amsterdam / Berlin / Berne / Rome / Stockholm / Vienne
> Objet: Re: [PATCH 1/4] pxa_camera: Remove YUV planar formats hole
> 
> > Yes, adjusting both is also what I was suggesting in my original review. 
> > How about aligning the bigger of the two to 4 bytes and the smaller to 2? 
> 
> Yes, sounds good.
> 
> I remade my calculations :
>  - if (width x height % 8 == 0) :
>    => frame size = width x height x 2
>    => U plane size = frame size / 4 = width x height /2
>    => U plane size is a multiple of 4
>       As the last DMA load from QIF fifo will return 8 bytes (and not 4 as 
>       we would expect, cf. PXA Developer's Manual, 27.4.4.1), this is not
>       good.
> 
> This implies that even if DMA is 8 bytes aligned, width x height should 
> be a multiple of 16, not 8 as I stated in the first git comment. So that 
> would align :
>  - width on 4 bytes (aligning meaning the lowest multiple of 4 below or equal to width)
>  - and height on 4 bytes (aligning meaning the lowest multiple of 4 below or equal to height)
> 
> Do we have an agreement on that specification, so that I can amend the code accordingly ?

Yep, looks good to me.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
