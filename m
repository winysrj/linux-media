Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-auth.no-ip.com ([8.23.224.61]:2623 "EHLO
	out.smtp-auth.no-ip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751569Ab3F0Upz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 16:45:55 -0400
From: "Carl-Fredrik Sundstrom" <cf@blueflowamericas.com>
To: "'Devin Heitmueller'" <dheitmueller@kernellabs.com>
Cc: <linux-media@vger.kernel.org>
References: <010c01ce7365$9181ff30$b485fd90$@blueflowamericas.com> <CAGoCfiyjeqxVV8A_MM-iV58=s48FEhNPA=5MPg3WAOAKs8d2iA@mail.gmail.com>
In-Reply-To: <CAGoCfiyjeqxVV8A_MM-iV58=s48FEhNPA=5MPg3WAOAKs8d2iA@mail.gmail.com>
Subject: RE: lgdt3304
Date: Thu, 27 Jun 2013 15:45:33 -0500
Message-ID: <011101ce7377$45180e70$cf482b50$@blueflowamericas.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


One of the TDA18271HD/C2 is detected on the secondary i2c bus at address
0x60. I haven't tried yet to find the second one.

The SAA7160E PCI-E interface has the following GPIO 

GPIO_[15:1]: interrupts from other external devices
GPIO_[23:16]: chip select to other external devices
GPIO_[29:26]: general purpose
BOOT_0 and BOOT_1: boot mode. The boot mode pins can be used as application
GPIO pins after 500 ms (after power-up). The boot mode has been latched.

All of them  are input and output with internal pull-up, so they should all
be set high.

Should I just try to change them all to outputs and then set them low one by
one until something answers at address 0x0e or 0x59? 

Thanks /// Carl

-----Original Message-----
From: Devin Heitmueller [mailto:dheitmueller@kernellabs.com] 
Sent: Thursday, June 27, 2013 1:59 PM
To: Carl-Fredrik Sundstrom
Cc: linux-media@vger.kernel.org
Subject: Re: lgdt3304

On Thu, Jun 27, 2013 at 2:38 PM, Carl-Fredrik Sundstrom
<cf@blueflowamericas.com> wrote:
>
> Has the driver for lgdt3304 been tested ? I am trying to get a new 
> card working
>
> AVerMedia AVerTVHD Duet PCTV tuner (A188) A188-AF PCI-Express x1 
> Interface
>
> It is using
>
> 1 x saa7160E
> 2 x LGDT3304
> 2 x TDA18271HD/C2
>
> I get so far that I can load a basic driver by modifying the existing 
> saa716x driver, I can detect the TDA18271HD/C2, but I fail to detect 
> the
> LGDT3304 when attaching it using the 3305 driver.
>
> I always fail at the first read from LGDT3305_GEN_CTRL_2, does this 
> register even exist in lgdt3304 or is it specific to lgdt3305?
>
>         /* verify that we're talking to a lg dt3304/5 */
>          ret = lgdt3305_read_reg(state, LGDT3305_GEN_CTRL_2, &val);
>          if ((lg_fail(ret)) | (val == 0))
>         {
>                 printk("fail 1\n");
>                 goto fail;
>         }
>
> Since I do find the TDA18271HD/C2 I don't think there is something 
> wrong with the i2c buss. I also tried every possible i2c address without
success.
> The lgdt3305 has option between address 0x0e and 0x59, is it the same 
> for
> 3304 ?
>
> This is the first time I am trying to get a driver to work in Linux. 
> Please help me.

Either the i2c is broken or the lgdt3304 is being held in reset by a GPIO.

Also, that device has multiple i2c busses, so you could be looking on the
wrong bus.

Do you see *any* i2c devices (such as an eeprom).

Devin

--
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

