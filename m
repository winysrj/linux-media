Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:36195 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab2AHPI0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Jan 2012 10:08:26 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] V4L: mt9m111: clean up and fix .s_crop() / .s_fmt()
References: <Pine.LNX.4.64.1112211649070.30646@axis700.grange>
Date: Sun, 08 Jan 2012 16:08:15 +0100
In-Reply-To: <Pine.LNX.4.64.1112211649070.30646@axis700.grange> (Guennadi
	Liakhovetski's message of "Wed, 21 Dec 2011 16:53:43 +0100 (CET)")
Message-ID: <871uramduo.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Hi all
>
> While working on a context-switching test, I've cleaned up the mt9m111 
> driver a bit and fixed its cropping and scaling functions. These are 
> planned for 3.3.

Hi Guennadi,

I've looked more deeply into the patchset, and I have no comment, it all looks
good. I've not been able to test it due to a ill tempered board, but I reviewed
patches 1 and 2 with my manual, and patch 3 a bit, and checked compilation
versus kernel 3.2.

So please find my:
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

-- 
Robert
