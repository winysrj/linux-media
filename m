Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab2ETL2L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 07:28:11 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: hverkuil@xs4all.nl
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] bttv: Use btv->has_radio rather then the card info
Date: Sun, 20 May 2012 13:28:11 +0200
Message-Id: <1337513292-3321-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've been spending some time playing with radio receivers under Linux, and
I noticed that my bttv's radio reception was not working. The patch in the
next message fixes the 1st of 3 problems related to this, can you review this
patch please and also let me know if it is ok to send patch though my tree?

As said there are 3 problems with the radio on my bttv:
1) The problem fixed by the attached patch

2) The audio_mux function in bttv-driver.c does the wrong thing for my
Haupage WinTV + radio + stereo (msp3400) card. Since the radio receiving
is part of the same tuner, and not in a separate chip, the same (default
) msp3400 input should be selected when trying to listen to radio, as when
watching TV.

I could special case my card in audio_mux, but in general it seems
to me that if their is a combined radio/tv tuner, rather then a separate
radio chip (ie the tea5757), the msp3400 input should stay connected
to the default / tuner1 input.

I guess we should go with special casing for now, to avoid regressions,
although I wonder how many people try to use the radio part of any tvcards
they may have.

3) The automatic selection of radio versus tv-mode goes astray pretty quickly,
if I start the radio program from xawtv, which I've patched in git to do
digital loopback of the audio through alsa, so as that I can actual hear
what the radio is doing :) And with a quick hack to fix 2), and then after
that start gtk-v4l to look at the radio controls (only the mute one actually),
then bttv automatically switches from radio to tv mode, not good (tm).

IMHO it would be better to defer the switching to tv mode until something
relevant is actually done to the /dev/video# node (set operations or start
streaming), likewise it would probably be best to defer switching to radio
mode until something relevant (any set operations) is actually done on
/dev/radio#. If you agree I can try to write a patch for this.

Regards,

Hans
