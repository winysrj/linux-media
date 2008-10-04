Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from blu0-omc3-s2.blu0.hotmail.com ([65.55.116.77])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <db260179@hotmail.com>) id 1Km505-0004qU-Po
	for linux-dvb@linuxtv.org; Sat, 04 Oct 2008 13:08:43 +0200
Message-ID: <BLU116-W3053E4BDEE434C8F4490D0C23F0@phx.gbl>
From: dabby bentam <db260179@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Sat, 4 Oct 2008 11:08:07 +0000
MIME-Version: 1.0
Subject: [linux-dvb] Avermedia Super 007 IR now working,
 BUT need help getting the keys setup!
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


Hope someone can help?

I've got the IR port working on the Avermedia Super 007 card. Problem i have is the remote has combination keys i.e. UP arrow is also number 2 etc

How can i set the correct mask_keycode? - if possible?

This is an output of mask_keycode=0

saa7133[0]/ir: scancode = 0x00 (code = 0x201, notcode= 0xfd7e) = source

saa7133[0]/ir: scancode = 0x00 (code = 0x200, notcode= 0xfd7f) = power

saa7133[0]/ir: scancode = 0x00 (code = 0x205, notcode= 0xfd7a) = 1 also UP arrow

saa7133[0]/ir: scancode = 0x00 (code = 0x206, notcode= 0xfd79) = 2

saa7133[0]/ir: scancode = 0x00 (code = 0x207, notcode= 0xfd78) = 3

saa7133[0]/ir: scancode = 0x00 (code = 0x209, notcode= 0xfd76) = 4 also LEFT arrow

saa7133[0]/ir: scancode = 0x00 (code = 0x20a, notcode= 0xfd75) = 5

saa7133[0]/ir: scancode = 0x00 (code = 0x20b, notcode= 0xfd74) = 6 also RIGHT arrow

saa7133[0]/ir: scancode = 0x00 (code = 0x20d, notcode= 0xfd72) = 7

saa7133[0]/ir: scancode = 0x00 (code = 0x20e, notcode= 0xfd71) = 8 also DOWN arrow

saa7133[0]/ir: scancode = 0x00 (code = 0x20f, notcode= 0xfd70) = 9

saa7133[0]/ir: scancode = 0x00 (code = 0x212, notcode= 0xfd6d) = Display

saa7133[0]/ir: scancode = 0x00 (code = 0x211, notcode= 0xfd6e) = 0 also ENTER button

saa7133[0]/ir: scancode = 0x00 (code = 0x213, notcode= 0xfd6c) = CH RTN

saa7133[0]/ir: scancode = 0x00 (code = 0x204, notcode= 0xfd7b) = EPG

saa7133[0]/ir: scancode = 0x00 (code = 0x303, notcode= 0xfc7c) = CH+
saa7133[0]/ir: scancode = 0x00 (code = 0x03, notcode= 0x807c) = CH+

saa7133[0]/ir: scancode = 0x00 (code = 0x210, notcode= 0xfd6f) = 16ch Prev

saa7133[0]/ir: scancode = 0x00 (code = 0x21e, notcode= 0xfd61) = VOL-

saa7133[0]/ir: scancode = 0x00 (code = 0x20c, notcode= 0xfd73) = Fullscreen

saa7133[0]/ir: scancode = 0x00 (code = 0x21f, notcode= 0xfd60) = VOL+

saa7133[0]/ir: scancode = 0x00 (code = 0x214, notcode= 0xfd6b) = Mute

saa7133[0]/ir: scancode = 0x00 (code = 0x302, notcode= 0xfc7d) = CH-

saa7133[0]/ir: scancode = 0x00 (code = 0x208, notcode= 0xfd77) = Audio

saa7133[0]/ir: scancode = 0x00 (code = 0x219, notcode= 0xfd66) = Record

saa7133[0]/ir: scancode = 0x00 (code = 0x218, notcode= 0xfd67) = Play

saa7133[0]/ir: scancode = 0x00 (code = 0x21b, notcode= 0xfd64) = Stop

saa7133[0]/ir: scancode = 0x00 (code = 0x21a, notcode= 0xfd65) = Timeshift

saa7133[0]/ir: scancode = 0x00 (code = 0x21d, notcode= 0xfd62) = Rewind also RED

saa7133[0]/ir: scancode = 0x00 (code = 0x21c, notcode= 0xfd63) = Fastforward also YELLOW

saa7133[0]/ir: scancode = 0x00 (code = 0x203, notcode= 0xfd7c) = Teletext

saa7133[0]/ir: scancode = 0x00 (code = 0x301, notcode= 0xfc7e) = Prev also GREEN

saa7133[0]/ir: scancode = 0x00 (code = 0x300, notcode= 0xfc7f) = Skip also BLUE

mask_keycode = 0
mask_keydown = 0x0040000

Thank you
_________________________________________________________________
Get all your favourite content with the slick new MSN Toolbar - FREE
http://clk.atdmt.com/UKM/go/111354027/direct/01/
_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
