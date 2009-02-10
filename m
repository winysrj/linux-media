Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:37518 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbZBJJqX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 04:46:23 -0500
Date: Tue, 10 Feb 2009 10:45:37 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
cc: linux-media@vger.kernel.org,
	"DVB mailin' list thingy" <linux-dvb@linuxtv.org>
Subject: Re: DAB SFN (was: Re: [linux-dvb] dib0700 "buggy sfn workaround" or
 equivalent)
In-Reply-To: <alpine.DEB.2.01.0902100329540.1147@ybpnyubfg.ybpnyqbznva>
Message-ID: <alpine.LRH.1.10.0902101041360.24048@pub2.ifh.de>
References: <e021c7c00902090411j4df14a69me568a6022a5bc4d2@mail.gmail.com> <e021c7c00902090413l12af9229t8a4db36f7c4ce160@mail.gmail.com> <alpine.LRH.1.10.0902091442500.21232@pub2.ifh.de> <alpine.DEB.2.01.0902100329540.1147@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Barry,

On Tue, 10 Feb 2009, BOUWSMA Barry wrote:
> Is it in theory possible that this may be the source of some
> problems I experience receiving DAB radio, using a multi-
> element directional antenna, regardless of orientation, in
> a location with reception from at least two and possibly more
> than four senders within eyesight, or close to that?
>
> It's a completely different manufacturer (Siano) and the
> problem disappears when I simply use a short indoor whip
> antenna with adequate S/N ratio.

I'm not sure how Siano's demodulator is working (not to say, I don't know 
it at all) for SFNs.

Your scenario could also be explained with a too strong signal. When the 
ADC is saturated the reception is bad. Especially when not using in-can 
tuners (but silicon ones) you can face the issue easily.

But your problem could also be explained by a 100 of different things I 
don't know.

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
