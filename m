Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp5.freeserve.com ([193.252.22.128])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@mfraz74.orangehome.co.uk>)
	id 1K2USw-0007xA-Na
	for linux-dvb@linuxtv.org; Sat, 31 May 2008 19:02:05 +0200
Received: from smtp5.freeserve.com (mwinf3429 [10.232.11.129])
	by mwinf3410.me.freeserve.com (SMTP Server) with ESMTP id 1BE831C00F44
	for <linux-dvb@linuxtv.org>; Sat, 31 May 2008 19:00:23 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf3429.me.freeserve.com (SMTP Server) with ESMTP id 2BE341C00086
	for <linux-dvb@linuxtv.org>; Sat, 31 May 2008 18:57:49 +0200 (CEST)
Received: from rachael.local (unknown [91.108.98.216])
	by mwinf3429.me.freeserve.com (SMTP Server) with ESMTP id E423B1C00084
	for <linux-dvb@linuxtv.org>; Sat, 31 May 2008 18:57:45 +0200 (CEST)
From: Mark Fraser <linuxtv@mfraz74.orangehome.co.uk>
To: linux-dvb@linuxtv.org
Date: Sat, 31 May 2008 17:57:46 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805311757.46842.linuxtv@mfraz74.orangehome.co.uk>
Subject: [linux-dvb] Hauppauge Nova-S-Plus PCI card
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I've just bought a Hauppauge Nova-S-Plus PCI card which seems to be slightl=
y =

different to the one in the Wiki - =

http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-S-Plus - having =

IIRC a model number of 790. LSPCI -v gives this info for the card:

01:08.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and =

Audio Decoder (rev 05)
        Subsystem: Hauppauge computer works Inc. Nova-S-Plus DVB-S
        Flags: bus master, medium devsel, latency 32, IRQ 19
        Memory at f5000000 (32-bit, non-prefetchable) [size=3D16M]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2

01:08.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio =

Decoder [Audio Port] (rev 05)
        Subsystem: Hauppauge computer works Inc. Unknown device 9202
        Flags: bus master, medium devsel, latency 32, IRQ 19
        Memory at f6000000 (32-bit, non-prefetchable) [size=3D16M]
        Capabilities: [4c] Power Management version 2

01:08.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio =

Decoder [MPEG Port] (rev 05)
        Subsystem: Hauppauge computer works Inc. Unknown device 9202
        Flags: bus master, medium devsel, latency 32, IRQ 19
        Memory at f7000000 (32-bit, non-prefetchable) [size=3D16M]
        Capabilities: [4c] Power Management version 2

01:08.4 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio =

Decoder [IR Port] (rev 05)
        Subsystem: Hauppauge computer works Inc. Unknown device 9202
        Flags: bus master, medium devsel, latency 32, IRQ 10
        Memory at f8000000 (32-bit, non-prefetchable) [size=3D16M]
        Capabilities: [4c] Power Management version 2

Plugged it in, connected the cable from the dish and fired up Kaffeine and =
it =

works. There is some A/V sync problems at times which I haven't figured out =

the cause of yet, but I'm more than pleased with it.

Just one question, is this the right mailing list to ask questions on how t=
o =

use the analogue audio/video inputs available on this card?

-- =

|\ =A0/| ark Fraser =A0/Registered Linux User #466407
| \/ | Somerset =A0 /Using Kmail on Kubuntu Gutsy Gibbon
| =A0 =A0|___________/You know what the sig means!


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
