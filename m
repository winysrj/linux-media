Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:53096 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab1KQK7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 05:59:46 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Sergei Shtylyov'" <sshtylyov@mvista.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v3 4/5] ARM: davinci: create new common platform header
 for davinci
Date: Thu, 17 Nov 2011 10:59:35 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F750107D5@DBDE01.ent.ti.com>
References: <1321525138-3928-1-git-send-email-manjunath.hadli@ti.com>
 <1321525138-3928-5-git-send-email-manjunath.hadli@ti.com>
 <4EC4E671.8030105@mvista.com>
In-Reply-To: <4EC4E671.8030105@mvista.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sergei,
  Thank you for the comments.

On Thu, Nov 17, 2011 at 16:18:17, Sergei Shtylyov wrote:
> Hello.
> 
> On 17-11-2011 14:18, Manjunath Hadli wrote:
> 
> > remove the code from individual platform header files for dm365, 
> > dm355, dm644x and dm646x and consolidate it into a single and common 
> > header file davinci_common.h.
> > Include the new header file in individual platform header files as a 
> > pre-cursor for deleting these headers in follow up patches.
> 
> > Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
> [...]
> 
> > diff --git a/arch/arm/mach-davinci/include/mach/davinci.h 
> > b/arch/arm/mach-davinci/include/mach/davinci.h
> > new file mode 100644
> > index 0000000..49bf2f3
> > --- /dev/null
> > +++ b/arch/arm/mach-davinci/include/mach/davinci.h
> > @@ -0,0 +1,88 @@
> [...]
> > +/* DM355 base addresses */
> > +#define DM355_ASYNC_EMIF_CONTROL_BASE	0x01e10000
> > +#define DM355_ASYNC_EMIF_DATA_CE0_BASE	0x02000000
> 
> > +/* DM365 base addresses */
> > +#define DM365_ASYNC_EMIF_CONTROL_BASE	0x01d10000
> > +#define DM365_ASYNC_EMIF_DATA_CE0_BASE	0x02000000
> > +#define DM365_ASYNC_EMIF_DATA_CE1_BASE	0x04000000
> 
>     Note that DM355/365 EMIF CE0/1 bases are similar -- perhaps it's worth to have the single definition for them now, like DM3X5_ASYNC_EMIF_DATA_CE<n>_BASE.
There is only DM355 and DM365. DM3X5 has not been used anywhere till now.
Too much generalization in naming might lead to confusion?
I guess we will keep it as-is for the sake of clarity. What do you say?

> 
> WBR, Sergei
> 

Thank s and Regards,
-Manju
