Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail21.extendcp.co.uk ([79.170.40.21])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mailing-lists@enginuities.com>) id 1Ly5wZ-0001jD-MQ
	for linux-dvb@linuxtv.org; Sun, 26 Apr 2009 17:07:00 +0200
From: Stuart <mailing-lists@enginuities.com>
To: Antti Palosaari <crope@iki.fi>
Date: Mon, 27 Apr 2009 01:08:13 +1000
References: <200903140506.00723.mailing-lists@enginuities.com>
	<200904221726.00028.mailing-lists@enginuities.com>
	<49EF5F85.2040909@iki.fi>
In-Reply-To: <49EF5F85.2040909@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904270108.15538.mailing-lists@enginuities.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Patch for DigitalNow TinyTwin remote.
Reply-To: linux-media@vger.kernel.org
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

Hi Antti,

> I have ~same stick (AzureWave) as you have and Fedora 10
> x86 and same fw. It is strange that this repeating issue does not affect
>   me :o I have seen this problem earlier, but don't remember which hw,
> fw and Fedora version was running.

The drivers contain firmware that is downloaded at offset 0x5100. Perhaps 
different devices have different firmware below this value, I believe mine is 
V3.0 (I'll explain later).

The only other thing I can think of is to do with polling. You may find slightly 
different behaviour with:

echo "1" > /sys/module/dvb_usb/parameters/disable_rc_polling

Also, if you have debugfs and usbmon then looking at the usbmon output for the 
device when a key is pressed on the remote may be interesting as well (obviously 
with polling disabled).

In case you're interested here's my list:

Kernel: 2.6.29
Distribution: Gentoo
Device: DigitalNow TinyTwin

Driver firmware issues:
4.95.0: 17x delay bug
All: Incorrectly report bInterval as full speed for high speed bus (can be 
worked around using HID quirks).

> I think hw is very much used Intel 8051 based, it could be nice to see
> decompile from various firmwares. I tried that before but without
> success - probably I don't have experience needed to set-up decompiler
> parameters.

It certainly seems to be an 8051/2 style uC. I've managed to download the memory 
up to 0x5100, combine this with the different versions of firmware from the 
drivers and disassemble them.

Looking at the memory downloaded from the device shows 'V3.0' at offset 0x0542, 
leading me to believe that may be the version for the code pre-programmed in to 
this device (as opposed to the driver firmware version).

> Probably I can try to ask manufacturer also fix for fw, don't know
> what's their response because AF9015 is old chipset and AF9035 is
> current one.

It would be best if they could help in some way, if they won't fix the firmware 
then if they could provide some source code that would be fantastic, otherwise 
some documentation would go a long way. I've managed to work out some of the 
simpler things and started to run it through a simulator but it'll take a while 
to work through the code without any documentation/source code!

Cheers,

Stuart


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
