Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound-sin.frontbridge.com ([207.46.51.80]
	helo=SG2EHSOBE001.bigfish.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <quielb@ecst.csuchico.edu>) id 1KQqx6-0001Cc-C5
	for linux-dvb@linuxtv.org; Wed, 06 Aug 2008 23:53:54 +0200
Received: from mail212-sin (localhost.localdomain [127.0.0.1])	by
	mail212-sin-R.bigfish.com (Postfix) with ESMTP id B09226C069B	for
	<linux-dvb@linuxtv.org>; Wed,  6 Aug 2008 17:18:29 +0000 (UTC)
Received: from mailhub.bi-tech.com (unknown [12.40.193.5])	by
	mail212-sin.bigfish.com (Postfix) with ESMTP id 2AA3B148805E	for
	<linux-dvb@linuxtv.org>; Wed,  6 Aug 2008 17:18:17 +0000 (UTC)
Message-ID: <4899DCCC.8030303@ecst.csuchico.edu>
Date: Wed, 6 Aug 2008 10:18:04 -0700
From: Barry Quiel <quielb@ecst.csuchico.edu>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <4886BD7D.3080905@ecst.csuchico.edu>
In-Reply-To: <4886BD7D.3080905@ecst.csuchico.edu>
Subject: Re: [linux-dvb] HVR-1800 firmware error
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>



Barry Quiel wrote:
> I seem to be getting some firmware errors on my HVR-1800.  From syslog:
> 
> Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
> initialized or corrupted, signature = 0xffffffff, cmd = SET_OUTPUT_PORT
> Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
> initialized or corrupted, signature = 0xffffffff, cmd = SET_OUTPUT_PORT
> Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
> initialized or corrupted, signature = 0xffffffff, cmd = SET_OUTPUT_PORT
> Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
> initialized or corrupted, signature = 0xffffffff, cmd = SET_OUTPUT_PORT
> Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
> initialized or corrupted, signature = 0xffffffff, cmd = SET_AUDIO_PROPERTIES
> Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
> initialized or corrupted, signature = 0xffffffff, cmd = SET_OUTPUT_PORT
> Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
> initialized or corrupted, signature = 0xffffffff, cmd = SET_BIT_RATE
> Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
> initialized or corrupted, signature = 0xffffffff, cmd = SET_OUTPUT_PORT
> Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
> initialized or corrupted, signature = 0xffffffff, cmd = SET_BIT_RATE
> Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
> initialized or corrupted, signature = 0xffffffff, cmd = SET_OUTPUT_PORT
> Jul 22 20:19:37 myth-mbe kernel: Firmware and/or mailbox pointer not 
> initialized or corrupted, signature = 0xffffffff, cmd = PING_FW
> 
> The errors show up if I try to use the card in MythTV, or do a cat 
> /dev/video1.  The capture file has no picture, but there is a bit of 
> sound, but lots of static.
> 
> I just downloaded the latest dvb tree, so that's up to date.  My kernel 
> is 2.6.25.9-76.fc9.x86_64.  I also refreshed the firmware from 
> http://steventoth.net/linux/hvr1800 to be sure the files weren't corrupt.
> 

I've been doing a bit more testing and seems that the HVR-1800 doesn't 
play well with the PVR-500.  That's not to say that I've been able to 
get the 1800 analog piece to work, but it does behave better when I take 
the 500 out of the box.  I don't get the firmware errors when the 500 is 
out.  I still don't get any video or audio on the 1800 though.  It acts 
like there is no cable connected, just static.

Any suggestions?



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
