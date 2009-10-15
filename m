Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n9FMevtF007852
	for <video4linux-list@redhat.com>; Thu, 15 Oct 2009 18:40:57 -0400
Received: from mail-ew0-f205.google.com (mail-ew0-f205.google.com
	[209.85.219.205])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n9FMe9M7001291
	for <video4linux-list@redhat.com>; Thu, 15 Oct 2009 18:40:47 -0400
Received: by mail-ew0-f205.google.com with SMTP id 1so1001726ewy.3
	for <video4linux-list@redhat.com>; Thu, 15 Oct 2009 15:40:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309046926@web.de>
References: <1309046926@web.de>
Date: Thu, 15 Oct 2009 18:40:47 -0400
Message-ID: <37219a840910151540u5aea8b93pe96bbf4a4d83acb0@mail.gmail.com>
From: Michael Krufky <mkrufky@linuxtv.org>
To: =?ISO-8859-1?Q?Michael_Gr=FCtzmann?= <Avalone@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: tuner type
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Thu, Oct 15, 2009 at 4:16 PM, Michael Grützmann <Avalone@web.de> wrote:
> Dear to all,
>
> I have an Medion 7134 card, so I use the saa7134 module with a 2.6.25 kernel (card=12). But I have a question. Which tuner type should I use?
>  cat /var/log/boot.msg |grep saa
> <6>saa7130/34: v4l2 driver version 0.2.14 loaded
> <6>saa7134[0]: found at 0000:00:0b.0, rev: 1, irq: 18, latency: 32, mmio: 0xdffffc00
> <6>saa7134[0]: subsystem: 16be:0003, board: Medion 7134 [card=12,autodetected]
> <6>saa7134[0]: board init: gpio is 0
> <6>saa7134[0]: i2c eeprom 00: be 16 03 00 08 20 1c 55 43 43 a9 1c 55 43 43 a9
> <6>saa7134[0]: i2c eeprom 10: ff ff ff ff 15 00 0e 01 0c c0 08 00 00 00 00 00
> <6>saa7134[0]: i2c eeprom 20: 00 00 00 e3 ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>tuner' 2-0043: chip found @ 0x86 (saa7134[0])
> <6>tuner' 2-0060: chip found @ 0xc0 (saa7134[0])
> <6>saa7134[0] Tuner type is 38
> <6>saa7134[0]: registered device video0 [v4l2]
> <6>saa7134[0]: registered device vbi0
> <6>saa7134[0]: registered device radio0
> <3>saa7134[0]/dvb: frontend initialization failed
> It is not tuner=38.
> On the card, there stands: 'tuner philips 3139 147 18201H#'.
> There are two Ambient chips on it. One chip ctis0tp. If needed, I can write to you the full chip labelings.
> Your help would be appreciated.
> ps. I'm a linux newbie (use it for 2 years). Maybe you could also tell me how to write the changes made manually to modules.d, so the changes aren't lost when rebooting.
>
> Thanks in advance,
> Dirk

Dirk,

The tuner labelled, "3139 147 18201H" should be tuner # 63 - Philips
FMD1216ME MK3 Hybrid Tuner

I hope this helps you.

Regards,

Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
