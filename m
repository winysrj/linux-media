Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <IxAYMzFpK2ojlw@sofortsurf.de>) id 1Jge2T-0006LS-3q
	for linux-dvb@linuxtv.org; Tue, 01 Apr 2008 12:48:30 +0200
Date: Tue, 1 Apr 2008 12:44:42 +0200
From: "L." <IxAYMzFpK2ojlw@sofortsurf.de>
To: linux-dvb <linux-dvb@linuxtv.org>
Message-ID: <20080401104442.GA18478@localhost>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Please correct wiki: KNC1 DVB-C Plus not fully supported
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

Hello,

the information about the KNC1 DVB-C Plus card (a card with analog video
input) in the linuxtv.org dvb wiki is wrong. It says it works under
linux, which is not correct. The analog input (Composite and S-Video) is
currently unsupported under Linux (at least for the recent MK3 version).
(See bug reports [3,4]).

The lack of support for the analog input by the driver is crucial, since
nobody would buy such a card without explicitly needing this analog
input; the model without analog input is much less expensive. So saying
the card works can lead to someone buying a card not fully supported by
Linux (unfortunately this has happened to me).

Please correct this information in the wiki! This wiki is not editable
by public. The following pages are affected:

http://linuxtv.org/wiki/index.php/KNC1_TV-Station_DVB-C_Plus
http://linuxtv.org/wiki/index.php/DVB-C_PCI_Cards
http://linuxtv.org/wiki/index.php/KNC1

I can say that the analog input on my MK3 version did not work with any 
kernel version or patch I tested since its first Linux support in 2007-02
[1] (however the input works under windows). I do not know if the analog
input of the older version of the card did work or still does. 

It should be noted that the MK3 version of the KNC1 DVB-C with tda10023
is only supported from kernel 2.6.22 on (and a little earlier with a
patch), but the older version of the card with tda10021 was supported
much earlier, already (at least) in kernel 2.6.12.

KNC1 DVB-C Plus (older)     = PCI subsystem ID 1894:0021      
KNC1 DVB-C Plus MK3 (newer) = PCI subsystem ID 1894:0023 

If someone owns a KNC One DVB Plus card, please can you say if your
analog input (Composite or S-Video) ever worked under Linux, or if
it stopped working with a specific kernel version? Thank you.

L.

References

1. 2007-02: First patch available supporting the MK3 versions of KNC1 DVB
cards (and identical Terratec/Satelco): tda1002x.008.diff for hg/v4l-dvb
http://www.vdr-portal.de/board/thread.php?threadid=60227&page=8
http://www.linuxtv.org/pipermail/linux-dvb/2007-February/015886.html

2. http://www.vdr-wiki.de/wiki/index.php/DVB-C_Budget-PCI-Karten

3. http://www.linuxtv.org/pipermail/linux-dvb/2008-March/025032.html

4. http://www.linuxtv.org/pipermail/linux-dvb/2007-December/022183.html

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
