Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:49960 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab3GCRyS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jul 2013 13:54:18 -0400
Message-ID: <51D46548.8050904@schinagl.nl>
Date: Wed, 03 Jul 2013 19:54:16 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Hermann_Ulrichsk=F6tter?= <ulrichsk@gmx.de>,
	dirk@GNUmatic.de
CC: linux-media <linux-media@vger.kernel.org>
Subject: [DTV Update] Re: =?ISO-8859-15?Q?=C4nderung_der_Sendefrequen?=
 =?ISO-8859-15?Q?zen_bei_KabelBW?=
References: <51D452EC.5090008@gmx.de>
In-Reply-To: <51D452EC.5090008@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/13 18:35, Hermann Ulrichskötter wrote:
> Hallo Oliver,
Hi Hermann,
>
> ich bin am Wochenende bei der TVHeadend-Installation auf meiner Synology über
> das Problem gestolpert, dass die Kanäle von Kabel-BW nicht mehr gescannt wurden.
>
> Kabel-BW hatte am Donnerstag hier in Freiburg einige Sendefrequenzen geändert,
> so dass die Datei tvheadend/share/tvheadend/data/dvb-scan/dvb-c/de-Kabel_BW
> nicht mehr korrekt ist.
>
> Ich habe in der Datei in dieser Datei die einzig relevante Zeile von "C
> 113000000 6900000 NONE QAM64" auf "C 114000000 6900000 NONE QAM256" korrigieren
> müssen, so dass der Scan wieder geklappt hat.
It looks like they changed frequencies. Their site confirms that a big 
changeover happened in June. I have staged this commit and will push it 
tomorrow unless anybody objects, Dirk, can you confirm/deny this being 
correct?

I already have it in my private repo [0]
>
> Vielleicht sollte die Datei in dtv-scan-tables/dvb-c entsprechend angepasst werden?
>
> Die neue Frequenzbelegung findet sich hier:
> https://www.kabelbw.de/kabelbw/cms/downloads/kabel-bw-programmuebersicht.pdf
>
> Schönen Gruß,
> Hermann
Thank you for the information,

Oliver
[0] 
http://git.schinagl.nl/cgi-bin/cgit.cgi/dtv-scan-tables.git/commit/?id=d913405dec10c60e852c55e77dc115ca94a2b74c
