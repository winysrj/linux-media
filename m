Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:48311 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab0KIPsN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Nov 2010 10:48:13 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Tue, 9 Nov 2010 21:17:52 +0530
Subject: RE: [PATCH 6/6] davinci vpbe: Build infrastructure for VPBE driver
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E9402DC0F0087@dbde02.ent.ti.com>
In-Reply-To: <4CD96006.8010301@mvista.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Nov 09, 2010 at 20:21:50, Sergei Shtylyov wrote:
> Hello.
> 
> Manjunath Hadli wrote:
> 
> > From: Muralidharan Karicheri <m-karicheri2@ti.com>
> 
> > This patch adds the build infra-structure for Davinci VPBE dislay 
> > driver.
> 
> > Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> [...]
> 
> > diff --git a/drivers/media/video/davinci/Kconfig 
> > b/drivers/media/video/davinci/Kconfig
> > index 6b19540..dab32d5 100644
> > --- a/drivers/media/video/davinci/Kconfig
> > +++ b/drivers/media/video/davinci/Kconfig
> > @@ -91,3 +91,25 @@ config VIDEO_ISIF
> >  
> >  	   To compile this driver as a module, choose M here: the
> >  	   module will be called vpfe.
> > +
> > +config VIDEO_DM644X_VPBE
> > +        tristate "DM644X VPBE HW module"
> > +        select VIDEO_VPSS_SYSTEM
> > +	select VIDEOBUF_DMA_CONTIG
> > +        help
> 
>     Please use tabs for indentation uniformly.
> 
> WBR, Sergei
> 
> 

Sure. Thank you for the review.
-Manju

