Return-path: <linux-media-owner@vger.kernel.org>
Received: from wmproxy2-g27.free.fr ([212.27.42.92]:12174 "EHLO
	wmproxy2-g27.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbZCFNjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 08:39:22 -0500
Date: Fri, 6 Mar 2009 14:39:05 +0100 (CET)
From: robert.jarzmik@free.fr
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <1344766464.2132001236346745220.JavaMail.root@zimbra20-e3.priv.proxad.net>
In-Reply-To: <421785551.2131221236346602590.JavaMail.root@zimbra20-e3.priv.proxad.net>
Subject: Re: [PATCH 1/4] pxa_camera: Remove YUV planar formats hole
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

----- Mail Original -----
De: "Trent Piepho" <xyzzy@speakeasy.org>
À: "robert jarzmik" <robert.jarzmik@free.fr>
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>, mike@compulab.co.il, "Linux Media Mailing List" <linux-media@vger.kernel.org>
Envoyé: Vendredi 6 Mars 2009 10h56:39 GMT +01:00 Amsterdam / Berlin / Berne / Rome / Stockholm / Vienne
Objet: Re: [PATCH 1/4] pxa_camera: Remove YUV planar formats hole

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

The requirement is for each plane, as each plane has a QIF fifo associated. If the requirement is granted for plane U, then it is for plane V (same size), and plane Y as well (twice the size of plane U).

And the file format is planar 4:2:2 YCbCr, which gives (assuming 32 bit wide representation, with most significant bit on the left of the schema and least on the right) for example :

 31      23     15     7     0
 +------+------+------+------+
 | Yn+3 | Yn+2 | Yn+1 | Yn   |
 | ..........................|
 + YN   | YN-1 | YN-1 | 0    |
 +------+------+------+------+
 | Cr+3 | Cr+2 | Cr+1 | Cr   |
 | ..........................|
 | CrN  | CrN-1|  0   |  0   |
 +------+------+------+------+
 | Cr+3 | Cr+2 | Cr+1 | Cr   |
 | ..........................|
 | CrN  | CrN-1|  0   |  0   |
 +------+------+------+------+

Everywhere where I put a "0", de QIF interface sends a 0 byte even if it doesn't represent a pixel (padding by 0s).
The same is true for RGB formats, but instead of 0, it is 0 or "transparency bit".

For the height/width calculation, I didn't find your function in kernel tree. As it is very generic, I have no way to put it into pxa_camera, it should go ... elsewhere. So I think I'll use a dumb "ALIGN(x, 8)" ...

Cheers.

--
Robert
