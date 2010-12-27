Return-path: <mchehab@gaivota>
Received: from mailout-de.gmx.net ([213.165.64.23]:39864 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750873Ab0L0V5G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 16:57:06 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Ludovic =?iso-8859-1?q?BOU=C9?= <ludovic.boue@gmail.com>
Subject: Re: ngene & Satix-S2 dual problems
Date: Mon, 27 Dec 2010 22:49:51 +0100
Cc: linux-media@dinkum.org.uk, linux-media@vger.kernel.org
References: <4D1753CF.9010205@gmail.com>
In-Reply-To: <4D1753CF.9010205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201012272249.52358@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sunday 26 December 2010 15:40:15 Ludovic BOU� wrote:
> Hi all,
> 
> I have a Satix-S2 Dual and I'm trying to get to work without his CI in a first time. I'm trying ngene-test2 
> from http://linuxtv.org/hg/~endriss/ngene-test2/ under 
> 2.6.32-21-generic.
> 
> It contains too much nodes (extra demuxes, dvrs & nets):
> ...
> Is it connected to this commit (http://linuxtv.org/hg/~endriss/ngene-test2/rev/eb4142f0d0ac) about "Support up to 4 tuners for cineS2 v5, duoflex & mystique v2" ?

Yes.

Please note that this is an experimental repository.
This bug will be fixed before the code will be submitted upstream.
(It is more complicated that it might appear at the first glance.)

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
