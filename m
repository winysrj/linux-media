Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:51220 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283AbZDSUBd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Apr 2009 16:01:33 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <magnus.damm@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Darius Augulis <augulis.darius@gmail.com>
Subject: Re: [PATCH 5/5 v2] soc-camera: Convert to a platform driver
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
	<aec7e5c30904170040p6ec1721aj6885ef16573cd484@mail.gmail.com>
	<Pine.LNX.4.64.0904172017550.5119@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 19 Apr 2009 22:01:20 +0200
In-Reply-To: <Pine.LNX.4.64.0904172017550.5119@axis700.grange> (Guennadi Liakhovetski's message of "Fri\, 17 Apr 2009 20\:38\:58 +0200 \(CEST\)")
Message-ID: <87prf876r3.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Convert soc-camera core to a platform driver. With this approach I2C
> devices are no longer statically registered in platform code, instead they
> are registered dynamically by the soc-camera core, when a match with a
> host driver is found. With this patch all platforms and all soc-camera
> device drivers are converted too. This is a preparatory step for the
> v4l-subdev conversion.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert
