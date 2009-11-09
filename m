Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp107.mail.ukl.yahoo.com ([77.238.184.39]:45972 "HELO
	smtp107.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751353AbZKITdy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Nov 2009 14:33:54 -0500
Message-ID: <4AF86E91.4070702@rocketmail.com>
Date: Mon, 09 Nov 2009 19:33:37 +0000
From: g_remlin <g_remlin@rocketmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: saa7416 woes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since the day my local transmitter 'upgraded' my budget DVB-T will no 
longer tune any station (tested with various apps, on various recent 
kernels), gut feeling is this may be a kernel driver issue.

I know the transmission mode for all channels included changes from 2K, 
& QAM16  to 8K, & QAM64, and suspect this may be the reason (or one hell 
of a coincidence), can anyone offer any advice as what to do to obtain 
meaningful information to include in a bug report posting.

PS. I tested the DVB-T card under WindowsXP and it (the hardware with 
the Windows software) works OK. I live in one of the first areas of the 
UK to 'upgrade'.

lspci -v

02:09.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
         Subsystem: Technotrend Systemtechnik GmbH 
Technotrend-Budget/Hauppauge WinTV-NOVA-T DVB card
         Flags: bus master, medium devsel, latency 32, IRQ 17
         Memory at e3001000 (32-bit, non-prefetchable) [size=512]
         Kernel driver in use: budget dvb
         Kernel modules: budget
