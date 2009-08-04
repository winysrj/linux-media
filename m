Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out3.libero.it ([212.52.84.103]:50148 "EHLO
	cp-out3.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbZHDHCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 03:02:17 -0400
Date: Tue,  4 Aug 2009 09:02:15 +0200
Message-Id: <KNUBJR$8288486206C8D52D23C09DCC0F568E3D@libero.it>
Subject: Re: Issue with LifeView FlyDVB-T Duo CardBus.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
From: "Francesco Marangoni" <fmarangoni@libero.it>
To: "hermann-pitton" <hermann-pitton@arcor.de>
Cc: "linux-media" <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hermann,

the card works fine on win2000 on another pc. The pc with linux installed is a pentium 3 800 mhz with RAM 256 MB: I don't think it's a resources problem because when I launch channels scan ram used is always at 70 MB and CPU is at 25%. The card becomes warm after the use, but not hot.

What dou You think about errors in compiling v4l-dvb?

And from output of dmesg | grep saa do You think the card has benn well detected or there is something wrong?

Thanks a lot for any suggetsion.

---------- Initial Header -----------

>From      : "hermann pitton" hermann-pitton@arcor.de
To          : "Francesco Marangoni" fmarangoni@libero.it
Cc          : "linux-media" linux-media@vger.kernel.org
Date      : Tue, 04 Aug 2009 02:21:38 +0200
Subject : Re: Issue with LifeView FlyDVB-T Duo CardBus.







> Hi Francesco,
> 
> Am Montag, den 03.08.2009, 23:49 +0200 schrieb Francesco Marangoni:
> > Dear sirs,
> > 
> > I'm not able to make my pcmcia LifeView DVB-T Duo Cardbus working on Ununtu 8.04 LTS kernel 2.6.24.24.
> > 
> > The card seems to be detected but the DVB channel detection fails (using Kaffeine too).
> > 
> > Here the output of some commands: Can Youhelp me?
> > 
> > francesco@ubuntu:~$ lspci
> > 00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (rev 03)
> > 00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev 03)
> > 00:07.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
> > 00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
> > 00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01)
> > 00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 03)
> > 00:0a.0 CardBus bridge: Texas Instruments PCI1420 PC card Cardbus Controller
> > 00:0a.1 CardBus bridge: Texas Instruments PCI1420 PC card Cardbus Controller
> > 00:0b.0 Ethernet controller: 3Com Corporation 3c556 Hurricane CardBus [Cyclone] (rev 10)
> > 00:0b.1 Communication controller: 3Com Corporation Mini PCI 56k Winmodem (rev 10)
> > 00:0d.0 Multimedia audio controller: ESS Technology ES1983S Maestro-3i PCI Audio Accelerator
> > 01:00.0 VGA compatible controller: ATI Technologies Inc Rage Mobility P/M AGP 2x (rev 64)
> > 02:00.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135 Video Broadcast Decoder (rev d0)
> > 
> > francesco@ubuntu:~$ dmesg | grep saa | more
> > [   46.176353] saa7130/34: v4l2 driver version 0.2.14 loaded
> > [   46.176618] saa7133[0]: quirk: PCIPCI_NATOMA
> > [   46.176628] saa7133[0]: found at 0000:02:00.0, rev: 208, irq: 10, latency: 0, mmio: 0x24000000
> > [   46.176653] saa7133[0]: subsystem: 5168:0502, board: LifeView/Typhoon/Genius FlyDVB-T Duo Cardbus [card=60,insmod option]
> > [   46.176681] saa7133[0]: board init: gpio is 8210000
> > [   46.280562] saa7133[0]: i2c eeprom 00: 68 51 02 05 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> > [   46.280587] saa7133[0]: i2c eeprom 10: 00 ff 22 0f ff 20 ff ff ff ff ff ff ff ff ff ff
> > [   46.280607] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01 aa ff ff ff ff
> > [   46.280627] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > [   46.280646] saa7133[0]: i2c eeprom 40: ff 25 00 c0 ff 10 07 01 c2 96 00 16 22 15 ff ff
> > [   46.280665] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > [   46.280685] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > [   46.280704] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > [   46.321890] saa7133[0]: registered device video0 [v4l2]
> > [   46.321945] saa7133[0]: registered device vbi0
> > [   46.321996] saa7133[0]: registered device radio0
> > [   46.609615] saa7133[0]/dvb: no tda827x tuner found at addr: 60
> > [   46.609624] DVB: registering new adapter (saa7133[0])
> > [  238.981774] saa7133[0]: dsp access error
> > [  238.981801] saa7133[0]: dsp access error
> > [  238.981820] saa7133[0]: dsp access error
> > [  238.981824] saa7133[0]: dsp access error
> > [  238.981837] saa7133[0]: dsp access error
> > [  238.981841] saa7133[0]: dsp access error
> > [  238.981854] saa7133[0]: dsp access error
> > [  238.981858] saa7133[0]: dsp access error
> > [  238.981871] saa7133[0]: dsp access error
> > [  238.981875] saa7133[0]: dsp access error
> > [  238.981887] saa7133[0]: dsp access error
> > [  238.981892] saa7133[0]: dsp access error
> > [  238.981904] saa7133[0]: dsp access error
> > [  238.981909] saa7133[0]: dsp access error
> > [  238.981921] saa7133[0]: dsp access error
> > [  238.981926] saa7133[0]: dsp access error
> > [  238.981938] saa7133[0]: dsp access error
> > [  238.981942] saa7133[0]: dsp access error
> > [  238.981955] saa7133[0]: dsp access error
> > [  238.981959] saa7133[0]: dsp access error
> > [  238.981972] saa7133[0]/irq[10,76507]: r=0xffffffff s=0xffffffff DONE_RA0 DONE_RA1 DONE_RA2 DONE_RA3 AR PE PWR_ON RDCAP INT
> > ....
> > [  238.993258] saa7133[0]: dsp access error
> > [  238.993263] saa7133[0]: dsp access error
> > [  238.993275] saa7133[0]: dsp access error
> > [  238.993280] saa7133[0]: dsp access error
> > [  238.993292] saa7133[0]: dsp access error
> > [  238.993297] saa7133[0]: dsp access error
> > [  238.993309] saa7133[0]: dsp access error
> > [  238.993314] saa7133[0]: dsp access error
> > [  238.993326] saa7133[0]: dsp access error
> > [  238.993330] saa7133[0]: dsp access error
> > [  238.993343] saa7133[0]: dsp access error
> > [  238.993347] saa7133[0]: dsp access error
> > [  238.993359] saa7133[0]/irq[10,76514]: r=0xffffffff s=0xffffffff DONE_RA0 DONE_RA1 DONE_RA2 DONE_RA3 AR PE PWR_ON RDCAP INT
> > L FIDT MMC TRIG_ERR CONF_ERR LOAD_ERR GPIO16? GPIO18 GPIO22 GPIO23 | RA0=vbi,b,odd,15
> > [  238.993385] saa7133[0]/irq: looping -- clearing PE (parity error!) enable bit
> > [  640.875510] saa7133[0]: quirk: PCIPCI_NATOMA
> > [  640.875520] saa7133[0]: found at 0000:02:00.0, rev: 208, irq: 10, latency: 0, mmio: 0x24000000
> > [  640.875544] saa7133[0]: subsystem: 5168:0502, board: LifeView/Typhoon/Genius FlyDVB-T Duo Cardbus [card=60,insmod option]
> > [  640.875577] saa7133[0]: board init: gpio is 8210000
> > [  641.010947] saa7133[0]: i2c eeprom 00: 68 51 02 05 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> > [  641.010978] saa7133[0]: i2c eeprom 10: 00 ff 22 0f ff 20 ff ff ff ff ff ff ff ff ff ff
> > [  641.010997] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01 aa ff ff ff ff
> > [  641.011016] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > [  641.011034] saa7133[0]: i2c eeprom 40: ff 25 00 c0 ff 10 07 01 c2 96 00 16 22 15 ff ff
> > [  641.011052] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > [  641.011070] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > [  641.011088] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > [  641.108271] saa7133[0]: registered device video0 [v4l2]
> > [  641.108329] saa7133[0]: registered device vbi0
> > [  641.108378] saa7133[0]: registered device radio0
> > [  641.492916] saa7133[0]/dvb: no tda827x tuner found at addr: 60
> > [  641.492925] DVB: registering new adapter (saa7133[0])
> > 
> > 
> > I did all is described in http://www.linuxtv.org/repo/ but this is the output of Make and Make install:
> > 
> > francesco@ubuntu:~/v4l-dvb$ make
> > make -C /home/francesco/v4l-dvb/v4l 
> > make[1]: Entering directory `/home/francesco/v4l-dvb/v4l'
> > Updating/Creating .config
> > Preparing to compile for kernel version 2.6.24
> > File not found: /lib/modules/2.6.24-24-generic/build/.config at ./scripts/make_kconfig.pl line 32, <IN> line 4.
> > make[1]: *** No rule to make target `.myconfig', needed by `config-compat.h'.  Stop.
> > make[1]: Leaving directory `/home/francesco/v4l-dvb/v4l'
> > make: *** [all] Error 2
> > 
> > francesco@ubuntu:~/v4l-dvb$ make install
> > make -C /home/francesco/v4l-dvb/v4l install
> > make[1]: Entering directory `/home/francesco/v4l-dvb/v4l'
> > -e 
> > Removing obsolete files from /lib/modules/2.6.24-24-generic/kernel/drivers/media/video:
> > 
> > -e 
> > Removing obsolete files from /lib/modules/2.6.24-24-generic/kernel/drivers/media/dvb/cinergyT2:
> > 
> > -e 
> > Removing obsolete files from /lib/modules/2.6.24-24-generic/kernel/drivers/media/dvb/frontends:
> > 
> > 
> > Hmm... distro kernel with a non-standard place for module backports detected.
> > Please always prefer to use vanilla upstream kernel with V4L/DVB
> > I'll try to remove old/obsolete LUM files from /lib/modules/2.6.24-24-generic/ubuntu/media:
> > Installing kernel modules under /lib/modules/2.6.24-24-generic/kernel/drivers/media/:
> > /sbin/depmod -a 2.6.24-24-generic 
> > FATAL: Could not open /lib/modules/2.6.24-24-generic/modules.dep.temp for writing: Permission denied
> > make[1]: *** [media-install] Error 1
> > make[1]: Leaving directory `/home/francesco/v4l-dvb/v4l'
> > make: *** [install] Error 2
> > francesco@ubuntu:~/v4l-dvb$ 
> > 
> > Any suggestions?
> > 
> > Thanks.
> 
> did it ever work for you or does it still on something?
> 
> First impression is, that the tuner chip melt down.
> 
> If the card was in for while, with the driver loaded, is it still very
> hot close to the antenna connector, if ejected then?
> 
> The first generations of the tuner chips have been good enough to fry
> eggs on them.
> 
> Cheers,
> Hermann
> 
> 
> 
> 
> 

