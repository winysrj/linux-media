Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:47262 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937Ab1KOORy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 09:17:54 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Sergei Shtylyov'" <sshtylyov@mvista.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2 1/5] davinci: dm644x: remove the macros from the
 header to move to c file
Date: Tue, 15 Nov 2011 14:17:38 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F750101ED@DBDE01.ent.ti.com>
References: <1321283357-27698-1-git-send-email-manjunath.hadli@ti.com>
 <1321283357-27698-2-git-send-email-manjunath.hadli@ti.com>
 <4EC24190.9010005@mvista.com>
In-Reply-To: <4EC24190.9010005@mvista.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sergei,

On Tue, Nov 15, 2011 at 16:10:16, Sergei Shtylyov wrote:
> Hello.
> 
> On 14-11-2011 19:09, Manjunath Hadli wrote:
> 
> > move the register base addresses and offsets used only by dm644x 
> > platform file from platform header dm644x.h to dm644x.c as they are 
> > used only in the c file.
> 
> > Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
> > ---
> >   arch/arm/mach-davinci/dm644x.c              |    6 ++++++
> >   arch/arm/mach-davinci/include/mach/dm644x.h |    7 -------
> >   2 files changed, 6 insertions(+), 7 deletions(-)
> 
> > diff --git a/arch/arm/mach-davinci/dm644x.c 
> > b/arch/arm/mach-davinci/dm644x.c index 3470983..1b4b911 100644
> > --- a/arch/arm/mach-davinci/dm644x.c
> > +++ b/arch/arm/mach-davinci/dm644x.c
> > @@ -34,6 +34,12 @@
> >    * Device specific clocks
> >    */
> >   #define DM644X_REF_FREQ		27000000
> 
>     Add an empty line here please.
Ok.

Regards,
--Manju
> 
> > +#define DM644X_EMAC_BASE		0x01c80000
> > +#define DM644X_EMAC_MDIO_BASE		(DM644X_EMAC_BASE + 0x4000)
> > +#define DM644X_EMAC_CNTRL_OFFSET	0x0000
> > +#define DM644X_EMAC_CNTRL_MOD_OFFSET	0x1000
> > +#define DM644X_EMAC_CNTRL_RAM_OFFSET	0x2000
> > +#define DM644X_EMAC_CNTRL_RAM_SIZE	0x2000
> >
> >   static struct pll_data pll1_data = {
> >   	.num       = 1,
> 
> WBR, Sergei
> 
> 

