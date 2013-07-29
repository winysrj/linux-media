Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab3G2Ow1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 10:52:27 -0400
Date: Mon, 29 Jul 2013 16:53:53 +0200
Message-ID: <s5ha9l5e7su.wl%tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, alsa-devel@alsa-project.org,
	linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 0/2] tea575x: Move from sound to media
In-Reply-To: <1375041704-17928-1-git-send-email-linux@rainbow-software.org>
References: <1375041704-17928-1-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At Sun, 28 Jul 2013 22:01:42 +0200,
Ondrej Zary wrote:
> 
> 
> Hello,
> TEA575x is neither a sound device nor an i2c device. Let's finally move it 
> from sound/i2c/other to drivers/media/radio.
> 
> Tested with snd-es1968, snd-fm801 and radio-sf16fmr2.

Good to resolve messes there now.

For both patches,
  Acked-by: Takashi Iwai <tiwai@suse.de>

Feel free to move them into media git tree for 3.12 kernel.


thanks,

Takashi
