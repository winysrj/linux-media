Return-path: <mchehab@pedra>
Received: from gelbbaer.kn-bremen.de ([78.46.108.116]:42720 "EHLO
	smtp.kn-bremen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab1FMAka (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 20:40:30 -0400
From: Juergen Lock <nox@jelal.kn-bremen.de>
Date: Mon, 13 Jun 2011 02:38:45 +0200
To: Antti Palosaari <crope@iki.fi>
Cc: Juergen Lock <nox@jelal.kn-bremen.de>, linux-media@vger.kernel.org,
	hselasky@c2i.net
Subject: Re: [PATCH] [media] af9015: setup rc keytable for LC-Power
 LC-USB-DVBT
Message-ID: <20110613003845.GA75278@triton8.kn-bremen.de>
References: <20110612202512.GA63911@triton8.kn-bremen.de>
 <201106122215.p5CMF0Xr069931@triton8.kn-bremen.de>
 <4DF53CB6.109@iki.fi>
 <20110612223437.GB71121@triton8.kn-bremen.de>
 <4DF542CE.4040903@iki.fi>
 <20110612230100.GA71756@triton8.kn-bremen.de>
 <4DF54FC2.2020104@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF54FC2.2020104@iki.fi>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jun 13, 2011 at 02:46:10AM +0300, Antti Palosaari wrote:
> On 06/13/2011 02:01 AM, Juergen Lock wrote:
> > On Mon, Jun 13, 2011 at 01:50:54AM +0300, Antti Palosaari wrote:
> >> On 06/13/2011 01:34 AM, Juergen Lock wrote:
> >>> On Mon, Jun 13, 2011 at 01:24:54AM +0300, Antti Palosaari wrote:
> >>>> On 06/13/2011 01:15 AM, Juergen Lock wrote:
> >>>>>> About the repeating bug you mention, are you using latest driver
> >>>>>> version? I am not aware such bug. There have been this kind of incorrect
> >>>>>> behaviour old driver versions which are using HID. It was coming from
> >>>>>> wrong HID interval.
> >>>>>>
> >>>>>> Also you can dump remote codes out when setting debug=2 to
> >>>>>> dvb_usb_af9015 module.
> >>>>>
> >>>>>     That doesn't seem to work here so maybe my version is really too old
> >>>>> to have that fix.  (But the keytable patch should still apply I guess?)
> >>>>
> >>>> Could you send af9015.c file you have I can check?
> >>>>
> >>>> Your patch is OK, but I want to know why it repeats.
> >>>
> >>> Sent off-list.
> >>
> >> It was latest version. Still mystery why it repeats... Have you
> >> unplugged that device after booting from Windows? I wonder if there is
> >> HID remote codes uploaded to device by Windows driver and then you have
> >> "warm" booted to Linux...
> >>
> > Well at least I can't rule something like that out, will send details
> > off-list.  (Btw where is debug=2 to print remote events handled in that
> > file?  Or is that done somewhere else?)
> 
> Few words about AF9015 remote. Chipset implements HID remote (~keyboard) 
> which is used normally. Driver uploads HID mappings (remote keycode & 
> keyboard keycode) to the chipset memory and chipset then outputs remote 
> events as HID without driver help. But there seems to be bug in chipset 
> which sets HID polling interval too short. Due to that interval Linux 
> HID starts repeating keycodes. There is some quirks added to the HID 
> drivers for that which are mapped device USB ID. Quirk prints to log: 
> "Afatech DVB-T 2: Fixing fullspeed to highspeed interval: 10 -> 7"
> 
> Due to that bug and inflexible remote configuration of HID remote I 
> implemented new way. Current code does not upload HID codes to chipset 
> at all which makes HID remote as disabled. Instead, remote codes are 
> read by polling directly from the chip memory. And it is very first time 
> I hear this new method goes repeating loop.
> 
> Drivers write to the system log. Typically it is called messages, 
> message.log, syslog, etc. in /var/log/ directory. There is dmesg command 
> which outputs same info.

Ah I needed CONFIG_DVB_USB_DEBUG. :)  Here is what I see when it happens,
first ir-keytable -t:

[...]
1307924961.676720: event sync
1307924961.676723: event key down: KEY_STOP (0x0080)
1307924961.676725: event sync
1307924962.193037: event MSC: scancode = 0e
1307924962.712487: event MSC: scancode = 0e
1307924963.232184: event MSC: scancode = 0e
1307924964.791025: event MSC: scancode = 1a
1307924964.791034: event key up: KEY_STOP (0x0080)
1307924964.791037: event sync
1307924964.791040: event key down: KEY_PAUSE (0x0077)
1307924964.791042: event sync
1307924965.310734: event MSC: scancode = 1a
1307924966.867192: event MSC: scancode = 54
1307924966.867201: event key up: KEY_PAUSE (0x0077)
1307924966.867203: event sync
1307924966.867207: event key down: KEY_0 (0x000b)
1307924966.867209: event sync
1307924971.538731: event MSC: scancode = 02
1307924971.538741: event key up: KEY_0 (0x000b)
1307924971.538743: event sync
1307924971.538746: event key down: KEY_VOLUMEDOWN (0x0072)
1307924971.538748: event sync
1307924974.135096: event MSC: scancode = 40
1307924974.135104: event key up: KEY_VOLUMEDOWN (0x0072)
1307924974.135106: event sync
1307924974.135110: event key down: KEY_VOLUMEUP (0x0073)
1307924974.135112: event sync
1307924974.653804: event MSC: scancode = 40
1307924975.172874: event MSC: scancode = 40
1307924975.692828: event MSC: scancode = 40
1307924976.212909: event MSC: scancode = 40
1307924976.732230: event MSC: scancode = 40
1307924977.252420: event MSC: scancode = 40
1307924977.772252: event MSC: scancode = 40
1307924978.289195: event MSC: scancode = 40
1307924978.808266: event MSC: scancode = 40
1307924979.327347: event MSC: scancode = 40
1307924979.846548: event MSC: scancode = 40
1307924980.364610: event MSC: scancode = 40
1307924980.884690: event MSC: scancode = 40
1307924981.401760: event MSC: scancode = 40
1307924981.919843: event MSC: scancode = 40
1307924982.437907: event MSC: scancode = 40
1307924982.953985: event MSC: scancode = 40
1307924983.475070: event MSC: scancode = 40
1307924983.995011: event MSC: scancode = 40
1307924984.513089: event MSC: scancode = 40
1307924985.032154: event MSC: scancode = 40
1307924985.552225: event MSC: scancode = 40
1307924986.072310: event MSC: scancode = 40
1307924986.591383: event MSC: scancode = 40
1307924987.111452: event MSC: scancode = 40
1307924987.630544: event MSC: scancode = 40
1307924988.149605: event MSC: scancode = 40
1307924988.669166: event MSC: scancode = 40
1307924989.189239: event MSC: scancode = 40
1307924989.708817: event MSC: scancode = 40
1307924990.227893: event MSC: scancode = 40
1307924990.746969: event MSC: scancode = 40
1307924991.267052: event MSC: scancode = 40
1307924991.786359: event MSC: scancode = 40
1307924992.306193: event MSC: scancode = 40
1307924992.825381: event MSC: scancode = 40
1307924993.345584: event MSC: scancode = 40
1307924993.864537: event MSC: scancode = 40
1307924994.384613: event MSC: scancode = 40
1307924994.903683: event MSC: scancode = 40
1307924995.423879: event MSC: scancode = 40
1307924995.943954: event MSC: scancode = 40
1307924996.463032: event MSC: scancode = 40
1307924996.982349: event MSC: scancode = 40
1307924997.502426: event MSC: scancode = 40
1307924998.022244: event MSC: scancode = 40
1307924998.541072: event MSC: scancode = 40
1307924999.060265: event MSC: scancode = 40
1307924999.579340: event MSC: scancode = 40
1307925000.099423: event MSC: scancode = 40
1307925000.619492: event MSC: scancode = 40
1307925000.619492: event MSC: scancode = 40

then `dmesg':

[...]
af9015_rc_query: no key press
af9015_rc_query: no key press
af9015_rc_query: key pressed 00 ff 1a e5
af9015_rc_query: key repeated
af9015_rc_query: no key press
af9015_rc_query: key pressed 00 ff 54 ab
af9015_rc_query: no key press
af9015_rc_query: no key press
af9015_rc_query: no key press
af9015_rc_query: no key press
af9015_rc_query: no key press
af9015_rc_query: no key press
af9015_rc_query: no key press
af9015_rc_query: no key press
af9015_rc_query: key pressed 00 ff 02 fd
af9015_rc_query: no key press
af9015_rc_query: no key press
af9015_rc_query: no key press
af9015_rc_query: no key press
af9015_rc_query: key pressed 00 ff 40 bf
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: key repeated
af9015_rc_query: no key press
af9015_rc_query: no key press
af9015_rc_query: no key press
af9015_rc_query: no key press
af9015_rc_query: no key press
af9015_rc_query: no key press
af9015_rc_query: no key press
af9015_rc_query: no key press
af9015_rc_query: no key press

 Does that help?
	Juergen
