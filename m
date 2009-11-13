Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37839 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755346AbZKMJwS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 04:52:18 -0500
Date: Fri, 13 Nov 2009 10:52:27 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] soc-camera: tw9910: modify V/H outpit pin setting to
 use VALID
In-Reply-To: <u7htun4tr.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0911131051350.4601@axis700.grange>
References: <uzl6r6re1.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0911130829360.4601@axis700.grange> <u7htun4tr.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 13 Nov 2009, Kuninori Morimoto wrote:

> 
> Dear Guennadi
> 
> Thank you for checking patch
> 
> > +	ret = i2c_smbus_write_byte_data(client, OUTCTR1,
> > +					VSP_LO | VSSL_VVALID |
> > +					HSP_LO | HSSL_DVALID);
> > 
> > now you dropped VSP_LO | HSP_LO, could you, please, explain, why? Also, 
> > sorry for not explaining properly. Yesterday I wrote
> 
> Because VSP_LO = HSP_LO = 0.

Oh, indeed. Ok, but can you add proper support for both high and low 
polarities?

> And when I use xVALID, xSP_LO mean ACTIVE HI.
> 
> So, I drop these explain because it is just un-understandable.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
