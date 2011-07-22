Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44663 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab1GVL55 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 07:57:57 -0400
Date: Fri, 22 Jul 2011 13:57:56 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v4 4/5] mt9m111: rewrite set_pixfmt
Message-ID: <20110722115756.GA26094@pengutronix.de>
References: <1310485146-27759-1-git-send-email-m.grzeschik@pengutronix.de>
 <1310485146-27759-4-git-send-email-m.grzeschik@pengutronix.de>
 <Pine.LNX.4.64.1107171855390.13485@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1107171855390.13485@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Sun, Jul 17, 2011 at 07:09:42PM +0200, Guennadi Liakhovetski wrote:
> On Tue, 12 Jul 2011, Michael Grzeschik wrote:
> 
> > added new bit offset defines,
> > more supported BE colour formats
> > and also support BGR565 swapped pixel formats
> > 
> > removed pixfmt helper functions and option flags
> > setting the configuration register directly in set_pixfmt
> > 
> > added reg_mask function
> > 
> > reg_mask is basically the same as clearing & setting registers,
> > but it is more convenient and faster (saves one rw cycle).
> > 
> > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
> 
> Applied after pretty heavy modifications. (1) forward-ported to the 
> current tree, (2) removed Bayer swapping, as discussed earlier, (3) 
> removed double bitfield definitions. Please, check out
> 
> http://git.linuxtv.org/gliakhovetski/v4l-dvb.git?a=shortlog;h=refs/heads/for-3.1
> 
> and see, if I haven't inadvertently broken anything.

I double checked all modifications and also tested your patch with some
formats. I also prefer the idea to handle the configuration of
data_outfmt1 in a separete patch. So everything looks right to me.

Thanks,
Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
