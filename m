Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54771 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751677Ab0FDB7f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jun 2010 21:59:35 -0400
Content-Type: text/plain; charset="utf-8"
Date: Fri, 04 Jun 2010 03:59:32 +0200
From: "Alexander Apostolatos" <Alexander.Apostolatos@gmx.de>
Message-ID: <20100604015932.212640@gmx.net>
MIME-Version: 1.0
Subject: success 
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, had success in activating analog tuner in:

http://linuxtv.org/wiki/index.php/DVB-T_PCI_Cards
Philips TV/Radio Card CTX918, (Medion 7134), PCI 

In my case, device is labeled:
MEDION
Type: TV-Tuner 7134
V.92 Data/Fax Modem
Rev: CTX918_V2 DVB-T/TV
P/N: 20024179


Label on tuner (other side of PCB) offers info on tuner type:
Label reads:
3139 147 22491c#
FMD1216ME/I H-3
SV21 6438
Made in INONESIA

So I suppose tuner=78 is the compatible type for FMD1216ME/I H-3,

NOT tuner=63 as detected by system. Please check and alter if applicable.

Suspect different Hardware revs come with identical hardware ID's.
Will provide additional info if told hot to obtain (hardware ID or whatever), but have to take a nap right now. It's 4 in the morning.

Have a nice one...and thanks for all the work

Your's

Alex

-- 
GRATIS für alle GMX-Mitglieder: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome01
