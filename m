Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:34669 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751805Ab1DWRmV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2011 13:42:21 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Issa Gorissen <flop.m@usa.net>
Subject: Re: ngene CI problems
Date: Sat, 23 Apr 2011 19:40:29 +0200
Cc: xtronom@gmail.com, linux-media@vger.kernel.org
References: <4D74E28A.6030302@gmail.com> <4DB1FE58.20006@usa.net>
In-Reply-To: <4DB1FE58.20006@usa.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201104231940.34575@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday 23 April 2011 00:16:56 Issa Gorissen wrote:
> Running a bunch of test with gnutv and a DuoFLEX S2.
> 
> I saw the same problem concerning the decryption with a CAM.
> 
> I'm running kern 2.6.39 rc 4 with the latest patches from Oliver. Also
> applied the patch moving from SEC to CAIO.

If you are running 2.6.39rc4, you must apply patch
http://www.mail-archive.com/linux-media@vger.kernel.org/msg29870.html
Otherwise the data will be garbled.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
