Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:37200 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab3AAQ4E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jan 2013 11:56:04 -0500
Received: by mail-ob0-f177.google.com with SMTP id uo13so12027312obb.8
        for <linux-media@vger.kernel.org>; Tue, 01 Jan 2013 08:56:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130101130041.52dee65f@redhat.com>
References: <1356739006-22111-1-git-send-email-mchehab@redhat.com>
	<CAGoCfix=2-pXmTE149XvwT+f7j1F29L3Q-dse0y_Rc-3LKucsQ@mail.gmail.com>
	<20130101130041.52dee65f@redhat.com>
Date: Tue, 1 Jan 2013 22:18:49 +0530
Message-ID: <CAHFNz9+hwx9Bpd5ZJC5RRchpvYzKUzzKv43PSzDunr403xiOsQ@mail.gmail.com>
Subject: Re: [PATCH RFCv3] dvb: Add DVBv5 properties for quality parameters
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 1, 2013 at 8:30 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:

> [RFCv4] dvb: Add DVBv5 properties for quality parameters
>
> The DVBv3 quality parameters are limited on several ways:
>         - Doesn't provide any way to indicate the used measure;
>         - Userspace need to guess how to calculate the measure;
>         - Only a limited set of stats are supported;
>         - Doesn't provide QoS measure for the OFDM TPS/TMCC
>           carriers, used to detect the network parameters for
>           DVB-T/ISDB-T;
>         - Can't be called in a way to require them to be filled
>           all at once (atomic reads from the hardware), with may
>           cause troubles on interpreting them on userspace;
>         - On some OFDM delivery systems, the carriers can be
>           independently modulated, having different properties.
>           Currently, there's no way to report per-layer stats;

per layer stats is a mythical bird, nothing of that sort does exist. If some
driver states that it is simply due to lack of knowledge at the coding side.

ISDB-T uses hierarchial modulation, just like DVB-S2 or DVB-T2

Once the Outer code is decoded, the OFDM segments are separated
using Hierarchial separation. This is well described by NHK.


"To improve mobile reception and robustness to multipath
interference, the system performs, in symbol units, time
interleaving plus frequency interleaving according to the
arrangement of OFDM segments. Pilot signals for
demodulation and control symbols consisting of TMCC
information are combined with information symbols to an
OFDM frame. Here, information symbols are modulated
by Differential Binary Phase Shift Keying (DBPSK) and
guard intervals are added at the IFFT output.

[3] Hierarchical transmission
A mixture of fixed-reception programs and mobile reception
programs in the transmission system is made
possible through the application of hierarchical
transmission achieved by band division within a channel.
"Hierarchical transmission" means that the three elements
of channel coding, namely, the modulation system, the
coding rate of convolutional correction code, and the time
interleave length, can be independently set. Time and
frequency interleaving are each performed in their
respective hierarchical data segment.
As described earlier, the smallest hierarchical unit in a
frequency spectrum is one OFDM segment."


Please don't muck up existing working things with uber crap.

Manu
