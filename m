Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3632 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab3GZLta (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 07:49:30 -0400
Message-ID: <51F26238.8020503@xs4all.nl>
Date: Fri, 26 Jul 2013 13:49:12 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [RFC PATCH 0/2] tea575x: Move from sound to media
References: <201306132342.28143.linux@rainbow-software.org>
In-Reply-To: <201306132342.28143.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ondrej!

On 06/13/2013 11:42 PM, Ondrej Zary wrote:
> Hello,
> TEA575x is neither a sound device nor an i2c device. Let's finally move it 
> from sound/i2c/other to drivers/media/radio.
> 
> Tested with snd-es1968, snd-fm801 and radio-sf16fmr2.
> 
> I guess the Kconfig dependencies are not correct.

Thanks for looking at this. Moving this module makes a lot of sense.

I looked at the Kconfig dependencies and I suggest the changes in the diff below.
I did some testing with make menuconfig, trying various combinations of 'y' and 'M'
and this handled everything I threw at it :-)

If you agree with this, can you make a new patch series? It might be best to wait
until your other changes to tea575x have been merged into media_tree.git.
I've accepted those and will post a pull request for them Monday at the latest.

I need an Ack from the alsa maintainer as well.

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/medidiff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index d529ba7..39882dd 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -12,6 +12,9 @@ menuconfig RADIO_ADAPTERS
 
 if RADIO_ADAPTERS && VIDEO_V4L2
 
+config RADIO_TEA575X
+	tristate
+
 config RADIO_SI470X
 	bool "Silicon Labs Si470x FM Radio Receiver support"
 	depends on VIDEO_V4L2
@@ -61,7 +64,8 @@ config USB_DSBR
 
 config RADIO_MAXIRADIO
 	tristate "Guillemot MAXI Radio FM 2000 radio"
-	depends on VIDEO_V4L2 && PCI && SND
+	depends on VIDEO_V4L2 && PCI
+	select RADIO_TEA575X
 	---help---
 	  Choose Y here if you have this radio card.  This card may also be
 	  found as Gemtek PCI FM.
@@ -76,7 +80,8 @@ config RADIO_MAXIRADIO
 
 config RADIO_SHARK
 	tristate "Griffin radioSHARK USB radio receiver"
-	depends on USB && SND
+	depends on USB
+	select RADIO_TEA575X
 	---help---
 	  Choose Y here if you have this radio receiver.
 
@@ -393,7 +398,8 @@ config RADIO_SF16FMI
 
 config RADIO_SF16FMR2
 	tristate "SF16-FMR2/SF16-FMD2 Radio"
-	depends on ISA && VIDEO_V4L2 && SND
+	depends on ISA && VIDEO_V4L2
+	select RADIO_TEA575X
 	---help---
 	  Choose Y here if you have one of these FM radio cards.
 
diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index fe6fa93..9df80ef 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -1,10 +1,5 @@
 # ALSA PCI drivers
 
-config SND_TEA575X
-	tristate
-	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2 || RADIO_MAXIRADIO || RADIO_SHARK
-	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2 || RADIO_MAXIRADIO || RADIO_SHARK
-
 menuconfig SND_PCI
 	bool "PCI sound devices"
 	depends on PCI
@@ -542,7 +537,9 @@ config SND_ES1968_INPUT
 config SND_ES1968_RADIO
 	bool "Enable TEA5757 radio tuner support for es1968"
 	depends on SND_ES1968
+	depends on MEDIA_RADIO_SUPPORT
 	depends on VIDEO_V4L2=y || VIDEO_V4L2=SND_ES1968
+	select RADIO_TEA575X
 	help
 	  Say Y here to include support for TEA5757 radio tuner integrated on
 	  some MediaForte cards (e.g. SF64-PCE2).
@@ -562,7 +559,9 @@ config SND_FM801
 config SND_FM801_TEA575X_BOOL
 	bool "ForteMedia FM801 + TEA5757 tuner"
 	depends on SND_FM801
+	depends on MEDIA_RADIO_SUPPORT
 	depends on VIDEO_V4L2=y || VIDEO_V4L2=SND_FM801
+	select RADIO_TEA575X
 	help
 	  Say Y here to include support for soundcards based on the ForteMedia
 	  FM801 chip with a TEA5757 tuner (MediaForte SF256-PCS, SF256-PCP and
