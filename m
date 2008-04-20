Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bld-mail11.adl2.internode.on.net ([203.16.214.75]
	helo=mail.internode.on.net) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <short_rz@internode.on.net>) id 1JnQad-00042k-Sm
	for linux-dvb@linuxtv.org; Sun, 20 Apr 2008 05:51:49 +0200
Message-ID: <480ABF78.1000300@internode.on.net>
Date: Sun, 20 Apr 2008 13:28:48 +0930
From: Andrew Jeffery <short_rz@internode.on.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <480977B6.5070304@internode.on.net> <20080419102156.GA8217@ts4.de>
	<480A9DA0.5060603@internode.on.net>
In-Reply-To: <480A9DA0.5060603@internode.on.net>
Cc: Thomas Schuering <schuering@ts4.de>
Subject: Re: [linux-dvb] FusionHDTV Dual Digital 4 Segfault
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Andrew Jeffery wrote:
|
|
| Thomas Schuering wrote:
| | On Sat, Apr 19, 2008 at 02:10:22PM +0930, Andrew Jeffery wrote:
| |> -----BEGIN PGP SIGNED MESSAGE-----
| |> Hash: SHA1
| |>
| |> Hi all,
| |>
| |> Bought myself a Dual Digital 4 the other day and I'm trying to get
it up
| |> and running - bumped into a segfault though :(
| |
| | Hi Andrew,
| |
| | I suppose you tried the standard-branch of v4l, didn't you?
| | That one also caused the same problems on my side.
| |
| | Try this one instead:
| | hg clone http://linuxtv.org/hg/~pascoe/xc-test/
|
| Yeah I was using the standard branch and tried the xc-test branch after
| I emailed :) It started working with Chris' branch but now I'm having
| troubles with the USB device on the card. This is what I'm getting in
dmesg:
|
| ...
| usb usb8: configuration #1 chosen from 1 choice
| hub 8-0:1.0: USB hub found
| hub 8-0:1.0: 4 ports detected
| usb 8-1: new high speed USB device using ehci_hcd and address 2
| usb 8-1: device descriptor read/64, error -71
| usb 8-1: device descriptor read/64, error -71
| usb 8-1: new high speed USB device using ehci_hcd and address 3
| usb 8-1: device descriptor read/64, error -71
| usb 8-1: device descriptor read/64, error -71
| usb 8-1: new high speed USB device using ehci_hcd and address 4
| EXT3 FS on sda3, internal journal
| DVB: registering new adapter (saa7133[0])
| DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
| usb 8-1: device not accepting address 4, error -71
| tda1004x: setting up plls for 48MHz sampling clock
| usb 8-1: new high speed USB device using ehci_hcd and address 5
| usb 8-1: device not accepting address 5, error -71
| usb 8-2: new high speed USB device using ehci_hcd and address 6
| usb 8-2: configuration #1 chosen from 1 choice
| ...
|
| If I modprobe the drivers (tuner-xc2028, zl10353 and dvb-usb-cxusb) in
| nothing happens, dmesg just says that a new interface has been loaded -
| no hardware initialisation messages or anything.

That's actually wrong, here one of the tuners accepted address 6 and I
could load the frontend for it. Not sure why but it seems that
occasionally one of the tuners will work, other times neither of them,
and as I said before I did have both of them working at one stage - it
seems pretty random :(

I had a look at the FAQ at http://www.linux-usb.org/ and found that my
problem's described there as well. I tried the relevant solutions (bios
update, rmmod/modprobe uhci-hcd) but none of them have worked.

It doesn't look very
| promising and it happens every boot since I got it working with Chris'
| drivers... not sure if it's correlated :( I've read the errors are
| something to do with the device getting suspended so I set noapic and
| acpi=off but that didn't help either :/ I'll chuck the card in a windows
| box and see what happens, see if that can kickstart it or something.
| Anything else I should try?
|
| Andrew
| |
| | That helped removing the segfault.
| |
| |
| | Hope this helps.
| |
| | Regards, Thomas
|

Andrew

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

- --
"Encouraging innovation by restricting the spread & use of information
seems highly counterintuitive to me." - Slashdot comment
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFICr94/5R+ugbygqQRAgO8AJ97PUX+VS/AfeeUdDKNsZAFqxIUCwCeIDUr
paNfJUUgk64J0KC5xA4DuaA=
=h0KX
-----END PGP SIGNATURE-----

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
