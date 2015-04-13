Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45561 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbbDMVNa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2015 17:13:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Oliver Lehmann <lehmann@ans-netz.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: capture high resolution images from webcam
Date: Tue, 14 Apr 2015 00:13:51 +0300
Message-ID: <2471555.Rk3gfDCClZ@avalon>
In-Reply-To: <20150319203143.Horde.LcvY5sHGLFtyWH8p9cPQHg1@avocado.salatschuessel.net>
References: <20150317223529.Horde.S4cQ0yA7NJaIix7vWKABGA9@avocado.salatschuessel.net> <2563432.Vgf8Q4ieBN@avalon> <20150319203143.Horde.LcvY5sHGLFtyWH8p9cPQHg1@avocado.salatschuessel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oliver,

On Thursday 19 March 2015 20:31:43 Oliver Lehmann wrote:
> Hi Laurent,
> 
> I took the first option ;)
> 
> http://pastebin.com/7YUgS2Zt

I have good news and bad news.

The good news is that the camera seems to support capturing video in 1920x1080 
natively, which is higher than the 720p you reported. This should work out of 
the box with the uvcvideo driver.

The bad news is that still image capture at higher resolutions isn't supported 
by the camera, or at least not in a UVC-compatible way. My guess is that 8MP 
is achieved either using software interpolation, or possibly using a vendor-
specific undocumented protocol. 

-- 
Regards,

Laurent Pinchart

