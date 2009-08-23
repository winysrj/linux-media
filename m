Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37606 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933455AbZHWO21 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 10:28:27 -0400
From: Daniel Senftleben <danprem@gmx.net>
To: hermann pitton <hermann-pitton@arcor.de>
Subject: Re: x3m_HPC2000 infos
Date: Sun, 23 Aug 2009 16:26:27 +0200
Cc: linux-media@vger.kernel.org
References: <200908231219.18706.danprem@gmx.net> <1251027595.3853.8.camel@pc07.localdom.local>
In-Reply-To: <1251027595.3853.8.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908231626.27328.danprem@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I got rid of the old modules and compiled new ones:

dmesg | grep cx88:

cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded            
cx88[0]: subsystem: 14f1:8852, board: Geniatech X8000-MT DVBT 
[card=63,autodetected], frontend(s): 1                                                                                    
cx88[0]: TV tuner type 71, Radio tuner type 0                                               
cx88[0]: Test OK                                                                            
cx88/0: cx2388x v4l2 driver version 0.0.7 loaded                                            
cx88_alsa: disagrees about version of symbol snd_ctl_add                                    
cx88_alsa: Unknown symbol snd_ctl_add                                                       
cx88_alsa: disagrees about version of symbol snd_pcm_new                                    
cx88_alsa: Unknown symbol snd_pcm_new                                                       
cx88_alsa: disagrees about version of symbol snd_card_register                              
cx88_alsa: Unknown symbol snd_card_register                                                 
cx88_alsa: disagrees about version of symbol snd_card_free                                  
cx88_alsa: Unknown symbol snd_card_free                                                     
cx88_alsa: disagrees about version of symbol snd_ctl_new1                                   
cx88_alsa: Unknown symbol snd_ctl_new1                                                      
cx88_alsa: Unknown symbol snd_card_new                                                      
cx88_alsa: disagrees about version of symbol snd_ctl_boolean_mono_info
cx88_alsa: Unknown symbol snd_ctl_boolean_mono_info
cx88_alsa: disagrees about version of symbol snd_pcm_lib_ioctl
cx88_alsa: Unknown symbol snd_pcm_lib_ioctl
cx88_alsa: disagrees about version of symbol snd_pcm_hw_constraint_pow2
cx88_alsa: Unknown symbol snd_pcm_hw_constraint_pow2
cx88_alsa: disagrees about version of symbol snd_pcm_set_ops
cx88_alsa: Unknown symbol snd_pcm_set_ops
cx88_alsa: disagrees about version of symbol snd_pcm_period_elapsed
cx88_alsa: Unknown symbol snd_pcm_period_elapsed
tuner 1-0061: chip found @ 0xc2 (cx88[0])
cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
cx88[0]/2: cx2388x 8802 Driver Manager
cx88-mpeg driver manager 0000:02:06.2: PCI INT A -> GSI 20 (level, low) -> IRQ 
20
cx88[0]/2: found at 0000:02:06.2, rev: 5, irq: 20, latency: 32, mmio: 
0xfa000000
cx8800 0000:02:06.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
cx88[0]/0: found at 0000:02:06.0, rev: 5, irq: 20, latency: 32, mmio: 
0xf9000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
cx88/2: cx2388x dvb driver version 0.0.7 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 14f1:8852, board: Geniatech X8000-MT DVBT [card=63]
cx88[0]/2: cx2388x based DVB/ATSC card
cx8802_alloc_frontends() allocating 1 frontend(s)
cx88[0]/2: xc3028 attached
DVB: registering new adapter (cx88[0])

---------------------

lsmod | grep cx88:

cx88_dvb               22812  2
cx88_vp3054_i2c         3112  1 cx88_dvb
videobuf_dvb            8140  1 cx88_dvb
dvb_core               97216  8 
stv0299,or51211,or51132,lgdt330x,lgdt3305,dvb_ttpci,cx88_dvb,videobuf_dvb
cx8800                 36748  0
cx8802                 17132  1 cx88_dvb
cx88xx                 81868  3 cx88_dvb,cx8800,cx8802
ir_common              54316  1 cx88xx
i2c_algo_bit            7004  2 cx88_vp3054_i2c,cx88xx
v4l2_common            19832  4 au8522,tuner,cx8800,cx88xx
videodev               40048  6 
au8522,saa7146_vv,tuner,cx8800,cx88xx,v4l2_common
tveeprom               13868  1 cx88xx
videobuf_dma_sg        14348  5 saa7146_vv,cx88_dvb,cx8800,cx8802,cx88xx
btcx_risc               5120  3 cx8800,cx8802,cx88xx
videobuf_core          20492  6 
saa7146_vv,videobuf_dvb,cx8800,cx8802,cx88xx,videobuf_dma_sg
i2c_core               35312  77 
zl10039,zl10036,ves1x93,ves1820,tua6100,tda826x,tda8261,tda8083,tda10086,tda1004x,tda10048,tda10023,tda10021,stv6110x,stv6110,stv090x,stv0900,stv0299,stv0297,stv0288,stb6100,stb6000,stb0899,sp887x,sp8870,si21xx,s921,s5h1420,s5h1411,s5h1409,or51211,or51132,nxt6000,nxt200x,mt352,mt312,lnbp21,lgs8gxx,lgs8gl5,lgdt330x,lgdt3305,lgdt3304,l64781,itd1000,isl6423,isl6421,isl6405,dvb_pll,drx397xD,dib7000p,dib7000m,dib3000mc,dibx000_common,dib3000mb,dib0070,cx24123,cx24116,cx24113,cx24110,cx22702,cx22700,bcm3510,au8522,af9013,dvb_ttpci,ttpci_eeprom,zl10353,cx88_vp3054_i2c,tuner_xc2028,tuner,cx8800,cx88xx,i2c_algo_bit,v4l2_common,videodev,tveeprom,i2c_piix4

--------------------------------------------------------

Then I checked the tuner. dmesg says:

firmware: requesting xc3028-v27.fw                                                          
xc2028 1-0061: Error: firmware xc3028-v27.fw not found.                                     
saa7146: register extension 'dvb'.  

--------------------

I then tried a procedure I found here: 
http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtain_the_Firmware 
but that didn't work for me.. just as it says here: 
http://www.linuxtv.org/wiki/index.php/DVB-T_PCI_Cards
It all comes down to the tuner.. any ideas how to solve this issue?
I downloaded the Windows drivers of the x3m hpc2000 and tried using the script 
"extract_xc3028.pl" on it, but it couldn't find "hcw85bda.sys".. so the script 
is limited to this file.. wish I knew how to rewrite this skript..
