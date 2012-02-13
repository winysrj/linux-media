Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:48154 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752330Ab2BMJiJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Feb 2012 04:38:09 -0500
Received: by obcva7 with SMTP id va7so6350986obc.19
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2012 01:38:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <53964DF8FAB24E4B882E96DCDE43BD32@Phoenix107>
References: <53964DF8FAB24E4B882E96DCDE43BD32@Phoenix107>
Date: Mon, 13 Feb 2012 10:38:08 +0100
Message-ID: <CAGH6_poRG-X+QBqGBeebqYGwdSYhpT0Cmo9O3YjkB2WWp6uMtg@mail.gmail.com>
Subject: Re: tw68-v2-lucid-tw6804 and tw68-v2
From: Domenico Andreoli <domenico.andreoli.it@gmail.com>
To: Phoenix <phoenix.gao@tech-trans.com>
Cc: wbrack@mmm.com.hk, linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

  yes, I know that some good work is waiting to be done on those
drivers. Unfortunately I have not any of those boards and any time to
work on it. And I'm sad for this because that is a nice project
waiting for some some love in order to be mainlined.


cheers,
Domenico

2012/2/13 Phoenix <phoenix.gao@tech-trans.com>:
> Hi all,
>
> I'm sorry for troubling you, but I have searched a lot on google, but can't
> find anything helpful.
>
> First, please allow me ask one question: Are TW6815(PCI), TW6816(PCI) and
> TW6869 supported by the driver?
>
> As far as I know, these are V4L2 device drivers for Techwell TW6800 based
> cards.
>
> I got TW6805A worked by using tw68-v2-lucid-tw6804 before.
>
> Now, I got 3 different tw68 series cards: TW6815(PCI), TW6816(PCI) and
> TW6869(PCI-E), then succeeded to compiled TW68-v2, but did not get any
> "video* " in /dev/
>
> It's so appreciated that you wrote these, and thank all the guys like
> you, because you make our life easier.
> Thanks in advance!
>
> Regards,
> Phoenix
>
> ======================================================================================================
>
> F.Y.I
>
> root@test105:/home/tw6800/tw68-v2# make
> make -C /lib/modules/2.6.32-5-686/build M=/home/tw6800/tw68-v2 modules
> make[1]: Entering directory `/usr/src/linux-headers-2.6.32-5-686'
>   CC [M]  /home/tw6800/tw68-v2/tw68-core.o
> /home/tw6800/tw68-v2/tw68-core.c: In function ‘tw68_initdev’:
> /home/tw6800/tw68-v2/tw68-core.c:713: warning: ‘DMA_nnBIT_MASK’ is
> deprecated
> /home/tw6800/tw68-v2/tw68-core.c:655: warning: ‘dev’ may be used
> uninitialized in this function
>   CC [M]  /home/tw6800/tw68-v2/tw68-cards.o
>   CC [M]  /home/tw6800/tw68-v2/tw68-video.o
>   CC [M]  /home/tw6800/tw68-v2/tw68-vbi.o
>   CC [M]  /home/tw6800/tw68-v2/tw68-ts.o
>   CC [M]  /home/tw6800/tw68-v2/tw68-risc.o
>   CC [M]  /home/tw6800/tw68-v2/tw68-tvaudio.o
>   LD [M]  /home/tw6800/tw68-v2/tw68.o
>   Building modules, stage 2.
>   MODPOST 1 modules
>   CC      /home/tw6800/tw68-v2/tw68.mod.o
>   LD [M]  /home/tw6800/tw68-v2/tw68.ko
> make[1]: Leaving directory `/usr/src/linux-headers-2.6.32-5-686'
> -------------------------------------------------------------------------------------------------------------------------------------------------------------
> root@test105:/home/tw6800/tw68-v2# make install
> make -C /lib/modules/2.6.32-5-686/build M=/home/tw6800/tw68-v2 modules
> make[1]: Entering directory `/usr/src/linux-headers-2.6.32-5-686'
>   Building modules, stage 2.
>   MODPOST 1 modules
> make[1]: Leaving directory `/usr/src/linux-headers-2.6.32-5-686'
> sudo find /lib/modules/2.6.32-5-686 -name tw68.ko -exec rm -f {} \;
> sudo cp -p tw68.ko /lib/modules/2.6.32-5-686/kernel/drivers/media/video
> sudo depmod -a
> -------------------------------------------------------------------------------------------------------------------------------------------------------------
> root@test105:/home/tw6800/tw68-v2# make insmod
> make -C /lib/modules/2.6.32-5-686/build M=/home/tw6800/tw68-v2 modules
> make[1]: Entering directory `/usr/src/linux-headers-2.6.32-5-686'
>   Building modules, stage 2.
>   MODPOST 1 modules
> make[1]: Leaving directory `/usr/src/linux-headers-2.6.32-5-686'
> -------------------------------------------------------------------------------------------------------------------------------------------------------------
> root@test105:/home/tw6800/tw68-v2# lsmod | grep tw
> tw68                   28564  0
> btcx_risc               2467  1 tw68
> videobuf_dma_sg         7099  1 tw68
> videobuf_core          10440  2 tw68,videobuf_dma_sg
> v4l2_common             9752  1 tw68
> videodev               25445  2 tw68,v4l2_common
> -------------------------------------------------------------------------------------------------------------------------------------------------------------
> root@test105:/home/tw6800/tw68-v2# make run
> make -C /lib/modules/2.6.32-5-686/build M=/home/tw6800/tw68-v2 modules
> make[1]: Entering directory `/usr/src/linux-headers-2.6.32-5-686'
>   Building modules, stage 2.
>   MODPOST 1 modules
> make[1]: Leaving directory `/usr/src/linux-headers-2.6.32-5-686'
> make: [insmod] Error 1 (ignored)
> test -x /usr/bin/v4l2ucp && v4l2ucp &
> test -x /usr/bin/mplayer && mplayer tv:// -tv
> device=/dev/video0:outfmt=yuy2:normid=3:width=640:height=480
> make: *** [run] Error 1
> -------------------------------------------------------------------------------------------------------------------------------------------------------------
> root@test105:/home/tw6800/tw68-v2# lspci
> 00:00.0 Host bridge: nVidia Corporation MCP73 Host Bridge (rev a2)
> 00:00.1 RAM memory: nVidia Corporation nForce 630i memory controller (rev
> a2)
> 00:01.0 RAM memory: nVidia Corporation nForce 630i memory controller (rev
> a1)
> 00:01.1 RAM memory: nVidia Corporation nForce 630i memory controller (rev
> a1)
> 00:01.2 RAM memory: nVidia Corporation nForce 630i memory controller (rev
> a1)
> 00:01.3 RAM memory: nVidia Corporation nForce 630i memory controller (rev
> a1)
> 00:01.4 RAM memory: nVidia Corporation nForce 630i memory controller (rev
> a1)
> 00:01.5 RAM memory: nVidia Corporation nForce 630i memory controller (rev
> a1)
> 00:01.6 RAM memory: nVidia Corporation nForce 630i memory controller (rev
> a1)
> 00:02.0 RAM memory: nVidia Corporation nForce 630i memory controller (rev
> a1)
> 00:03.0 ISA bridge: nVidia Corporation MCP73 LPC Bridge (rev a2)
> 00:03.1 SMBus: nVidia Corporation MCP73 SMBus (rev a1)
> 00:03.2 RAM memory: nVidia Corporation MCP73 Memory Controller (rev a1)
> 00:03.4 RAM memory: nVidia Corporation MCP73 Memory Controller (rev a1)
> 00:04.0 USB Controller: nVidia Corporation GeForce 7100/nForce 630i USB (rev
> a1)
> 00:04.1 USB Controller: nVidia Corporation MCP73 [nForce 630i] USB 2.0
> Controller (EHCI) (rev a1)
> 00:08.0 IDE interface: nVidia Corporation MCP73 IDE (rev a1)
> 00:0a.0 PCI bridge: nVidia Corporation MCP73 PCI Express bridge (rev a1)
> 00:0b.0 PCI bridge: nVidia Corporation MCP73 PCI Express bridge (rev a1)
> 00:0c.0 PCI bridge: nVidia Corporation MCP73 PCI Express bridge (rev a1)
> 00:0d.0 PCI bridge: nVidia Corporation MCP73 PCI Express bridge (rev a1)
> 00:0e.0 IDE interface: nVidia Corporation MCP73 IDE (rev a2)
> 00:0f.0 Ethernet controller: nVidia Corporation MCP73 Ethernet (rev a2)
> 00:10.0 VGA compatible controller: nVidia Corporation C73 [GeForce 7100 /
> nForce 630i] (rev a2)
> 01:05.0 PCI bridge: Hint Corp HB6 Universal PCI-PCI bridge (non-transparent
> mode) (rev 11)
> 02:00.0 Multimedia video controller: Techwell Inc. Device 6810 (rev 10)
> 02:00.1 Multimedia video controller: Techwell Inc. Device 6811 (rev 10)
> 02:00.2 Multimedia video controller: Techwell Inc. Device 6812 (rev 10)
> 02:00.3 Multimedia video controller: Techwell Inc. Device 6813 (rev 10)
> 02:00.4 Multimedia controller: Techwell Inc. Device 6814 (rev 10)
> 02:00.5 Multimedia controller: Techwell Inc. Device 6815 (rev 10)
> 02:00.6 Multimedia controller: Techwell Inc. Device 6816 (rev 10)
> 02:00.7 Multimedia controller: Techwell Inc. Device 6817 (rev 10)
> 02:01.0 Multimedia video controller: Techwell Inc. Device 6810 (rev 10)
> 02:01.1 Multimedia video controller: Techwell Inc. Device 6811 (rev 10)
> 02:01.2 Multimedia video controller: Techwell Inc. Device 6812 (rev 10)
> 02:01.3 Multimedia video controller: Techwell Inc. Device 6813 (rev 10)
> 02:01.4 Multimedia controller: Techwell Inc. Device 6814 (rev 10)
> 02:01.5 Multimedia controller: Techwell Inc. Device 6815 (rev 10)
> 02:01.6 Multimedia controller: Techwell Inc. Device 6816 (rev 10)
> 02:01.7 Multimedia controller: Techwell Inc. Device 6817 (rev 10)
> 02:02.0 Multimedia video controller: Techwell Inc. Device 6810 (rev 10)
> 02:02.1 Multimedia video controller: Techwell Inc. Device 6811 (rev 10)
> 02:02.2 Multimedia video controller: Techwell Inc. Device 6812 (rev 10)
> 02:02.3 Multimedia video controller: Techwell Inc. Device 6813 (rev 10)
> 02:02.4 Multimedia controller: Techwell Inc. Device 6814 (rev 10)
> 02:02.5 Multimedia controller: Techwell Inc. Device 6815 (rev 10)
> 02:02.6 Multimedia controller: Techwell Inc. Device 6816 (rev 10)
> 02:02.7 Multimedia controller: Techwell Inc. Device 6817 (rev 10)
> 02:03.0 Multimedia video controller: Techwell Inc. Device 6810 (rev 10)
> 02:03.1 Multimedia video controller: Techwell Inc. Device 6811 (rev 10)
> 02:03.2 Multimedia video controller: Techwell Inc. Device 6812 (rev 10)
> 02:03.3 Multimedia video controller: Techwell Inc. Device 6813 (rev 10)
> 02:03.4 Multimedia controller: Techwell Inc. Device 6814 (rev 10)
> 02:03.5 Multimedia controller: Techwell Inc. Device 6815 (rev 10)
> 02:03.6 Multimedia controller: Techwell Inc. Device 6816 (rev 10)
> 02:03.7 Multimedia controller: Techwell Inc. Device 6817 (rev 10)
>
