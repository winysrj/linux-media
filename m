Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1LEGgl-0004dZ-6K
	for linux-dvb@linuxtv.org; Sun, 21 Dec 2008 06:17:16 +0100
Received: by qw-out-2122.google.com with SMTP id 9so536939qwb.17
	for <linux-dvb@linuxtv.org>; Sat, 20 Dec 2008 21:17:09 -0800 (PST)
Message-ID: <412bdbff0812202117w12d59c2cwa86231a013a81565@mail.gmail.com>
Date: Sun, 21 Dec 2008 00:17:09 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Roshan Karki" <roshan@olenepal.org>
In-Reply-To: <1229772341.6521.5.camel@roxan-laptop>
MIME-Version: 1.0
Content-Disposition: inline
References: <1229772341.6521.5.camel@roxan-laptop>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] YUAN High-Tech STK7700PH problem
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

On Sat, Dec 20, 2008 at 6:25 AM, Roshan Karki <roshan@olenepal.org> wrote:
> Hello,
>
> I have tv-tuner with may laptop. I downloaded the source from
> linuxtv.org and installed it. It asked for two files
> dvb-usb-dib0700-1.20.fw and xc3028-v27.fw. which I copied from internet.
>
> I cant however scan for any channels. I have added dump_stack to
> dib0700_core.c and here is the dmesg output.
>
> http://pastebin.com/d77534a37
>
> snippet from irc
> <roxan> devinheitmueller: does it look if my hardware is damaged?
> <devinheitmueller> Well, the dib7000p demodulator is not answering the
> very first i2c command it is sent, which usually means the chip is
> totally non-functional.
>
> Please help.
> --
> Regards,
> Roshan Karki

To elaborate on Roshan's situation (since I spent an hour debugging it
this morning with him on #linuxtv), basically his problem is the
dib7000p is not responding to even the i2c query for the vendor info
(which is the first request sent to the chip).  I suspect that perhaps
the GPIOs are not setup properly and the chip is being held in reset.

I had him rule out faulty hardware by having him boot into Windows and
successfully perform a capture.

Does anyone know who did the driver work for the "YUAN High-Tech
STK7700PH" product?  I will dig through the hg history if nobody
speaks up...

Also, there were some bugs in the dib0700 exception handling that made
this harder to debug than it should have been.  I will send Patrick
some patches next week if I have time (I found three or four issues).

Devin

 = Below is the dump_stack() results I had him add so we could see
where the i2c error was coming from =

[<f8c36afd>] dib0700_i2c_xfer+0x44d/0x470 [dvb_usb_dib0700]
[<f8acb5c9>] i2c_transfer+0x69/0xa0 [i2c_core]
 [<f8bf7143>] dib7000p_read_word+0x63/0xc0 [dib7000p]
[<f8bf7ebc>] dib7000p_identify+0x2c/0x130 [dib7000p]
[<f8bf8088>] dib7000p_i2c_enumeration+0xc8/0x270 [dib7000p]
[<f8c37609>] stk7700ph_frontend_attach+0x119/0x1c0 [dvb_usb_dib0700]
[<f8bb207b>] dvb_usb_adapter_frontend_init+0x1b/0x100 [dvb_usb]
[<f8bb1917>] dvb_usb_device_init+0x387/0x600 [dvb_usb]
[<f8c36b75>] dib0700_probe+0x55/0x80 [dvb_usb_dib0700]
[<f88df4e7>] usb_probe_interface+0xa7/0x140 [usbcore]
[<c0201107>] ? sysfs_create_link+0x17/0x20
[<c02c3d4e>] really_probe+0xee/0x190
[<f88de8a9>] ? usb_match_id+0x49/0x60 [usbcore]
[<c02c3e33>] driver_probe_device+0x43/0x60
[<c02c3ec9>] __driver_attach+0x79/0x80
[<c02c3593>] bus_for_each_dev+0x53/0x80
[<c02c3b6e>] driver_attach+0x1e/0x20
[<c02c3e50>] ? __driver_attach+0x0/0x80
[<c02c2f37>] bus_add_driver+0x1b7/0x230
[<c02c409e>] driver_register+0x6e/0x150
[<f88df7bc>] usb_register_driver+0x7c/0xf0 [usbcore]
[<f8991000>] ? dib0700_module_init+0x0/0x55 [dvb_usb_dib0700]
[<f8991000>] ? dib0700_module_init+0x0/0x55 [dvb_usb_dib0700]
[<f8991035>] dib0700_module_init+0x35/0x55 [dvb_usb_dib0700]
[<c0101120>] _stext+0x30/0x160
[<c014c604>] ? __blocking_notifier_call_chain+0x14/0x70
[<c015c208>] sys_init_module+0x88/0x1b0
[<c0103f7b>] sysenter_do_call+0x12/0x2f

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
