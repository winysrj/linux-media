Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarro.2783@gmail.com>) id 1JZd3w-0003ii-Rs
	for linux-dvb@linuxtv.org; Thu, 13 Mar 2008 03:21:03 +0100
Received: by ti-out-0910.google.com with SMTP id y6so1380732tia.13
	for <linux-dvb@linuxtv.org>; Wed, 12 Mar 2008 19:20:52 -0700 (PDT)
Message-ID: <abf3e5070803121920j5d05208fo1162e4d4e3f6c44f@mail.gmail.com>
Date: Thu, 13 Mar 2008 13:20:51 +1100
From: "Jarryd Beck" <jarro.2783@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <47D86336.2070200@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>
	<47D847AC.9070803@linuxtv.org>
	<abf3e5070803121425k326fd126l1bfd47595617c10f@mail.gmail.com>
	<47D86336.2070200@iki.fi>
Cc: linux-dvb@linuxtv.org, mkrufky@linuxtv.org
Subject: Re: [linux-dvb] NXP 18211HDC1 tuner
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

On Thu, Mar 13, 2008 at 10:11 AM, Antti Palosaari <crope@iki.fi> wrote:
> Jarryd Beck wrote:
>  > On Thu, Mar 13, 2008 at 8:14 AM,  <mkrufky@linuxtv.org> wrote:
>
> >>  Then, please turn ON debug, repeat your tests, and post again with
>  >>  dmesg.  I am not familiar with the af9015 driver, but for tda18271, set
>  >>  debug=1.  (you must unload all modules first -- do 'make unload' in the
>  >>  v4l-dvb dir, then replug your device)
>  >>
>  >>  -Mike
>  >>
>  >>
>  >
>  > Sorry I'm unsure where to set debug.
>  >
>  > Jarryd.
>
>  I added initial support for this tda-tuner to the driver. Jarryd, can
>  you test?
>  http://linuxtv.org/hg/~anttip/af9015_new/
>
>  There is debug switch in af9013 module that may be helpful if it does
>  not work. You can enable it as described or if it is too hard to play
>  with modprobe just edit af9013.c file in frontend directory and set
>  debug=1 by hard coding.
>  If it does not work you can also try set GPIO3 setting (af9015) to 0xb
>  instead 0x3 used currently. Also try to change rf-spectral inversion to
>  see if it helps. Firmware should be ok and all other settings as well as
>  I can see from usb-sniffs. With little lucky it should start working.
>
>  regards
>  Antti
>  --
>  http://palosaari.fi/
>

Thanks, but now for some reason all I get is this:

usb 2-10: new high speed USB device using ehci_hcd and address 6
usb 2-10: configuration #1 chosen from 1 choice
input: Leadtek WinFast DTV Dongle Gold as /class/input/input8
input: USB HID v1.01 Keyboard [Leadtek WinFast DTV Dongle Gold] on
usb-0000:00:02.1-10
af9015_usb_probe:
af9015_identify_state: reply:01
dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold state,
will try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
af9015_download_firmware:
usbcore: registered new interface driver dvb_usb_af9015

Jarryd.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
