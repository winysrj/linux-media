Return-path: <mchehab@pedra>
Received: from h5.dl5rb.org.uk ([81.2.74.5]:40944 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755404Ab1FXMJZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2011 08:09:25 -0400
Date: Fri, 24 Jun 2011 13:09:06 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] SOUND: Fix non-ISA_DMA_API build failure
Message-ID: <20110624120906.GB6327@linux-mips.org>
References: <20110623144750.GA10180@linux-mips.org>
 <s5hzkl7zlcq.wl%tiwai@suse.de>
 <20110624111608.GA6327@linux-mips.org>
 <4E04767A.5020201@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E04767A.5020201@infradead.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jun 24, 2011 at 08:35:22AM -0300, Mauro Carvalho Chehab wrote:

> Em 24-06-2011 08:16, Ralf Baechle escreveu:
> >         tristate "miroSOUND PCM20 radio"
> >         depends on ISA && VIDEO_V4L2 && SND
> >         select SND_ISA
> >         select SND_MIRO
> > 
> > So SND_ISA gets forced on even though the dependency on ISA_DMA_API is not
> > fulfilled.  That's solved by adding the dependency on ISA_DMA_API to
> > RADIO_MIROPCM20.
> 
> Another option would be to convert the two above selects into depends on.

Depends has the disadvantage that users may have to enable unobvious
options first before they are offered the one they are looking for and
that's what a "depends SND_ISA" would cause in this case.

  Ralf
