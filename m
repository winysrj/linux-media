Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:53796 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754936AbeDTNJL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 09:09:11 -0400
Date: Fri, 20 Apr 2018 10:09:05 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: <alsa-devel@alsa-project.org>,
        "Mauro Carvalho Chehab" <mchehab@infradead.org>,
        "Jaroslav Kysela" <perex@perex.cz>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/4] sound, media: allow building ISA drivers it with
 COMPILE_TEST
Message-ID: <20180420100905.51e04e82@vento.lan>
In-Reply-To: <s5h36zqvxug.wl-tiwai@suse.de>
References: <cover.1524227382.git.mchehab@s-opensource.com>
        <3f4d8ae83a91c765581d9cbbd1e436b6871368fa.1524227382.git.mchehab@s-opensource.com>
        <s5h7ep2vysl.wl-tiwai@suse.de>
        <20180420095129.2b7d004d@vento.lan>
        <s5h36zqvxug.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 20 Apr 2018 14:58:15 +0200
Takashi Iwai <tiwai@suse.de> escreveu:

> On Fri, 20 Apr 2018 14:51:29 +0200,
> Mauro Carvalho Chehab wrote:
> > 
> > Em Fri, 20 Apr 2018 14:37:46 +0200
> > Takashi Iwai <tiwai@suse.de> escreveu:
> >   
> > > On Fri, 20 Apr 2018 14:32:15 +0200,
> > > Mauro Carvalho Chehab wrote:  
> > > > 
> > > > All sound drivers that don't depend on PNP can be safelly
> > > > build with COMPILE_TEST, as ISA provides function stubs to
> > > > be used for such purposes.
> > > > 
> > > > As a side effect, with this change, the radio-miropcm20
> > > > can now be built outside i386 with COMPILE_TEST.
> > > > 
> > > > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > > > ---
> > > >  drivers/media/radio/Kconfig | 3 ++-
> > > >  sound/isa/Kconfig           | 9 +++++----
> > > >  2 files changed, 7 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> > > > index d363726e9eb1..8fa403c7149e 100644
> > > > --- a/drivers/media/radio/Kconfig
> > > > +++ b/drivers/media/radio/Kconfig
> > > > @@ -372,7 +372,8 @@ config RADIO_GEMTEK_PROBE
> > > >  
> > > >  config RADIO_MIROPCM20
> > > >  	tristate "miroSOUND PCM20 radio"
> > > > -	depends on ISA && ISA_DMA_API && VIDEO_V4L2 && SND
> > > > +	depends on ISA || COMPILE_TEST
> > > > +	depends on ISA_DMA_API && VIDEO_V4L2 && SND
> > > >  	select SND_ISA
> > > >  	select SND_MIRO
> > > >  	---help---
> > > > diff --git a/sound/isa/Kconfig b/sound/isa/Kconfig
> > > > index cb54d9c0a77f..d2a6cdd0395c 100644
> > > > --- a/sound/isa/Kconfig
> > > > +++ b/sound/isa/Kconfig
> > > > @@ -20,7 +20,8 @@ config SND_SB16_DSP
> > > >  
> > > >  menuconfig SND_ISA
> > > >  	bool "ISA sound devices"
> > > > -	depends on ISA && ISA_DMA_API
> > > > +	depends on ISA || COMPILE_TEST
> > > > +	depends on ISA_DMA_API
> > > >  	default y
> > > >  	help
> > > >  	  Support for sound devices connected via the ISA bus.
> > > > @@ -38,7 +39,7 @@ config SND_ADLIB
> > > >  
> > > >  config SND_AD1816A
> > > >  	tristate "Analog Devices SoundPort AD1816A"
> > > > -	depends on PNP
> > > > +	depends on PNP && ISA
> > > >  	select ISAPNP
> > > >  	select SND_OPL3_LIB
> > > >  	select SND_MPU401_UART    
> > > 
> > > Just from curiosity: what's the reason for this explicit CONFIG_ISA
> > > dependency?  What error did you get?  
> > 
> > Kconfig complains with "select ISAPNP":
> > 
> > WARNING: unmet direct dependencies detected for ISAPNP
> >   Depends on [n]: PNP [=y] && ISA [=n]
> >   Selected by [y]:
> >   - SND_AD1816A [=y] && SOUND [=y] && !UML && SND [=y] && SND_ISA [=y] && PNP [=y]
> > 
> > Because it is declared as:
> > 
> > config ISAPNP
> > 	bool "ISA Plug and Play support"
> >         depends on ISA  
> 
> I see.  Then it'd be better to put this explanations in the changelog
> as well.

Added. See enclosed.

> 
> > I could have tried to change ISAPNP to depends on ISA || COMPILE_TEST,
> > but I suspect that would touch on yet another subsystem and has
> > the potential to point to other things that need changes, as
> > a lot more drivers will be selected.
> > 
> > Anyway, after a quick look at include/linux/isapnp.h, I suspect
> > that this can work.
> > 
> > I'll run some tests here.  
> 
> At least a dumb stub is there, so let's hope we can widen the test
> coverage :)

Yes, that's the idea :-)

Right now, for every patch I receive, I build media drivers for i386
(I just made all of them build on i386), but I'm considering doing such
builds on x86_64 instead, as it also enables compat32 code.

Thanks,
Mauro

[PATCH v2] sound, media: allow building ISA drivers it with COMPILE_TEST

All sound drivers that don't depend on PNP can be safelly
build with COMPILE_TEST, as ISA provides function stubs to
be used for such purposes.

As a side effect, with this change, the radio-miropcm20
can now be built outside i386 with COMPILE_TEST.

It should be noticed that ISAPNP currently depends on ISA.
So, on drivers that depend on it, we need to add an
explicit dependency on ISA, at least until another patch
removes it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

---

v2: only patch description changed, with the addition of a note
about ISA explicit dependency on 3 drivers.


diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index d363726e9eb1..8fa403c7149e 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -372,7 +372,8 @@ config RADIO_GEMTEK_PROBE
 
 config RADIO_MIROPCM20
 	tristate "miroSOUND PCM20 radio"
-	depends on ISA && ISA_DMA_API && VIDEO_V4L2 && SND
+	depends on ISA || COMPILE_TEST
+	depends on ISA_DMA_API && VIDEO_V4L2 && SND
 	select SND_ISA
 	select SND_MIRO
 	---help---
diff --git a/sound/isa/Kconfig b/sound/isa/Kconfig
index cb54d9c0a77f..d2a6cdd0395c 100644
--- a/sound/isa/Kconfig
+++ b/sound/isa/Kconfig
@@ -20,7 +20,8 @@ config SND_SB16_DSP
 
 menuconfig SND_ISA
 	bool "ISA sound devices"
-	depends on ISA && ISA_DMA_API
+	depends on ISA || COMPILE_TEST
+	depends on ISA_DMA_API
 	default y
 	help
 	  Support for sound devices connected via the ISA bus.
@@ -38,7 +39,7 @@ config SND_ADLIB
 
 config SND_AD1816A
 	tristate "Analog Devices SoundPort AD1816A"
-	depends on PNP
+	depends on PNP && ISA
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -66,7 +67,7 @@ config SND_AD1848
 
 config SND_ALS100
 	tristate "Diamond Tech. DT-019x and Avance Logic ALSxxx"
-	depends on PNP
+	depends on PNP && ISA
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -107,7 +108,7 @@ config SND_AZT2316
 
 config SND_AZT2320
 	tristate "Aztech Systems AZT2320"
-	depends on PNP
+	depends on PNP && ISA
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
