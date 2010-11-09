Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60680 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab0KIXKm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Nov 2010 18:10:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: OMAP3530 ISP irqs disabled
Date: Wed, 10 Nov 2010 00:10:41 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Bastian Hecht <hechtb@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTint8J4NdXQ4v1wmKAKWa7oeSHsdOn8JzjDqCqeY@mail.gmail.com> <201011080416.16090.laurent.pinchart@ideasonboard.com> <4CD7EC8C.1020505@matrix-vision.de>
In-Reply-To: <4CD7EC8C.1020505@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011100010.42129.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Monday 08 November 2010 13:26:52 Michael Jones wrote:
> Laurent Pinchart wrote:
> > Sorry for the late reply, I've been travelling for the past two weeks and
> > had no hardware to test this on. I will try the latest code on a board
> > with a parallel sensor and I'll let you know if I can reproduce the
> > problem.
> 
> If I'm correct about the problem, it's not about the parallel sensor,
> it's about writing the data from the CCDC to memory.  I expect the
> problem to occur with a serial sensor too if the CCDC writes to memory.

You're 100% right, I've been able to reproduce the problem with both a 
parallel and a serial sensor. I wonder how this bug got introduced, it's time 
to tighten the QA process. I'll work on a fix ASAP.

-- 
Regards,

Laurent Pinchart
