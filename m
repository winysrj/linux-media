Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:41982 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590Ab1ETPJA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 11:09:00 -0400
Message-ID: <4DD68408.20507@infradead.org>
Date: Fri, 20 May 2011 12:08:56 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PULL] soc-camera for 2.6.40
References: <Pine.LNX.4.64.1105201022070.17254@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105201022070.17254@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 20-05-2011 05:34, Guennadi Liakhovetski escreveu:
> Hi Mauro,
> 
> Sorry, a bit late again... Here go patches for 2.6.40:
> 
> The following changes since commit f9b51477fe540fb4c65a05027fdd6f2ecce4db3b:
> 
>   [media] DVB: return meaningful error codes in dvb_frontend (2011-05-09 05:47:20 +0200)
> 
> are available in the git repository at:
>   git://linuxtv.org/gliakhovetski/v4l-dvb.git for-2.6.40

...

> Sergio Aguirre (1):
>       V4L: soc-camera: regression fix: calculate .sizeimage in soc_camera.c

This patch didn't apply. Weren't it already applied at 2.6.39?
> 
> Sylwester Nawrocki (1):
>       V4L: Add V4L2_MBUS_FMT_JPEG_1X8 media bus format

Already applied via snawrocki's tree.

Thanks,
Mauro
