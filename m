Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.wohnheimg.uni-frankfurt.de ([141.2.118.239])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sven@whgl.uni-frankfurt.de>) id 1K9rYI-0008Br-06
	for linux-dvb@linuxtv.org; Sat, 21 Jun 2008 03:06:04 +0200
Received: from localhost ([127.0.0.1] helo=ssl.verfeiert.org)
	by www.wohnheimg.uni-frankfurt.de with esmtp (Exim 4.69)
	(envelope-from <sven@whgl.uni-frankfurt.de>) id 1K9rXe-0006JM-VD
	for linux-dvb@linuxtv.org; Sat, 21 Jun 2008 03:05:56 +0200
Message-ID: <60602.85.180.168.159.1214010322.squirrel@ssl.verfeiert.org>
Date: Sat, 21 Jun 2008 03:05:22 +0200 (CEST)
From: "Sven Eschenberg" <sven@whgl.uni-frankfurt.de>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Support for MSI TV @nywhere Satellite
Reply-To: sven@whgl.uni-frankfurt.de
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

Hi List,

what exactly is needed, to get support for the TV @nywhere Satellite.

Some Info that might be required:

Card has Connectors for Sat, S-Video, AV (RCA JAcket), and IR reciever.

Card is based upon Conexant CX23883-39 and uses a MB86A16 (L)
Tuner/Demodulator from Fairchild Semiconductors.

There is a sticker on the card saying 1027_V1.2 (Seems there are different
Versions/Revisions).

Output from lspci:

01:07.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and
Audio Decoder (rev 05)
01:07.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio
Decoder [MPEG Port] (rev 05)
01:07.4 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio
Decoder [IR Port] (rev 05)
---
01:07.0 0400: 14f1:8800 (rev 05)
01:07.2 0480: 14f1:8802 (rev 05)
01:07.4 0480: 14f1:8804 (rev 05)

lspci -v:
01:07.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and
Audio Decoder (rev 05)
	Subsystem: Twinhan Technology Co. Ltd Unknown device 0023
	Flags: bus master, medium devsel, latency 32, IRQ 15
	Memory at eb000000 (32-bit, non-prefetchable) [size=16M]

01:07.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio
Decoder [MPEG Port] (rev 05)
	Subsystem: Twinhan Technology Co. Ltd Unknown device 0023
	Flags: bus master, medium devsel, latency 32, IRQ 15
	Memory at ec000000 (32-bit, non-prefetchable) [size=16M]

01:07.4 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio
Decoder [IR Port] (rev 05)
	Subsystem: Twinhan Technology Co. Ltd Unknown device 0023
	Flags: bus master, medium devsel, latency 32, IRQ 15
	Memory at ed000000 (32-bit, non-prefetchable) [size=16M]

Output from dmesg:

[   42.293604] cx88[0]: Your board isn't known (yet) to the driver.  You can
[   42.293605] cx88[0]: try to pick one of the existing card configs via
[   42.293607] cx88[0]: card=<n> insmod option.  Updating to the latest
[   42.293608] cx88[0]: version might help as well.
[   42.293610] cx88[0]: Here is a list of valid choices for the card=<n>
insmod option:
[   42.293612] cx88[0]:    [cardlist cropped]
[   42.293716] cx88[0]: subsystem: 1822:0023, board: UNKNOWN/GENERIC
[card=0,autodetected]
[   42.293718] cx88[0]: TV tuner type -1, Radio tuner type -1
[   42.439466] cx88[0]/0: found at 0000:01:07.0, rev: 5, irq: 15, latency:
32, mmio: 0xeb000000
[   42.614814] cx88[0]/0: registered device video0 [v4l2]
[   42.614837] cx88[0]/0: registered device vbi0

Any help or recommendations would be appreciated. If further information
is needed, please don't hesitate to ask.

Regards

-Sven

I just realized, thath the twinhan AD-SP200(1027) board looks exactly the
same as the MSI TV @nywhere Satellite board, as far as I can compare it
and it seems it is no coincidence, that the MSI board carries the
1027_V1.2 Sticker.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
