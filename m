Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outmailhost.telefonica.net ([213.4.149.242]
	helo=ctsmtpout2.frontal.correo)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jareguero@telefonica.net>) id 1JzwRD-0002oA-KD
	for linux-dvb@linuxtv.org; Sat, 24 May 2008 18:17:44 +0200
Received: from jar.dominio (80.25.230.35) by ctsmtpout2.frontal.correo
	(7.2.056.6) (authenticated as jareguero$telefonica.net)
	id 482C07F400264EB9 for linux-dvb@linuxtv.org;
	Sat, 24 May 2008 18:17:09 +0200
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-dvb@linuxtv.org
Date: Sat, 24 May 2008 18:17:07 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_D+DOI09zqbec9FT"
Message-Id: <200805241817.07810.jareguero@telefonica.net>
Subject: [linux-dvb] kernel BUG with AverTV DVB-T 777 and kernel 2.6.23-rc3
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_D+DOI09zqbec9FT
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Work well with kernel 2.6.25

Jose Alberto

--Boundary-00=_D+DOI09zqbec9FT
Content-Type: text/plain;
  charset="us-ascii";
  name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg"

BUG: unable to handle kernel NULL pointer dereference at 0000000000000008       
IP: [<ffffffffa0b1953b>] :tuner_simple:simple_tuner_attach+0x99/0x396           
PGD 7d988067 PUD 7d989067 PMD 0                                                 
Oops: 0000 [1] SMP                                                              
CPU 1                                                                           
Modules linked in: tuner_simple tuner_types mt352 saa7134_dvb(+) mt2060 snd_usb_audio(+) videobuf_dvb snd_seq_dummy snd_hda_intel snd_seq_oss(+) saa7134 snd_seq_midi_event snd_seq snd_pcm_oss v4l2_common videobuf_dma_sg snd_mixer_oss videobuf_core snd_pcm ir_kbd_i2c dvb_usb_dib0700(+) snd_timer dib7000p ir_common dib7000m nvidia(P) pwc snd_usb_lib dvb_usb dvb_core dib3000mc dibx000_common snd_page_alloc sr_mod tveeprom compat_ioctl32 dib0070 i2c_viapro snd_rawmidi snd_seq_device snd_hwdep i2c_core cdrom sg videodev v4l1_compat button ppdev parport_pc k8temp hwmon pata_via shpchp snd serio_raw pcspkr atl1 mii parport soundcore floppy ahci ata_generic pata_acpi sata_via libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]                         
Pid: 1553, comm: modprobe Tainted: P          2.6.26-rc3 #2                     
RIP: 0010:[<ffffffffa0b1953b>]  [<ffffffffa0b1953b>] :tuner_simple:simple_tuner_attach+0x99/0x396                                                               
RSP: 0018:ffff81007d0d7c88  EFLAGS: 00010286                                    
RAX: 0000000000000043 RBX: ffff81007d45c000 RCX: 00000000c3e796e9               
RDX: 00000000ffffffff RSI: 00000000000000c3 RDI: ffff81007d45c208               
RBP: ffff81007d0d7ce8 R08: 0000000000000001 R09: 0000000000000000               
R10: 0000000000000000 R11: ffffffffa0b1af00 R12: ffff81007d45c1d0               
R13: ffff81007e411408 R14: ffff81007d45c161 R15: 0000000000000043               
FS:  00007fc159ba16f0(0000) GS:ffff81007f802780(0000) knlGS:0000000000000000    
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b                               
CR2: 0000000000000008 CR3: 000000007d98b000 CR4: 00000000000006e0               
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000               
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400               
Process modprobe (pid: 1553, threadinfo ffff81007d0d6000, task ffff81007e142d20)
Stack:  0000000000000000 ffffffff81054bf8 ffff000100010061 ffff81007d0d7cb7     
 ffff81007d45c000 ffffffffa0b06e80 ffff81007d45c170 ffff81007d45c000            
 ffff81007d45c000 ffffffffa0b06e80 ffff81007d45c170 0000000000000000            
Call Trace:                                                                     
 [<ffffffff81054bf8>] ? gpl_only_unused_warning+0x0/0x1b                        
 [<ffffffffa0b033e5>] :saa7134_dvb:dvb_init+0xec5/0x15bd                        
 [<ffffffff8102ba59>] ? try_to_wake_up+0x1cc/0x1dd                              
 [<ffffffffa0a3c9f8>] :saa7134:saa7134_ts_register+0x4a/0x92                    
 [<ffffffffa0139010>] :saa7134_dvb:dvb_register+0x10/0x12                       
 [<ffffffff81057bcc>] sys_init_module+0x199c/0x1af8                             
 [<ffffffff810a3c90>] ? do_sync_read+0xe7/0x12d                                 
 [<ffffffff8100ba4a>] ? do_notify_resume+0x88f/0x8b0                            
 [<ffffffff8103e66e>] ? msleep+0x0/0x1e                                         
 [<ffffffff8100bf8b>] system_call_after_swapgs+0x7b/0x80                        


Code: 60 01 00 00 48 85 c0 74 07 be 01 00 00 00 ff d0 48 8d 75 b0 ba 01 00 00 00 4c 89 e7 e8 93 4d 65 ff ff c8 74 44 44 89 f8 83 ca ff <8a> 0c 25 08 00 00 00 48 6b c0 30 4c 8b 80 90 26 b1 a0 48 8b 04                                         
RIP  [<ffffffffa0b1953b>] :tuner_simple:simple_tuner_attach+0x99/0x396          
 RSP <ffff81007d0d7c88>                                                         
CR2: 0000000000000008                                                           
---[ end trace 8d47842439a4768b ]---                                            

--Boundary-00=_D+DOI09zqbec9FT
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_D+DOI09zqbec9FT--
