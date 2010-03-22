Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:50324 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab0CVLkV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 07:40:21 -0400
Received: by bwz1 with SMTP id 1so1792103bwz.21
        for <linux-media@vger.kernel.org>; Mon, 22 Mar 2010 04:40:19 -0700 (PDT)
From: Armando =?iso-8859-1?q?Ba=EDa?= <armbaia@gmail.com>
To: linux-media@vger.kernel.org
Subject: TT s2-3200 does not scan the frequencies <5000
Date: Mon, 22 Mar 2010 11:39:38 +0000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003221139.38105.armbaia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I do not speak English but can understand. This text was translated by google.
Do not want to be inconvenient. In December I reported that the board TT 
s2-3200 does not scan the frequencies <5000.
Because there will be issues of more interest was not the case is not 
resolved, hence my insistence. By doing scan with SymbolRate <5000
I have the following response:

My scan:

daddy@linux-rpr6:~/satelite> scan Feeds
scanning Feeds
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
ERROR: invalid enum value '9'
initial transponder 10983000 V 4999000 9
>>> tune to: 10983:v:0:4999
DVB-S IF freq is 1233000
__tune_to_transponder:1508: ERROR: Setting frontend parameters failed: 22 
Invalid argument
>>> tune to: 10983:v:0:4999
DVB-S IF freq is 1233000
__tune_to_transponder:1508: ERROR: Setting frontend parameters failed: 22 
Invalid argument
ERROR: initial tuning failed
dumping lists (0 services)
Done.

My /log/warn

Mar 22 11:09:05 linux-rpr6 kernel: [ 3982.186317] DVB: adapter 0 frontend 0 
symbol rate 4999000 out of range (5000000..45000000)
Mar 22 11:09:06 linux-rpr6 kernel: [ 3982.399294] DVB: adapter 0 frontend 0 
symbol rate 4999000 out of range (5000000..45000000)

My lspci -nn

01:00.0 Multimedia controller [0480]: Philips Semiconductors SAA7146 
[1131:7146] (rev 01)

My lspci -vv

01:00.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: Technotrend Systemtechnik GmbH S2-3200
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (3750ns min, 9500ns max)
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at dfeffc00 (32-bit, non-prefetchable) [size=512]
        Kernel driver in use: budget_ci dvb

My lsmod

linux-rpr6:/home/daddy # lsmod
Module                  Size  Used by
ip6t_LOG                6468  6      
xt_tcpudp               3136  2      
xt_pkttype              1632  3      
ipt_LOG                 6276  6      
xt_limit                2692  12     
snd_pcm_oss            51616  0      
snd_mixer_oss          19104  1 snd_pcm_oss
snd_seq                64784  0            
snd_seq_device          8620  1 snd_seq    
edd                    10472  0            
af_packet              23456  0            
ip6t_REJECT             5472  3            
nf_conntrack_ipv6      22036  4            
ip6table_raw            3008  1            
xt_NOTRACK              1632  4            
ipt_REJECT              3168  3            
xt_state                2208  8            
iptable_raw             2848  1            
iptable_filter          3616  1            
ip6table_mangle         4160  0            
nf_conntrack_netbios_ns     2560  0        
i915                  251464  1
drm                   185440  2 i915
i2c_algo_bit            6884  1 i915
video                  24600  1 i915
nf_conntrack_ipv4      11688  4
nf_conntrack           84768  5 
nf_conntrack_ipv6,xt_NOTRACK,xt_state,nf_conntrack_netbios_ns,nf_conntrack_ipv4
nf_defrag_ipv4          2112  1 nf_conntrack_ipv4
ip_tables              13392  2 iptable_raw,iptable_filter
ip6table_filter         3616  1
ip6_tables             14832  4 
ip6t_LOG,ip6table_raw,ip6table_mangle,ip6table_filter
x_tables               19524  11 
ip6t_LOG,xt_tcpudp,xt_pkttype,ipt_LOG,xt_limit,ip6t_REJECT,xt_NOTRACK,ipt_REJECT,xt_state,ip_tables,ip6_tables
cpufreq_conservative     8396  0
cpufreq_userspace       3332  0
cpufreq_powersave       1568  0
acpi_cpufreq            9452  0
speedstep_lib           5092  0
fuse                   74332  5
loop                   17228  0
dm_mod                 84900  0
lnbp21                  2816  1
stb6100                 7780  1
stb0899                37252  1
iTCO_wdt               12164  0
budget_ci              25240  0
snd_hda_codec_realtek   233860  1
budget_core            10628  1 budget_ci
dvb_core               98692  2 budget_ci,budget_core
saa7146                19880  2 budget_ci,budget_core
ttpci_eeprom            2144  1 budget_core
iTCO_vendor_support     3876  1 iTCO_wdt
ppdev                  10276  0
sg                     32884  0
sr_mod                 17572  0
cdrom                  40768  1 sr_mod
pcspkr                  2784  0
joydev                 11232  0
ir_common              49284  1 budget_ci
i2c_i801               12788  0
serio_raw               6276  0
snd_hda_intel          31712  3
snd_hda_codec          94688  2 snd_hda_codec_realtek,snd_hda_intel
snd_hwdep               8740  1 snd_hda_codec
snd_pcm                96324  4 snd_pcm_oss,snd_hda_intel,snd_hda_codec
snd_timer              25960  3 snd_seq,snd_pcm
snd                    75236  14 
snd_pcm_oss,snd_mixer_oss,snd_seq,snd_seq_device,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
snd_page_alloc         10600  2 snd_hda_intel,snd_pcm
intel_agp              31460  1
atl2                   30264  0
parport_pc             40356  0
parport                39948  2 ppdev,parport_pc
floppy                 61220  0
asus_atk0110           13888  0
button                  6608  0
ext4                  381480  1
jbd2                   96288  1 ext4
crc16                   1952  1 ext4
fan                     5028  0
processor              50576  1 acpi_cpufreq
ide_pci_generic         4036  0
piix                    6760  0
ide_core              122540  2 ide_pci_generic,piix
ata_generic             4836  0
thermal                21084  0
thermal_sys            18344  4 video,fan,processor,thermal

Thank you for your attention.



