Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from honiara.magic.fr ([195.154.193.36])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <aconrad.tlv@magic.fr>) id 1K8CQD-0001hc-F1
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 12:58:50 +0200
Received: from [127.0.0.1] (ppp-76.net11.magic.fr [195.154.129.76])
	by honiara.magic.fr (8.13.1/8.13.1) with ESMTP id m5GAwErf030914
	for <linux-dvb@linuxtv.org>; Mon, 16 Jun 2008 12:58:15 +0200
Message-ID: <485646D3.6040201@magic.fr>
Date: Mon, 16 Jun 2008 12:56:19 +0200
From: Alexandre Conrad <aconrad.tlv@magic.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] SkyStar 2 - rev 2.8A
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

Hi,

we just bought around 70 SkyStar2 PCI cards for deploying at our
customer's sites meant for a digital signage application. We've always
been working with these cards before which have always worked flawlessly
under linux.

Anyway, it turns out that after we have ordered more SkyStar 2 cards
from our supplier, the "new" cards we have recieved this morning looked
physically different from the previous generation we were using for a
couple of years now. So I opened one and tested it in our system. It
seems to be recognized by the kernel somehow, but after a few "i2c
master_xfer failed" messages ending with a "no frontend driver found for
this B2C2/FlexCop adapter" message in dmesg, the card doesn't work. On
the circuit board, it says REV 2.8A. I took a card that worked fine
before, it's says REV 2.6D.

After searching over the linux-dvb mailing list, I ran across the
following post from Patrick Boettcher regarding the REV 2.8A card:

http://www.linuxtv.org/pipermail/linux-dvb/2008-February/023866.html

"""
an OpenSource driver is not in sight for that card. There are some NDA
problems... I will see what I can do.
"""

Of course, that's puts us in a very uncomfortable situation with our client.

The message is from last febuary. I'm posting a message here to ask the
dvb experts if anything has changed since then.

Thanks for your help, pointers and suggestions.

Best regards,
-- 
Alexandre CONRAD





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
