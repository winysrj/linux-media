Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe09.c2i.net ([212.247.155.2]:51370 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751306Ab1LYOTT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Dec 2011 09:19:19 -0500
From: Hans Petter Selasky <hselasky@c2i.net>
To: Dennis Sperlich <dsperlich@googlemail.com>
Subject: Re: em28xx_isoc_dvb_max_packetsize for EM2884 (Terratec Cinergy HTC Stick)
Date: Sun, 25 Dec 2011 15:11:54 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
References: <4EF64AF4.2040705@gmail.com> <4EF70077.5040907@redhat.com> <4EF72D61.9090001@gmail.com>
In-Reply-To: <4EF72D61.9090001@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112251511.54080.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 25 December 2011 15:04:17 Dennis Sperlich wrote:
> On 25.12.2011 11:52, Mauro Carvalho Chehab wrote:
> > On 24-12-2011 19:58, Dennis Sperlich wrote:
> >> Hi,
> >> 
> >> I have a Terratec Cinergy HTC Stick an tried the new support for the
> >> DVB-C part. It works for SD material (at least for free receivable
> >> stations, I tried afair only QAM64), but did not for HD stations
> >> (QAM256). I have only access to unencrypted ARD HD, ZDF HD and arte HD
> >> (via KabelDeutschland). The HD material was just digital artefacts, as
> >> far as mplayer could decode it. When I did a dumpstream and looked at
> >> the resulting file size I got something about 1MB/s which seems a
> >> little too low, because SD was already about 870kB/s. After looking
> >> around I found a solution in increasing the isoc_dvb_max_packetsize
> >> from 752 to 940 (multiple of 188). Then an HD stream was about 1.4MB/s
> >> and looked good. I'm not sure, whether this is the correct fix, but it
> >> works for me.
> >> 
> >> If you need more testing pleas tell.
> >> 
> >> Regards,
> >> Dennis
> >> 

These numbers should not be hardcoded, but extracted from the USB endpoint 
descriptor!

--HPS
