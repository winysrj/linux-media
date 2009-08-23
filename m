Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:54524 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933497AbZHWLmg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 07:42:36 -0400
Subject: Re: x3m_HPC2000 infos
From: hermann pitton <hermann-pitton@arcor.de>
To: Daniel Senftleben <danprem@gmx.net>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200908231219.18706.danprem@gmx.net>
References: <200908231219.18706.danprem@gmx.net>
Content-Type: text/plain
Date: Sun, 23 Aug 2009 13:39:55 +0200
Message-Id: <1251027595.3853.8.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Sonntag, den 23.08.2009, 12:19 +0200 schrieb Daniel Senftleben:
> Ok, I'll try giving some more infos.
> 
> lspci:
> 
> 02:06.0 Multimedia video controller: Conexant Systems, Inc. CX23880/1/2/3 PCI 
> Video and Audio Decoder (rev 05)
> 02:06.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video 
> and Audio Decoder [Audio Port] (rev 05)
> 02:06.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video 
> and Audio Decoder [MPEG Port] (rev 05)
> 
> -----------------------------
> 
> dmesg | grep cx88:
> 
> cx88/0: cx2388x v4l2 driver version 0.0.6 loaded                                            
> cx8800 0000:02:06.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20                             
> cx88[0]: subsystem: 14f1:8852, board: UNKNOWN/GENERIC [card=0,insmod option]

Looks good so far ;)

>                
> cx88[0]: TV tuner type 71, Radio tuner type -1                                              
> cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
> cx88_alsa: disagrees about version of symbol snd_ctl_add                                    
> cx88_alsa: Unknown symbol snd_ctl_add                                                       
> cx88_alsa: disagrees about version of symbol snd_pcm_new                                    
> cx88_alsa: Unknown symbol snd_pcm_new
> cx88_alsa: disagrees about version of symbol snd_card_register
> cx88_alsa: Unknown symbol snd_card_register
> cx88_alsa: disagrees about version of symbol snd_card_free
> cx88_alsa: Unknown symbol snd_card_free
> cx88_alsa: disagrees about version of symbol snd_ctl_new1
> cx88_alsa: Unknown symbol snd_ctl_new1
> cx88_alsa: Unknown symbol snd_card_new
> cx88_alsa: disagrees about version of symbol snd_ctl_boolean_mono_info
> cx88_alsa: Unknown symbol snd_ctl_boolean_mono_info
> cx88_alsa: disagrees about version of symbol snd_pcm_lib_ioctl
> cx88_alsa: Unknown symbol snd_pcm_lib_ioctl
> cx88_alsa: disagrees about version of symbol snd_pcm_hw_constraint_pow2
> cx88_alsa: Unknown symbol snd_pcm_hw_constraint_pow2
> cx88_alsa: disagrees about version of symbol snd_pcm_set_ops
> cx88_alsa: Unknown symbol snd_pcm_set_ops
> cx88_alsa: disagrees about version of symbol snd_pcm_period_elapsed
> cx88_alsa: Unknown symbol snd_pcm_period_elapsed
> cx88[0]: Test OK
> tuner' 1-0061: chip found @ 0xc2 (cx88[0])
> cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
> cx88[0]/0: found at 0000:02:06.0, rev: 5, irq: 20, latency: 32, mmio: 
> 0xf9000000
> cx88[0]/0: registered device video0 [v4l2]
> cx88[0]/0: registered device vbi0
> cx88[0]/2: cx2388x 8802 Driver Manager
> 
> --------------------------
> 
> lsmod | grep cx88:
> 
> cx8802                 17356  0
> cx8800                 35156  0
> cx88xx                 72040  2 cx8802,cx8800
> ir_common              43340  1 cx88xx
> i2c_algo_bit            7004  1 cx88xx
> compat_ioctl32          8504  1 cx8800
> videodev               35328  5 saa7146_vv,tuner,cx8800,cx88xx,compat_ioctl32
> tveeprom               13724  1 cx88xx
> v4l2_common            12600  2 tuner,cx8800
> btcx_risc               5152  3 cx8802,cx8800,cx88xx
> videobuf_dma_sg        14332  4 saa7146_vv,cx8802,cx8800,cx88xx
> videobuf_core          20748  5 
> saa7146_vv,cx8802,cx8800,cx88xx,videobuf_dma_sg
> i2c_core               35312  53 
> zl10353,ves1x93,ves1820,tua6100,tda826x,tda8083,tda10086,tda1004x,tda10048,tda10023,tda10021,stv0299,stv0297,sp887x,sp8870,s5h1420,s5h1411,s5h1409,or51211,or51132,nxt6000,nxt200x,mt352,mt312,lnbp21,lgdt330x,l64781,itd1000,isl6421,isl6405,dvb_pll,drx397xD,dib7000p,dib7000m,dib3000mc,dibx000_common,dib3000mb,dib0070,cx24123,cx24110,cx22702,cx22700,bcm3510,au8522,dvb_ttpci,ttpci_eeprom,tuner_xc2028,tuner,cx88xx,i2c_algo_bit,tveeprom,v4l2_common,i2c_piix4
> 
> -----------------------
> 
> I'm not sure what yast did as I tried to get the card working, but it looks a 
> bit messed up to me.. But it was able to load a driver and some modules, but 
> I'm not able to unload the modules to get the v4l module compiled myself like 
> you suggested (using these instuctions: 
> http://linuxtv.org/wiki/index.php/How_to_Obtain%2C_Build_and_Install_V4L-
> DVB_Device_Drivers). The modules "are in use" and i get errors while 
> compiling..
> Shall I try cleaning up a bit and remove the driver installed by yast, or do 
> you see another way. Whats cx88_alsa here for?
> Thanks

You need to get rid of all old media modules and have to replace them
with current v4l-dvb stuff to have eventually a chance.

On top of mercurial v4l-dvb you can try make rmmod twice and make
rminstall, don't bother to delete the complete media folder in your
kernels /lib/modules... tree, with "make install" you will get it back.
(does also depmod -a for the new modules)

If there should be modules left on unusual places, "modprobe -v" should
show those, also any remaining options forced by yast, but I'm not on
such currently.

If you did not make sure to unload all old modules previously, reboot.

Cheeers,
Hermann


