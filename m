Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:53734 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZBJCqG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Feb 2009 21:46:06 -0500
Received: by bwz5 with SMTP id 5so2136844bwz.13
        for <linux-media@vger.kernel.org>; Mon, 09 Feb 2009 18:46:02 -0800 (PST)
Date: Tue, 10 Feb 2009 03:45:51 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Patrick Boettcher <patrick.boettcher@desy.de>
cc: linux-media@vger.kernel.org,
	DVB mailin' list thingy <linux-dvb@linuxtv.org>
Subject: DAB SFN (was: Re: [linux-dvb] dib0700 "buggy sfn workaround" or
 equivalent)
In-Reply-To: <alpine.LRH.1.10.0902091442500.21232@pub2.ifh.de>
Message-ID: <alpine.DEB.2.01.0902100329540.1147@ybpnyubfg.ybpnyqbznva>
References: <e021c7c00902090411j4df14a69me568a6022a5bc4d2@mail.gmail.com> <e021c7c00902090413l12af9229t8a4db36f7c4ce160@mail.gmail.com> <alpine.LRH.1.10.0902091442500.21232@pub2.ifh.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 9 Feb 2009, Patrick Boettcher wrote:

> It has nothing to with the channel bandwidth. In Australia, and maybe in 
> other places too, the DVB-T radio-channels (not to mix up with a radio 
> service) which are used in single-frequency-networks (SFNs) are 
> transmitted buggy: different transmitters are not using the same tps-data 
> (cellid IIRC). The dibcom-demods are using this information to improve the 
> reception robustness. This leads to synchronization losses, when the SFN 
> is not set up correctly...

Hijacking this bit of information...

Is it in theory possible that this may be the source of some
problems I experience receiving DAB radio, using a multi-
element directional antenna, regardless of orientation, in
a location with reception from at least two and possibly more
than four senders within eyesight, or close to that?

It's a completely different manufacturer (Siano) and the
problem disappears when I simply use a short indoor whip
antenna with adequate S/N ratio.

Note that so far, I haven't been able to extract more than
a subset of the metainformation which accompanies the
different audio streams, and I've had other hardware
problems, but I've been puzzled why I had not been able
to overcome the regular periodic mangling of the audio.


My knowledge of DAB is dismal, to start with, anyway.
So be gentle.  Unless you don't feel like it, or need
to let off steam.  Or whatever, treat me like a dog...

thanks,
barry bouwsma
