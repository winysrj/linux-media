Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:47444 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213Ab1KON4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 08:56:06 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Sergei Shtylyov'" <sshtylyov@mvista.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2 4/5] davinci: create new common platform header for
 davinci
Date: Tue, 15 Nov 2011 13:55:50 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F750101C7@DBDE01.ent.ti.com>
References: <1321283357-27698-1-git-send-email-manjunath.hadli@ti.com>
 <1321283357-27698-5-git-send-email-manjunath.hadli@ti.com>
 <4EC238E2.3040600@mvista.com>
In-Reply-To: <4EC238E2.3040600@mvista.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sergei,

On Tue, Nov 15, 2011 at 15:33:14, Sergei Shtylyov wrote:
> Hello.
> 
> On 14-11-2011 19:09, Manjunath Hadli wrote:
> 
> > remove the code from individual platform header files for dm365, 
> > dm355, dm644x and dm646x and consolidate it into a single and common 
> > header file davinci_common.h.
> > Include the new header file in individual platform header files as a 
> > pre-cursor for deleting these headers in follow up patches.
> 
> > Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
> > ---
> >   .../arm/mach-davinci/include/mach/davinci_common.h |   88 ++++++++++++++++++++
> >   arch/arm/mach-davinci/include/mach/dm355.h         |   18 +----
> >   arch/arm/mach-davinci/include/mach/dm365.h         |   20 +----
> >   arch/arm/mach-davinci/include/mach/dm644x.h        |   15 +---
> >   arch/arm/mach-davinci/include/mach/dm646x.h        |   20 +----
> >   5 files changed, 92 insertions(+), 69 deletions(-)
> >   create mode 100644 
> > arch/arm/mach-davinci/include/mach/davinci_common.h
> 
> > diff --git a/arch/arm/mach-davinci/include/mach/davinci_common.h 
> > b/arch/arm/mach-davinci/include/mach/davinci_common.h
> > new file mode 100644
> > index 0000000..a859318
> > --- /dev/null
> > +++ b/arch/arm/mach-davinci/include/mach/davinci_common.h
> 
>     Why not call it just davinci.h?
  Ok.

Regards,
--Manju
> 
> WBR, Sergei
> 

