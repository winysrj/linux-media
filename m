Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:51418 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab0KHM1B (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Nov 2010 07:27:01 -0500
Message-ID: <4CD7EC8C.1020505@matrix-vision.de>
Date: Mon, 08 Nov 2010 13:26:52 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Bastian Hecht <hechtb@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: OMAP3530 ISP irqs disabled
References: <AANLkTint8J4NdXQ4v1wmKAKWa7oeSHsdOn8JzjDqCqeY@mail.gmail.com> <4CD413E4.20401@matrix-vision.de> <4CD630EA.8040409@maxwell.research.nokia.com> <201011080416.16090.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201011080416.16090.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent Pinchart wrote:

> 
> Sorry for the late reply, I've been travelling for the past two weeks and had 
> no hardware to test this on. I will try the latest code on a board with a 
> parallel sensor and I'll let you know if I can reproduce the problem.
> 

If I'm correct about the problem, it's not about the parallel sensor,
it's about writing the data from the CCDC to memory.  I expect the
problem to occur with a serial sensor too if the CCDC writes to memory.

-- 
Michael Jones

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
