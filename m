Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:53654 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbZBPXWA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 18:22:00 -0500
Received: by bwz5 with SMTP id 5so3506657bwz.13
        for <linux-media@vger.kernel.org>; Mon, 16 Feb 2009 15:21:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <59463.79.136.92.202.1234820777.squirrel@webmail.bahnhof.se>
References: <59463.79.136.92.202.1234820777.squirrel@webmail.bahnhof.se>
Date: Tue, 17 Feb 2009 00:21:56 +0100
Message-ID: <854d46170902161521g1ad03be0s1114799fe296df14@mail.gmail.com>
Subject: Re: Tevii S650 DVB-S2 diseqc problem
From: Faruk A <fa@elwak.com>
To: svankan@bahnhof.se
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 16, 2009 at 10:46 PM,  <svankan@bahnhof.se> wrote:
> Hello!
>
> I just bought a Tevii S650 DVB-S2 card and I have a few questions.
>
> My server have Ubuntu 8.10 amd64 with a custom kernel and drivers and tools
> compiled from these sources.
> http://mercurial.intuxication.org/hg/szap-s2
> http://mercurial.intuxication.org/hg/s2-liplianin/
>
> The scan-s2 utility only find channels from latest used transponder in VDR
> and diseqc does not work. It took me many hours to have VDR working with
> Tevii S650 because my old diseqc.conf did not work with this card.
>
> When I have a skystar2 or a Hauppauge FF rev 2.1 I can use this config.
>
> Old diseqc.conf
> #
> S1W 11700 V 9750 t v W15 A W15 t
> S1W 99999 V 10600 t v W15 A W15 T
> S1W 11700 H 9750 t V W15 A W15 t
> S1W 99999 H 10600 t V W15 A W15 T
> #
> S5E 11700 V 9750 t v W15 B W15 t
> S5E 99999 V 10600 t v W15 B W15 T
> S5E 11700 H 9750 t V W15 B W15 t
> S5E 99999 H 10600 t V W15 B W15 T
>
>
> New diseqc.conf (working with Tevii S650)
> #
> S1W 11700 V 9750 t v W15 [E0 10 38 F0] W15 t
> S1W 99999 V 10600 t v W15 [E0 10 38 F1] W15 T
> S1W 11700 H 9750 t V W15 [E0 10 38 F2] W15 t
> S1W 99999 H 10600 t V W15 [E0 10 38 F3] W15 T
> #
> S5E 11700 V 9750 t v W15 [E0 10 38 F4] W15 t
> S5E 99999 V 10600 t v W15 [E0 10 38 F5] W15 T
> S5E 11700 H 9750 t V W15 [E0 10 38 F6] W15 t
> S5E 99999 H 10600 t V W15 [E0 10 38 F7] W15 T
>
> Can this diseqc "problem" cause the scan-s2 tool to fail too?
> Why do I need to change the diseqc.conf in VDR?
>
> Because of this problem I have to manually include all HD-channels to
> channels.conf. I have tried to follow the README for scan-s2 and tried
> different options. My old cards work with scan-s2 and diseqc. To be sure I
> downloaded the latest drivers from www.tevii.com and extracted the
> firmware from windows drivers but with the same result.
> Linux driver is from 2008-08-15
> Windows driver is released 2009-01-22
>
> similar problem?
> http://www.dvbnetwork.de/viewtopic.php?f=59&t=169
>
> VDR 1.7.4 works very good with the new diseqc.conf so the card is NOT broken.
> Any suggestions?
>
> /Svankan

Hi!

I don't have any diseqc problem with this card.
Tested with vdr 1.7.0, scan-s2, szap-s2 (myTeVii and ProgDVB)
ArchLinux 32-bit, kernel26 2.6.28.4
here is my vdr disecq.conf

# Input 1 - Eutelsat

S16.0E  11700 V  9750  t v W15 [E0 10 38 F0] W15 t
S16.0E  99999 V 10600  t v W15 [E0 10 38 F0] W15 T
S16.0E  11700 H  9750  t V W15 [E0 10 38 F0] W15 t
S16.0E  99999 H 10600  t V W15 [E0 10 38 F0] W15 T

# Input 2 - Sirius

S5E  11700 V  9750  t v W15 [E0 10 38 F4] W15 t
S5E  99999 V 10600  t v W15 [E0 10 38 F4] W15 T
S5E  11700 H  9750  t V W15 [E0 10 38 F4] W15 t
S5E  99999 H 10600  t V W15 [E0 10 38 F4] W15 T

# Input 3 - Hotbird

S13.0E   11700 V  9750  t v W15 [E0 10 38 F8] W15 t
S13.0E   99999 V 10600  t v W15 [E0 10 38 F8] W15 T
S13.0E   11700 H  9750  t V W15 [E0 10 38 F8] W15 t
S13.0E   99999 H 10600  t V W15 [E0 10 38 F8] W15 T

# Input 4 Astra 1 19.2E

S19.2E   11700 V  9750  t v W15 [E0 10 38 FC] W15 t
S19.2E   99999 V 10600  t v W15 [E0 10 38 FC] W15 T
S19.2E   11700 H  9750  t V W15 [E0 10 38 FC] W15 t
S19.2E   99999 H 10600  t V W15 [E0 10 38 FC] W15 T
