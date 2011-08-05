Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:37428 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755365Ab1HEX4N (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2011 19:56:13 -0400
Date: Fri, 5 Aug 2011 16:56:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Ondrej Zary <linux@rainbow-software.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: Re: linux-next: Tree for Aug 5 (media/radio/radio-sf16fmr2)
Message-Id: <20110805165611.d2feaf32.rdunlap@xenotime.net>
In-Reply-To: <20110805143103.f9388ca143560d73caac60c1@canb.auug.org.au>
References: <20110805143103.f9388ca143560d73caac60c1@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 5 Aug 2011 14:31:03 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> [The kernel.org mirroring is running slowly today]

Is media/radio/radio-sf16fmr2 an ISA driver or a PCI driver?
ugh.  Or is it an I2C driver?


linux-next fails with (this is not a new failure):

ERROR: "snd_tea575x_init" [drivers/media/radio/radio-sf16fmr2.ko] undefined!
ERROR: "snd_tea575x_exit" [drivers/media/radio/radio-sf16fmr2.ko] undefined!

The Kconfig entry for RADIO_SF16FMR2 is:

config RADIO_SF16FMR2
	tristate "SF16FMR2 Radio"
	depends on ISA && VIDEO_V4L2 && SND

and the Kconfig entry for SND_TEA575X is (not user visible):

config SND_TEA575X
	tristate
	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2
	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2

This latter entry is in sound/pci/Kconfig and is under:
if SND_PCI
so it depends on PCI and SND_PCI.

This build fails when CONFIG_PCI is not enabled.


Suggestions?

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
