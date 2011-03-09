Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57759 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901Ab1CIPyw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 10:54:52 -0500
Received: by vxi39 with SMTP id 39so570627vxi.19
        for <linux-media@vger.kernel.org>; Wed, 09 Mar 2011 07:54:51 -0800 (PST)
References: <20110309175231.16446e92.jean.bruenn@ip-minds.de>
In-Reply-To: <20110309175231.16446e92.jean.bruenn@ip-minds.de>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <76A39CFB-2838-4AD7-B353-49971F9F7DFF@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: linux-media@vger.kernel.org
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: WinTV 1400 broken with recent versions?
Date: Wed, 9 Mar 2011 10:55:03 -0500
To: Jean-Michel Bruenn <jean.bruenn@ip-minds.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mar 9, 2011, at 11:52 AM, Jean-Michel Bruenn wrote:

> Hey,
> 
> is this driver going to be fixed anytime soon? It was working fine ago a
> half year/year.
> 
> lspci:
> 06:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI
> Video and Audio Decoder (rev 02)
> 
> uname -a:
> Linux lyra 2.6.37.1 #1 SMP PREEMPT Tue Feb 22 13:22:59 CET 2011 x86_64
> x86_64 x86_64 GNU/Linux
> 
> dmesg:
> xc2028 1-0064: i2c output error: rc = -6 (should be 64)
> xc2028 1-0064: -6 returned from send
> xc2028 1-0064: Error -22 while loading base firmware
> xc2028 1-0064: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 1-0064: i2c output error: rc = -6 (should be 64)
> xc2028 1-0064: -6 returned from send
> xc2028 1-0064: Error -22 while loading base firmware
> xc2028 1-0064: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 1-0064: i2c output error: rc = -6 (should be 64)
> xc2028 1-0064: -6 returned from send
> xc2028 1-0064: Error -22 while loading base firmware
> 
> nothing works - if i do scan it finds nothing and those messages appear on
> dmesg. if i try to watch with the channels.conf from my other pc i can play
> nothing, all i get is those messages above.

This may already be fixed, just not in 2.6.37.x yet. Can you give
2.6.38-rc8 (or later) a try and/or the media_build bits?

http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

-- 
Jarod Wilson
jarod@wilsonet.com



