Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp7-g19.free.fr ([212.27.42.64])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.merle@free.fr>) id 1KgXLy-00022t-Ly
	for linux-dvb@linuxtv.org; Fri, 19 Sep 2008 06:12:25 +0200
Message-ID: <ce9f20ac2ae714295e7aeef3f4f7730e.squirrel@78.226.152.136:8080>
Date: Fri, 19 Sep 2008 06:12:12 +0200 (CEST)
From: "Thierry Merle" <thierry.merle@free.fr>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] [RFC] cinergyT2 rework final review
Reply-To: thierry.merle@free.fr
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
About the rework from Tomi Orava I stored here:
http://linuxtv.org/hg/~tmerle/cinergyT2

since there seems to be no bug declared with this driver by testers (I
tested this driver on AMD/Intel/ARM platforms for months), it is time for
action.
If I receive no problem report before 19th of October (in one month), I
will push this driver into mainline.
This modification uses the dvb-usb framework, this is

To give you an idea of the code benefit, here is a diffstat of the
cinergyT2 rework patch:
 linux/drivers/media/dvb/cinergyT2/Kconfig        |   85 -
 linux/drivers/media/dvb/cinergyT2/Makefile       |    3
 linux/drivers/media/dvb/cinergyT2/cinergyT2.c    | 1150
---------------------
 linux/drivers/media/dvb/dvb-usb/cinergyT2-core.c |  230 ++++
 linux/drivers/media/dvb/dvb-usb/cinergyT2-fe.c   |  351 ++++++
 linux/drivers/media/dvb/dvb-usb/cinergyT2.h      |   95 +
 linux/drivers/media/dvb/Kconfig                    |    1
 linux/drivers/media/dvb/dvb-usb/Kconfig            |    8
 linux/drivers/media/dvb/dvb-usb/Makefile           |    4
 9 files changed, 688 insertions(+), 1239 deletions(-)

Cheers,
Thierry
-- 
Sent from an ArmedSlack powered NSLU2.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
