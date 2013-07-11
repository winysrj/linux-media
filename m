Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:35709 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab3GKMwF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 08:52:05 -0400
Received: by mail-qa0-f44.google.com with SMTP id o13so7585378qaj.17
        for <linux-media@vger.kernel.org>; Thu, 11 Jul 2013 05:52:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <01ab01ce7df1$e92cc9e0$bb865da0$@blueflowamericas.com>
References: <010c01ce7365$9181ff30$b485fd90$@blueflowamericas.com>
	<CAGoCfiyjeqxVV8A_MM-iV58=s48FEhNPA=5MPg3WAOAKs8d2iA@mail.gmail.com>
	<011901ce73ab$9b81cce0$d28566a0$@blueflowamericas.com>
	<CALzAhNV7Cv9SR1C2mpgtLTwxD_grCZeOWc6O-2XpJEAKg1mX6w@mail.gmail.com>
	<017101ce7c5b$6899c860$39cd5920$@blueflowamericas.com>
	<CALzAhNVo0gi1HZ5TH9oXnUpgsqKa+YL=uGLvQNYxqj6gLd2upw@mail.gmail.com>
	<017801ce7d0e$73eeff60$5bccfe20$@blueflowamericas.com>
	<CALzAhNULmGJSXvGogBFV4KXFH4OBvSydbJQ_7PbAnMAmwByjjA@mail.gmail.com>
	<019d01ce7de9$f620cdc0$e2626940$@blueflowamericas.com>
	<01ab01ce7df1$e92cc9e0$bb865da0$@blueflowamericas.com>
Date: Thu, 11 Jul 2013 08:52:04 -0400
Message-ID: <CALzAhNUorCeGGp+uLPObiybQ=7M00_eyCj1PyAWWQDSORvF7ag@mail.gmail.com>
Subject: Re: FW: lgdt3304
From: Steven Toth <stoth@kernellabs.com>
To: Carl-Fredrik Sundstrom <cf@blueflowamericas.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Carl,

Thanks for writing. Please CC the mailing list at all times.

Comments below.

On Thu, Jul 11, 2013 at 12:48 AM, Carl-Fredrik Sundstrom
<cf@blueflowamericas.com> wrote:
> I don't know what happened to the dmeg log formatting when I pasted it I
> cleaned it up below.
> I can't see anything obvious that fail when scanning, it just starts on the
> next frequency after getting a lock

Ignore scan for now, use the azap tools with the -r arg and dvbtraffic
tools in two different terminal sessions.

azap -r FOX, will tune fox reliably for you, as your log messages
below indicate tuner and demodulator lock. This is good. This implies
the tuner and demodulator are most likely configured for RF reception,
this is a big part of the problem solved.

dvbtraffic will show all/any transmitter data coming from the
demodulator and entering the kernel. The display is a breakdown pid by
pid on how much data 'per pid' is being received by the kernel (from
the card). In your case the answer will be zero, or occasional junk.
Normal conditions shows 10-25 lines of stable text, show Mbp/s per
pid. (Goal being 19.2) for stable reception.

>
> Probably will give up un this and get that other card.

You're close, don't give up.

Better yet, finish the work, publish it _THEN_ buy the other card,
it's a little better in my opinion ;)

>
> Thanks /// Carl
>
> [ 4806.292479] lgdt3305_read_status: SIGNALEXIST INLOCK SYNCLOCK NOFECERR
> SNRGOOD
> [ 4806.292481] lgdt3305_read_reg: reg: 0x011d
> [ 4806.292957] lgdt3305_read_cr_lock_status: (1) CLOCKVSB
> [ 4807.448098] lgdt3305_get_tune_settings:
>
>
> tridentsx@tridentsx-P5K-E:~/.kde/share/apps/kaffeine$ azap FOX using
> '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 599028615 Hz
> video pid 0x0031, audio pid 0x0034
> status 01 | signal 0000 | snr 0000 | ber 00000000 | unc 0000ca8b |
> status 1f | signal 8e53 | snr 00c4 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal 907a | snr 00c5 | ber 00000000 | unc 00000165 |
> FE_HAS_LOCK
> status 1f | signal 8dc8 | snr 00c4 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal 8d3f | snr 00c1 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK

This is very good. The tuner and demodulator are locked to FOX and
your error counts are well within acceptable ranges. Congratulations.

>
> However when I try to view or scan channels in mplayer or kaffeine it can't
> find them and there are some timeouts Similar to the ones I got in scan
> utility.

This is invariably because the electrical interface between the LG
demod and the host controller (PCIe or USB - whatever your card is)
has been incorrectly configured, or not configured at all. I don't
know the specifics of that card so I need to talk generally here.

1. Demodulators and host controllers usually transmit data over either
a serial or parallel data bus. Each bus has slightly different control
lines to indicate such things as CLOCK, START_OF_PACKET, TSVAL, TSERR,
along with the data lines. The control lines help the demod tell the
host controller about the state of the data on the bus.

2. The demod and the host controller need to be configured identically
else the host controller won't receive any data from the demod, or
best case will receive garbage. Linux drivers can vary in respect to
windows drivers here in terms of how the bus is configured, somewhat,
but some hard and fast rules still apply.

a) Assuming both the host controller and the LG support both serial
and parallel (I haven't checked) you'll need to configure that option
correctly to match the card. You can't just 'pick one and hope', you
have to pick the right mode. Visual inspection of the PCB helps, or
knowing their either end of the bus can only be serial due to the
nature of the silicon implementation also helps. Or simply, try all
combinations.

b) Control lines such as TSVALID, TSERR, START_OF_PACKET usually have
polarities HIGH or LOW. These can vary between Windows and Linux, it
doesn't matter if they do, as long as each end matches correctly. I
personally like to match windows by probing the bus visually with
either a logic analyzer or a scope on pads in/around the demodulator.
Trial and error changing these configuration settings at one end
(usually the demodulator) should very quickly start to show garbage or
real data in dvbtraffic. In my experience both ends have their own
defaults and they never match. Leave the host controller alone and
adjust the demodulator unless the demodulator in questions simply
cannot be controlled (highly unusual).

Don't look at scan until dvbtraffic shows real and stable pid data
that doesn't jump about the screen and look like junk. Expect
dvbtraffic to show you between 10-25 lines of stable data, constantly
updating at roughly 19.2Mbps total throughput.

Review the card, determine whether its a serial or parallel bus (or
guess), then review the control line polarities.

This should help.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
