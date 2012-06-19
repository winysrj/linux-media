Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab2FSBCM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 21:02:12 -0400
Message-ID: <4FDFCF89.9040807@redhat.com>
Date: Mon, 18 Jun 2012 22:02:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH] Revert "[media] media: mx2_camera: Fix mbus format handling"
References: <Pine.LNX.4.64.1205260005230.13353@axis700.grange> <CAOMZO5DVWz0EtfkHq+pquNWyB6+kn3G2b2G-ANYi-Nmfh1uCYQ@mail.gmail.com>
In-Reply-To: <CAOMZO5DVWz0EtfkHq+pquNWyB6+kn3G2b2G-ANYi-Nmfh1uCYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-06-2012 21:55, Fabio Estevam escreveu:
> Hi Mauro,
> 
> On Fri, May 25, 2012 at 7:06 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
>> This reverts commit d509835e32bd761a2b7b446034a273da568e5573. That commit
>> breaks support for the generic pass-through mode in the driver for formats,
>> not natively supported by it. Besides due to a merge conflict it also breaks
>> driver compilation:
>>
>> drivers/media/video/mx2_camera.c: In function 'mx2_camera_set_bus_param':
>> drivers/media/video/mx2_camera.c:937: error: 'pixfmt' undeclared (first use in this function)
>> drivers/media/video/mx2_camera.c:937: error: (Each undeclared identifier is reported only once
>> drivers/media/video/mx2_camera.c:937: error: for each function it appears in.)
> 
> Can this be applied?
> 
> It is breaking mxs_defconfig for one month now.

It were applied today at my -next tree.

> 
> Thanks,
> 
> Fabio Estevam
> 


