Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:61076 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab3F0S70 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 14:59:26 -0400
Received: by mail-qa0-f47.google.com with SMTP id i13so18744qae.20
        for <linux-media@vger.kernel.org>; Thu, 27 Jun 2013 11:59:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <010c01ce7365$9181ff30$b485fd90$@blueflowamericas.com>
References: <010c01ce7365$9181ff30$b485fd90$@blueflowamericas.com>
Date: Thu, 27 Jun 2013 14:59:26 -0400
Message-ID: <CAGoCfiyjeqxVV8A_MM-iV58=s48FEhNPA=5MPg3WAOAKs8d2iA@mail.gmail.com>
Subject: Re: lgdt3304
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Carl-Fredrik Sundstrom <cf@blueflowamericas.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 27, 2013 at 2:38 PM, Carl-Fredrik Sundstrom
<cf@blueflowamericas.com> wrote:
>
> Has the driver for lgdt3304 been tested ? I am trying to get a new card
> working
>
> AVerMedia AVerTVHD Duet PCTV tuner (A188) A188-AF PCI-Express x1 Interface
>
> It is using
>
> 1 x saa7160E
> 2 x LGDT3304
> 2 x TDA18271HD/C2
>
> I get so far that I can load a basic driver by modifying the existing
> saa716x driver, I can detect the TDA18271HD/C2, but I fail to detect the
> LGDT3304 when attaching it using the 3305 driver.
>
> I always fail at the first read from LGDT3305_GEN_CTRL_2, does this register
> even exist in lgdt3304 or is it specific to lgdt3305?
>
>         /* verify that we're talking to a lg dt3304/5 */
>          ret = lgdt3305_read_reg(state, LGDT3305_GEN_CTRL_2, &val);
>          if ((lg_fail(ret)) | (val == 0))
>         {
>                 printk("fail 1\n");
>                 goto fail;
>         }
>
> Since I do find the TDA18271HD/C2 I don't think there is something wrong
> with the i2c buss. I also tried every possible i2c address without success.
> The lgdt3305 has option between address 0x0e and 0x59, is it the same for
> 3304 ?
>
> This is the first time I am trying to get a driver to work in Linux. Please
> help me.

Either the i2c is broken or the lgdt3304 is being held in reset by a GPIO.

Also, that device has multiple i2c busses, so you could be looking on
the wrong bus.

Do you see *any* i2c devices (such as an eeprom).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
