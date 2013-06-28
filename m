Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-auth.no-ip.com ([8.23.224.61]:3167 "EHLO
	out.smtp-auth.no-ip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754103Ab3F1DAe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 23:00:34 -0400
From: "Carl-Fredrik Sundstrom" <cf@blueflowamericas.com>
To: "'Devin Heitmueller'" <dheitmueller@kernellabs.com>
Cc: <linux-media@vger.kernel.org>
References: <010c01ce7365$9181ff30$b485fd90$@blueflowamericas.com> <CAGoCfiyjeqxVV8A_MM-iV58=s48FEhNPA=5MPg3WAOAKs8d2iA@mail.gmail.com>
In-Reply-To: <CAGoCfiyjeqxVV8A_MM-iV58=s48FEhNPA=5MPg3WAOAKs8d2iA@mail.gmail.com>
Subject: RE: lgdt3304
Date: Thu, 27 Jun 2013 22:00:11 -0500
Message-ID: <011901ce73ab$9b81cce0$d28566a0$@blueflowamericas.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I am able to detect two lgdt3304 one on each i2c bus now. As you suspected I
had to set GPIO pin 17 for them to come alive.

Now to my next question, how do I attach two front ends I have two lgdt3304
and two TDA18271HD/C2 
Is there a good driver I can look at where they do that ?

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

