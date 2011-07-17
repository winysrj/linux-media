Return-path: <linux-media-owner@vger.kernel.org>
Received: from linux-sh.org ([111.68.239.195]:50973 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab1GQNQl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2011 09:16:41 -0400
Date: Sun, 17 Jul 2011 22:16:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 6/6] V4L: soc-camera: remove soc-camera bus and devices on it
Message-ID: <20110717131638.GB14100@linux-sh.org>
References: <Pine.LNX.4.64.1107160135500.27399@axis700.grange> <Pine.LNX.4.64.1107160209460.27399@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1107160209460.27399@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 16, 2011 at 02:14:03AM +0200, Guennadi Liakhovetski wrote:
> Now that v4l2 subdevices have got their own device objects, having
> one more device in soc-camera clients became redundant and confusing.
> This patch removes those devices and the soc-camera bus, they used to
> reside on.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> This one looks pretty big, most of it are just 10-liners. It removes more 
> than a 100 lines of code. Tested on sh-mobile, pxa270, i.MX31. Compile 
> tested with all soc-camera hosts and clients. Hope it doesn't break too 
> many things, if it does, we'll have the whole 3.1-rc timeframe to fix 
> them.
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
