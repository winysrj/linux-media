Return-path: <linux-media-owner@vger.kernel.org>
Received: from 25.mail-out.ovh.net ([91.121.27.228]:56392 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758150Ab0EFNRm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 May 2010 09:17:42 -0400
Message-ID: <8f1b2ff0858f2aa153e600249dee95c4.squirrel@webmail.ovh.net>
In-Reply-To: <j2s83bcf6341005060536tf5283d7bo212076436801866a@mail.gmail.com>
References: <10683c6d21eb608c93a46b06b23ef73f.squirrel@webmail.ovh.net>
    <j2s83bcf6341005060536tf5283d7bo212076436801866a@mail.gmail.com>
Date: Thu, 6 May 2010 08:17:41 -0500 (GMT+5)
Subject: Re: Philips/NXP channel decoders
From: "Guillaume Audirac" <guillaume.audirac@webag.fr>
To: "Steven Toth" <stoth@kernellabs.com>
Cc: linux-media@vger.kernel.org
Reply-To: guillaume.audirac@webag.fr
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Steven,

> I can test your TDA10048 patches and add sign-off for merge. Looking
> at the list it appears that you have a few nice cleanups. I'll draw
> all of these together this weekend and run some tests.

Thanks a lot.
By the way, I found the read_ber function not fully defined. I guess this
subject has already been addressed on this list but cannot pinpoint where
in the archives. Did I miss something ?

First, *ber is an unsigned integer type, then the bit-error-rate (<=1) has
obviously to be made higher than 1. I have decided to multiply the actual
ber into 1e8 for two reasons:
- 1e-8 offers a good precision and is compatible with what can give the
TDA10046/TDA10048 for the VBER
- the theoretical max value (1 -> 1e8) fits into the u32 type

Naturally, this factor of 1e8 should be defined to be homogeneous for all
channel decoders as the read_ber function is exposed.

Second, the returned BER is the channel bit-error-rate which is the BER
estimation before the Viterbi decoder (for DVB-T). Why this choice ?

Thanks in advance for clarifying.

-- 
Guillaume

