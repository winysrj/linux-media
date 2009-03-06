Return-path: <linux-media-owner@vger.kernel.org>
Received: from wmproxy2-g27.free.fr ([212.27.42.92]:16720 "EHLO
	wmproxy2-g27.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZCFI0P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 03:26:15 -0500
Date: Fri, 6 Mar 2009 09:26:03 +0100 (CET)
From: robert.jarzmik@free.fr
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Trent Piepho <xyzzy@speakeasy.org>
Message-ID: <1028158815.2045371236327963888.JavaMail.root@zimbra20-e3.priv.proxad.net>
In-Reply-To: <1402002204.2045281236327939805.JavaMail.root@zimbra20-e3.priv.proxad.net>
Subject: Re: [PATCH 1/4] pxa_camera: Remove YUV planar formats hole
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

----- Mail Original -----
De: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
À: "Trent Piepho" <xyzzy@speakeasy.org>
Cc: "Robert Jarzmik" <robert.jarzmik@free.fr>, mike@compulab.co.il, "Linux Media Mailing List" <linux-media@vger.kernel.org>
Envoyé: Jeudi 5 Mars 2009 23h15:03 GMT +01:00 Amsterdam / Berlin / Berne / Rome / Stockholm / Vienne
Objet: Re: [PATCH 1/4] pxa_camera: Remove YUV planar formats hole

> Yes, adjusting both is also what I was suggesting in my original review. 
> How about aligning the bigger of the two to 4 bytes and the smaller to 2? 

Yes, sounds good.

I remade my calculations :
 - if (width x height % 8 == 0) :
   => frame size = width x height x 2
   => U plane size = frame size / 4 = width x height /2
   => U plane size is a multiple of 4
      As the last DMA load from QIF fifo will return 8 bytes (and not 4 as 
      we would expect, cf. PXA Developer's Manual, 27.4.4.1), this is not
      good.

This implies that even if DMA is 8 bytes aligned, width x height should be a multiple of 16, not 8 as I stated in the first git comment. So that would align :
 - width on 4 bytes (aligning meaning the lowest multiple of 4 below or equal to width)
 - and height on 4 bytes (aligning meaning the lowest multiple of 4 below or equal to height)

Do we have an agreement on that specification, so that I can amend the code accordingly ?

Cheers.

--
Robert
