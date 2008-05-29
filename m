Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from static.135.41.46.78.clients.your-server.de ([78.46.41.135]
	helo=hetzner.kompasmedia.nl)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bas@kompasmedia.nl>) id 1K1mGE-0005YW-4n
	for linux-dvb@linuxtv.org; Thu, 29 May 2008 19:49:59 +0200
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Date: Thu, 29 May 2008 19:49:54 +0200
From: Bas v.d. Wiel <bas@kompasmedia.nl>
Message-ID: <425dd4c41015c1c7de90ed667ccd1aa9@localhost>
Subject: [linux-dvb] Mantis problems: my hardware
Reply-To: bas@kompasmedia.nl
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


Hello all,
Since the mantis driver from Manu still doesn't give me any channels
whatsoever, I decided to have a closer look at the hardware. Here's all the
information I can get from looking at the card itself:

Mantis-chip: 
K62323.1A-2
061117

Frontend: (hidden under nasty Twinhan sticker):
NXP
3139 147 24321C8 (this is uncertain, the sticker destroyed part of this
label)
CU1216LS/ACICH-3 (everything after '/A' uncertain)
SW21 0716
MADE IN INDONESIA

Corner of card:
VP-20330 Ver:1.4
2005.12.22

Barcode label on the back of the card
2-T2033-14
SN: 07053E00015

The frontend has two coaxial connectors of which only the left one is
connected to the connector on the back of the card. The other (male) seems
to have no purpose. Also the letters NXP are engraved into the cover of the
frontend assembly. Other than this I found a very small IC next to the CAM
slot. This reads:

EMC
EM78P156ELMJ-G
0615A BD64A6

Is this in any significant way different from the cards that are reported
working here?

Bas




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
