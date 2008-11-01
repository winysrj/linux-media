Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web52810.mail.re2.yahoo.com ([206.190.48.253])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <sean_donnelly@yahoo.com>) id 1KwLpI-0001UC-M2
	for linux-dvb@linuxtv.org; Sat, 01 Nov 2008 20:08:01 +0100
Date: Sat, 1 Nov 2008 12:07:26 -0700 (PDT)
From: Sean Donnelly <sean_donnelly@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <546027.53072.qm@web52810.mail.re2.yahoo.com>
Subject: [linux-dvb] Problem with CI/CAM with TT C-2300 Premiun
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0245523139=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0245523139==
Content-Type: multipart/alternative; boundary="0-1047596092-1225566446=:53072"

--0-1047596092-1225566446=:53072
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hej,=0A=0AA newbie question, I hope someone can suggest some troubleshootin=
g steps.=0A=0AI have a problem with viewing encrypted channels with my new =
TechnoTrend TT C-2300 Premium card with the matching CI.=0A=0AI have tried =
with two conax cams from SMARDTV & Turbosat which both work in my tv.=0A=0A=
I am able to scan the channels and view the one FTA channel that my provide=
r comhem transmits. I am testing with both Kaffiene and Mythtv=0A=0AI belie=
ve that I have downloaded and installed the latest v4l-dvb source code from=
 Mercurial and I have recently upgraded Intrepid Ubuntu 8.1=0A=0AI see no r=
eference to  the CAM or CA in the syslog. Should there be?=0A=0AThanks for =
any assistance=0ASean=0A=0Auname -a=0ALinux tyrone-desktop 2.6.27-7-generic=
 #1 SMP Thu Oct 30 04:18:38 UTC 2008 i686 GNU/Linux=0A=0Asean@tyrone-deskto=
p:~$ dmesg | grep  [dD][vV][bB]=0A[   19.183691] saa7146: register extensio=
n 'dvb'.=0A[   19.692545] dvb 0000:02:0b.0: PCI INT A -> Link[LNK4] -> GSI =
5 (level, low) -> IRQ 5=0A[   19.692596] firmware: requesting dvb-ttpci-01.=
fw=0A[   21.578128] DVB: registering new adapter (Technotrend/Hauppauge Win=
TV Nexus-CA rev1.X)=0A[   21.823332] dvb-ttpci: gpioirq unknown type=3D0 le=
n=3D0=0A[   21.848095] dvb-ttpci: info @ card 0: firm f0240009, rtsl b02500=
18, vid 71010068, app 80002622=0A[   21.848100] dvb-ttpci: firmware @ card =
0 supports CI link layer interface=0A[   22.024269] dvb-ttpci: DVB-C analog=
 module @ card 0 detected, initializing MSP3415=0A[   22.130584] dvb_ttpci:=
 saa7113 not accessible.=0A[   22.235445] DVB: registering frontend 0 (ST S=
TV0297 DVB-C)...=0A[   22.235657] input: DVB on-card IR receiver as /device=
s/pci0000:00/0000:00:0e.0/0000:02:0b.0/input/input6=0A[   22.236090] dvb-tt=
pci: found av7110-0.=0Asean@tyrone-desktop:~$=0A=0Asean@tyrone-desktop:~$ l=
spci -v=0A=0A02:09.0 Multimedia video controller: Internext Compression Inc=
 iTVC16 (CX23416) MPEG-2 Encoder (rev 01)=0A    Subsystem: Hauppauge comput=
er works Inc. Device 8003=0A    Flags: bus master, medium devsel, latency 6=
4, IRQ 10=0A    Memory at e8000000 (32-bit, prefetchable) [size=3D64M]=0A  =
  Capabilities: <access denied>=0A    Kernel driver in use: ivtv=0A    Kern=
el modules: ivtv=0A=0A02:0b.0 Multimedia controller: Philips Semiconductors=
 SAA7146 (rev 01)=0A    Subsystem: Technotrend Systemtechnik GmbH Device 00=
