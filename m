Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <quielb@ecst.csuchico.edu>) id 1KLWda-0007yZ-K2
	for linux-dvb@linuxtv.org; Wed, 23 Jul 2008 07:11:47 +0200
Message-ID: <4886BD7D.3080905@ecst.csuchico.edu>
Date: Tue, 22 Jul 2008 22:11:25 -0700
From: Barry Quiel <quielb@ecst.csuchico.edu>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] HVR-1800 firmware error
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

I seem to be getting some firmware errors on my HVR-1800.  From syslog:

Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
initialized or corrupted, signature = 0xffffffff, cmd = SET_OUTPUT_PORT
Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
initialized or corrupted, signature = 0xffffffff, cmd = SET_OUTPUT_PORT
Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
initialized or corrupted, signature = 0xffffffff, cmd = SET_OUTPUT_PORT
Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
initialized or corrupted, signature = 0xffffffff, cmd = SET_OUTPUT_PORT
Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
initialized or corrupted, signature = 0xffffffff, cmd = SET_AUDIO_PROPERTIES
Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
initialized or corrupted, signature = 0xffffffff, cmd = SET_OUTPUT_PORT
Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
initialized or corrupted, signature = 0xffffffff, cmd = SET_BIT_RATE
Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
initialized or corrupted, signature = 0xffffffff, cmd = SET_OUTPUT_PORT
Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
initialized or corrupted, signature = 0xffffffff, cmd = SET_BIT_RATE
Jul 22 20:19:36 myth-mbe kernel: Firmware and/or mailbox pointer not 
initialized or corrupted, signature = 0xffffffff, cmd = SET_OUTPUT_PORT
Jul 22 20:19:37 myth-mbe kernel: Firmware and/or mailbox pointer not 
initialized or corrupted, signature = 0xffffffff, cmd = PING_FW

The errors show up if I try to use the card in MythTV, or do a cat 
/dev/video1.  The capture file has no picture, but there is a bit of 
sound, but lots of static.

I just downloaded the latest dvb tree, so that's up to date.  My kernel 
is 2.6.25.9-76.fc9.x86_64.  I also refreshed the firmware from 
http://steventoth.net/linux/hvr1800 to be sure the files weren't corrupt.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
