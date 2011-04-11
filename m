Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:37308 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab1DKM7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 08:59:46 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] V4L: soc-camera: regression fix: calculate .sizeimage in soc_camera.c
Date: Mon, 11 Apr 2011 14:58:28 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sergio Aguirre <saaguirre@ti.com>
References: <Pine.LNX.4.64.1104111054110.18511@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1104111054110.18511@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104111458.28668.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dnia poniedziałek 11 kwiecień 2011 o 10:58:26 Guennadi Liakhovetski 
napisał(a):
> A recent patch has given individual soc-camera host drivers a
> possibility to calculate .sizeimage and .bytesperline pixel format
> fields internally, however, some drivers relied on the core
> calculating these values for them, following a default algorithm.
> This patch restores the default calculation for such drivers.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Hi Guennadi,
Works for me on my OMAP1 camera (Amstrad Delta, 2.6.39-rc2).
You can add my Tested-by: if you like.

Thanks,
Janusz
