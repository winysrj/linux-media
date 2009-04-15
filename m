Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:41293 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639AbZDOUgU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2009 16:36:20 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/5] soc-camera: simplify register access routines in multiple sensor drivers
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
	<Pine.LNX.4.64.0904151402540.4729@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 15 Apr 2009 22:36:11 +0200
Message-ID: <87ws9lmz7o.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Register access routines only need the I2C client, not the soc-camera device
> context.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
For mt9m111.c :
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert
