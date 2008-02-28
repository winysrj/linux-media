Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hireach@internode.on.net>) id 1JUfR6-0004w4-R9
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 10:52:21 +0100
Message-ID: <99BC16843B464C4C9081D5DF5DDA98BE@LaptopPC>
From: "Martin Thompson" <hireach@internode.on.net>
To: <linux-dvb@linuxtv.org>
References: <9FC6541BF8D049BB839E9F30F5258D64@LaptopPC>
	<47C67A3C.6050602@shikadi.net>
In-Reply-To: <47C67A3C.6050602@shikadi.net>
Date: Thu, 28 Feb 2008 20:52:10 +1100
MIME-Version: 1.0
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

nothing in dmesg
firmware in folder
chris asked me for a ssh box
is installed and ready to go
only thing loaded is chris's v4l tree
if you wanted to have a look ill email you the details


heres the lsusb

Bus 005 Device 003: ID 0fe9:db98 DVICO
Bus 005 Device 002: ID 0fe9:db98 DVICO

Note the hw id mine end in 98 yours in 78

----- Original Message ----- 
From: "Adam Nielsen" <a.nielsen@shikadi.net>
To: "Martin Thompson" <hireach@internode.on.net>
Cc: <linux-dvb@linuxtv.org>
Sent: Thursday, February 28, 2008 8:09 PM
Subject: Re: [linux-dvb] dvico dual digital 4 revision 2.0


>> have chris pascoe intrested but he is very busy so could be a while
>> before he looks into it
>> the new card has a new hardware id  last 2 digits is 98 not 78
>> am working with a mate who has a revision 1.1 card
>> if i change the v4l-dvb haidware id to mine
>> linux will pick it up and install the driver
>> but can not find the frontend (using mythtv)
>> what is the command that you usb to give all the info about the card
>> so i can check against an working one
>> and maybe pick whats differnet
> 
> Wow, lucky the card I bought last week was a rev1.1!  I would imagine
> the rev2.0 card would be using different firmware - I assume you've
> correctly installed the firmware for the rev1.1 card?  If that doesn't
> work, you could try extracting the firmware from the Windows driver,
> assuming that's where Chris got it from in the first place.
> 
> This is what dmesg reports when I initialise the card:
> 
> xc2028 2-0061: Loading firmware for type=BASE F8MHZ (3), id
>   0000000000000000.
> xc2028 2-0061: Loading firmware for type=D2620 DTV7 (88), id
>   0000000000000000.
> xc2028 2-0061: Loading SCODE for type=DTV7 ZARLINK456 SCODE (22000080),
>   id 0000000000000000.
> xc2028 2-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
> 
> With this firmware:
> 
> $ ls /lib/firmware/
> total 48K
> drwxr-xr-x 2 root root   92 2008-02-23 11:54 .
> drwxr-xr-x 9 root root 8.0K 2008-02-23 23:38 ..
> -rw-r--r-- 1 root root 8.9K 2006-01-10 02:21 dvb-usb-bluebird-01.fw
> -rw-r--r-- 1 root root 8.4K 2007-11-21 22:51 dvb-usb-bluebird-02.fw
> -rw-r--r-- 1 root root 9.0K 2007-11-20 01:15 xc3028-dvico-au-01.fw
> 
> What does yours say?
> 
> Cheers,
> Adam.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
