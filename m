Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:47154 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305Ab2CQJok (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Mar 2012 05:44:40 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] [media] V4L: pxa_camera: add clk_prepare/clk_unprepare calls
References: <1331835211.14662.5.camel@flow>
Date: Sat, 17 Mar 2012 10:44:25 +0100
In-Reply-To: <1331835211.14662.5.camel@flow> (Philipp Zabel's message of "Thu,
	15 Mar 2012 19:13:31 +0100")
Message-ID: <87sjh7a7eu.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Philipp Zabel <philipp.zabel@gmail.com> writes:

> This patch adds clk_prepare/clk_unprepare calls to the pxa_camera
> driver by using the helper functions clk_prepare_enable and
> clk_disable_unprepare.
>
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Robert Jarzmik <robert.jarzmik@free.fr>

Certainly, clocks have to be prepared before being enabled AFAIK.
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert
