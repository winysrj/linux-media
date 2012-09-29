Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:37392 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab2I2Rkh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Sep 2012 13:40:37 -0400
Date: Sat, 29 Sep 2012 19:40:27 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/2] V4L: soc_camera: disable I2C subdev streamon for
 mpc52xx_csi
Message-ID: <20120929194027.24cd9008@wker>
In-Reply-To: <Pine.LNX.4.64.1209281317130.5428@axis700.grange>
References: <1348822255-30875-1-git-send-email-agust@denx.de>
	<1348822255-30875-2-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1209281317130.5428@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Fri, 28 Sep 2012 13:26:03 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
...
> > +#if !defined(CONFIG_VIDEO_MPC52xx_CSI) && \
> > +    !defined(CONFIG_VIDEO_MPC52xx_CSI_MODULE)
> 
> No, we're not adding any preprocessor or run-time hardware dependencies to 
> soc-camera or to any other generic code. I have no idea what those "IFM 
> O2D" cameras are. If it's their common feature, that they cannot take any 
> further I2C commands, while streaming, their drivers have to do that 
> themselves.

I'm not sure I understand you. To do what themselves?

Thanks,
Anatolij
