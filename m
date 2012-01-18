Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35329 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510Ab2ARNuT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 08:50:19 -0500
Received: by werb13 with SMTP id b13so366726wer.19
        for <linux-media@vger.kernel.org>; Wed, 18 Jan 2012 05:50:17 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] [RFC] dib8000: return an error if the TMCC is not locked
Date: Wed, 18 Jan 2012 14:50:13 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1326825928-29894-1-git-send-email-mchehab@redhat.com> <201201181349.57722.pboettcher@kernellabs.com> <4F16CBB9.7030801@redhat.com>
In-Reply-To: <4F16CBB9.7030801@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201181450.14089.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 18 January 2012 14:40:09 Mauro Carvalho Chehab wrote:
> Em 18-01-2012 10:49, Patrick Boettcher escreveu:
> > On Tuesday 17 January 2012 19:45:28 you wrote:
> >> On ISDB-T, a few carriers are reserved for TMCC decoding
> >> (1 to 20 carriers, depending on the mode). Those carriers
> >> use the DBPSK modulation, and contain the information about
> >> each of the three layers of carriers (modulation, partial
> >> reception, inner code, interleaving, and number of segments).
> >> 
> >> If the TMCC carrier was not locked and decoded, no information
> >> would be provided by get_frontend(). So, instead of returning
> >> false values, return -EAGAIN.
> >> 
> >> Another alternative for this patch would be to add a flag to
> >> fe_status (FE_HAS_GET_FRONTEND?), to indicate that the ISDB-T
> >> TMCC carriers (and DVB-T TPS?), required for get_frontend
> >> to work, are locked.
> >> 
> >> Comments?
> > 
> > I think it changes the behaviour of get_frontend too much and in
> > fact transmission parameter signaling (TPS for DVB-T, TMCC for
> > ISDB-T) locks are already or should be if not integrated to the
> > status locks.
> > 
> > Also those parameters can change over time and signal a
> > "reconfiguration" of the transmission.
> > 
> > So, for me I would vote against this kind of implementation in
> > favor a better one. Unfortunately I don't have a much better idea
> > at hand right now.
> 
> The current status are:
> 
> typedef enum fe_status {
>         FE_HAS_SIGNAL   = 0x01,   /* found something above the noise
> level */ FE_HAS_CARRIER  = 0x02,   /* found a DVB signal  */
>         FE_HAS_VITERBI  = 0x04,   /* FEC is stable  */
>         FE_HAS_SYNC     = 0x08,   /* found sync bytes  */
>         FE_HAS_LOCK     = 0x10,   /* everything's working... */
>         FE_TIMEDOUT     = 0x20,   /* no lock within the last ~2
> seconds */ FE_REINIT	= 0x40    /* frontend was reinitialized,  */ }
> fe_status_t;                    /* application is recommended to
> reset */
> 
> There are a few options that can be done:
> 
> 1) only rise FE_HAS_LOCK if TPS/TMCC demod were locked. The
> "description" for FE_HAS_LOCK ("everything's working") seems to
> indicate that TMCC lock/TPS lock is also part of "everything".

HAS_LOCK includes TPS-lock, right. But TPS-lock can raise much before 
HAS_LOCK and at worse signal conditions. In DVB-T and ISDB-T we can have 
the parameters at -1 dB SNR (or below) whereas data reception at least 
needs  ~3 dB ( QPSK 1/2 in DVB-T)  and much more for the modulations 
used currently on earth.

> 2) create a new status for it.

Maybe that's the way to go then. FE_HAS_PARAMETERS.

> With regards to dvb-core get_frontend() call, it only makes sense if
> the TPS/TMCC is locked. So, I think that such call needs to be
> limited to happen only when the lock were archived, like the
> enclosed patch.

OK.

--
Patrick Boettcher

Kernel Labs Inc.
http://www.kernellabs.com/
