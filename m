Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:42810 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbZIBSD1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Sep 2009 14:03:27 -0400
Date: Wed, 2 Sep 2009 20:03:19 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Thomas Rokamp <thomas@rokamp.dk>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Problems with Hauppauge Nova-T USB2
In-Reply-To: <4A9EB032.7000503@rokamp.dk>
Message-ID: <alpine.LRH.1.10.0909021957400.3802@pub6.ifh.de>
References: <41138.1251890451@rokamp.dk> <alpine.LRH.1.10.0909021905001.3802@pub6.ifh.de> <4A9EB032.7000503@rokamp.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, 2 Sep 2009, Thomas Rokamp wrote:
> dvbsnoop -s pidscan
> ---------------------------------------------------------
> Transponder PID-Scan...
> ---------------------------------------------------------
> PID found:    0 (0x0000)  [SECTION: Program Association Table (PAT)]
> PID found:  110 (0x006e)  [PS/PES: ITU-T Rec. H.262 | ISO/IEC 13818-2 or 
> ISO/IEC 11172-2 video stream]
> PID found:  120 (0x0078)  [PS/PES: ISO/IEC 13818-3 or ISO/IEC 11172-3 audio 
> stream]
> PID found:  130 (0x0082)  [PS/PES: private_stream_1]
> PID found:  131 (0x0083)  [unknown]
> PID found:  257 (0x0101)  [SECTION: Program Map Table (PMT)]
> PID found:  259 (0x0103)  [SECTION: Program Map Table (PMT)]
> PID found:  260 (0x0104)  [SECTION: Program Map Table (PMT)]
> PID found:  261 (0x0105)  [SECTION: Program Map Table (PMT)]
> PID found:  301 (0x012d)  [PS/PES: private_stream_1]
> PID found:  512 (0x0200)  [PS/PES: ITU-T Rec. H.262 | ISO/IEC 13818-2 or 
> ISO/IEC 11172-2 video stream]
> PID found:  513 (0x0201)  [PS/PES: ITU-T Rec. H.262 | ISO/IEC 13818-2 or 
> ISO/IEC 11172-2 video stream]
> PID found:  640 (0x0280)  [PS/PES: ISO/IEC 13818-3 or ISO/IEC 11172-3 audio 
> stream]
> PID found:  644 (0x0284)  [PS/PES: ISO/IEC 13818-3 or ISO/IEC 11172-3 audio 
> stream]
> PID found: 1200 (0x04b0)  [PS/PES: ITU-T Rec. H.262 | ISO/IEC 13818-2 or 
> ISO/IEC 11172-2 video stream]
> PID found: 1201 (0x04b1)  [PS/PES: ISO/IEC 13818-3 or ISO/IEC 11172-3 audio 
> stream]
> PID found: 5008 (0x1390)  [PS/PES: private_stream_1]
> PID found: 5009 (0x1391)  [PS/PES: private_stream_1]
> PID found: 8180 (0x1ff4)  [unknown]
> PID found: 8191 (0x1fff)  [stuffing]
>
>
> If it can be any help, I have uploaded 2 test files
> (both made with "dvbstream -n 5 -qam 64 -gi 16 -cr 5_6 -crlp 5_6 -bw 8 -tm 2 
> -hy NONE -f 722000000 513 644 -o > testX.mpg")
>
> http://phail.dk/test01.mpg

Hmm, I did:

wget http://phail.dk/test01.mpg
mplayer test01.mpg

and I see a nice star animation looks like Eurosport .

> http://phail.dk/test02.mpg

doing the same thing with this file:

It show Melzer vs. Safin playing Tennis at the US Open on Eurosport.

Something's wrong with your mplayer/vlc/libffmpeg or whatever, definitely 
not a problem of driver or reception.

best regards,

--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
