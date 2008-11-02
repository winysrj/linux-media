Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA20gqZm004122
	for <video4linux-list@redhat.com>; Sat, 1 Nov 2008 20:42:52 -0400
Received: from mail-in-14.arcor-online.net (mail-in-14.arcor-online.net
	[151.189.21.54])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA20gcCf001507
	for <video4linux-list@redhat.com>; Sat, 1 Nov 2008 20:42:38 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: picciuX <matteo@picciux.it>
In-Reply-To: <c41ce8440810310231gdb614bcred3f4386de883abb@mail.gmail.com>
References: <c41ce8440810310231gdb614bcred3f4386de883abb@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 02 Nov 2008 01:42:01 +0100
Message-Id: <1225586521.2642.7.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Pinnacle PCTV 310i Remote: i2c 'ERROR: NO_DEVICE'
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

Hi,

Am Freitag, den 31.10.2008, 10:31 +0100 schrieb picciuX:
> hi all.
> Someone could explain to me what does 'saa7133[0]: i2c xfer: < 8f
> ERROR: NO_DEVICE' mean? It appears in my logs exactly when I push a
> button on my Pinnacle PCTV 310i remote... and obviously the remote
> seems not to work.... this is why I enabled debug output.
> Seems strange to me that I found tutorials on the net talking about
> this board, and reporting experiences of happy users because the board
> and the remote both *just work*. In my case, and some other I found
> googling around, the remote simply doesn't work.
> An user had two cards, buyed 6 months one after the other: the first
> *just worked*, the second didn't.
> Mine is new, and Pinnacle changed the name in "PCTV Hybrid Pro PCI",
> but pci ids are the very same of PCTV 310i. Maybe did something change
> on this cards?
> I searched the net, with no luck.
> Today i tried enabling saa7134 debug, loading the module like this:
> 
> modprobe saa7134 ir_debug=1 i2c_debug=1 gpio_tracking=1
> 
> My syslog started filling the screen with i2c xfer lines. When I
> pushed a button on the remote, immediately appeared those "ERROR:
> NO_DEVICE" lines, like this:
> 
> [ 1065.227063] saa7133[0]: i2c xfer: < 8f =ef =56 =40 =93 >
> [ 1065.334805] saa7133[0]: i2c xfer: < 8f =6f =fd =d4 =4f >
> [ 1065.443552] saa7133[0]: i2c xfer: < 8f =6a =5d =d3 =cd >
> [ 1065.550300] saa7133[0]: i2c xfer: < 8f =b2 =6c =5e =28 >
> [ 1065.658042] saa7133[0]: i2c xfer: < 8f =5c =02 =36 =f5 >
> [ 1065.765786] saa7133[0]: i2c xfer: < 8f =07 =fc =dd =5b >
> [ 1065.874533] saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
> [ 1065.974329] saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
> [ 1066.073096] saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
> [ 1066.172860] saa7133[0]: i2c xfer: < 8f =ec =de =bd =fb >
> [ 1066.280569] saa7133[0]: i2c xfer: < 8f =32 =d5 =13 =75 >
> [ 1066.388315] saa7133[0]: i2c xfer: < 8f =af =6a =8f =01 >
> [ 1066.496064] saa7133[0]: i2c xfer: < 8f =60 =20 =00 =10 >
> 
> I repeated the test more than once, just to be sure of the
> relationship between remote button presses and the *ERROR* lines.
> 
> Kernel is stock ubuntu 8.04 (2.6.24-21). I tried also compiling and
> using latest v4l-dvb from mercurial: but besides some problems with
> saa7134_alsa (probably latest v4l-dvb needs a more recent kernel),
> nothing changed with the remote.
> 
> Someone can shed some light on this?
> 
> I can post the entire dmesg output from module load to module unload,
> if it could be useful.
> 

don't have that remote, but also enable ir-kbd-i2c debug=1.

ir-kbd-i2c: probe 0x7a @ saa7133[0]: no
ir-kbd-i2c: probe 0x47 @ saa7133[0]: no
ir-kbd-i2c: probe 0x71 @ saa7133[0]: no
ir-kbd-i2c: probe 0x2d @ saa7133[0]: no
ir-kbd-i2c: probe 0x7a @ saa7133[1]: no
ir-kbd-i2c: probe 0x47 @ saa7133[1]: no
ir-kbd-i2c: probe 0x71 @ saa7133[1]: no
ir-kbd-i2c: probe 0x2d @ saa7133[1]: no

You should have the device found at 0x47.

Else something has changed or goes wrong.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
