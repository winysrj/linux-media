Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp240.poczta.interia.pl ([217.74.64.240]:36219 "EHLO
	smtp240.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758496AbZKYKWz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 05:22:55 -0500
Date: 25 Nov 2009 11:23:00 +0100
From: krzysztof.h1@poczta.fm
Subject: =?UTF-8?q?Re:_Re:_[PATCH]_New_driver_for_the_radio_FM_module_on_Miro_PCM20_sound_card?=
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: TEXT/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Message-Id: <20091125102300.2CA573D1832@f53.poczta.interia.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Takashi Iwai" <tiwai@suse.de> pisze:
> At Tue, 24 Nov 2009 22:12:36 +0100,
> Krzysztof Helt wrote:
> > 
> > From: Krzysztof Helt <krzysztof.h1@wp.pl>
> > 
> > This is recreated driver for the FM module found on Miro
> > PCM20 sound cards. This driver was removed around the 2.6.2x
> > kernels because it relied on the removed OSS module. Now, it
> > uses a current ALSA module (snd-miro) and is adapted to v4l2
> > layer.
> > 
> > It provides only basic functionality: frequency changing and
> > FM module muting.
> > 
> > Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> > ---
> > This driver depends on changes to the snd-miro driver. These changes
> > are already accepted to the ALSA tree, but these changes 
> > won't be pushed into the 2.6.33 kernel.
> 
> Well, if we get ACK from V4L guys for this patch, I can merge it
> together with snd-miro changes for 2.6.33.  But, it should be done
> ASAP (preferably in this week).

This would be a good solution because the Miro card is borrowed and I have to
return it in 2-3 weeks. Any problems detected in these period can be patched 
and tested. Later, the test will be almost impossible (depends on will of the
guy who borrowed the card).

Regards,
Krzysztof

----------------------------------------------------------------------
Audi kilka tysiecy zlotych taniej? Przebieraj wsrod tysiecy ogloszen!
Kliknij >>> http://link.interia.pl/f2424