0a=0A    Flags: bus master, medium devsel, latency 32, IRQ 5=0A    Memory a=
t ec003000 (32-bit, non-prefetchable) [size=3D512]=0A    Kernel driver in u=
se: dvb=0A    Kernel modules: dvb-ttpci, snd-aw2=0A=0Asean@tyrone-desktop:~=
$ czap SVT1=0Ausing '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/de=
mux0'=0A 21 SVT1:290000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64:4102:4358=
:1097=0A 21 SVT1: f 290000000, s 6875000, i 2, fec 0, qam 3, v 0x1006, a 0x=
1106=0Astatus 00 | signal 0000 | snr 1060 | ber 00000000 | unc 00000000 |=
=0Astatus 1f | signal ca65 | snr 11e2 | ber 00000003 | unc 00000000 | FE_HA=
S_LOCK=0Astatus 1f | signal ca65 | snr 1201 | ber 00000002 | unc 00000000 |=
 FE_HAS_LOCK=0As=0A=0Asean@tyrone-desktop:~$ ls -al /dev/dvb/adapter0=0Atot=
al 0=0Adrwxr-xr-x  2 root root     200 2008-11-01 17:46 .=0Adrwxr-xr-x  3 r=
oot root      60 2008-11-01 17:46 ..=0Acrw-rw----+ 1 root video 212, 1 2008=
-11-01 17:46 audio0=0Acrw-rw----+ 1 root video 212, 6 2008-11-01 17:46 ca0=
=0Acrw-rw----+ 1 root video 212, 4 2008-11-01 17:46 demux0=0Acrw-rw----+ 1 =
root video 212, 5 2008-11-01 17:46 dvr0=0Acrw-rw----+ 1 root video 212, 3 2=
008-11-01 17:46 frontend0=0Acrw-rw----+ 1 root video 212, 7 2008-11-01 17:4=
6 net0=0Acrw-rw----+ 1 root video 212, 8 2008-11-01 17:46 osd0=0Acrw-rw----=
+ 1 root video 212, 0 2008-11-01 17:46 video0=0A=0Asean@tyrone-desktop:~$ l=
smod=0AModule                  Size  Used by=0Aipv6                  263972=
  60=0Aaf_packet              25728  4=0Abinfmt_misc            16904  1=0A=
rfkill_input           12672  0=0Abridge                 56980  0=0Astp    =
                10628  1 bridge=0Abnep                   20480  2=0Asco    =
                18308  2=0Arfcomm                 44432  0=0Al2cap         =
         30464  6 bnep,rfcomm=0Abluetooth              61924  6 bnep,sco,rf=
comm,l2cap=0Appdev                  15620  0=0Acpufreq_powersave       9856=
  0=0Acpufreq_userspace      11396  0=0Acpufreq_stats          13188  0=0Ac=
pufreq_conservative    14600  0=0Acpufreq_ondemand       14988  0=0Afreq_ta=
ble             12672  2 cpufreq_stats,cpufreq_ondemand=0Asbs              =
      19464  0=0Apci_slot               12552  0=0Avideo                  2=
5104  0=0Aoutput                 11008  1 video=0Asbshc                  13=
440  1 sbs=0Acontainer              11520  0=0Awmi                    14504=
  0=0Abattery                18436  0=0Aiptable_filter         10752  0=0Ai=
p_tables              19600  1 iptable_filter=0Ax_tables               2291=
6  1 ip_tables=0Aac                     12292  0=0Alirc_atiusb            2=
4352  0=0Alirc_dev               20020  1 lirc_atiusb=0Asbp2               =
    29324  0=0Alp                     17156  0=0Astv0297                152=
32  1=0Aarc4                    9984  2=0Aecb                    10880  2=
=0Acrypto_blkcipher       25476  1 ecb=0Ab43legacy             128156  0=0A=
tuner_simple           22288  1=0Atuner_types            22400  1 tuner_sim=
ple=0Arfkill                 17176  3 rfkill_input,b43legacy=0Amac80211    =
          216820  1 b43legacy=0Acfg80211               32392  1 mac80211=0A=
