Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:11899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab1FSRoB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 13:44:01 -0400
Date: Sun, 19 Jun 2011 14:42:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@redhat.com>,
	alsa-devel@alsa-project.org
Subject: [PATCH 00/11] em28xx improvements
Message-ID: <20110619144246.76c25ff9@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Douglas borrowed me a couple devices some time ago. I've made
some patches for the first one, but never had time to look at
the second device, until this weekend, when I re-discovered
it: An em2861-based device: a Kworld 305.

On em2861, the audio interface is provided by a separate device,
breaking the audio detection rules.

With this device in hands, and using xawtv with audio support, I
decided to make it work.

This patch series contains:
	- a few em28xx driver random fixes;
	- support for compiling em28xx driver without IR support;
	- Mixer control for em28xx-based devices with AC97 mixer;
	- Add support for the USB vendor audio class at interface 1.

Most em28xx hardware comes with an AC97 mixer (in general,
emp202, also manufactured by Empiatech). In general, different
types of input (TV, Svideo, Composite) uses different audio
inputs at the mixer. Some devices also provide two different outputs
(one for the audio out plug, and another for DMA transfers).
Each vendor has its own way to connect the device.

The em28xx cards contain the logic to mute/unmute the entries
associated with each input, so the direct access to the mixer
is interesting only if someone wants to do things like using
more than one entry at the same time, or controlling the volume
for whatever reason.

With this setup, pulseaudio does the wrong thing: it just assumes
that the master volume controls the device. On all tree devices
I used for tests, this volume doesn't control the PCM output.

I think that, on one of them, the Master is used to control the
Audio Out jack output (seldomly used, on an usb device).

Anyway, this is something that needs to be solved at pulseaudio,
not inside the kernel (or, at least, I dunno any way for a driver
to tell pulseaudio to not try to mask the audio controls).

Mauro Carvalho Chehab (11):
  [media] em28xx: Don't initialize a var if won't be using it
  [media] em28xx: Fix a wrong enum at the ac97 control tables
  [media] em28xx: Allow to compile it without RC/input support
  [media] em28xx-alsa: add mixer support for AC97 volume controls
  [media] em28xx-audio: add support for mute controls
  [media] em28xx-audio: volumes are inverted
  [media] em28xx-audio: add debug info for the volume control
  [media] em28xx-audio: Properly report failures to start stream
  [media] em28xx-audio: Some Alsa API fixes
  [media] em28xx: Add support for devices with a separate audio interface
  [media] em28xx: Mark Kworld 305 as validated

 drivers/media/video/em28xx/Kconfig        |   10 +-
 drivers/media/video/em28xx/Makefile       |    6 +-
 drivers/media/video/em28xx/em28xx-audio.c |  253 ++++++++++++++++++++++++++---
 drivers/media/video/em28xx/em28xx-cards.c |  104 +++++++++----
 drivers/media/video/em28xx/em28xx-core.c  |   37 +++--
 drivers/media/video/em28xx/em28xx-i2c.c   |    2 -
 drivers/media/video/em28xx/em28xx.h       |   20 +++
 7 files changed, 355 insertions(+), 77 deletions(-)

