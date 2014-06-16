Return-path: <linux-media-owner@vger.kernel.org>
Received: from dehamd003.servertools24.de ([31.47.254.18]:45808 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754138AbaFPHjU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 03:39:20 -0400
Message-ID: <539E9F25.7030504@ladisch.de>
Date: Mon, 16 Jun 2014 09:39:17 +0200
From: Clemens Ladisch <clemens@ladisch.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [alsa-devel] [PATCH 1/3] sound: Add a quirk to enforce period_bytes
References: <1402762571-6316-1-git-send-email-m.chehab@samsung.com> <1402762571-6316-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1402762571-6316-2-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(CC stable dropped; this is not how to submit stable patches.)

Mauro Carvalho Chehab wrote:
> The Auvitek 0828 chip, used on HVR950Q actually need two
> quirks and not just one.
>
> The first one, already implemented, enforces that it won't have
> channel swaps at the transfers.
>
> However, for TV applications, like xawtv and tvtime, another quirk
> is needed, in order to enforce that, at least 2 URB transfer
> intervals will be needed to fill a buffer.

> +			period = 2 * MAX_URBS * fp->maxpacksize;
> +			min_period = period * 90 / 100;
> +			max_period = period * 110 / 100;

I don't quite understand what you mean with "URB transfer interval".

All USB audio devices transfer packets in intervals between 125 µs and
1000 µs.

MAX_URBS is a somewhat random value that is not directly derived from
either a hardware or software constraint.

Are you trying to enforce two packets per URB?

Why are you setting both a minimum and a maximum?

Isn't this affected by the constraints of the playback device?

> Without it, buffer underruns happen when trying to syncronize the
> audio input from au0828 and the audio playback at the default audio
> output device.

This looks like a workaround for a userspace bug that would affect all
USB audio devices.  What period/buffer sizes are xawtv/tvtime trying to
use?


Regards,
Clemens
