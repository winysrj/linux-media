Return-path: <mchehab@gaivota>
Received: from devils.ext.ti.com ([198.47.26.153]:39163 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686Ab0LTNkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 08:40:13 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>,
	"Hadli, Manjunath" <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Mon, 20 Dec 2010 19:09:55 +0530
Subject: RE: [PATCH v7 5/8] davinci vpbe: board specific additions
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930247ECB7E6@dbde02.ent.ti.com>
In-Reply-To: <4D0B8FE3.3080502@mvista.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, Dec 17, 2010 at 21:59:23, Sergei Shtylyov wrote:
> Hello.
> 
> Manjunath Hadli wrote:
> 
> > This patch implements tables for display timings,outputs and other 
> > board related functionalities.
> 
> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> > Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> [...]
> 
> > diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c 
> > b/arch/arm/mach-davinci/board-dm644x-evm.c
> > index 34c8b41..e9b1243 100644
> > --- a/arch/arm/mach-davinci/board-dm644x-evm.c
> > +++ b/arch/arm/mach-davinci/board-dm644x-evm.c
> [...]
> > @@ -620,6 +671,8 @@ davinci_evm_map_io(void)  {
> >  	/* setup input configuration for VPFE input devices */
> >  	dm644x_set_vpfe_config(&vpfe_cfg);
> > +	/* setup configuration for vpbe devices */
> > +	dm644x_set_vpbe_display_config(&vpbe_display_cfg);
> >  	dm644x_init();
> >  }
> 
>     This patch should *follow* the platform patch (where
> dm644x_set_vpbe_display_config() is defined), not precede it.
Thanks. Will update the patch series.
-Manju
> 
> WBR, Sergei
> 

