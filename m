Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:62627 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896AbZKWLLl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 06:11:41 -0500
Date: Mon, 23 Nov 2009 12:11:40 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mario Bachmann <mbachman@stud.uni-frankfurt.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: dibusb-common.c FE_HAS_LOCK problem
In-Reply-To: <20091123120310.5b10c9cc@x2.grafnetz>
Message-ID: <alpine.LRH.2.00.0911231206450.14263@pub1.ifh.de>
References: <20091107105614.7a51f2f5@x2.grafnetz> <alpine.LRH.2.00.0911191630250.12734@pub2.ifh.de> <20091121182514.61b39d23@x2.grafnetz> <alpine.LRH.2.00.0911230947540.14263@pub1.ifh.de> <20091123120310.5b10c9cc@x2.grafnetz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Nov 2009, Mario Bachmann wrote:
>> sequence in dibusb_i2c_xfer
>>
>> instead of break, please add something like
>>
>> printk(KERN_ERR "----- hello stupid I2C access ----\n");
>>
>> recompile and load the new module, then check whether the line is
>> appearing in /var/log/messages or /var/log/syslog when you tune the board.
>>
>> If this is the case, try to identify which device is issuing the access by
>> printing the i2c-address of struct i2c_msg.
>>
>> HTH,
>> --
>>
>> Patrick
>> http://www.kernellabs.com/
>
> Hello Patrick,
>
> I tried it with Kernel 2.6.31.6 (same as before).
>
> I made the printk-change, recompiled and reloaded the modules and pluged in my Twinhan Magic Box...
> It definately jumps in the last else-branch and shows "hello stupid I2C access", but no KERN_ERR ?!

KERN_ERR is a prefix for printk to define the message priority to high. 
(to have it in syslog or messages)

> dibusb: This device has the Thomson Cable onboard. Which is default.
> ----- hello stupid I2C access ----

Hmm... where is this coming from:

can you write it like that:

else {
 	printk(...);
 	dump_stack();
}

> Hey, without the break-command, tuning seems to work:
> $ tzap pro7 -r
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> reading channels from file '/home/grafrotz/.tzap/channels.conf'
> tuning to 738000000 Hz
> video pid 0x0131, audio pid 0x0132
> status 00 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff |
> status 1f | signal 0b20 | snr 008d | ber 001fffff | unc 0000ffff | FE_HAS_LOCK
> status 1f | signal f4dd | snr 0077 | ber 00000770 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal ffff | snr 008c | ber 00000770 | unc 00000000 | FE_HAS_LOCK

We are close to identify the drivers in charge for the stupid I2c access.

--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
