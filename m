Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-relay1.leicester.gov.uk ([212.50.184.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <John.Chajecki@leicester.gov.uk>) id 1KTGiw-0000vn-GL
	for linux-dvb@linuxtv.org; Wed, 13 Aug 2008 15:49:15 +0200
Message-Id: <48A2EF6A.23BC.005F.0@leicester.gov.uk>
Date: Wed, 13 Aug 2008 14:27:48 +0100
From: "John Chajecki" <John.Chajecki@leicester.gov.uk>
To: <hermann-pitton@arcor.de>
Mime-Version: 1.0
Content-Disposition: inline
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Attempting to compile the saa7134-alsa module
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

Herman,

Thanks again. It was suggested to me to use Ubuntu because apparently it is good for multimedia apps. I had googled saa7134-alsa prior to posting and saw a few reports of the problem but no solution. This does seem to be a Ubuntu issue and in one of the reports I looked at (https://bugs.launchpad.net/ubuntu/+source/linux-ubuntu-modules-2.6.24/+bug/212271) it states that the problem does not occurr on a 'stock kernel' from kernel.org.

Now I'm womdoering whether I shpuld use another Linux distro? If so, which distro do others use?

>>> hermann pitton <hermann-pitton@arcor.de> 08/12/08 9:51 PM >>>
Hi again,

Am Dienstag, den 12.08.2008, 15:47 +0100 schrieb John Chajecki:
> I'm trying to compile the saa7134-alsa module that comes with the v4l-dvb drivers. In order to get it to compile I've had to tag it to the end of the saa7134-onjs list in the Makefile resident in the saa7134 direcorty like this:
> 
> saa7134-objs := saa7134-cards.o saa7134-core.o saa7134-i2c.o    \
>                 saa7134-ts.o saa7134-tvaudio.o saa7134-vbi.o    \
>                 saa7134-video.o saa7134-input.o saa7134-alsa.o
> 
> I'm running make, I'm getting the folowing error:
> 
> root@tinman:/home/john/Src/v4l-dvb# make
> make -C /home/john/Src/v4l-dvb/v4l
> make[1]: Entering directory `/home/john/Src/v4l-dvb/v4l'
> creating symbolic links...
> Kernel build directory is /lib/modules/2.6.24-19-generic/build
> make -C /lib/modules/2.6.24-19-generic/build SUBDIRS=/home/john/Src/v4l-dvb/v4l  modules
> make[2]: Entering directory `/usr/src/linux-headers-2.6.24-19-generic'
>   LD [M]  /home/john/Src/v4l-dvb/v4l/saa7134.o
> /home/john/Src/v4l-dvb/v4l/saa7134-alsa.o: In function `saa7134_alsa_init':
> /home/john/Src/v4l-dvb/v4l/saa7134-alsa.c:1083: multiple definition of `init_module'
> /home/john/Src/v4l-dvb/v4l/saa7134-core.o:/home/john/Src/v4l-dvb/v4l/saa7134-core.c:1346: first defined here
> /home/john/Src/v4l-dvb/v4l/saa7134-alsa.o: In function `saa7134_alsa_exit':
> /home/john/Src/v4l-dvb/v4l/saa7134-alsa.c:1109: multiple definition of `cleanup_module'
> /home/john/Src/v4l-dvb/v4l/saa7134-core.o:/home/john/Src/v4l-dvb/v4l/saa7134-core.c:1361: first defined here
> make[3]: *** [/home/john/Src/v4l-dvb/v4l/saa7134.o] Error 1
> make[2]: *** [_module_/home/john/Src/v4l-dvb/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-headers-2.6.24-19-generic'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/john/Src/v4l-dvb/v4l'
> make: *** [all] Error 2
> 
> I'm tring to get the saa7134-alsa compiled because, although the other modules are compiling, the alsa module is not so when I'm doing a modproble saa7134 I'm getting as follows in dmesg:
> 
> [108767.374805] saa7133[0]: registered device video0 [v4l2]
> [108767.374831] saa7133[0]: registered device vbi0
> [108767.396356] saa7134_alsa: disagrees about version of symbol saa7134_tvaudio_setmute
> [108767.396363] saa7134_alsa: Unknown symbol saa7134_tvaudio_setmute
> [108767.396512] saa7134_alsa: disagrees about version of symbol saa_dsp_writel
> [108767.396515] saa7134_alsa: Unknown symbol saa_dsp_writel
> [108767.396684] saa7134_alsa: disagrees about version of symbol videobuf_dma_free
> [108767.396686] saa7134_alsa: Unknown symbol videobuf_dma_free
> [108767.396884] saa7134_alsa: disagrees about version of symbol saa7134_pgtable_alloc
> [108767.396887] saa7134_alsa: Unknown symbol saa7134_pgtable_alloc
> [108767.396934] saa7134_alsa: disagrees about version of symbol saa7134_pgtable_build
> [108767.396937] saa7134_alsa: Unknown symbol saa7134_pgtable_build
> [108767.396975] saa7134_alsa: disagrees about version of symbol saa7134_pgtable_free
> [108767.396978] saa7134_alsa: Unknown symbol saa7134_pgtable_free
> [108767.397016] saa7134_alsa: disagrees about version of symbol saa7134_dmasound_init
> [108767.397019] saa7134_alsa: Unknown symbol saa7134_dmasound_init
> [108767.397154] saa7134_alsa: disagrees about version of symbol saa7134_dmasound_exit
> [108767.397156] saa7134_alsa: Unknown symbol saa7134_dmasound_exit
> [108767.397252] saa7134_alsa: disagrees about version of symbol videobuf_dma_init
> [108767.397255] saa7134_alsa: Unknown symbol videobuf_dma_init
> [108767.397399] saa7134_alsa: disagrees about version of symbol videobuf_dma_init_kernel
> [108767.397402] saa7134_alsa: Unknown symbol videobuf_dma_init_kernel
> [108767.397518] saa7134_alsa: Unknown symbol videobuf_pci_dma_unmap
> [108767.397661] saa7134_alsa: Unknown symbol videobuf_pci_dma_map
> [108767.397706] saa7134_alsa: disagrees about version of symbol saa7134_set_dmabits
> [108767.397709] saa7134_alsa: Unknown symbol saa7134_set_dmabits
> [108767.411034] saa7133[0]/dvb: Huh? unknown DVB card?
> [108767.411040] saa7133[0]/dvb: frontend initialization failed

vanilla kernel compatibility on recent Ubuntu is broken in various ways,
especially for alsa.

Try to google for "ubuntu saa7134-alsa" and/or check the lists.

It is not caused by v4l-dvb.

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
