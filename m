Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:33869 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab1EXM7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 08:59:19 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>,
	Sergei Shtylyov <sshtylyov@mvista.com>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>
Date: Tue, 24 May 2011 18:29:10 +0530
Subject: RE: [PATCH v17 5/6] davinci vpbe: Build infrastructure for VPBE
 driver
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF734@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024D09B11F@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, May 23, 2011 at 13:58:26, Nori, Sekhar wrote:
> On Fri, May 20, 2011 at 20:02:08, Sergei Shtylyov wrote:
> > Hello.
> > 
> > Manjunath Hadli wrote:
> > 
> > > This patch adds the build infra-structure for Davinci VPBE dislay 
> > > driver.
> > 
> > > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > > Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> > > Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> > [...]
> > 
> > > diff --git a/drivers/media/video/davinci/Kconfig 
> > > b/drivers/media/video/davinci/Kconfig
> > > index 6b19540..a7f11e7 100644
> > > --- a/drivers/media/video/davinci/Kconfig
> > > +++ b/drivers/media/video/davinci/Kconfig
> > > @@ -91,3 +91,25 @@ config VIDEO_ISIF
> > >  
> > >  	   To compile this driver as a module, choose M here: the
> > >  	   module will be called vpfe.
> > > +
> > > +config VIDEO_DM644X_VPBE
> > > +	tristate "DM644X VPBE HW module"
> > 
> >     BTW, as this seems DM644x specific, shouldn't this depend on 
> > CONFIG_ARCH_DAVINCI_DM644x?
> 
> Since VENC/OSD etc are also applicable to other DaVinci devices, this KConfig entry should probably be split to refer to them individually and in a generic way. "depends on" can then be used to make sure only the relevant ones show up.

Both venc and osd have to be used together always, so might not make a good idea to split. However, I will add a dependency on DM644x, and include others with appropriate patch sets.

> 
> Thanks,
> Sekhar
> 
> 

