Return-path: <mchehab@pedra>
Received: from cmsout01.mbox.net ([165.212.64.31]:36382 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab1DVWRV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2011 18:17:21 -0400
Message-ID: <4DB1FE58.20006@usa.net>
Date: Sat, 23 Apr 2011 00:16:56 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: xtronom@gmail.com
CC: linux-media@vger.kernel.org
Subject: ngene CI problems
References: <4D74E28A.6030302@gmail.com>
In-Reply-To: <4D74E28A.6030302@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Hi all!
>
> I'm trying to make the DVB_DEVICE_SEC approach work, however I'm 
> experiencing certain problems with the following setup:
>
> Software:
> Linux 2.6.34.8 (vanilla)
> drivers from http://linuxtv.org/hg/~endriss/v4l-dvb/ <http://linuxtv.org/hg/%7Eendriss/v4l-dvb/>
>
> Hardware:
> Digital Devices CineS2 + CI Module
>
> Problems:
>
> - Packets get lost in SEC device:
>
> I write complete TS to SEC, but when reading from SEC there are 
> discontinuities on the CC.
>
> - SEC device generates NULL packets (ad infinitum):
>
> When reading from SEC, NULL packets are read and interleaved with 
> expected packets. They can be even read with dd(1) when nobody is 
> writing to SEC and even when CAM is not ready.
>
> - SEC device blocks on CAM re-insertion:
>
> When CAM is removed from the slot and inserted again, all read() 
> operations just hang. Rebooting resolves the problem.
>
> - SEC device does not respect O_NONBLOCK:
>
> In connection to the previous problem, SEC device blocks even if opened 
> with O_NONBLOCK.
>
> Best regards,
> Martin Vidovic

Hi,

Running a bunch of test with gnutv and a DuoFLEX S2.

I saw the same problem concerning the decryption with a CAM.

I'm running kern 2.6.39 rc 4 with the latest patches from Oliver. Also
applied the patch moving from SEC to CAIO.

I would run gnutv  like 'gnutv -out stdout channelname >
/dev/dvb/adapter0/caio0' and then 'cat /dev/dvb/adapter0/caio0 | mplayer -'
Mplayer would complain the file is invalid. Simply running simply 'cat
/dev/dvb/adapter0/caio0' will show me the same data pattern over and over.

Anyone using ngene based card with a CAM running successfully ?

--
Issa
