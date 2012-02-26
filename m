Return-Path: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <lists@rewt.org.uk>) id 1S1UhV-000663-1U
	for linux-dvb@linuxtv.org; Sun, 26 Feb 2012 04:23:32 +0100
Received: from abby.lhr1.as41113.net ([91.208.177.20]
	helo=hosted.mx.as41113.net)
	by mail.tu-berlin.de (exim-4.75/mailfrontend-3) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1S1UhU-0002GV-Fs; Sun, 26 Feb 2012 04:23:05 +0100
Received: from [172.16.11.44] (unknown [91.208.177.192])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lists@rewt.org.uk)
	by hosted.mx.as41113.net (Postfix) with ESMTPSA id 0FE0022813
	for <linux-dvb@linuxtv.org>; Sun, 26 Feb 2012 03:22:53 +0000 (UTC)
Message-ID: <4F49A586.30200@rewt.org.uk>
Date: Sun, 26 Feb 2012 03:22:46 +0000
From: Joe Holden <lists@rewt.org.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [Fwd: DM1105N]
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi guys,

I've got a DM1105 (revision "n") that doesn't seem to attach, even using
   the unbranded card option, it's branded as "Digitale" but looks to be
a generic DM1105...

I get the typical "could not attach frontend" but alongside that the
driver doesn't report a mac (all zeros)

What do I need to enable in the kernel to get debug messages that may be
useful in diagnosing why it can't attach?

00:0a.0 Ethernet controller: Device 195d:1105 (rev 10)
         Subsystem: Device 195d:1105
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR+ INTx-
         Interrupt: pin A routed to IRQ 17
         Region 0: I/O ports at e000 [size=256]
         Kernel modules: dm1105

Any pointers appreciated!

Thanks,
J


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
