Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8JMIV4E023371
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 18:18:31 -0400
Received: from d1.scratchtelecom.com (69.42.52.179.scratchtelecom.com
	[69.42.52.179])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m8JMHm3R024297
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 18:17:49 -0400
Received: from vegas (CPE00a02477ff82-CM001225d885d8.cpe.net.cable.rogers.com
	[99.249.154.65])
	by d1.scratchtelecom.com (8.13.8/8.13.8/Debian-3) with ESMTP id
	m8JMHm1i020441
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 18:17:48 -0400
Received: from lawsonk (helo=localhost)
	by vegas with local-esmtp (Exim 3.36 #1 (Debian)) id 1KgoIJ-00061F-00
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 18:17:43 -0400
Date: Fri, 19 Sep 2008 18:17:43 -0400 (EDT)
From: Keith Lawson <lawsonk@lawson-tech.com>
To: video4linux-list@redhat.com
In-Reply-To: <alpine.DEB.1.10.0809191733380.22306@vegas>
Message-ID: <alpine.DEB.1.10.0809191812490.22306@vegas>
References: <alpine.DEB.1.10.0809191733380.22306@vegas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Subject: Re: TM5600 chipset device (diamond vc500) problems
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>



On Fri, 19 Sep 2008, Keith Lawson wrote:

> Hello,
>
> Okay I've got the tm6000 module loaded but it doesn't seem to see my device 
> at all. dmesg output from loading module:
>
> tm6000 v4l2 driver version 0.0.1 loaded
> usbcore: registered new interface driver tm6000
>
> I've also tried "modprobe tm6000 card=1" which gives the same results. I 
> haven't found the firmware for the device yet, does that have to be in place 
> before the kernel module will see the card?
>
<snip>

I got the module to see my card by adding the device ID to tm6000-cards.c:

{ USB_DEVICE(0x07de, 0x2820), .driver_info = TM5600_BOARD_GENERIC },

Now I just need to figure out how to get firmware.

Have I done this correctly?

TIA,
Keith.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
