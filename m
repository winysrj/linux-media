Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp22.services.sfr.fr ([93.17.128.13]:43024 "EHLO
	smtp22.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab0BOWDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 17:03:40 -0500
From: "ftape-jlc" <ftape-jlc@club-internet.fr>
Reply-To: ftape-jlc@club-internet.fr
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Fwd: Re: FM radio problem with HVR1120
Date: Mon, 15 Feb 2010 23:03:37 +0100
References: <201001252029.12009.ftape-jlc@club-internet.fr> <4B733321.40803@redhat.com>
In-Reply-To: <4B733321.40803@redhat.com>
MIME-Version: 1.0
Message-Id: <201002152303.37084.ftape-jlc@club-internet.fr>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here the results of tests.

In FM radio mode regspy.exe reports :
GPIO_GPSTATUS 2840001
In Digital TV
GPIO_GPSTATUS 6040001
In Analog TV
GPIO_GPSTATUS 2040001

In saa7134-cards.c, In section of HVR1120, I've replaced 0x0800100 with 
0x2840001 in both lines
gpiomask and in
radio = {
			.name = name_radio,
			.amux = TV,
			.gpio = 0x2840001,  

The result is the same. No progress.

To check my install method (I am not professional programmer), I have tested 
the driver with replacing "audio_clock = 0x00187de7" with "audio_clock = 
0x200000". The result was worst. I can conclude make and make install are 
correct.

All tests have been made today using v4l-dvb-14021dfc00f3.tar.gz
All changes have been followed by computer reboot.

Coul I check anything else ?

Regards,

ftape-jlc

Le mercredi 10 février 2010, vous avez écrit :
> Hi,
> 
> ftape-jlc wrote:
> > Hello,
> >
> > I didn't received any message about radio on HVR1120.
> > I just want to know if the use /dev/radio0 is deprecated in v4l2 today.
> > In the mails, I only read messages about video or TV.
> 
> No, it is not deprecated.
> 
> > Did one user of the mailing list have tested actual v4l2 on /dev/radio0 ?
> 
> Yes. It works with several devices. Maybe there's a bug at the radio entry
> for your board.
> 
> >> The problem is to listen radio.
> >> With Linux, the command used is
> >> /usr/bin/radio -c /dev/radio0
> >> in association with
> >> sox -t ossdsp -r 32000 -c 2 /dev/dsp1 -t ossdsp /dev/dsp
> >> to listen the sound.
> >>
> >> The result is an unstable frecuency. The station is not tuned. Stereo is
> >> permanently switching to mono.
> >> The 91.5MHz station is mixed permanently with other stations.
> 
> This probably means that the GPIO setup for your board is wrong for radio.
> Only someone with a HVR1120 could fix it, since the GPIO's are
>  board-specific.
> 
> The better is if you could try to do it. It is not hard. Please take a look
>  at:
> 
> http://linuxtv.org/wiki/index.php/GPIO_pins
> 
> You'll need to run the regspy.exe utility (part of Dscaler package), and
>  check how the original driver sets the GPIO registers. Then edit them on
>  your board entry, at saa78134-cards.c, recompile the driver and test.
> 
> The better is to use the out-of-tree mercuiral tree:
> 	http://linuxtv.org/hg/v4l-dvb
> 
> since it allows you to recompile and test without needing to replace your
>  kernel.
> 
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


