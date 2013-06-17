Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:51694 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab3FQGM3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 02:12:29 -0400
Date: Mon, 17 Jun 2013 08:12:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: Simon Horman <horms+renesas@verge.net.au>,
	Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
	SH-Linux <linux-sh@vger.kernel.org>,
	"arm@kernel.org" <arm@kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Magnus Damm <damm@opensource.se>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 14/15] ARM: shmobile: Remove AP4EVB board support
In-Reply-To: <CANqRtoRXBupbbU_cq257p5usu8F5975NFDenkOx1qTvYZaxF2w@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1306170805390.22409@axis700.grange>
References: <1371106793-25071-1-git-send-email-horms+renesas@verge.net.au>
 <1371106793-25071-15-git-send-email-horms+renesas@verge.net.au>
 <Pine.LNX.4.64.1306132128370.3777@axis700.grange>
 <CANqRtoSx4Jf_EfG3LvkpoOED4-SuOdWjRedz-RbwGCOcOeP-Xg@mail.gmail.com>
 <Pine.LNX.4.64.1306141123380.6920@axis700.grange>
 <CANqRtoRXBupbbU_cq257p5usu8F5975NFDenkOx1qTvYZaxF2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 17 Jun 2013, Magnus Damm wrote:

[snip]

> So Guennadi, if you want to keep this board then you have to step up
> and fix things. If not then there is no point in keeping it.

Ok, after a private discussion we agreed to remove the board, which will 
also make the drivers for the Renesas sh-/r-mobile CSI2 interface and for 
the Sony IMX074 sensor untestable and susceptible to removal. Also 
multi-subdevice support in soc-camera now will lose its only use and can 
become broken. I will also drop CSI2 and AP4EVB patches from my V4L2 clock 
/ async probing series.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
