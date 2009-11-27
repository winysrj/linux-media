Return-path: <linux-media-owner@vger.kernel.org>
Received: from n71.bullet.mail.sp1.yahoo.com ([98.136.44.36]:21374 "HELO
	n71.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753105AbZK0KMg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 05:12:36 -0500
Message-ID: <214960.24182.qm@web110609.mail.gq1.yahoo.com>
References: <754577.88092.qm@web110614.mail.gq1.yahoo.com>  <1259025174.5511.24.camel@pc07.localdom.local>  <990417.69725.qm@web110607.mail.gq1.yahoo.com>  <1259107698.2535.10.camel@localhost>  <623705.13034.qm@web110608.mail.gq1.yahoo.com> <1259172867.3335.7.camel@pc07.localdom.local>
Date: Fri, 27 Nov 2009 02:12:42 -0800 (PST)
From: Dominic Fernandes <dalf198@yahoo.com>
Subject: Re: Compile error saa7134 - compro videomate S350
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1259172867.3335.7.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hermann,

> unload the driver with "modprobe -vr saa7134-alsa saa7134-dvb".

When I tried this I got the message "FATAL: saa7134-alsa is in use" (or something like that).

>You might have to close mixers using saa7134-alsa previously.
> With "modinfo saa7134" you get available options.

I wasn't sure what to look for here, there was a lot of info. being displayed.

I carried on with "modprobe -v saa7134 card=169" command.  I ran dmesg to see the status of the card.  It did get the card id 169 but the board decription came up as unknown instead of the name of the videomate S350.  Is this expected?

The modification of the GPIO address "Instead of 0x8000 used in Jan's patch, use 0xC000 for GPIO setup" I'm not sure what I changed was the correct value.  Looking at the code lines I found relate to the Remote that I had changed (saa7134-cards.c):


+	case SAA7134_BOARD_VIDEOMATE_S350:
+		dev->has_remote = SAA7134_REMOTE_GPIO;
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
+		break;

Which leads to the question where the GPIO address of 0x8000 is currently specified?


Thanks,
Dominic




----- Original Message ----
From: hermann pitton <hermann-pitton@arcor.de>
To: Dominic Fernandes <dalf198@yahoo.com>
Cc: linux-media@vger.kernel.org
Sent: Wed, November 25, 2009 6:14:27 PM
Subject: Re: Compile error saa7134 - compro videomate S350

Hi Dominic,

Am Mittwoch, den 25.11.2009, 08:31 -0800 schrieb Dominic Fernandes:
> Hi Hermann,
> 
> Thanks for your reply.  I'm a little lost in what to do next.
> 
> How do I force the card to be recongised as card 169 (the compro videomate S350) instead of card 139?

unload the driver with "modprobe -vr saa7134-alsa saa7134-dvb".

You might have to close mixers using saa7134-alsa previously.
With "modinfo saa7134" you get available options.

With "modprobe -v saa7134 card=169" you can force that card then.

If we disable the T750 auto detection in saa7134-cards.c, both have to
force the correct card number.

Cheers,
Hermann


      