wm8775                 13740  0=0Acx25840                35504  0=0Aled_cla=
ss              12164  1 b43legacy=0Atuner                  32836  0=0Aevde=
v                  17696  9=0Ainput_polldev          11912  1 b43legacy=0Ad=
vb_ttpci             107340  7=0Advb_core               94592  1 dvb_ttpci=
=0Aivtv                  150596  0=0Asaa7146_vv             53888  1 dvb_tt=
pci=0Asaa7146                24584  2 dvb_ttpci,saa7146_vv=0Acompat_ioctl32=
          9344  1 ivtv=0Ai2c_algo_bit           14340  1 ivtv=0Avideobuf_dm=
a_sg        20612  1 saa7146_vv=0Avideobuf_core          26372  2 saa7146_v=
v,videobuf_dma_sg=0Acx2341x                20996  1 ivtv=0Av4l2_common     =
       21120  5 wm8775,cx25840,tuner,ivtv,cx2341x=0Avideodev               =
41728  3 tuner,ivtv,saa7146_vv=0Attpci_eeprom           10240  1 dvb_ttpci=
=0Av4l1_compat            21892  2 saa7146_vv,videodev=0Atveeprom          =
     20228  1 ivtv=0Afglrx                1813960  23=0Asnd_intel8x0       =
    37532  3=0Asnd_ac97_codec        111652  1 snd_intel8x0=0Aac97_bus     =
           9856  1 snd_ac97_codec=0Asnd_pcm_oss            46848  0=0Asnd_m=
ixer_oss          22784  1 snd_pcm_oss=0Asnd_pcm                83204  3 sn=
d_intel8x0,snd_ac97_codec,snd_pcm_oss=0Asnd_seq_dummy          10884  0=0As=
nd_seq_oss            38528  0=0Aparport_pc             39204  1=0Aparport =
               42604  3 ppdev,lp,parport_pc=0Ai2c_nforce2            14468 =
 0=0Asnd_seq_midi           14336  0=0Asnd_rawmidi            29824  1 snd_=
seq_midi=0Asnd_seq_midi_event     15232  2 snd_seq_oss,snd_seq_midi=0Asnd_s=
eq                57776  6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_m=
idi_event=0Asnd_timer              29960  2 snd_pcm,snd_seq=0Asnd_seq_devic=
e         15116  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_s=
eq=0Ai2c_core               31892  12 stv0297,tuner_simple,wm8775,cx25840,t=
uner,dvb_ttpci,ivtv,i2c_algo_bit,v4l2_common,ttpci_eeprom,tveeprom,i2c_nfor=
ce2=0Aamd64_agp              18184  1=0Abutton                 14224  0=0As=
nd                    63268  16 snd_intel8x0,snd_ac97_codec,snd_pcm_oss,snd=
_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device=
=0Aagpgart                42184  2 fglrx,amd64_agp=0Apcspkr                =
 10624  0=0Ashpchp                 37908  0=0Apci_hotplug            35236 =
 1 shpchp=0Asoundcore              15328  1 snd=0Ak8temp                 12=
416  0=0Asnd_page_alloc         16136  2 snd_intel8x0,snd_pcm=0Aext3       =
           133256  1=0Ajbd                    55444  1 ext3=0Ambcache      =
          16004  1 ext3=0Asd_mod                 42264  3=0Acrc_t10dif     =
         9984  1 sd_mod=0Asr_mod                 22212  0=0Acdrom          =
        43168  1 sr_mod=0Asg                     39732  0=0Apata_acpi      =
        12160  0=0Ausbhid                 35840  0=0Ahid                   =
 50560  1 usbhid=0Asata_nv                30600  2=0Apata_amd              =
 18692  0=0Aohci1394               37936  0=0Assb                    40580 =
 1 b43legacy=0Aieee1394               96324  2 sbp2,ohci1394=0Aata_generic =
           12932  0=0Alibata                177312  4 pata_acpi,sata_nv,pat=
