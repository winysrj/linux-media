Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:35065 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab0F3DEJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jun 2010 23:04:09 -0400
Date: Wed, 30 Jun 2010 06:03:16 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCHv4 1/3] mx2_camera: Add soc_camera support for
 i.MX25/i.MX27
Message-ID: <20100630030315.GA23534@tarshish>
References: <cover.1277096909.git.baruch@tkos.co.il>
 <03d6e55c39690618e92a91a580ec34549a135c79.1277096909.git.baruch@tkos.co.il>
 <Pine.LNX.4.64.1006292145001.22603@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1006292145001.22603@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 29, 2010 at 09:47:42PM +0200, Guennadi Liakhovetski wrote:
> On Mon, 21 Jun 2010, Baruch Siach wrote:
> 
> > This is the soc_camera support developed by Sascha Hauer for the i.MX27.  Alan
> > Carvalho de Assis modified the original driver to get it working on more recent
> > kernels. I modified it further to add support for i.MX25. This driver has been
> > tested on i.MX25 and i.MX27 based platforms.
> 
> This looks good to me, thanks! Overflow on eMMA is, probably, still 
> broken, but it will, most probably, remain so, until someone tests and 
> fixes it. One question though: do you know whether this imx/mxc overhaul: 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2010-June/thread.html#18844 
> affects your driver?

I tested this yesterday, and, unfortunately, it does :(. See 
http://lists.infradead.org/pipermail/linux-arm-kernel/2010-June/019111.html.  
However, this issue does not affect mx27 builds. So I think this should not 
stop the merge of this driver, for now. I hope Uwe and I will find an 
acceptable solution before the .36 merge window opens.

baruch

> I can ask Uwe, but maybe you have an idea or could test your patches with 
> Uwe's git tree?
> 
> Thanks
> Guennadi
> 
> > 
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
