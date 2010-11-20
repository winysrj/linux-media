Return-path: <mchehab@gaivota>
Received: from mailout-de.gmx.net ([213.165.64.23]:34933 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754805Ab0KTT6I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Nov 2010 14:58:08 -0500
From: Oliver Endriss <o.endriss@gmx.de>
To: Robert Longbottom <rongblor@googlemail.com>
Subject: Re: ngene & Satix-S2 dual problems
Date: Sat, 20 Nov 2010 20:22:42 +0100
Cc: linux-media@vger.kernel.org
References: <4CE7EEC2.3040900@googlemail.com>
In-Reply-To: <4CE7EEC2.3040900@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201011202022.43042@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

On Saturday 20 November 2010 16:52:34 Robert Longbottom wrote:
> Hi all,
> 
> I have a Satix-S2 Dual that I'm trying to get to work properly so that I 
> can use it under MythTv however I'm running into a few issues.  I 
> previously posted about the problems I'm having here to the mythtv 
> list[1], but didn't really get anywhere.  I've had chance to have a bit 
> more of a play and I now seem to have a definite repeatable problem.
> 
> The problem is when a recording stops on one of the inputs, after about 
> 40s it causes the other input to loose it's signal lock and stop the 
> recording as well.
> 
> 
> Steps to demonstrate the problem (My Satix card is adapters 5 and 6)
> 
> In 3 seperate terminals set up femon/szap/cat to make a recording from 
> one of the inputs:
> 
> 1 - femon -a 6 -f 0 -H
> 2 - szap -a 6 -f 0 -d 0 -r -H -p -c scanResult07Oct2010_Satix -l 
> UNIVERSAL "BBC 1 London"
> 3 - cat /dev/dvb/adapter6/dvr0 > ad6.mpg
> 
> In 2 seperate terminals tune in the other input:
> 
> 4 - femon -a 5 -f 0 -H
> 5 - szap -a 5 -f 0 -d 0 -r -H -p -c scanResult07Oct2010_Satix -l 
> UNIVERSAL "ITV1 London"
> 
> Both inputs are fine, signal is good, recording from adapter 6 works.
> 
> 6 - Ctrl-C the szap process created in (5).
> 
> femon in (4) still reports status=SCVYL and decent signal strengh as if 
> the adapter is still tuned and FE_HAS_LOCK.  After approximately 40 
> seconds, either:
> 
> a) the signal drops significantly but the status remains at SCVYL and 
> FE_HAS_LOCK
> 
> or
> 
> b) the signal drops and the status goes blank with no lock.
> 
> It doesn't seem to matter which of these two happen, but at the same 
> time the recording on the other tuner looses it signal and stops 
> recording, despite the fact that szap is still running in (2).  femon in 
> (1) no longer reports FE_HAS_LOCK.
> 
> Strangely if I then try to restart the szap process created in terminal 
> 2 (to try and retune it) it just waits after printing out "using 
> '/dev/dvb/....".  However if I then restart the szap process in terminal 
> 5, the one in terminal 2 suddenly kicks in and gets a lock.
> 
> Interestingly I found a link describing a 60s period the card is kept 
> open for [2], which seems to be similar to my ~40s delay.  So it looks 
> like when the second input on the card is closed the first input looses 
> it's lock.
> 
> This obviously makes it pretty useless for MythTv and as a result it's 
> not currently being used, which is a shame!
> 
> I'm using the ngene driver from the stock 2.6.35.4 kernel on Gentoo.
> 
> Does anyone else see this problem?  Is there anything I can do to try 
> and fix / debug it?  Are there any bug fixes in the latest kernel that 
> might help, or in the linux-dvb drivers that would help?
> 
> Any help or advice much appreciated.

Please try this driver:
http://linuxtv.org/hg/~endriss/ngene-test2

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
