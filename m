Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:46118 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbZCFJ4l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 04:56:41 -0500
Date: Fri, 6 Mar 2009 01:56:39 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: robert.jarzmik@free.fr
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] pxa_camera: Remove YUV planar formats hole
In-Reply-To: <1028158815.2045371236327963888.JavaMail.root@zimbra20-e3.priv.proxad.net>
Message-ID: <Pine.LNX.4.58.0903060151240.24268@shell2.speakeasy.net>
References: <1028158815.2045371236327963888.JavaMail.root@zimbra20-e3.priv.proxad.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 6 Mar 2009 robert.jarzmik@free.fr wrote:
> ----- Mail Original -----
> De: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
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

So it's only a requirement that the total size of all three planes put
together is a multiple of 8?  Or is it a requirement that each plane is a
multiple of 8?  And are you using 4:2:2 or 4:2:0?
