Return-path: <mchehab@pedra>
Received: from gelbbaer.kn-bremen.de ([78.46.108.116]:59374 "EHLO
	smtp.kn-bremen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1FTRKH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 13:10:07 -0400
From: Juergen Lock <nox@jelal.kn-bremen.de>
Date: Mon, 20 Jun 2011 19:03:51 +0200
To: Antti Palosaari <crope@iki.fi>
Cc: Juergen Lock <nox@jelal.kn-bremen.de>, linux-media@vger.kernel.org,
	hselasky@c2i.net
Subject: Re: [PATCH] [media] af9015: setup rc keytable for LC-Power
 LC-USB-DVBT
Message-ID: <20110620170351.GA10510@triton8.kn-bremen.de>
References: <20110612202512.GA63911@triton8.kn-bremen.de>
 <201106122215.p5CMF0Xr069931@triton8.kn-bremen.de>
 <4DF53CB6.109@iki.fi>
 <20110612223437.GB71121@triton8.kn-bremen.de>
 <4DF542CE.4040903@iki.fi>
 <20110612230100.GA71756@triton8.kn-bremen.de>
 <4DF54FC2.2020104@iki.fi>
 <20110613003845.GA75278@triton8.kn-bremen.de>
 <4DF93CE2.8050201@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF93CE2.8050201@iki.fi>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jun 16, 2011 at 02:14:42AM +0300, Antti Palosaari wrote:
> Moikka Juergen,
Hi!
> 
> On 06/13/2011 03:38 AM, Juergen Lock wrote:
> > af9015_rc_query: key repeated
> 
> >   Does that help?
> 
> Repeat check logick in function af9015_rc_query() is failing for some 
> reason. You could try to look that function and checks if you wish as I 
> cannot reproduce it.
> 
> Add debug dump immediately after registers are read and look from log 
> what happens.
> 
> debug_dump(buf, 17, deb_rc);

I finally got back to this (sorry it took so long :( ), added that line
and this is what I got:

 First ir-keytable:

Testing events. Please, press CTRL-C to abort.
1308574953.777114: event MSC: scancode = 1b
1308574953.777123: event key down: KEY_1 (0x0002)
1308574953.777125: event sync
1308574954.293830: event MSC: scancode = 1b
1308574954.813919: event MSC: scancode = 1b
1308574955.332231: event MSC: scancode = 1b
1308574955.848046: event MSC: scancode = 1b
1308574956.362626: event MSC: scancode = 1b
1308574956.875069: event MSC: scancode = 1b
1308574957.391143: event MSC: scancode = 1b
1308574957.908859: event MSC: scancode = 1b
1308574958.426553: event MSC: scancode = 1b
1308574958.944992: event MSC: scancode = 1b
1308574959.462682: event MSC: scancode = 1b
1308574959.981519: event MSC: scancode = 1b
1308574960.500599: event MSC: scancode = 1b
1308574961.020155: event MSC: scancode = 1b
1308574961.540230: event MSC: scancode = 1b
1308574962.057815: event MSC: scancode = 1b
1308574962.576256: event MSC: scancode = 1b
1308574963.092961: event MSC: scancode = 1b
1308574963.611549: event MSC: scancode = 1b
1308574964.130601: event MSC: scancode = 1b
1308574964.645437: event MSC: scancode = 1b
1308574965.164752: event MSC: scancode = 1b
1308574965.684325: event MSC: scancode = 1b
1308574966.202289: event MSC: scancode = 1b
1308574966.718374: event MSC: scancode = 1b
1308574967.236913: event MSC: scancode = 1b
1308574967.756988: event MSC: scancode = 1b
1308574968.276573: event MSC: scancode = 1b
1308574968.794147: event MSC: scancode = 1b
1308574969.307834: event MSC: scancode = 1b
1308574969.823410: event MSC: scancode = 1b
1308574970.342993: event MSC: scancode = 1b
1308574970.862952: event MSC: scancode = 1b
1308574971.382144: event MSC: scancode = 1b
1308574971.897716: event MSC: scancode = 1b
1308574972.412159: event MSC: scancode = 1b
1308574972.927879: event MSC: scancode = 1b
1308574973.440304: event MSC: scancode = 1b
1308574973.961383: event MSC: scancode = 1b
1308574974.479087: event MSC: scancode = 1b
1308574974.994777: event MSC: scancode = 1b
1308574976.027044: event MSC: scancode = 05
1308574976.027054: event key up: KEY_1 (0x0002)
1308574976.027056: event sync
1308574976.027060: event key down: KEY_MUTE (0x0071)
1308574976.027062: event sync
1308574976.545246: event MSC: scancode = 05
1308574977.065213: event MSC: scancode = 05
1308574977.583911: event MSC: scancode = 05
1308574978.102972: event MSC: scancode = 05
1308574978.621050: event MSC: scancode = 05
1308574979.138112: event MSC: scancode = 05
1308574979.655187: event MSC: scancode = 05
1308574980.171269: event MSC: scancode = 05
1308574980.690343: event MSC: scancode = 05
1308574981.208045: event MSC: scancode = 05
1308574981.724746: event MSC: scancode = 05
1308574982.762866: event MSC: scancode = 4d
1308574982.762874: event key up: KEY_MUTE (0x0071)
1308574982.762876: event sync
1308574982.762880: event key down: KEY_PLAYPAUSE (0x00a4)
1308574982.762882: event sync
1308574983.278592: event MSC: scancode = 4d
^C

 Then the debug output:

[..]
dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
dvb-usb: pid filter enabled by module option.
DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 stick)
af9013: firmware version:4.95.0.0
DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
MT2060: successfully identified (IF1 = 1220)
Registered IR keymap rc-digittrade
rc0: IR-receiver inside an USB DVB receiver as webcamd
dvb-usb: schedule remote query interval to 500 msecs.
dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully initialized and connected.

00 00 00 00 00 00 01 00 00 00 00 00 00 ff 01 fe ff 
af9015_rc_query: no key press
00 00 00 00 00 00 01 00 00 00 00 00 00 ff 01 fe ff 
af9015_rc_query: no key press
00 00 00 00 00 00 01 00 00 00 00 00 00 ff 01 fe ff 
af9015_rc_query: no key press
00 00 00 00 00 00 01 00 00 00 00 00 00 ff 01 fe ff 
af9015_rc_query: no key press
00 00 00 00 00 00 01 00 00 00 00 00 00 ff 01 fe ff 
af9015_rc_query: no key press
00 00 00 00 00 00 01 00 00 00 00 00 00 ff 01 fe ff 
af9015_rc_query: no key press
00 00 00 00 00 00 01 00 00 00 00 00 00 ff 01 fe ff 
af9015_rc_query: no key press
00 00 00 00 00 00 01 00 00 00 00 00 00 ff 01 fe ff 
af9015_rc_query: no key press
00 00 00 00 00 00 01 00 00 00 00 00 00 ff 01 fe ff 
af9015_rc_query: no key press
02 00 00 00 00 00 01 00 00 00 00 00 00 ff 1b e4 00 
af9015_rc_query: key pressed 00 ff 1b e4
02 00 00 00 00 00 00 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 00 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
00 00 00 00 00 00 02 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
00 00 00 00 00 00 00 00 00 00 00 00 00 ff 1b e4 ff 
af9015_rc_query: key repeated
01 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 05 fa 00 
af9015_rc_query: key pressed 00 ff 05 fa
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 05 fa ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 05 fa ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 05 fa ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 05 fa ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 05 fa ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 05 fa ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 05 fa ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 05 fa ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 03 00 00 00 00 00 00 ff 05 fa ff 
af9015_rc_query: key repeated
02 00 00 00 00 00 02 00 00 00 00 00 00 ff 05 fa ff 
af9015_rc_query: key repeated
00 00 00 00 00 00 01 00 00 00 00 00 00 ff 05 fa ff 
af9015_rc_query: key repeated
00 00 00 00 00 00 01 00 00 00 00 00 00 ff 05 fa ff 
af9015_rc_query: no key press
02 00 00 00 00 00 01 00 00 00 00 00 00 ff 4d b2 00 
af9015_rc_query: key pressed 00 ff 4d b2
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: key repeated
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
00 00 00 00 00 00 03 00 00 00 00 00 00 ff 4d b2 ff 
af9015_rc_query: no key press
