Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.nielsen@shikadi.net>) id 1JUela-0000eM-0q
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 10:09:26 +0100
Message-ID: <47C67A3C.6050602@shikadi.net>
Date: Thu, 28 Feb 2008 19:09:16 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
MIME-Version: 1.0
To: Martin Thompson <hireach@internode.on.net>
References: <9FC6541BF8D049BB839E9F30F5258D64@LaptopPC>
In-Reply-To: <9FC6541BF8D049BB839E9F30F5258D64@LaptopPC>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvico dual digital 4 revision 2.0
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

> have chris pascoe intrested but he is very busy so could be a while
> before he looks into it
> the new card has a new hardware id  last 2 digits is 98 not 78
> am working with a mate who has a revision 1.1 card
> if i change the v4l-dvb haidware id to mine
> linux will pick it up and install the driver
> but can not find the frontend (using mythtv)
> what is the command that you usb to give all the info about the card
> so i can check against an working one
> and maybe pick whats differnet

Wow, lucky the card I bought last week was a rev1.1!  I would imagine
the rev2.0 card would be using different firmware - I assume you've
correctly installed the firmware for the rev1.1 card?  If that doesn't
work, you could try extracting the firmware from the Windows driver,
assuming that's where Chris got it from in the first place.

This is what dmesg reports when I initialise the card:

xc2028 2-0061: Loading firmware for type=BASE F8MHZ (3), id
   0000000000000000.
xc2028 2-0061: Loading firmware for type=D2620 DTV7 (88), id
   0000000000000000.
xc2028 2-0061: Loading SCODE for type=DTV7 ZARLINK456 SCODE (22000080),
   id 0000000000000000.
xc2028 2-0061: Device is Xceive 3028 version 1.0, firmware version 2.7

With this firmware:

$ ls /lib/firmware/
total 48K
drwxr-xr-x 2 root root   92 2008-02-23 11:54 .
drwxr-xr-x 9 root root 8.0K 2008-02-23 23:38 ..
-rw-r--r-- 1 root root 8.9K 2006-01-10 02:21 dvb-usb-bluebird-01.fw
-rw-r--r-- 1 root root 8.4K 2007-11-21 22:51 dvb-usb-bluebird-02.fw
-rw-r--r-- 1 root root 9.0K 2007-11-20 01:15 xc3028-dvico-au-01.fw

What does yours say?

Cheers,
Adam.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
