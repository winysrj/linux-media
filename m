Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36298 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab1LYTnO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Dec 2011 14:43:14 -0500
Received: by wibhm6 with SMTP id hm6so4066596wib.19
        for <linux-media@vger.kernel.org>; Sun, 25 Dec 2011 11:43:13 -0800 (PST)
Message-ID: <1324842167.3134.4.camel@tvbox>
Subject: Re: em28xx_isoc_dvb_max_packetsize for EM2884 (Terratec Cinergy HTC
 Stick)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Hans Petter Selasky <hselasky@c2i.net>
Cc: Dennis Sperlich <dsperlich@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Sun, 25 Dec 2011 19:42:47 +0000
In-Reply-To: <201112251511.54080.hselasky@c2i.net>
References: <4EF64AF4.2040705@gmail.com> <4EF70077.5040907@redhat.com>
	 <4EF72D61.9090001@gmail.com> <201112251511.54080.hselasky@c2i.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2011-12-25 at 15:11 +0100, Hans Petter Selasky wrote:
> On Sunday 25 December 2011 15:04:17 Dennis Sperlich wrote:
> > On 25.12.2011 11:52, Mauro Carvalho Chehab wrote:
> > > On 24-12-2011 19:58, Dennis Sperlich wrote:
> > >> Hi,
> > >> 
> > >> I have a Terratec Cinergy HTC Stick an tried the new support for the
> > >> DVB-C part. It works for SD material (at least for free receivable
> > >> stations, I tried afair only QAM64), but did not for HD stations
> > >> (QAM256). I have only access to unencrypted ARD HD, ZDF HD and arte HD
> > >> (via KabelDeutschland). The HD material was just digital artefacts, as
> > >> far as mplayer could decode it. When I did a dumpstream and looked at
> > >> the resulting file size I got something about 1MB/s which seems a
> > >> little too low, because SD was already about 870kB/s. After looking
> > >> around I found a solution in increasing the isoc_dvb_max_packetsize
> > >> from 752 to 940 (multiple of 188). Then an HD stream was about 1.4MB/s
> > >> and looked good. I'm not sure, whether this is the correct fix, but it
> > >> works for me.
> > >> 

Would not increasing EM28XX_DVB_NUM_BUFS currently set at 5 to say 10
have a better effect?

Malcolm

