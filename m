Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:42136 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab0AIR0v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jan 2010 12:26:51 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NTf5M-0002Jl-7z
	for linux-media@vger.kernel.org; Sat, 09 Jan 2010 18:26:48 +0100
Received: from upc.si.94.140.72.111.dc.cable.static.telemach.net ([94.140.72.111])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 09 Jan 2010 18:26:48 +0100
Received: from prusnik by upc.si.94.140.72.111.dc.cable.static.telemach.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 09 Jan 2010 18:26:48 +0100
To: linux-media@vger.kernel.org
From: =?UTF-8?Q?Alja=C5=BE?= Prusnik <prusnik@gmail.com>
Subject: Re: Which modules for the VP-2033? Where is the module "mantis.ko"?
Date: Sat, 09 Jan 2010 18:26:09 +0100
Message-ID: <1263057968.3484.149.camel@slash.doma>
References: <4B1D6194.4090308@freenet.de>
	 <1261578615.8948.4.camel@slash.doma> <200912231753.28988.liplianin@me.by>
	 <1261586462.8948.23.camel@slash.doma> <4B3269AE.6080602@freenet.de>
	 <1a297b360912231124v6e31c9e6ja24d205f6b5dc39@mail.gmail.com>
	 <1261611901.8948.37.camel@slash.doma> <4B339A8F.8020201@freenet.de>
	 <1261673477.2119.1.camel@slash.doma>
	 <1a297b360912271423x2f5b48caw7b2adad8849280ee@mail.gmail.com>
Reply-To: abraham.manu@gmail.com, liplianin@me.by
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1a297b360912271423x2f5b48caw7b2adad8849280ee@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Still no change regarding regaining IR support for VP2040 device.
Despite successfully loading the module from Abraham's tree and starting
the UART, I still do not see the input device that I can use with lirc.

I tried both trees:
today's Liplianin tree, dmesg on loading the mantis module:

ir_common: Unknown symbol ir_g_keycode_from_table
ir_common: Unknown symbol ir_core_debug


today's Abraham's tree, dmesg on loading the mantis modulem verbose=5: 

the result is still the same as the last time I wrote about it (no input
device is registered, despite successful uart initialization).





