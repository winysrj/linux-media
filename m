Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [212.57.247.218] (helo=glcweb.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael.curtis@glcweb.co.uk>) id 1JVRrZ-00023R-UR
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 14:34:54 +0100
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Sat, 1 Mar 2008 13:34:14 -0000
Message-ID: <A33C77E06C9E924F8E6D796CA3D635D1023979@w2k3sbs.glcdomain.local>
From: "Michael Curtis" <michael.curtis@glcweb.co.uk>
To: "Manu Abraham" <abraham.manu@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] make errors multiproto
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



Manu, I do not understand your response

I am using the TT3200 and so the stb0899 module will be required

I cannot see how make menuconfig can disable the stb0899 module as it is not a recognised module in 2.6.23.137

Although if I ignore the errors, the modules appear to compile and then load

Output from lsmod

Module                  Size  Used by
nls_utf8               10305  1 
vfat                   19009  1 
fat                    54513  1 vfat
rfcomm                 50537  0 
l2cap                  36289  9 rfcomm
bluetooth              64453  4 rfcomm,l2cap
sunrpc                168009  1 
cpufreq_ondemand       15569  1 
loop                   23493  0 
dm_multipath           24401  0 
ipv6                  307273  18 
osst                   57193  0 
st                     43109  0 
lnbp21                 10240  1 
stb6100                15748  1 
stb0899                41728  1 
saa7134_dvb            24076  0 
videobuf_dvb           13316  1 saa7134_dvb
tda1004x               23300  2 saa7134_dvb
sr_mod                 23397  1 
cdrom                  40553  1 sr_mod
snd_hda_intel         361577  3 
snd_seq_dummy          11461  0 
snd_seq_oss            37313  0 
snd_seq_midi_event     15041  1 snd_seq_oss
snd_seq                56673  5
snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_seq_device         15061  3 snd_seq_dummy,snd_seq_oss,snd_seq
snd_pcm_oss            45889  0 
snd_mixer_oss          22721  1 snd_pcm_oss
snd_pcm                80201  2 snd_hda_intel,snd_pcm_oss
snd_timer              27721  2 snd_seq,snd_pcm
snd_page_alloc         16465  2 snd_hda_intel,snd_pcm
budget_ci              30980  0 
budget_core            17668  1 budget_ci
saa7134               148572  1 saa7134_dvb
videodev               33664  1 saa7134
v4l1_compat            19460  1 videodev
compat_ioctl32         16128  1 saa7134
v4l2_common            26240  3 saa7134,videodev,compat_ioctl32
videobuf_dma_sg        19716  3 saa7134_dvb,videobuf_dvb,saa7134
videobuf_core          24196  3 videobuf_dvb,saa7134,videobuf_dma_sg
ir_kbd_i2c             16912  1 saa7134
snd_hwdep              16073  1 snd_hda_intel
dvb_core               89684  3 videobuf_dvb,budget_ci,budget_core
saa7146                23688  2 budget_ci,budget_core
ttpci_eeprom           10496  1 budget_core
firewire_ohci          25281  0 
ir_common              41732  3 budget_ci,saa7134,ir_kbd_i2c
snd                    60137  15
snd_hda_intel,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_o
ss,snd_pcm,snd_timer,snd_hwdep
nvidia               8895940  24 
firewire_core          46337  1 firewire_ohci
crc_itu_t              10433  1 firewire_core
aic7xxx               133501  0 
scsi_transport_spi     32577  1 aic7xxx
parport_pc             35177  0 
tveeprom               24848  1 saa7134
soundcore              15073  1 snd
sg                     40297  0 
forcedeth              53321  0 
parport                42317  1 parport_pc
pcspkr                 11329  0 
button                 15969  0 
pata_amd               20293  0 
k8temp                 13377  0 
hwmon                  11081  1 k8temp
i2c_nforce2            14017  0 
usblp                  20801  0 
i2c_core               28865  14
lnbp21,stb6100,stb0899,saa7134_dvb,tda1004x,budget_ci,budget_core,saa713
4,v4l2_common,ir_kbd_i2c,ttpci_eeprom,nvidia,tveeprom,i2c_nforce2
usb_storage            87681  2 
dm_snapshot            23049  0 
dm_zero                10433  0 
dm_mirror              27200  0 
dm_mod                 57905  9
dm_multipath,dm_snapshot,dm_zero,dm_mirror
ata_generic            14533  0 
sata_nv                25285  2 
libata                114288  3 pata_amd,ata_generic,sata_nv
sd_mod                 33345  5 
scsi_mod              146553  9
osst,st,sr_mod,aic7xxx,scsi_transport_spi,sg,usb_storage,libata,sd_mod
ext3                  127569  2 
jbd                    64945  1 ext3
mbcache                15937  1 ext3
uhci_hcd               30689  0 
ohci_hcd               27973  0 
ehci_hcd               39245  0

