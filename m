Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:52869 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752414Ab0JFLN6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Oct 2010 07:13:58 -0400
Content-Type: text/plain; charset="utf-8"
Date: Wed, 06 Oct 2010 13:13:53 +0200
From: "Matthias Weber" <matthiaz.weber@gmx.de>
Message-ID: <20101006111353.161320@gmx.net>
MIME-Version: 1.0
Subject: [v4l/dvb] identification/ fixed registration order of DVB cards
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

we are using two identical DVB cards (TT-budget S2-1600) in one system.

How can we assure that the same card always are assigned to the same device file /dev/dvb/adapter0 (/dev/dvb/adapter1 

respectively). 

Short example:
Is the card in the first PCI slot always /dev/dvb/adapter0
and the card in the second PCI slot always /dev/dvb/adapter1?

Is this (registration order or whatever it may be called) done in some drivers?
Or is it pure luck when booting the system?

If not implemented, what can be done to tell our own software to switch frontend handles or not to?

There might be a way through MAC addresses...
In ttpci-eeprom.c is a function called ttpci_eeprom_parse_mac()
which is used in budget_core.c ttpci_budget_init() function.
Can this somehow combined with PCI?

Any ideas what would be a smart and easy way?
Thanks!

Cheers
Matthias
-- 
GRATIS: Spider-Man 1-3 sowie 300 weitere Videos!
Jetzt freischalten! http://portal.gmx.net/de/go/maxdome
