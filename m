Return-path: <mchehab@pedra>
Received: from h5.dl5rb.org.uk ([81.2.74.5]:37970 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751094Ab1FXNI3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2011 09:08:29 -0400
Date: Fri, 24 Jun 2011 14:08:18 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jaroslav Kysela <perex@perex.cz>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
	linux-mips@linux-mips.org
Subject: Re: [PATCH] SOUND: Fix non-ISA_DMA_API build failure
Message-ID: <20110624130818.GC6327@linux-mips.org>
References: <20110623144750.GA10180@linux-mips.org>
 <s5hzkl7zlcq.wl%tiwai@suse.de>
 <20110624111608.GA6327@linux-mips.org>
 <s5hzkl72zce.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hzkl72zce.wl%tiwai@suse.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jun 24, 2011 at 02:22:41PM +0200, Takashi Iwai wrote:

> >  o The drivers/media/radio/Kconfig part should be applied for 3.0 and
> >    maybe -stable.
> 
> Yes, this will be good.

I just tested that segment only and it works as expected.  Will repost in
a minute.

> >  o The sound/isa/Kconfig part is basically only fixing the dependency for
> >    the Adlib driver allowing it to be built on non-ISA_DMA_API system and
> >    is material for the next release after 3.0.
> 
> Any serious reason that snd-adlib must be built even with ISA=n?

Definately not.

> As the device is really present only for ISA, it doesn't make much
> sense to build this even though the driver itself doesn't need
> ISA_DMA_API.

I'm not aware of any systems that could use the Adlib in a ISA=n
environment.  That's why my patch left the dependency on ISA untouched.

  Ralf