But then the best I can get with with zapping using your modified szap is

status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe | status 1e | signal 0136 | snr 005f | ber 00000000 | unc fffffffe | FE_HAS_LOCK status 1e | signal 0136 | snr 005f | ber 00000000 | unc fffffffe | FE_HAS_LOCK status 1e | signal 0136 | snr 0060 | ber 00000000 | unc fffffffe | FE_HAS_LOCK status 1e | signal 0136 | snr 005e | ber 00000000 | unc fffffffe | FE_HAS_LOCK status 1e | signal 0136 | snr 005e | ber 00000000 | unc fffffffe | FE_HAS_LOCK

I need to know if I am on the right track or those compile errors are having an influence on the performance of the TT3200 frontend

The signal strength should be >50-60% and quality >80%


Best Regards



Michael Curtis wrote:
> Can anyone help with this please?
> 

Disable that relevant module by using a custom config, such as
using make menuconfig, or make xconfig or whatever.


Regards,
Manu

> -----Original Message-----
> From: linux-dvb-bounces@linuxtv.org [mailto:linux-dvb-bounces@linuxtv.org] On Behalf Of Michael Curtis
> Sent: 20 February 2008 08:03
> To: linux-dvb@linuxtv.org
> Subject: [linux-dvb] make errors multiproto
> 
> Hi all
> 
> The following errors occurred during the 'make all' of the multiproto
> install
> 
> The mercurial was from the above date
> 
> I am using the TT3200 so the stb0899 errors will matter
> 
> 
> /home/mythtv/dvb/multiproto/v4l/dvb_frontend.c: In function
> 'dvb_frontend_thread':
> /home/mythtv/dvb/multiproto/v4l/dvb_frontend.c:1123: warning: unused
> variable 'status'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c: In function
> 'stb0899_diseqc_init':
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:834: warning: unused
> variable 'ret_2'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:833: warning: unused
> variable 'ret_1'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:832: warning: unused
> variable 'trial'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:830: warning: unused
> variable 'i'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:830: warning: unused
> variable 'count'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:826: warning: unused
> variable 'rx_data'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c: In function
> 'stb0899_sleep':
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:899: warning: unused
> variable 'reg'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c: In function
> 'stb0899_track':
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:1935: warning: unused
> variable 'internal'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:1932: warning: unused
> variable 'lock_lost'
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c: At top level:
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:1727: warning:
> 'stb0899_track_carrier' defined but not used
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:1744: warning:
> 'stb0899_get_ifagc' defined but not used
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:1761: warning:
> 'stb0899_get_s1fec' defined but not used
> /home/mythtv/dvb/multiproto/v4l/stb0899_drv.c:1789: warning:
> 'stb0899_get_modcod' defined but not used
> /home/mythtv/dvb/multiproto/v4l/radio-si470x.c: In function
> 'si470x_get_rds_registers':
> /home/mythtv/dvb/multiproto/v4l/radio-si470x.c:562: warning: format '%d'
> expects type 'int', but argument 3 has type 'long unsigned int'
> 
> Regards
> 
> Mike curtis
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 


-- 
This message has been scanned for viruses and
dangerous content by IC-MailScanner, and is
believed to be clean.

For queries or information please contact:-

=================================
Internet Central Technical Support


 http://www.netcentral.co.uk
=================================


No virus found in this incoming message.
Checked by AVG Free Edition. 
Version: 7.5.516 / Virus Database: 269.21.2/1305 - Release Date: 29/02/2008 18:32
 

No virus found in this outgoing message.
Checked by AVG Free Edition. 
Version: 7.5.516 / Virus Database: 269.21.2/1305 - Release Date: 29/02/2008 18:32
 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
