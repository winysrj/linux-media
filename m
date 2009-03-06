Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:33737 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415AbZCFXau (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Mar 2009 18:30:50 -0500
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] pxa_camera: Remove YUV planar formats hole
References: <1028158815.2045371236327963888.JavaMail.root@zimbra20-e3.priv.proxad.net>
	<Pine.LNX.4.64.0903061953170.5665@axis700.grange>
	<Pine.LNX.4.58.0903061442240.24268@shell2.speakeasy.net>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 07 Mar 2009 00:30:37 +0100
In-Reply-To: <Pine.LNX.4.58.0903061442240.24268@shell2.speakeasy.net> (Trent Piepho's message of "Fri\, 6 Mar 2009 15\:12\:36 -0800 \(PST\)")
Message-ID: <87eixa2pr6.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trent Piepho <xyzzy@speakeasy.org> writes:

> I like the algorithm I posted, after another small improvement, better.
So push it toward v4l2, to have wider audience.

If I were you, I'd have a peek at include/linux/kernel.h, which brings you
beautiful functions like ALIGN(), IS_ALIGNED(), and so on ... That could make
your next review easier.

> For instance, if width is aligned by 8 and height by 2, then you have
> already have 16 byte alignment and there is no need to align height by 4.
> E.g., 168x202 will be kept as 168x202 with my method but the rounding down
> method changes it to 168x200.
In the algorithm I posted, I keep 168x202 as well.

> Another example, take 159x243.  My algorithm produces 160x243, which seems
> much better than 156x240, what one gets by rounding each dimention down to
> a multiple of four.
By better you mean "nearer" ? Well, why not. If your patch mades it through v4l2
stack, I'll push an update to use it, deal ?

--
Robert
