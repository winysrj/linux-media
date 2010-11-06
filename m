Return-path: <mchehab@gaivota>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53656 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab0KFAlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Nov 2010 20:41:08 -0400
Received: by bwz11 with SMTP id 11so3222610bwz.19
        for <linux-media@vger.kernel.org>; Fri, 05 Nov 2010 17:41:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimpXwWGJfXRa=_38SKbKyfu_6sEME=in7YESV8x@mail.gmail.com>
References: <AANLkTimpXwWGJfXRa=_38SKbKyfu_6sEME=in7YESV8x@mail.gmail.com>
Date: Sat, 6 Nov 2010 01:41:04 +0100
Message-ID: <AANLkTi=BEfin74WWmqppLZ945dcdxH3NYnOBoCkpPb3B@mail.gmail.com>
Subject: Re: Tevii S470 on Debian Squeeze
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media@vger.kernel.org,
	Discussion about mythtv <mythtv-users@mythtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Thanks to Pedro i make it working, it works this way:

mkdir /usr/local/src/dvb
cd /usr/local/src/dvb
wget http://tevii.com/100315_Beta_linux_tevii_ds3000.rar
unrar x 100315_Beta_linux_tevii_ds3000.rar
cp *.fw /lib/firmware
tar xjvf linux-tevii-ds3000.tar.bz2
cd linux-tevii-ds3000
make && make install

I have the adapter, but I can't use the remote and can't compile SASC.

I want to try the liplianin drivers. Is there any way to get ir
working on this card?

Thanks and best regards.

2010/11/4 Josu Lazkano <josu.lazkano@gmail.com>:
> Hello, I am having some problems to get working my Tevii S470 DVB-S2 PCIe card.
>
> I am using a Debian Squeeze (2.6.32-5-686) system on a Intel Atom 330
> (Nvidia ION) machine. I read the LinuxTV wiki:
> http://www.linuxtv.org/wiki/index.php/TeVii_S470#Older_kernels
>
> These are my steps:
>
> 1. Donwloas the Tevii driver:
>  wget -c http://tevii.com/tevii_ds3000.tar.gz
>  tar zxfv tevii_ds3000.tar.gz
>  su
>  cp tevii_ds3000/dvb-fe-ds3000.fw /lib/firmware/
>
> 2. Download s2-liplianin:
>  hg clone http://mercurial.intuxication.org/hg/s2-liplianin
>
> 3. When I run make I have some warnings and errors: (all the log from
> make: http://dl.dropbox.com/u/1541853/tevii/s2-liplianin_make)
>  make[5]: *** [/home/lazkano/s2-liplianin/v4l/ir-sysfs.o] Error 1
>  make[4]: *** [_module_/home/lazkano/s2-liplianin/v4l] Error 2
>
> This is my card info:
>  $ lspci | grep CX23885
>  05:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885
> PCI Video and Audio Decoder (rev 02)
>
> Can you help with this?
>
> Thanks for all your help and best regards
>
>
> --
> Josu Lazkano
>



-- 
Josu Lazkano
