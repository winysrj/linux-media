Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1DKo0VC029362
	for <video4linux-list@redhat.com>; Fri, 13 Feb 2009 15:50:01 -0500
Received: from outgoing.csail.mit.edu (outgoing.csail.mit.edu [128.30.2.149])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1DKniAu015532
	for <video4linux-list@redhat.com>; Fri, 13 Feb 2009 15:49:44 -0500
Received: from kaleidoscope.csail.mit.edu ([128.30.30.14])
	by outgoing.csail.mit.edu with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.63) (envelope-from <schwa@csail.mit.edu>) id 1LY4yl-0005yb-Qq
	for video4linux-list@redhat.com; Fri, 13 Feb 2009 15:49:43 -0500
Message-ID: <4995DCE7.2000207@csail.mit.edu>
Date: Fri, 13 Feb 2009 15:49:43 -0500
From: Eric Schwartz <schwa@csail.mit.edu>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: ImpactVCB 64405 low-profile PCI problem
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

Hi all,

I'm having a frustrating problem with getting a brand new Hauppauge card
to work with v4l, of the ImpactVCB 64405 low-profile PCI variety. I have
a basic NTSC camera that I want to hook up to one of the composite
inputs. And yes, during my troubleshooting efforts I succumbed to the
temptation of plugging it into an XP box (gasp!) and verified that the
hardware works perfectly fine.

Vanilla kernel versions 2.6.21, 2.6.24, and 2.6.28 all detect the
presence of the card and painlessly load the bttv module. According to
dmesg, it audodetects the type of card and even reads the exact model
string off the eeprom. (see dmesg output pasted below)

So far so good, eh? When I plug the camera into each of the inputs, I
get nothing on /dev/video0. Not exactly all zeroes, to be precise, but
close. A hexdump shows that there are occasional "c0"s mixed in with the
"00"s. Using "dov4l -i" lets me change the inputs as expected -- no
errors when the input number is in range, error when it's > 3.

Searching Google, I found that some people extracted firmware from a
Windows driver for a similar card and passed the "firm_altera=fwfile"
parameter to modprobe. I got the firmware file in question (from another
driver disk; it wasn't on the one that came with the card) but the
module balks at accepting that parameter at all. (bttv: Unknown
parameter firm_altera)

Anyone have experience with getting this card to work? What I thought
was going to be an easy project has quickly turned into a nightmare. Any
help will be appreciated.

Thanks,
Eric Schwartz

--

sunset:~# dmesg | grep bttv
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv 0000:02:0a.0: PCI INT A -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
bttv0: Bt878 (rev 17) at 0000:02:0a.0, irq: 11, latency: 64, mmio:
0xf6001000
bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
bttv0: using: Hauppauge (bt878) [card=10,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
bttv0: Hauppauge eeprom indicates model#64405
bttv0: tuner absent
bttv0: i2c: checking for MSP34xx @ 0x80... not found
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: PLL: 28636363 => 35468950 .. ok

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
