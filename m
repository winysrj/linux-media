Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:41249 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756548AbZDOUgS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2009 16:36:18 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/5] soc-camera: host-driver cleanup
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
	<Pine.LNX.4.64.0904151400490.4729@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 15 Apr 2009 22:36:07 +0200
Message-ID: <873ac9ods8.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Embed struct soc_camera_host in platform-specific per host instance objects
> instead of allocating them statically in drivers, use platform_[gs]et_drvdata
> consistently, use resource_size().
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

I you want it for pxa_camera part :
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert
