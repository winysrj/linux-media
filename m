Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <sven.helmberger@gmx.de>) id 1KrVwr-0002Xl-Pa
	for linux-dvb@linuxtv.org; Sun, 19 Oct 2008 12:55:50 +0200
Message-ID: <48FB1210.3060809@gmx.de>
Date: Sun, 19 Oct 2008 12:55:12 +0200
From: Sven Helmberger <sven.helmberger@gmx.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem: Cinergy DT USB XS remote keys repeating
	endlessly
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

I have a freshly bought Cinergy DT USB XS which I got working with the 
description from 
http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_DT_USB_XS_Diversity.

I got the sources from hg, applied the patch to have it recognize the 
new type id "0ccd:0081".
The key repeat patch that is mentioned on the page seemed to have 
already applied to the tree so I skipped that.
(my C skills are seriously rusty, but all the code from the patch seemed 
to be there)

The device itself works fine with all two tuners being recognized in 
mythtv and all.

For the remote, I tried both lircd.conf settings mentioned on the page, 
but it's always the same result. The remote keys seems to work except 
for the fact that they keep endlessly repeating each key you press until 
you press another one.

Do you have any ideas or pointers to how I could solve this problem?

Sven.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