a_amd,ata_generic=0Ascsi_mod              155212  5 sbp2,sd_mod,sr_mod,sg,l=
ibata=0Aohci_hcd               31888  0=0Aehci_hcd               43276  0=
=0Adock                   16656  1 libata=0Aforcedeth              61328  0=
=0Ausbcore               148848  5 lirc_atiusb,usbhid,ohci_hcd,ehci_hcd=0At=
hermal                23708  0=0Aprocessor              42156  1 thermal=0A=
fan                    12548  0=0Afbcon                  47648  0=0Atilebli=
t               10880  1 fbcon=0Afont                   16512  1 fbcon=0Abi=
tblit                13824  1 fbcon=0Asoftcursor              9984  1 bitbl=
it=0Afuse                   60828  1=0A=0A=0A=0A      
--0-1047596092-1225566446=:53072
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head><style type=3D"text/css"><!-- DIV {margin:0px;} --></style></he=
ad><body><div style=3D"font-family:times new roman,new york,times,serif;fon=
t-size:12pt"><div>Hej,<br><br>A newbie question, I hope someone can suggest=
 some troubleshooting steps.<br><br>I have a problem with viewing encrypted=
 channels with my new TechnoTrend TT C-2300 Premium card with the matching =
CI.<br><br>I have tried with two conax cams from SMARDTV &amp; Turbosat whi=
ch both work in my tv.<br><br>I am able to scan the channels and view the o=
ne FTA channel that my provider comhem transmits. I am testing with both Ka=
ffiene and Mythtv<br><br>I believe that I have downloaded and installed the=
 latest v4l-dvb source code from Mercurial and I have recently upgraded Int=
repid Ubuntu 8.1<br><br>I see no reference to&nbsp; the CAM or CA in the sy=
slog. Should there be?<br><br>Thanks for any assistance<br>Sean<br><br>unam=
e -a<br>Linux tyrone-desktop 2.6.27-7-generic #1 SMP Thu Oct 30 04:18:38
 UTC 2008 i686 GNU/Linux<br><br>sean@tyrone-desktop:~$ dmesg | grep&nbsp; [=
dD][vV][bB]<br>[&nbsp;&nbsp; 19.183691] saa7146: register extension 'dvb'.<=
br>[&nbsp;&nbsp; 19.692545] dvb 0000:02:0b.0: PCI INT A -&gt; Link[LNK4] -&=
gt; GSI 5 (level, low) -&gt; IRQ 5<br>[&nbsp;&nbsp; 19.692596] firmware: re=
questing dvb-ttpci-01.fw<br>[&nbsp;&nbsp; 21.578128] DVB: registering new a=
dapter (Technotrend/Hauppauge WinTV Nexus-CA rev1.X)<br>[&nbsp;&nbsp; 21.82=
3332] dvb-ttpci: gpioirq unknown type=3D0 len=3D0<br>[&nbsp;&nbsp; 21.84809=
5] dvb-ttpci: info @ card 0: firm f0240009, rtsl b0250018, vid 71010068, ap=
p 80002622<br>[&nbsp;&nbsp; 21.848100] dvb-ttpci: firmware @ card 0 support=
s CI link layer interface<br>[&nbsp;&nbsp; 22.024269] dvb-ttpci: DVB-C anal=
og module @ card 0 detected, initializing MSP3415<br>[&nbsp;&nbsp; 22.13058=
4] dvb_ttpci: saa7113 not accessible.<br>[&nbsp;&nbsp; 22.235445] DVB: regi=
stering frontend 0 (ST STV0297 DVB-C)...<br>[&nbsp;&nbsp; 22.235657]
 input: DVB on-card IR receiver as /devices/pci0000:00/0000:00:0e.0/0000:02=
:0b.0/input/input6<br>[&nbsp;&nbsp; 22.236090] dvb-ttpci: found av7110-0.<b=
r>sean@tyrone-desktop:~$<br><br>sean@tyrone-desktop:~$ lspci -v<br><br>02:0=
9.0 Multimedia video controller: Internext Compression Inc iTVC16 (CX23416)=
 MPEG-2 Encoder (rev 01)<br>&nbsp;&nbsp;&nbsp; Subsystem: Hauppauge compute=
