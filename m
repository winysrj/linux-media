Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:9128 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747Ab1AMNWj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 08:22:39 -0500
Date: Thu, 13 Jan 2011 14:21:44 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 3/3] lirc_zilog: Remove use of deprecated struct  
 i2c_adapter.id field
Message-ID: <20110113142144.662d54e0@endymion.delvare>
In-Reply-To: <1294274780.9672.93.camel@morgan.silverblock.net>
References: <1293587067.3098.10.camel@localhost>
 <1293587390.3098.16.camel@localhost>
 <20110105154553.546998bf@endymion.delvare>
 <1294274780.9672.93.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 05 Jan 2011 19:46:20 -0500, Andy Walls wrote:
> If you look at more of the dumps, it appears that accesses to I2C
> addresses 0x70 and 0x71 can be interleaved, so it looks like the
> IR.ir_lock might not be needed.  Although looking further I see this:
> 
>   2.035mS: 70 W 61 00 00 00   . . . 
>  10.887mS: 70 W 00 40   @ 
>  10.012mS: 70 W 00   
>     681uS: 70 r A0   
>     717uS: 70 W 00 80   . 
>  18.808mS: 70 W  -nak-  
>   1.393mS: 70 W  -nak-  
>   1.393mS: 70 W  -nak-  
>   1.396mS: 70 W  -nak-  
>   1.393mS: 70 W  -nak-  
>   1.393mS: 70 W  -nak- 
> [...]
>   1.393mS: 70 W  -nak-  
>   1.477mS: 71 W  -nak-  
>   1.391mS: 71 W  -nak-  
>   1.393mS: 71 W  -nak-  
>   1.393mS: 71 W  -nak-  
>   1.391mS: 71 W  -nak-  
>   1.438mS: 71 W 00   
>     681uS: 71 r 00 00 00 00 00 00   . . . . . 
>  51.079mS: 70 W 00   
>     681uS: 70 r 80
> 
> Which seems to indicate that actions taken on the Transmit side of the
> chip can cause it to go unresponsive for both Tx and Rx.  The "goto
> done;" statement that was in lirc_zilog skips the code that deals with
> those -nak- for the HD PVR.

My bet is that register at 0x00 is a control register, and writing bit
7 (value 0x80) makes the chip busy enough that it can't process I2C
requests at the same time. The following naks would be until the
chip is operational again.

In fact, the "waiting" code in lirc_zilog.c:send_code() makes a lot of
sense, and I wouldn't skip it: if the device is busy, you don't want to
return immediately, otherwise a subsequent request will fail. The
failure documented for the HD PVR simply suggests that the wait loop
isn't long enough. It is 20 * 50 ms currently, i.e. 1 second total,
maybe this isn't sufficient. Have you ever tried a longer delay?

-- 
Jean Delvare
