Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:65305 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab2JBWJc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 18:09:32 -0400
Date: Wed, 3 Oct 2012 00:09:29 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Anatolij Gustschin <agust@denx.de>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/2] V4L: soc_camera: disable I2C subdev streamon for
 mpc52xx_csi
In-Reply-To: <1348822255-30875-2-git-send-email-agust@denx.de>
Message-ID: <Pine.LNX.4.64.1210030001440.15778@axis700.grange>
References: <1348822255-30875-1-git-send-email-agust@denx.de>
 <1348822255-30875-2-git-send-email-agust@denx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Anatolij

> > > +#if !defined(CONFIG_VIDEO_MPC52xx_CSI) && \
> > > +    !defined(CONFIG_VIDEO_MPC52xx_CSI_MODULE)
> > 
> > No, we're not adding any preprocessor or run-time hardware dependencies to 
> > soc-camera or to any other generic code. I have no idea what those "IFM 
> > O2D" cameras are. If it's their common feature, that they cannot take any 
> > further I2C commands, while streaming, their drivers have to do that 
> > themselves.
> 
> I'm not sure I understand you. To do what themselves?

They - subdevice drivers of such IFM O2D cameras - should take care to avoid 
any I2C commands during a running read-out. Neither the bridge driver nor 
the framework core can or should know these details. This is just a generic 
call to a subdevice's .s_stream() method. What the driver does in it is 
totally its own business. Nobody says, that you have to issue I2C commands 
in it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