r works Inc. Device 8003<br>&nbsp;&nbsp;&nbsp; Flags: bus master, medium de=
vsel, latency 64, IRQ 10<br>&nbsp;&nbsp;&nbsp; Memory at e8000000 (32-bit, =
prefetchable) [size=3D64M]<br>&nbsp;&nbsp;&nbsp; Capabilities: &lt;access d=
enied&gt;<br>&nbsp;&nbsp;&nbsp; Kernel driver in use: ivtv<br>&nbsp;&nbsp;&=
nbsp; Kernel modules: ivtv<br><br>02:0b.0 Multimedia controller: Philips Se=
miconductors SAA7146 (rev 01)<br>&nbsp;&nbsp;&nbsp; Subsystem: Technotrend =
Systemtechnik GmbH Device 000a<br>&nbsp;&nbsp;&nbsp; Flags: bus master, med=
ium devsel, latency 32, IRQ 5<br>&nbsp;&nbsp;&nbsp; Memory at ec003000
 (32-bit, non-prefetchable) [size=3D512]<br>&nbsp;&nbsp;&nbsp; Kernel drive=
r in use: dvb<br>&nbsp;&nbsp;&nbsp; Kernel modules: dvb-ttpci, snd-aw2<br><=
br>sean@tyrone-desktop:~$ czap SVT1<br>using '/dev/dvb/adapter0/frontend0' =
and '/dev/dvb/adapter0/demux0'<br>&nbsp;21 SVT1:290000000:INVERSION_AUTO:68=
75000:FEC_NONE:QAM_64:4102:4358:1097<br>&nbsp;21 SVT1: f 290000000, s 68750=
00, i 2, fec 0, qam 3, v 0x1006, a 0x1106<br>status 00 | signal 0000 | snr =
1060 | ber 00000000 | unc 00000000 |<br>status 1f | signal ca65 | snr 11e2 =
| ber 00000003 | unc 00000000 | FE_HAS_LOCK<br>status 1f | signal ca65 | sn=
r 1201 | ber 00000002 | unc 00000000 | FE_HAS_LOCK<br>s<br><br>sean@tyrone-=
desktop:~$ ls -al /dev/dvb/adapter0<br>total 0<br>drwxr-xr-x&nbsp; 2 root r=
oot&nbsp;&nbsp;&nbsp;&nbsp; 200 2008-11-01 17:46 .<br>drwxr-xr-x&nbsp; 3 ro=
ot root&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 60 2008-11-01 17:46 ..<br>crw-rw----+=
 1 root video 212, 1 2008-11-01 17:46 audio0<br>crw-rw----+ 1 root
 video 212, 6 2008-11-01 17:46 ca0<br>crw-rw----+ 1 root video 212, 4 2008-=
11-01 17:46 demux0<br>crw-rw----+ 1 root video 212, 5 2008-11-01 17:46 dvr0=
<br>crw-rw----+ 1 root video 212, 3 2008-11-01 17:46 frontend0<br>crw-rw---=
-+ 1 root video 212, 7 2008-11-01 17:46 net0<br>crw-rw----+ 1 root video 21=
2, 8 2008-11-01 17:46 osd0<br>crw-rw----+ 1 root video 212, 0 2008-11-01 17=
:46 video0<br><br>sean@tyrone-desktop:~$ lsmod<br>Module&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; Size&nbsp; Used by<br>ipv6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 263972&nbsp;=
 60<br>af_packet&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; 25728&nbsp; 4<br>binfmt_misc&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 16904&nbsp; 1<br>rfkill_input&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 12672&nbsp;
 0<br>bridge&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 56980&nbsp; 0<br>stp&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; 10628&nbsp; 1 bridge<br>bnep&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; 20480&nbsp; 2<br>sco&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 18308&nbs=
p; 2<br>rfcomm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 44432&nbsp; 0<br>l2cap&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; 30464&nbsp; 6 bnep,rfcomm<br>bluetooth&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 61924&nbsp; 6
 bnep,sco,rfcomm,l2cap<br>ppdev&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15620&nbsp; 0<br=
