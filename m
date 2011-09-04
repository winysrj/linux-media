Return-path: <linux-media-owner@vger.kernel.org>
Received: from nskntmtas04p.mx.bigpond.com ([61.9.168.146]:47069 "EHLO
	nskntmtas04p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753425Ab1IDNKG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Sep 2011 09:10:06 -0400
Received: from nskntotgx02p.mx.bigpond.com ([121.214.104.126])
          by nskntmtas04p.mx.bigpond.com with ESMTP
          id <20110904131004.FNZN1385.nskntmtas04p.mx.bigpond.com@nskntotgx02p.mx.bigpond.com>
          for <linux-media@vger.kernel.org>; Sun, 4 Sep 2011 13:10:04 +0000
Received: from [192.168.0.204] (really [121.214.104.126])
          by nskntotgx02p.mx.bigpond.com with ESMTP
          id <20110904131003.BGAR17136.nskntotgx02p.mx.bigpond.com@[192.168.0.204]>
          for <linux-media@vger.kernel.org>; Sun, 4 Sep 2011 13:10:03 +0000
Message-ID: <4E6378AD.7040004@bigpond.com>
Date: Sun, 04 Sep 2011 23:10:05 +1000
From: Declan Mullen <declan.mullen@bigpond.com>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: New Hauppauge HVR-2200 Revision?
References: <1313434995.7350.26.camel@adrien-nb>
In-Reply-To: <1313434995.7350.26.camel@adrien-nb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/08/2011 5:03 AM, Adrien Dorsaz wrote:
> Hi,
>
> I've recently bought two cards HVR-2200 rev 0700:8940 and installed them
> into one PC. Kernel module saa7164 was launched by linux (under Ubuntu
> 11.04, with kernel 2.6.38-10-generic-pae), but it didn't recognize my
> cards (so, it selected card 0 : unknown).
>
> I've seen a new patch on your mailing list (see archive [1] and the
> patch [2]), but it was apparently only applied on kernellabs.org and not
> in the linuxtv.org archive.
>
> So I've downloaded the Ubuntu linux source (with apt-get install
> linux-source), I've patched it following the diff [2] and I've compiled
> this new kernel.
>
> Now when I reboot it, it works really well : I don't need any more to
> say which cards I've in /etc/modprobe.d/saa-7164.conf and both were well
> recognized (I've seen my four adapters in /dev/dvb/adapter[0,1,2,3]).
>
> So, could you apply this patch also on your source please (and try it to
> confirm my tests)?
>
> Thank you very much,
> Adrien Dorsaz
> a.dorsaz@gmail.com
>
> [1] :
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg14612.html ,
> and the message which give a patch :
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg14626.html
>
> [2] : the patch on kernellabs.org :
> http://www.kernellabs.com/hg/saa7164-stable/rev/cf2d7530d676
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I've just done something similar.

I installed the source code for my Ubuntu 10.10 x86 32bit kernel:
    apt-get source linux-image-2.6.35-30-generic-pae

I got the source code of the version of the saa7164 driver that supports 
the "0700:8940" revision of the 2200 card from Kernel Labs by:
   git clone git://kernellabs.com/stoth/saa7164-stable.git
   cd saa7164-stable
   git checkout 87e0c0378bf2068df5d0c43acd66aea9ba71bd89
   make clean

Many thanks to Steven Toth (driver author) for telling me about the 
"87e0c0378bf2068df5d0c43acd66aea9ba71bd89" commit.

I then replaced the Ubuntu kernal source's 
"linux-2.6.35/drivers/media/video/saa7164/" directory with that from the 
above "87e0c0378bf2068df5d0c43acd66aea9ba71bd89" commit and then 
recompiled the ubuntu kernel source.

I found the instructions at 
"http://linuxtweaking.blogspot.com/2010/05/how-to-compile-kernel-on-ubuntu-1004.html<http://linuxtweaking.blogspot.com/2010/05/how-to-compile-kernel-on-ubuntu-1004.html>" 
for getting the ubuntu kernel source code and recompiling it most helpfull.

I got the following firmware from http://www.steventoth.net/linux/hvr22xx :
   dvb-fe-tda10048-1.0.fw
   NXP7164-2010-03-10.1.fw

After putting the firmware files into place and doing a cold reboot, the 
card's DVB-T functionality seems to be working fine within my Mythtv 0.24.

Regards,
Declan

