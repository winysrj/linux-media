Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <picciux@gmail.com>) id 1KsPbe-0000ri-GX
	for linux-dvb@linuxtv.org; Wed, 22 Oct 2008 00:21:41 +0200
Received: by fg-out-1718.google.com with SMTP id e21so87598fga.25
	for <linux-dvb@linuxtv.org>; Tue, 21 Oct 2008 15:21:33 -0700 (PDT)
Message-ID: <c41ce8440810211521n6efafa8di9453a91dedba1256@mail.gmail.com>
Date: Wed, 22 Oct 2008 00:21:33 +0200
From: picciuX <matteo@picciux.it>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Pinnacle PCTV 310i Remote: i2c 'ERROR: NO_DEVICE'
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

hi all.
Someone could explain to me what does 'saa7133[0]: i2c xfer: < 8f
ERROR: NO_DEVICE' mean? It appears in my logs exactly when I push a
button on my Pinnacle PCTV 310i remote... and obviously the remote
seems not to work.... this is why I enabled debug output.
Seems strange to me that I found tutorials on the net talking about
this board, and reporting experiences of happy users because the board
and the remote both *just work*. In my case, and some other I found
googling around, the remote simply doesn't work.
An user had two cards, buyed 6 months one after the other: the first
*just worked*, the second didn't.
Mine is new, and Pinnacle changed the name in "PCTV Hybrid Pro PCI",
but pci ids are the very same of PCTV 310i. Maybe did something change
on this cards?
I searched the net, with no luck.
Today i tried enabling saa7134 debug, loading the module like this:

modprobe saa7134 ir_debug=1 i2c_debug=1 gpio_tracking=1

My syslog started filling the screen with i2c xfer lines. When I
pushed a button on the remote, immediately appeared those "ERROR:
NO_DEVICE" lines, like this:

[ 1065.227063] saa7133[0]: i2c xfer: < 8f =ef =56 =40 =93 >
[ 1065.334805] saa7133[0]: i2c xfer: < 8f =6f =fd =d4 =4f >
[ 1065.443552] saa7133[0]: i2c xfer: < 8f =6a =5d =d3 =cd >
[ 1065.550300] saa7133[0]: i2c xfer: < 8f =b2 =6c =5e =28 >
[ 1065.658042] saa7133[0]: i2c xfer: < 8f =5c =02 =36 =f5 >
[ 1065.765786] saa7133[0]: i2c xfer: < 8f =07 =fc =dd =5b >
[ 1065.874533] saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
[ 1065.974329] saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
[ 1066.073096] saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
[ 1066.172860] saa7133[0]: i2c xfer: < 8f =ec =de =bd =fb >
[ 1066.280569] saa7133[0]: i2c xfer: < 8f =32 =d5 =13 =75 >
[ 1066.388315] saa7133[0]: i2c xfer: < 8f =af =6a =8f =01 >
[ 1066.496064] saa7133[0]: i2c xfer: < 8f =60 =20 =00 =10 >

I repeated the test more than once, just to be sure of th
relationships between remote button presses and the *ERROR* lines.

Kernel is stock ubuntu 8.04 (2.6.24-21). I tried also compiling and
using latest mercurial modules: but besides some problems with
saa7134_alsa (probably latest v4l-dvb needs a more recent kernel),
nothing changed with the remote.

Someone can shed some light on this?

I can post the entire dmesg output from module load to module unload,
if it could be useful.

Thanks a lot...
picciuX

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