>cpufreq_powersave&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9856&nbsp; 0<br>cpuf=
req_userspace&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 11396&nbsp; 0<br>cpufreq_stats&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 13188&nbsp; 0<br>cpuf=
req_conservative&nbsp;&nbsp;&nbsp; 14600&nbsp; 0<br>cpufreq_ondemand&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14988&nbsp; 0<br>freq_table&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 12672&nbsp; 2 cpufre=
q_stats,cpufreq_ondemand<br>sbs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1946=
4&nbsp; 0<br>pci_slot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 12552&nbsp;
 0<br>video&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 25104&nbsp; 0<br>output&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; 11008&nbsp; 1 video<br>sbshc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 13440&nbsp=
; 1 sbs<br>container&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; 11520&nbsp; 0<br>wmi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; 14504&nbsp; 0<br>battery&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 18436&nbsp; 0<br>iptable_f=
ilter&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10752&nbsp; 0<br>ip_t=
ables&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; 19600&nbsp; 1
 iptable_filter<br>x_tables&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 22916&nbsp; 1 ip_tables<br>ac&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 12292&nbsp; 0<br>lirc_atiusb&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 24352&nbsp; 0<br>l=
irc_dev&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; 20020&nbsp; 1 lirc_atiusb<br>sbp2&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; 29324&nbsp; 0<br>lp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1=
7156&nbsp; 0<br>stv0297&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15232&nbsp;
 1<br>arc4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9984&nbsp; 2<br>ecb&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10880&nbsp; 2<br>crypto_blkcipher&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; 25476&nbsp; 1 ecb<br>b43legacy&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 128156&nbsp; 0<br>=
tuner_simple&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 22=
288&nbsp; 1<br>tuner_types&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; 22400&nbsp; 1 tuner_simple<br>rfkill&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 17176&nbsp; 3 rfkill_input,b43legacy<br>mac80211&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 216820&nbsp; 1
 b43legacy<br>cfg80211&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 32392&nbsp; 1 mac80211<br>wm8775&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; 13740&nbsp; 0<br>cx25840&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 35504&nbsp; 0<br>led_cla=
ss&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; 12164&nbsp; 1 b43legacy<br>tuner&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 32836&nbs=
p; 0<br>evdev&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 17696&nbsp; 9<br>input_polldev&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 11912&nbsp; 1 b43legacy<=
br>dvb_ttpci&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; 107340&nbsp;
 7<br>dvb_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; 94592&nbsp; 1 dvb_ttpci<br>ivtv&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; 150596&nbsp; 0<br>saa7146_vv&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 53888&nbsp; 1 dvb_ttpci<br>saa7146&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; 24584&nbsp; 2 dvb_ttpci,saa7146_vv<br>compat_ioctl32&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9344&nbsp; 1 ivtv<br>i2c_algo_bit&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14340&nbsp; 1 i=
vtv<br>videobuf_dma_sg&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 20612&nbsp=
; 1 saa7146_vv<br>videobuf_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; 26372&nbsp; 2
 saa7146_vv,videobuf_dma_sg<br>cx2341x&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 20996&nbsp; 1 ivtv<br=
>v4l2_common&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; 21120&nbsp; 5 wm8775,cx25840,tuner,ivtv,cx2341x<br>videodev&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 41=
728&nbsp; 3 tuner,ivtv,saa7146_vv<br>ttpci_eeprom&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10240&nbsp; 1 dvb_ttpci<br>v4l1_compat&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 21892&nbsp=
; 2 saa7146_vv,videodev<br>tveeprom&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 20228&nbsp; 1 ivtv<br>fglrx&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; 1813960&nbsp; 23<br>snd_intel8x0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 37532&nbsp;
 3<br>snd_ac97_codec&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 111652&nbsp;=
 1 snd_intel8x0<br>ac97_bus&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9856&nbsp; 1 snd_ac97_codec<br>s=
nd_pcm_oss&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; 46848&nbsp; 0<br>snd_mixer_oss&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; 22784&nbsp; 1 snd_pcm_oss<br>snd_pcm&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 83204&nbsp;=
 3 snd_intel8x0,snd_ac97_codec,snd_pcm_oss<br>snd_seq_dummy&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10884&nbsp; 0<br>snd_seq_oss&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 38528&nbsp; 0<br=
