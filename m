Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:32897 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751023AbeCGIOR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 03:14:17 -0500
Date: Wed, 7 Mar 2018 09:14:13 +0100
From: Simon Horman <horms@verge.net.au>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: platform: Drop OF dependency of VIDEO_RENESAS_VSP1
Message-ID: <20180307081413.bk4tiporpu2wk2m7@verge.net.au>
References: <1519668550-26082-1-git-send-email-geert+renesas@glider.be>
 <20180306132515.261cf47c@vento.lan>
 <3554226.unskCpdSGX@avalon>
 <20180306133738.7acd5529@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180306133738.7acd5529@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 06, 2018 at 01:37:38PM -0300, Mauro Carvalho Chehab wrote:
> Em Tue, 06 Mar 2018 18:35:32 +0200
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> 
> > Hi Mauro,
> > 
> > On Tuesday, 6 March 2018 18:25:15 EET Mauro Carvalho Chehab wrote:
> > > Em Mon, 26 Feb 2018 19:09:10 +0100 Geert Uytterhoeven escreveu:  
> > > > VIDEO_RENESAS_VSP1 depends on ARCH_RENESAS && OF.
> > > > As ARCH_RENESAS implies OF, the latter can be dropped.
> > > > 
> > > > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > > ---
> > > > 
> > > >  drivers/media/platform/Kconfig | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/media/platform/Kconfig
> > > > b/drivers/media/platform/Kconfig index 614fbef08ddcabb0..2b8b1ad0edd9eb31
> > > > 100644
> > > > --- a/drivers/media/platform/Kconfig
> > > > +++ b/drivers/media/platform/Kconfig
> > > > @@ -448,7 +448,7 @@ config VIDEO_RENESAS_FCP
> > > > 
> > > >  config VIDEO_RENESAS_VSP1
> > > >  
> > > >  	tristate "Renesas VSP1 Video Processing Engine"
> > > >  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
> > > > 
> > > > -	depends on (ARCH_RENESAS && OF) || COMPILE_TEST
> > > > +	depends on ARCH_RENESAS || COMPILE_TEST  
> > > 
> > > That is not correct!
> > > 
> > > COMPILE_TEST doesn't depend on OF. With this patch, it will likely
> > > cause build failures with randconfigs.  
> > 
> > ARCH_RENESAS implies OF, so replacing (ARCH_RENESAS && OF) with ARCH_RENESAS 
> > doesn't change anything. The driver can be compiled with COMPILE_TEST and !OF 
> > both before and after this patch.

FWIIW, I think this is a useful cleanup.

> OK!
> > 
> > > >  	depends on (!ARM64 && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
> > > >  	select VIDEOBUF2_DMA_CONTIG
> > > >  	select VIDEOBUF2_VMALLOC  
> > 
> 
> 
> 
> Thanks,
> Mauro
> 
