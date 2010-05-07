Return-path: <linux-media-owner@vger.kernel.org>
Received: from 25.mail-out.ovh.net ([91.121.27.228]:41281 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751127Ab0EGEjQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 May 2010 00:39:16 -0400
Message-ID: <5a07650fa788200a5704379bc3e47890.squirrel@webmail.ovh.net>
In-Reply-To: <i2h83bcf6341005060540sb9e841d2jbf1f8f8c81bd9bb9@mail.gmail.com>
References: <f8f6b7c78cd8469f838fc084573dbe8b.squirrel@webmail.ovh.net>
    <i2h83bcf6341005060540sb9e841d2jbf1f8f8c81bd9bb9@mail.gmail.com>
Date: Thu, 6 May 2010 23:39:13 -0500 (GMT+5)
Subject: Re: [PATCH] dvb_frontend: fix typos in comments and one function
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

> I've had an open TDA10048 bug on my list for quite a while, I think
> you've already made reference to this in an earlier email. Essentially
> I'm told my a number of Australian users that the 10048 isn't
> broad-locking when tuned +- 167Khz away from the carrier, which it
> should definitely do. If you're in the mood for patching the 10048 and
> want to find and flip the broad-locking bit then I'd be certainly
> thrilled to test this. :)

Well, this is an interesting subject and there is a lot to say. Sorry in
advance if you already know what I will explain:
- the channel distribution is usually well known in DVB-T. For example,
from 474MHz to 858MHz in UHF/8MHz. This channel distribution depends on
each country.
- due to the existing analogue channels, some FIXED frequency offsets have
been introduced here and there to move the DVB-T channel away from the
analogue channels depending on how critical it can be.
These frequency offsets are commonly +/-166KHz everywhere, except in
France (+/-N*166KHz with N=1,2,3) and in Australia (+/-125KHz) as far as I
know.
- hence the DVB-T channel can be shifted in IF by +/-125KHz, +/-166KHz,
+/-333KHz, +/-500KHz. The channel decoder will or will not recover such an
offset depending on the strategy. If it can lock, the IF signal will be
partially filtered out by the IF filter and this impacts the performance.
The best approach is to detect the potential frequency offset and
re-program the tuner to the new frequency.

Now about the TDA10048:
- it naturally recovers the small offsets during the lock (error returned
in FREQERR_R at 0x28 & 0x29):
in 8MHz: +/-93KHz
in 7MHz: +/-82KHz
in 6MHz: +/-70KHz
- the AUTOOFFSET bit allows to detect the fixed frequency offset whose
value is returned in OFFSET_F (in 0x14) when there is no lock. If an
offset is detected, it is applied to the tuner, then AUTOOFFSET is set to
0 and the acquisition is checked again. This is the normal and preferred
way.

The non-recommended option is to force the lock when a fixed offset is
detected without reprogramming the tuner. This is possible only with
certain firmware versions (>=0x34), in forcing 1 in register 0x19[0], the
fixed offset will still be available in OFFSET_F after the lock. For
earlier firmware versions, the 0x19[0] bit has no effect.

Ideally, for the channel demodulator driver, the API should provide an
interface to set the frequency offset recovery (AUTO, NONE...) and to get
the detected frequency offset if any.

-- 
Guillaume

