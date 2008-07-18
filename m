Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rn-out-0910.google.com ([64.233.170.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1KJrJi-0003jz-K4
	for linux-dvb@linuxtv.org; Fri, 18 Jul 2008 16:52:19 +0200
Received: by rn-out-0910.google.com with SMTP id m36so141063rnd.2
	for <linux-dvb@linuxtv.org>; Fri, 18 Jul 2008 07:52:13 -0700 (PDT)
Message-ID: <854d46170807180752p2fcc6653occb590199eb28e0b@mail.gmail.com>
Date: Fri, 18 Jul 2008 16:52:12 +0200
From: "Faruk A" <fa@elwak.com>
To: alain@satfans.be
In-Reply-To: <78fbccd765c111c5f53504a4f5b1fc45@localhost>
MIME-Version: 1.0
Content-Disposition: inline
References: <78fbccd765c111c5f53504a4f5b1fc45@localhost>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technotrend TT3650 S2 USB and multiproto
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi!

You don't have to compile every modules in multiproto just compile
what you need for S2-3650_CI
cd to multiproto/v4l
and create a file name .config
add:

CONFIG_INPUT=y
CONFIG_USB=y
CONFIG_PARPORT=m
CONFIG_FW_LOADER=m
CONFIG_NET=y
CONFIG_SND_AC97_CODEC=m
CONFIG_I2C=m
CONFIG_STANDALONE=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND=m
CONFIG_MODULES=y
CONFIG_HAS_IOMEM=y
CONFIG_PROC_FS=y
CONFIG_I2C_ALGOBIT=m
CONFIG_INET=y
CONFIG_CRC32=m
CONFIG_FB=y
CONFIG_SYSFS=y
CONFIG_PCI=y
CONFIG_SND_PCM=m
CONFIG_PARPORT_1284=y
CONFIG_EXPERIMENTAL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_DVB_CORE=m
CONFIG_DVB_CAPTURE_DRIVERS=y
CONFIG_DVB_PLL=m
CONFIG_DVB_USB=m
CONFIG_DVB_USB_PCTV452E=m
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_LNBP22=m

Faruk


2008/7/18  <alain@satfans.be>:
> Hi,
>
> I'm trying to use my DVB S2 USB with Ubuntu8.04 and MyTheatre.
> I found an how to
> [url]http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-connect_S2-3650_CI[/url]
> But I get stuck with the fail of the make.
> It claims about the audio driver?
> [QUOTE]make[2]: Entering directory
> `/usr/src/linux-headers-2.6.24-19-generic'
>   CC [M]  /home/alain/3650/multiproto/v4l/em28xx-audio.o
> In file included from /home/alain/3650/multiproto/v4l/em28xx-audio.c:39:
> include/sound/core.h:281: error: 'SNDRV_CARDS' undeclared here (not in a
> function)
> /home/alain/3650/multiproto/v4l/em28xx-audio.c:58: error: array index in
> initializer not of integer type
> /home/alain/3650/multiproto/v4l/em28xx-audio.c:58: error: (near
> initialization for 'index')
> make[3]: *** [/home/alain/3650/multiproto/v4l/em28xx-audio.o] Error 1
> [/QUOTE]
>
> Did someone succeed?
> I suppose it's due to the constant changing of the multiproto drive?
>
> Hope someone have a solution or I will have to forget Linux and decide that
> it still can't replace Windows.
>
> Thanks.
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
