Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o7K0sYI9024542
	for <video4linux-list@redhat.com>; Thu, 19 Aug 2010 20:54:34 -0400
Received: from smtp.nexicom.net (dell.nexicom.net [216.168.96.13])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o7K0sL0U000354
	for <video4linux-list@redhat.com>; Thu, 19 Aug 2010 20:54:21 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-66-79-239-161.nexicom.net
	[66.79.239.161])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id o7K0sKiK031204
	for <video4linux-list@redhat.com>; Thu, 19 Aug 2010 20:54:20 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 940AA9831D
	for <video4linux-list@redhat.com>; Thu, 19 Aug 2010 20:54:19 -0400 (EDT)
Message-ID: <4C6DD23B.1030404@lockie.ca>
Date: Thu, 19 Aug 2010 20:54:19 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: Video 4 Linux Mailing List <video4linux-list@redhat.com>
Subject: Re: upgraded software and audio stopped working
References: <4C630CEE.7000200@lockie.ca>
In-Reply-To: <4C630CEE.7000200@lockie.ca>
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: Mauro Carvalho Chehab <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

 On 08/11/10 16:49, James wrote:
>  It could just be coincidental that the audio stopped working after I
> upgrade software.
> I didn't try it right after I upgraded the system software so it could
> be the hardware just failed.
> I can still tune channels, I just don't get audio.
>
> bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
> bttv0: Hauppauge eeprom indicates model#44981
> bttv0: tuner type=50
> bttv0: audio absent, no audio device found!
> tuner 2-0061: chip found @ 0xc2 (bt878 #0 [sw])
I upgraded the kernel and the audio out works.

bttv: driver version 0.9.18 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv 0000:02:08.0: PCI INT A -> Link[LNKA] -> GSI 17 (level, low) -> IRQ 17
bttv0: Bt878 (rev 17) at 0000:02:08.0, irq: 17, latency: 32, mmio:
0xcffff000
bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
bttv0: using: Hauppauge (bt878) [card=10,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
bttv0: Hauppauge eeprom indicates model#44981
bttv0: tuner type=50
bttv0: audio absent, no audio device found!
tuner 2-0061: chip found @ 0xc2 (bt878 #0 [sw])
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: PLL: 28636363 => 35468950 .. ok
bttv0: PLL can sleep, using XTAL (28636363).

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