>parport_pc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; 39204&nbsp; 1<br>parport&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 42604&nbsp; 3
 ppdev,lp,parport_pc<br>i2c_nforce2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; 14468&nbsp; 0<br>snd_seq_midi&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14336&nbsp; 0<br>snd_rawmidi&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 29824&nbsp; 1=
 snd_seq_midi<br>snd_seq_midi_event&nbsp;&nbsp;&nbsp;&nbsp; 15232&nbsp; 2 s=
nd_seq_oss,snd_seq_midi<br>snd_seq&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 57776&nbsp; 6 snd_seq_dum=
my,snd_seq_oss,snd_seq_midi,snd_seq_midi_event<br>snd_timer&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 29960&nbsp; =
2 snd_pcm,snd_seq<br>snd_seq_device&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; 15116&nbsp; 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,s=
nd_seq<br>i2c_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; 31892&nbsp; 12
 stv0297,tuner_simple,wm8775,cx25840,tuner,dvb_ttpci,ivtv,i2c_algo_bit,v4l2=
_common,ttpci_eeprom,tveeprom,i2c_nforce2<br>amd64_agp&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 18184&nbsp; 1<br>=
button&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; 14224&nbsp; 0<br>snd&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; 63268&nbsp; 16 snd_intel8x0,snd_ac97_codec,snd_pcm_oss,snd_mix=
er_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device<br>=
agpgart&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; 42184&nbsp; 2 fglrx,amd64_agp<br>pcspkr&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; 10624&nbsp; 0<br>shpchp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 37908&nbsp;
 0<br>pci_hotplug&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; 35236&nbsp; 1 shpchp<br>soundcore&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15328&nbsp; 1 snd<br>k8temp&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; 12416&nbsp; 0<br>snd_page_alloc&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; 16136&nbsp; 2 snd_intel8x0,snd_pcm<br>ext3&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; 133256&nbsp; 1<br>jbd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; 55444&nbsp; 1 ext3<br>mbcache&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 16004&nbsp; 1 ext3<br>sd=
_mod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; 42264&nbsp;
 3<br>crc_t10dif&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; 9984&nbsp; 1 sd_mod<br>sr_mod&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2221=
2&nbsp; 0<br>cdrom&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 43168&nbsp; 1 sr_mod<br>sg&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 39732&nbsp; 0<br>pata_acpi&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 12=
160&nbsp; 0<br>usbhid&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 35840&nbsp; 0<br>hid&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; 50560&nbsp; 1
 usbhid<br>sata_nv&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 30600&nbsp; 2<br>pata_amd&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 18692&=
nbsp; 0<br>ohci1394&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; 37936&nbsp; 0<br>ssb&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; 40580&nbsp; 1 b43legacy<br>ieee1394&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 96324&nbsp; 2 sb=
p2,ohci1394<br>ata_generic&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; 12932&nbsp; 0<br>libata&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 177312&nbsp; 4 pat=
a_acpi,sata_nv,pata_amd,ata_generic<br>scsi_mod&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 155212&nbsp; 5
 sbp2,sd_mod,sr_mod,sg,libata<br>ohci_hcd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31888&nbsp; 0<br>ehci_hc=
d&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; 43276&nbsp; 0<br>dock&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 16656&nbs=
p; 1 libata<br>forcedeth&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; 61328&nbsp; 0<br>usbcore&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 148848&nbsp; =
5 lirc_atiusb,usbhid,ohci_hcd,ehci_hcd<br>thermal&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 23708&nbsp=
; 0<br>processor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; 42156&nbsp; 1
 thermal<br>fan&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 12548&nbsp; 0<br>fbc=
on&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 47648&nbsp; 0<br>tileblit&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10880&nbsp=
; 1 fbcon<br>font&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 16512&nbsp; 1 fbcon<br>b=
itblit&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; 13824&nbsp; 1 fbcon<br>softcursor&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9984&nbsp; 1 bit=
blit<br>fuse&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 60828&nbsp; 1<br></div></div>=
<br>=0A=0A=0A=0A      </body></html>
--0-1047596092-1225566446=:53072--


--===============0245523139==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0245523139==--
