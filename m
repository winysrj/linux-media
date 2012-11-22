Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm22-vm2.bullet.mail.gq1.yahoo.com ([98.136.217.65]:42696 "EHLO
	nm22-vm2.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754461Ab2KVWiG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 17:38:06 -0500
References: 
Message-ID: <1353598043.25176.YahooMailNeo@web113301.mail.gq1.yahoo.com>
Date: Thu, 22 Nov 2012 07:27:23 -0800 (PST)
From: Yuri Glushkov <yglushkov@yahoo.com>
Reply-To: Yuri Glushkov <yglushkov@yahoo.com>
Subject: 093a:2460 Webcam (Pixart PAC207BCA) - inverted LED logic 
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "525959@bugs.launchpad.net" <525959@bugs.launchpad.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1771772517-281753162-1353598043=:25176"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--1771772517-281753162-1353598043=:25176
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

[1.] One line summary of the problem: =0A093a:2460 Webcam (Pixart PAC207BCA=
) - inverted LED logic =0A=0A[2.] Full description of the problem/report: =
=0AThe LED on this webcam is always turned on when connected to USB, unless=
=0A some application uses it - the behavior that is opposite to what is =0A=
expected.=0Ahttps://bugs.launchpad.net/ubuntu/+source/linux/+bug/525959=0AT=
he problem persists on all versions of Ubuntu I've tested.=0A=0A=0A[3.] Key=
words (i.e., modules, networking, kernel): Please note, Kernel.org uses a d=
ifferent keyword system then the Ubuntu Tags system. =0Agspca, pac207, 093a=
:2460, Pixart PAC207BCA=0A=0A[4.] Kernel version (from /proc/version): =0AL=
inux version 3.2.0-32-generic-pae (buildd@roseapple) (gcc version 4.6.3 (Ub=
untu/Linaro 4.6.3-1ubuntu5) ) #51-Ubuntu SMP Wed Sep 26 21:54:23 UTC 2012=
=0A=0A[5.] Output of Oops.. message (if applicable) with symbolic informati=
on resolved (see Documentation/oops-tracing.txt) =0ANA=0A=0A[6.] A small sh=
ell script or example program which triggers the problem (if possible) =0AN=
A=0A=0A[7.] Environment =0ADescription:=A0=A0=A0 Ubuntu 12.04.1 LTS=0ARelea=
se:=A0=A0=A0 12.04=0A=0A[7.1.] Software (add the output of the ver_linux sc=
ript here) =0A=0ALinux yuri-desktop 3.2.0-32-generic-pae #51-Ubuntu SMP Wed=
 Sep 26 21:54:23 UTC 2012 i686 i686 i386 GNU/Linux=0A=A0=0AGnu C=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 4.6=0AGnu make=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 3.81=0Abinutils=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 2.22=0Autil-linux=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.20.1=0Amo=
unt=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 support=0Amodule-ini=
t-tools=A0=A0=A0=A0=A0 3.16=0Ae2fsprogs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 1.42=0Apcmciautils=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 018=0ALinux C Libra=
ry=A0=A0=A0=A0=A0=A0=A0 2.15=0ADynamic linker (ldd)=A0=A0 2.15=0AProcps=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 3.2.8=0ANet-tools=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 1.60=0AKbd=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 1.15.2=0ASh-utils=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 8.13=0Awireless-tools=A0=A0=A0=A0=A0=A0=A0=A0 30=0AModules Loaded=A0=
=A0=A0=A0=A0=A0=A0=A0 rfcomm bnep bluetooth binfmt_misc dm_crypt snd_hda_co=
dec_hdmi gspca_pac207 gspca_main videodev snd_hda_codec_realtek ppdev eeepc=
_wmi asus_wmi sparse_keymap snd_hda_intel snd_hda_codec snd_hwdep snd_pcm s=
nd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq nvidia parport_pc snd_ti=
mer wmi snd_seq_device snd serio_raw mac_hid soundcore snd_page_alloc mei l=
p parport vesafb usbhid hid r8169 pata_via video=0A=0A[7.2.] Processor info=
rmation (from /proc/cpuinfo): =0A=0Aprocessor=A0=A0=A0 : 0=0Avendor_id=A0=
=A0=A0 : GenuineIntel=0Acpu family=A0=A0=A0 : 6=0Amodel=A0=A0=A0 =A0=A0=A0 =
: 42=0Amodel name=A0=A0=A0 : Intel(R) Core(TM) i5-2500 CPU @ 3.30GHz=0Astep=
ping=A0=A0=A0 : 7=0Amicrocode=A0=A0=A0 : 0x28=0Acpu MHz=A0=A0=A0 =A0=A0=A0 =
: 1600.000=0Acache size=A0=A0=A0 : 6144 KB=0Aphysical id=A0=A0=A0 : 0=0Asib=
lings=A0=A0=A0 : 4=0Acore id=A0=A0=A0 =A0=A0=A0 : 0=0Acpu cores=A0=A0=A0 : =
4=0Aapicid=A0=A0=A0 =A0=A0=A0 : 0=0Ainitial apicid=A0=A0=A0 : 0=0Afdiv_bug=
=A0=A0=A0 : no=0Ahlt_bug=A0=A0=A0 =A0=A0=A0 : no=0Af00f_bug=A0=A0=A0 : no=
=0Acoma_bug=A0=A0=A0 : no=0Afpu=A0=A0=A0 =A0=A0=A0 : yes=0Afpu_exception=A0=
=A0=A0 : yes=0Acpuid level=A0=A0=A0 : 13=0Awp=A0=A0=A0 =A0=A0=A0 : yes=0Afl=
ags=A0=A0=A0 =A0=A0=A0 : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr p=
ge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rd=
tscp lm constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf=
 pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm p=
cid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm id=
a arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid=0A=
bogomips=A0=A0=A0 : 6622.34=0Aclflush size=A0=A0=A0 : 64=0Acache_alignment=
=A0=A0=A0 : 64=0Aaddress sizes=A0=A0=A0 : 36 bits physical, 48 bits virtual=
=0Apower management:=0A=0Aprocessor=A0=A0=A0 : 1=0Avendor_id=A0=A0=A0 : Gen=
uineIntel=0Acpu family=A0=A0=A0 : 6=0Amodel=A0=A0=A0 =A0=A0=A0 : 42=0Amodel=
 name=A0=A0=A0 : Intel(R) Core(TM) i5-2500 CPU @ 3.30GHz=0Astepping=A0=A0=
=A0 : 7=0Amicrocode=A0=A0=A0 : 0x28=0Acpu MHz=A0=A0=A0 =A0=A0=A0 : 1600.000=
=0Acache size=A0=A0=A0 : 6144 KB=0Aphysical id=A0=A0=A0 : 0=0Asiblings=A0=
=A0=A0 : 4=0Acore id=A0=A0=A0 =A0=A0=A0 : 1=0Acpu cores=A0=A0=A0 : 4=0Aapic=
id=A0=A0=A0 =A0=A0=A0 : 2=0Ainitial apicid=A0=A0=A0 : 2=0Afdiv_bug=A0=A0=A0=
 : no=0Ahlt_bug=A0=A0=A0 =A0=A0=A0 : no=0Af00f_bug=A0=A0=A0 : no=0Acoma_bug=
=A0=A0=A0 : no=0Afpu=A0=A0=A0 =A0=A0=A0 : yes=0Afpu_exception=A0=A0=A0 : ye=
s=0Acpuid level=A0=A0=A0 : 13=0Awp=A0=A0=A0 =A0=A0=A0 : yes=0Aflags=A0=A0=
=A0 =A0=A0=A0 : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cm=
ov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm c=
onstant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf pni pclm=
ulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_=
1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat ep=
b xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid=0Abogomips=
=A0=A0=A0 : 6622.22=0Aclflush size=A0=A0=A0 : 64=0Acache_alignment=A0=A0=A0=
 : 64=0Aaddress sizes=A0=A0=A0 : 36 bits physical, 48 bits virtual=0Apower =
management:=0A=0Aprocessor=A0=A0=A0 : 2=0Avendor_id=A0=A0=A0 : GenuineIntel=
=0Acpu family=A0=A0=A0 : 6=0Amodel=A0=A0=A0 =A0=A0=A0 : 42=0Amodel name=A0=
=A0=A0 : Intel(R) Core(TM) i5-2500 CPU @ 3.30GHz=0Astepping=A0=A0=A0 : 7=0A=
microcode=A0=A0=A0 : 0x28=0Acpu MHz=A0=A0=A0 =A0=A0=A0 : 1600.000=0Acache s=
ize=A0=A0=A0 : 6144 KB=0Aphysical id=A0=A0=A0 : 0=0Asiblings=A0=A0=A0 : 4=
=0Acore id=A0=A0=A0 =A0=A0=A0 : 2=0Acpu cores=A0=A0=A0 : 4=0Aapicid=A0=A0=
=A0 =A0=A0=A0 : 4=0Ainitial apicid=A0=A0=A0 : 4=0Afdiv_bug=A0=A0=A0 : no=0A=
hlt_bug=A0=A0=A0 =A0=A0=A0 : no=0Af00f_bug=A0=A0=A0 : no=0Acoma_bug=A0=A0=
=A0 : no=0Afpu=A0=A0=A0 =A0=A0=A0 : yes=0Afpu_exception=A0=A0=A0 : yes=0Acp=
uid level=A0=A0=A0 : 13=0Awp=A0=A0=A0 =A0=A0=A0 : yes=0Aflags=A0=A0=A0 =A0=
=A0=A0 : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat =
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm constant=
_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf pni pclmulqdq d=
tes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_=
2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsave=
opt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid=0Abogomips=A0=A0=
=A0 : 6622.21=0Aclflush size=A0=A0=A0 : 64=0Acache_alignment=A0=A0=A0 : 64=
=0Aaddress sizes=A0=A0=A0 : 36 bits physical, 48 bits virtual=0Apower manag=
ement:=0A=0Aprocessor=A0=A0=A0 : 3=0Avendor_id=A0=A0=A0 : GenuineIntel=0Acp=
u family=A0=A0=A0 : 6=0Amodel=A0=A0=A0 =A0=A0=A0 : 42=0Amodel name=A0=A0=A0=
 : Intel(R) Core(TM) i5-2500 CPU @ 3.30GHz=0Astepping=A0=A0=A0 : 7=0Amicroc=
ode=A0=A0=A0 : 0x28=0Acpu MHz=A0=A0=A0 =A0=A0=A0 : 1600.000=0Acache size=A0=
=A0=A0 : 6144 KB=0Aphysical id=A0=A0=A0 : 0=0Asiblings=A0=A0=A0 : 4=0Acore =
id=A0=A0=A0 =A0=A0=A0 : 3=0Acpu cores=A0=A0=A0 : 4=0Aapicid=A0=A0=A0 =A0=A0=
=A0 : 6=0Ainitial apicid=A0=A0=A0 : 6=0Afdiv_bug=A0=A0=A0 : no=0Ahlt_bug=A0=
=A0=A0 =A0=A0=A0 : no=0Af00f_bug=A0=A0=A0 : no=0Acoma_bug=A0=A0=A0 : no=0Af=
pu=A0=A0=A0 =A0=A0=A0 : yes=0Afpu_exception=A0=A0=A0 : yes=0Acpuid level=A0=
=A0=A0 : 13=0Awp=A0=A0=A0 =A0=A0=A0 : yes=0Aflags=A0=A0=A0 =A0=A0=A0 : fpu =
vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush=
 dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm constant_tsc arch_per=
fmon pebs bts xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor=
 ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popc=
nt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts d=
therm tpr_shadow vnmi flexpriority ept vpid=0Abogomips=A0=A0=A0 : 6622.21=
=0Aclflush size=A0=A0=A0 : 64=0Acache_alignment=A0=A0=A0 : 64=0Aaddress siz=
es=A0=A0=A0 : 36 bits physical, 48 bits virtual=0Apower management:=0A=0A[7=
.3.] Module information (from /proc/modules): =0A=0Arfcomm 38139 0 - Live 0=
x00000000=0Abnep 17830 2 - Live 0x00000000=0Abluetooth 158438 10 rfcomm,bne=
p, Live 0x00000000=0Abinfmt_misc 17292 1 - Live 0x00000000=0Adm_crypt 22528=
 0 - Live 0x00000000=0Asnd_hda_codec_hdmi 31775 4 - Live 0x00000000=0Agspca=
_pac207 13275 0 - Live 0x00000000=0Agspca_main 27654 1 gspca_pac207, Live 0=
x00000000=0Avideodev 86588 1 gspca_main, Live 0x00000000=0Asnd_hda_codec_re=
altek 174313 1 - Live 0x00000000=0Appdev 12849 0 - Live 0x00000000=0Aeeepc_=
wmi 12949 0 - Live 0x00000000=0Aasus_wmi 19624 1 eeepc_wmi, Live 0x00000000=
=0Asparse_keymap 13658 1 asus_wmi, Live 0x00000000=0Asnd_hda_intel 32765 5 =
- Live 0x00000000=0Asnd_hda_codec 109562 3 snd_hda_codec_hdmi,snd_hda_codec=
_realtek,snd_hda_intel, Live 0x00000000=0Asnd_hwdep 13276 1 snd_hda_codec, =
Live 0x00000000=0Asnd_pcm 80845 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_=
codec, Live 0x00000000=0Asnd_seq_midi 13132 0 - Live 0x00000000=0Asnd_rawmi=
di 25424 1 snd_seq_midi, Live 0x00000000=0Asnd_seq_midi_event 14475 1 snd_s=
eq_midi, Live 0x00000000=0Asnd_seq 51567 2 snd_seq_midi,snd_seq_midi_event,=
 Live 0x00000000=0Anvidia 10235966 41 - Live 0x00000000 (P)=0Aparport_pc 32=
114 1 - Live 0x00000000=0Asnd_timer 28931 2 snd_pcm,snd_seq, Live 0x0000000=
0=0Awmi 18744 1 asus_wmi, Live 0x00000000=0Asnd_seq_device 14172 3 snd_seq_=
midi,snd_rawmidi,snd_seq, Live 0x00000000=0Asnd 62064 20 snd_hda_codec_hdmi=
,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_ra=
wmidi,snd_seq,snd_timer,snd_seq_device, Live 0x00000000=0Aserio_raw 13027 0=
 - Live 0x00000000=0Amac_hid 13077 0 - Live 0x00000000=0Asoundcore 14635 1 =
snd, Live 0x00000000=0Asnd_page_alloc 14108 2 snd_hda_intel,snd_pcm, Live 0=
x00000000=0Amei 36570 0 - Live 0x00000000 (C)=0Alp 17455 0 - Live 0x0000000=
0=0Aparport 40930 3 ppdev,parport_pc,lp, Live 0x00000000=0Avesafb 13516 1 -=
 Live 0x00000000=0Ausbhid 41906 0 - Live 0x00000000=0Ahid 77367 1 usbhid, L=
ive 0x00000000=0Ar8169 56321 0 - Live 0x00000000=0Apata_via 13428 0 - Live =
0x00000000=0Avideo 19068 0 - Live 0x00000000=0A=0A[7.4.] Loaded driver and =
hardware information (/proc/ioports, /proc/iomem) =0A=A0 =0A0000-0cf7 : PCI=
 Bus 0000:00=0A=A0 0000-001f : dma1=0A=A0 0020-0021 : pic1=0A=A0 0040-0043 =
: timer0=0A=A0 0050-0053 : timer1=0A=A0 0060-0060 : keyboard=0A=A0 0064-006=
4 : keyboard=0A=A0 0070-0077 : rtc0=0A=A0 0080-008f : dma page reg=0A=A0 00=
a0-00a1 : pic2=0A=A0 00c0-00df : dma2=0A=A0 00f0-00ff : fpu=0A=A0 0200-020f=
 : pnp 00:05=0A=A0 0290-029f : pnp 00:08=0A=A0 0378-037a : parport0=0A=A0 0=
3c0-03df : vesafb=0A=A0 03f8-03ff : serial=0A=A0 0400-0453 : pnp 00:05=0A=
=A0=A0=A0 0400-0403 : ACPI PM1a_EVT_BLK=0A=A0=A0=A0 0404-0405 : ACPI PM1a_C=
NT_BLK=0A=A0=A0=A0 0408-040b : ACPI PM_TMR=0A=A0=A0=A0 0410-0415 : ACPI CPU=
 throttle=0A=A0=A0=A0 0420-042f : ACPI GPE0_BLK=0A=A0=A0=A0 0450-0450 : ACP=
I PM2_CNT_BLK=0A=A0 0454-0457 : pnp 00:07=0A=A0 0458-047f : pnp 00:05=0A=A0=
 04d0-04d1 : pnp 00:0a=0A=A0 0500-057f : pnp 00:05=0A=A0 0680-069f : pnp 00=
:05=0A0cf8-0cff : PCI conf1=0A0d00-ffff : PCI Bus 0000:00=0A=A0 164e-164f :=
 pnp 00:05=0A=A0 c000-cfff : PCI Bus 0000:05=0A=A0=A0=A0 c000-c0ff : 0000:0=
5:00.0=0A=A0=A0=A0=A0=A0 c000-c0ff : r8169=0A=A0 d000-dfff : PCI Bus 0000:0=
3=0A=A0=A0=A0 d000-d00f : 0000:03:00.0=0A=A0=A0=A0=A0=A0 d000-d00f : pata_v=
ia=0A=A0=A0=A0 d010-d013 : 0000:03:00.0=0A=A0=A0=A0=A0=A0 d010-d013 : pata_=
via=0A=A0=A0=A0 d020-d027 : 0000:03:00.0=0A=A0=A0=A0=A0=A0 d020-d027 : pata=
_via=0A=A0=A0=A0 d030-d033 : 0000:03:00.0=0A=A0=A0=A0=A0=A0 d030-d033 : pat=
a_via=0A=A0=A0=A0 d040-d047 : 0000:03:00.0=0A=A0=A0=A0=A0=A0 d040-d047 : pa=
ta_via=0A=A0 e000-efff : PCI Bus 0000:01=0A=A0=A0=A0 e000-e07f : 0000:01:00=
.0=0A=A0 f000-f01f : 0000:00:1f.3=0A=A0 f020-f02f : 0000:00:1f.5=0A=A0=A0=
=A0 f020-f02f : ata_piix=0A=A0 f030-f03f : 0000:00:1f.5=0A=A0=A0=A0 f030-f0=
3f : ata_piix=0A=A0 f040-f043 : 0000:00:1f.5=0A=A0=A0=A0 f040-f043 : ata_pi=
ix=0A=A0 f050-f057 : 0000:00:1f.5=0A=A0=A0=A0 f050-f057 : ata_piix=0A=A0 f0=
60-f063 : 0000:00:1f.5=0A=A0=A0=A0 f060-f063 : ata_piix=0A=A0 f070-f077 : 0=
000:00:1f.5=0A=A0=A0=A0 f070-f077 : ata_piix=0A=A0 f080-f08f : 0000:00:1f.2=
=0A=A0=A0=A0 f080-f08f : ata_piix=0A=A0 f090-f09f : 0000:00:1f.2=0A=A0=A0=
=A0 f090-f09f : ata_piix=0A=A0 f0a0-f0a3 : 0000:00:1f.2=0A=A0=A0=A0 f0a0-f0=
a3 : ata_piix=0A=A0 f0b0-f0b7 : 0000:00:1f.2=0A=A0=A0=A0 f0b0-f0b7 : ata_pi=
ix=0A=A0 f0c0-f0c3 : 0000:00:1f.2=0A=A0=A0=A0 f0c0-f0c3 : ata_piix=0A=A0 f0=
d0-f0d7 : 0000:00:1f.2=0A=A0=A0=A0 f0d0-f0d7 : ata_piix=0A=A0 ffff-ffff : p=
np 00:05=0A=A0=A0=A0 ffff-ffff : pnp 00:05=0A=0A=0A00000000-0000ffff : rese=
rved=0A00010000-0009ebff : System RAM=0A0009ec00-0009ffff : reserved=0A000a=
0000-000bffff : PCI Bus 0000:00=0A=A0 000a0000-000bffff : Video RAM area=0A=
000c0000-000c7fff : Video ROM=0A000d0000-000d3fff : PCI Bus 0000:00=0A000d4=
000-000d7fff : PCI Bus 0000:00=0A000d8000-000dbfff : PCI Bus 0000:00=0A000d=
c000-000dffff : PCI Bus 0000:00=0A000e0000-000fffff : reserved=0A=A0 000e00=
00-000e3fff : PCI Bus 0000:00=0A=A0 000e4000-000e7fff : PCI Bus 0000:00=0A=
=A0 000f0000-000fffff : System ROM=0A00100000-de948fff : System RAM=0A=A0 0=
1000000-015af13b : Kernel code=0A=A0 015af13c-0187627f : Kernel data=0A=A0 =
01936000-01a0efff : Kernel bss=0Ade949000-df13bfff : reserved=0Adf13c000-df=
38dfff : ACPI Non-volatile Storage=0Adf38e000-df39bfff : ACPI Tables=0Adf39=
c000-df3bbfff : ACPI Non-volatile Storage=0Adf3bc000-df3c0fff : ACPI Tables=
=0Adf3c1000-df403fff : ACPI Non-volatile Storage=0Adf404000-df7fffff : Syst=
em RAM=0Adf800000-dfffffff : RAM buffer=0Ae0000000-feafffff : PCI Bus 0000:=
00=0A=A0 e0000000-ebffffff : PCI Bus 0000:01=0A=A0=A0=A0 e0000000-e7ffffff =
: 0000:01:00.0=0A=A0=A0=A0 e8000000-ebffffff : 0000:01:00.0=0A=A0=A0=A0=A0=
=A0 e9000000-e94fffff : vesafb=0A=A0 ec100000-ec1fffff : PCI Bus 0000:05=0A=
=A0=A0=A0 ec100000-ec103fff : 0000:05:00.0=0A=A0=A0=A0=A0=A0 ec100000-ec103=
fff : r8169=0A=A0=A0=A0 ec104000-ec104fff : 0000:05:00.0=0A=A0=A0=A0=A0=A0 =
ec104000-ec104fff : r8169=0A=A0 ec200000-ec200fff : pnp 00:0e=0A=A0 f400000=
0-f60fffff : PCI Bus 0000:01=0A=A0=A0=A0 f4000000-f5ffffff : 0000:01:00.0=
=0A=A0=A0=A0=A0=A0 f4000000-f5ffffff : nvidia=0A=A0=A0=A0 f6000000-f607ffff=
 : 0000:01:00.0=0A=A0=A0=A0 f6080000-f6083fff : 0000:01:00.1=0A=A0=A0=A0=A0=
=A0 f6080000-f6083fff : ICH HD audio=0A=A0 f6100000-f61fffff : PCI Bus 0000=
:04=0A=A0=A0=A0 f6100000-f6107fff : 0000:04:00.0=0A=A0=A0=A0=A0=A0 f6100000=
-f6107fff : xhci_hcd=0A=A0 f6200000-f62fffff : PCI Bus 0000:03=0A=A0=A0=A0 =
f6200000-f620ffff : 0000:03:00.0=0A=A0 f6300000-f6303fff : 0000:00:1b.0=0A=
=A0=A0=A0 f6300000-f6303fff : ICH HD audio=0A=A0 f6305000-f63050ff : 0000:0=
0:1f.3=0A=A0 f6306000-f63063ff : 0000:00:1d.0=0A=A0=A0=A0 f6306000-f63063ff=
 : ehci_hcd=0A=A0 f6307000-f63073ff : 0000:00:1a.0=0A=A0=A0=A0 f6307000-f63=
073ff : ehci_hcd=0A=A0 f630a000-f630a00f : 0000:00:16.0=0A=A0=A0=A0 f630a00=
0-f630a00f : mei=0A=A0 f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]=0A=
=A0=A0=A0 f8000000-fbffffff : reserved=0A=A0=A0=A0=A0=A0 f8000000-fbffffff =
: pnp 00:0e=0Afec00000-fec00fff : reserved=0A=A0 fec00000-fec003ff : IOAPIC=
 0=0Afed00000-fed03fff : reserved=0A=A0 fed00000-fed003ff : HPET 0=0Afed100=
00-fed17fff : pnp 00:0e=0Afed18000-fed18fff : pnp 00:0e=0Afed19000-fed19fff=
 : pnp 00:0e=0Afed1c000-fed1ffff : reserved=0A=A0 fed1c000-fed1ffff : pnp 0=
0:0e=0Afed20000-fed3ffff : pnp 00:0e=0Afed40000-fed44fff : pnp 00:01=0Afed4=
5000-fed8ffff : pnp 00:0e=0Afed90000-fed93fff : pnp 00:0e=0Afee00000-fee00f=
ff : Local APIC=0A=A0 fee00000-fee00fff : reserved=0Aff000000-ffffffff : re=
served=0A=A0 ff000000-ffffffff : pnp 00:0e=0A100000000-11effffff : System R=
AM=0A11f000000-11fffffff : RAM buffer=0A=0A[7.5.] PCI information ('lspci -=
vvv' as root) =0A=0ASee the attached file lspci=A0-vvv.txt=0A=0A[7.6.] SCSI=
 information (from /proc/scsi/scsi) =0A=0AAttached devices:=0AHost: scsi0 C=
hannel: 00 Id: 00 Lun: 00=0A=A0 Vendor: ATA=A0=A0=A0=A0=A0 Model: WDC WD500=
0AAKX-0 Rev: 15.0=0A=A0 Type:=A0=A0 Direct-Access=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ANSI=A0 SCSI revision: 05=0AHost: scsi1 C=
hannel: 00 Id: 00 Lun: 00=0A=A0 Vendor: TSSTcorp Model: CDDVDW SH-222AB=A0 =
Rev: SB00=0A=A0 Type:=A0=A0 CD-ROM=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ANSI=A0 SCSI revision: 05=0AHost: s=
csi2 Channel: 00 Id: 00 Lun: 00=0A=A0 Vendor: ATA=A0=A0=A0=A0=A0 Model: ST3=
500410AS=A0=A0=A0=A0=A0 Rev: CC31=0A=A0 Type:=A0=A0 Direct-Access=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ANSI=A0 SCSI revision: 05=
=0AHost: scsi4 Channel: 00 Id: 01 Lun: 00=0A=A0 Vendor: ATA=A0=A0=A0=A0=A0 =
Model: WDC WD1600JB-00R Rev: 20.0=0A=A0 Type:=A0=A0 Direct-Access=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ANSI=A0 SCSI revision: 05=
=0A=0A[7.7.] Other information that might be relevant to the problem (pleas=
e =0Alook in /proc and include all information that you think to be =0Arele=
vant): =0ANA=0A=0A[X.] Other notes, patches, fixes, workarounds:=A0=0ASugge=
sted solution:=0AThe driver for this camera is gspca_pac207 (located at /li=
b/modules/ 2.6.31- 19-generic/ kernel/ drivers/ media/video/ gspca).=0AIn t=
he driver source file pac207.c it can be seen that the bit 1 of the =0Aregi=
ster at 0x41 controls the LED. Looks like it was assumed that '0' at=0A thi=
s bit turns the light off, when actually '1' does that. After I've =0Achang=
ed the value of this register to the opposite, the re-compiled =0Adriver wo=
rks correctly and the LED is on only when the camera is in use.=0AI've atta=
ched the modified pac207.c. The diff of the changed file vs. original is be=
low:=0A272c272 change:=0Apac207_ write_reg( gspca_dev, 0x41, 0x00);=0Ato:=
=0Apac207_ write_reg( gspca_dev, 0x41, 0x02);=0A308c308 change:=0Amode =3D =
0x02; /* Image Format (Bit 0), LED (1), Compr. test mode (2) */=0Ato:=0Amod=
e =3D 0x00; /* Image Format (Bit 0), LED (1), Compr. test mode (2) */=0A331=
c331 change:=0Apac207_ write_reg( gspca_dev, 0x41, 0x00); /* Turn of LED */=
=0Ato:=0Apac207_ write_reg( gspca_dev, 0x41, 0x02); /* Turn off LED */
--1771772517-281753162-1353598043=:25176
Content-Type: text/plain; name="lspci -vvv.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="lspci -vvv.txt"

MDA6MDAuMCBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gMm5kIEdl
bmVyYXRpb24gQ29yZSBQcm9jZXNzb3IgRmFtaWx5IERSQU0gQ29udHJvbGxl
ciAocmV2IDA5KQoJU3Vic3lzdGVtOiBBU1VTVGVLIENvbXB1dGVyIEluYy4g
UDhQNjcgRGVsdXhlIE1vdGhlcmJvYXJkCglDb250cm9sOiBJL08tIE1lbSsg
QnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJF
cnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVz
OiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkIrIFBhckVyci0gREVWU0VMPWZh
c3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydCsgPlNFUlItIDxQRVJSLSBJ
TlR4LQoJTGF0ZW5jeTogMAoJQ2FwYWJpbGl0aWVzOiBbZTBdIFZlbmRvciBT
cGVjaWZpYyBJbmZvcm1hdGlvbjogTGVuPTBjIDw/PgoKMDA6MDEuMCBQQ0kg
YnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiBYZW9uIEUzLTEyMDAvMm5kIEdl
bmVyYXRpb24gQ29yZSBQcm9jZXNzb3IgRmFtaWx5IFBDSSBFeHByZXNzIFJv
b3QgUG9ydCAocmV2IDA5KSAocHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0p
CglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1l
bVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0
QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1B
Ym9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUg
TGluZSBTaXplOiA2NCBieXRlcwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRh
cnk9MDEsIHN1Ym9yZGluYXRlPTAxLCBzZWMtbGF0ZW5jeT0wCglJL08gYmVo
aW5kIGJyaWRnZTogMDAwMGUwMDAtMDAwMGVmZmYKCU1lbW9yeSBiZWhpbmQg
YnJpZGdlOiBmNDAwMDAwMC1mNjBmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9y
eSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGUwMDAwMDAwLTAwMDAwMDAwZWJm
ZmZmZmYKCVNlY29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJF
cnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtIDxT
RVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFyaXR5LSBTRVJSLSBOb0lTQS0g
VkdBKyBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlEaXNjVG1yLSBT
ZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzg4XSBTdWJzeXN0ZW06IEFTVVNUZUsgQ29tcHV0ZXIgSW5j
LiBEZXZpY2UgODQ0ZAoJQ2FwYWJpbGl0aWVzOiBbODBdIFBvd2VyIE1hbmFn
ZW1lbnQgdmVyc2lvbiAzCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDIt
IEF1eEN1cnJlbnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xk
KykKCQlTdGF0dXM6IEQwIE5vU29mdFJzdCsgUE1FLUVuYWJsZS0gRFNlbD0w
IERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogWzkwXSBNU0k6IEVuYWJs
ZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdC0KCQlBZGRyZXNzOiBmZWUw
ZjAwYyAgRGF0YTogNDE2MQoJQ2FwYWJpbGl0aWVzOiBbYTBdIEV4cHJlc3Mg
KHYyKSBSb290IFBvcnQgKFNsb3QrKSwgTVNJIDAwCgkJRGV2Q2FwOglNYXhQ
YXlsb2FkIDEyOCBieXRlcywgUGhhbnRGdW5jIDAsIExhdGVuY3kgTDBzIDw2
NG5zLCBMMSA8MXVzCgkJCUV4dFRhZy0gUkJFKyBGTFJlc2V0LQoJCURldkN0
bDoJUmVwb3J0IGVycm9yczogQ29ycmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0
YWwtIFVuc3VwcG9ydGVkLQoJCQlSbHhkT3JkLSBFeHRUYWctIFBoYW50RnVu
Yy0gQXV4UHdyLSBOb1Nub29wLQoJCQlNYXhQYXlsb2FkIDEyOCBieXRlcywg
TWF4UmVhZFJlcSAxMjggYnl0ZXMKCQlEZXZTdGE6CUNvcnJFcnIrIFVuY29y
ckVyci0gRmF0YWxFcnItIFVuc3VwcFJlcS0gQXV4UHdyLSBUcmFuc1BlbmQt
CgkJTG5rQ2FwOglQb3J0ICMyLCBTcGVlZCA1R1QvcywgV2lkdGggeDE2LCBB
U1BNIEwwcyBMMSwgTGF0ZW5jeSBMMCA8MjU2bnMsIEwxIDw0dXMKCQkJQ2xv
Y2tQTS0gU3VycHJpc2UtIExMQWN0UmVwLSBCd05vdCsKCQlMbmtDdGw6CUFT
UE0gRGlzYWJsZWQ7IFJDQiA2NCBieXRlcyBEaXNhYmxlZC0gUmV0cmFpbi0g
Q29tbUNsaysKCQkJRXh0U3luY2gtIENsb2NrUE0tIEF1dFdpZERpcy0gQldJ
bnQtIEF1dEJXSW50LQoJCUxua1N0YToJU3BlZWQgMi41R1QvcywgV2lkdGgg
eDE2LCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlLSBCV01nbXQr
IEFCV01nbXQtCgkJU2x0Q2FwOglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0
dG5JbmQtIFB3ckluZC0gSG90UGx1Zy0gU3VycHJpc2UtCgkJCVNsb3QgIzEs
IFBvd2VyTGltaXQgNzUuMDAwVzsgSW50ZXJsb2NrLSBOb0NvbXBsKwoJCVNs
dEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JGbHQtIE1STC0gUHJlc0RldC0g
Q21kQ3BsdC0gSFBJcnEtIExpbmtDaGctCgkJCUNvbnRyb2w6IEF0dG5JbmQg
VW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJ
U2x0U3RhOglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENw
bHQtIFByZXNEZXQrIEludGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVz
RGV0LSBMaW5rU3RhdGUtCgkJUm9vdEN0bDogRXJyQ29ycmVjdGFibGUtIEVy
ck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUludEVuYS0gQ1JTVmlzaWJsZS0K
CQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBNRSBSZXFJRCAw
MDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxl
dGlvbiBUaW1lb3V0OiBOb3QgU3VwcG9ydGVkLCBUaW1lb3V0RGlzLSBBUklG
d2QtCgkJRGV2Q3RsMjogQ29tcGxldGlvbiBUaW1lb3V0OiA1MHVzIHRvIDUw
bXMsIFRpbWVvdXREaXMtIEFSSUZ3ZC0KCQlMbmtDdGwyOiBUYXJnZXQgTGlu
ayBTcGVlZDogNUdUL3MsIEVudGVyQ29tcGxpYW5jZS0gU3BlZWREaXMtLCBT
ZWxlY3RhYmxlIERlLWVtcGhhc2lzOiAtMy41ZEIKCQkJIFRyYW5zbWl0IE1h
cmdpbjogTm9ybWFsIE9wZXJhdGluZyBSYW5nZSwgRW50ZXJNb2RpZmllZENv
bXBsaWFuY2UtIENvbXBsaWFuY2VTT1MtCgkJCSBDb21wbGlhbmNlIERlLWVt
cGhhc2lzOiAtNmRCCgkJTG5rU3RhMjogQ3VycmVudCBEZS1lbXBoYXNpcyBM
ZXZlbDogLTZkQgoJQ2FwYWJpbGl0aWVzOiBbMTAwIHYxXSBWaXJ0dWFsIENo
YW5uZWwKCQlDYXBzOglMUEVWQz0wIFJlZkNsaz0xMDBucyBQQVRFbnRyeUJp
dHM9MQoJCUFyYjoJRml4ZWQtIFdSUjMyLSBXUlI2NC0gV1JSMTI4LQoJCUN0
cmw6CUFyYlNlbGVjdD1GaXhlZAoJCVN0YXR1czoJSW5Qcm9ncmVzcy0KCQlW
QzA6CUNhcHM6CVBBVE9mZnNldD0wMCBNYXhUaW1lU2xvdHM9MSBSZWpTbm9v
cFRyYW5zLQoJCQlBcmI6CUZpeGVkKyBXUlIzMi0gV1JSNjQtIFdSUjEyOC0g
VFdSUjEyOC0gV1JSMjU2LQoJCQlDdHJsOglFbmFibGUrIElEPTAgQXJiU2Vs
ZWN0PUZpeGVkIFRDL1ZDPWZmCgkJCVN0YXR1czoJTmVnb1BlbmRpbmctIElu
UHJvZ3Jlc3MtCglDYXBhYmlsaXRpZXM6IFsxNDAgdjFdIFJvb3QgQ29tcGxl
eCBMaW5rCgkJRGVzYzoJUG9ydE51bWJlcj0wMiBDb21wb25lbnRJRD0wMSBF
bHRUeXBlPUNvbmZpZwoJCUxpbmswOglEZXNjOglUYXJnZXRQb3J0PTAwIFRh
cmdldENvbXBvbmVudD0wMSBBc3NvY1JDUkItIExpbmtUeXBlPU1lbU1hcHBl
ZCBMaW5rVmFsaWQrCgkJCUFkZHI6CTAwMDAwMDAwZmVkMTkwMDAKCUtlcm5l
bCBkcml2ZXIgaW4gdXNlOiBwY2llcG9ydAoJS2VybmVsIG1vZHVsZXM6IHNo
cGNocAoKMDA6MTYuMCBDb21tdW5pY2F0aW9uIGNvbnRyb2xsZXI6IEludGVs
IENvcnBvcmF0aW9uIDYgU2VyaWVzL0MyMDAgU2VyaWVzIENoaXBzZXQgRmFt
aWx5IE1FSSBDb250cm9sbGVyICMxIChyZXYgMDQpCglTdWJzeXN0ZW06IEFT
VVNUZUsgQ29tcHV0ZXIgSW5jLiBQOFA2NyBEZWx1eGUgTW90aGVyYm9hcmQK
CUNvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVt
V0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RC
MkItIERpc0lOVHgrCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIy
Qi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFi
b3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJbnRlcnJ1
cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgNDcKCVJlZ2lvbiAwOiBNZW1vcnkg
YXQgZjYzMGEwMDAgKDY0LWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9
MTZdCglDYXBhYmlsaXRpZXM6IFs1MF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJz
aW9uIDMKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVu
dD0wbUEgUE1FKEQwKyxEMS0sRDItLEQzaG90KyxEM2NvbGQrKQoJCVN0YXR1
czogRDAgTm9Tb2Z0UnN0KyBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAg
UE1FLQoJQ2FwYWJpbGl0aWVzOiBbOGNdIE1TSTogRW5hYmxlKyBDb3VudD0x
LzEgTWFza2FibGUtIDY0Yml0KwoJCUFkZHJlc3M6IDAwMDAwMDAwZmVlMGYw
MGMgIERhdGE6IDQxYTEKCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBtZWkKCUtl
cm5lbCBtb2R1bGVzOiBtZWkKCjAwOjFhLjAgVVNCIGNvbnRyb2xsZXI6IElu
dGVsIENvcnBvcmF0aW9uIDYgU2VyaWVzL0MyMDAgU2VyaWVzIENoaXBzZXQg
RmFtaWx5IFVTQiBFbmhhbmNlZCBIb3N0IENvbnRyb2xsZXIgIzIgKHJldiAw
NSkgKHByb2ctaWYgMjAgW0VIQ0ldKQoJU3Vic3lzdGVtOiBBU1VTVGVLIENv
bXB1dGVyIEluYy4gUDhQNjcgRGVsdXhlIE1vdGhlcmJvYXJkCglDb250cm9s
OiBJL08tIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZH
QVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJ
TlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkIrIFBhckVy
ci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+
U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJbnRlcnJ1cHQ6IHBp
biBBIHJvdXRlZCB0byBJUlEgMjMKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgZjYz
MDcwMDAgKDMyLWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9MUtdCglD
YXBhYmlsaXRpZXM6IFs1MF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIK
CQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD0zNzVt
QSBQTUUoRDArLEQxLSxEMi0sRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBE
MCBOb1NvZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUt
CglDYXBhYmlsaXRpZXM6IFs1OF0gRGVidWcgcG9ydDogQkFSPTEgb2Zmc2V0
PTAwYTAKCUNhcGFiaWxpdGllczogWzk4XSBQQ0kgQWR2YW5jZWQgRmVhdHVy
ZXMKCQlBRkNhcDogVFArIEZMUisKCQlBRkN0cmw6IEZMUi0KCQlBRlN0YXR1
czogVFAtCglLZXJuZWwgZHJpdmVyIGluIHVzZTogZWhjaV9oY2QKCjAwOjFi
LjAgQXVkaW8gZGV2aWNlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9D
MjAwIFNlcmllcyBDaGlwc2V0IEZhbWlseSBIaWdoIERlZmluaXRpb24gQXVk
aW8gQ29udHJvbGxlciAocmV2IDA1KQoJU3Vic3lzdGVtOiBBU1VTVGVLIENv
bXB1dGVyIEluYy4gRGV2aWNlIDg0MWIKCUNvbnRyb2w6IEkvTy0gTWVtKyBC
dXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVy
ci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgrCglTdGF0dXM6
IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFz
dCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElO
VHgtCglMYXRlbmN5OiAwLCBDYWNoZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglJ
bnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgNDgKCVJlZ2lvbiAwOiBN
ZW1vcnkgYXQgZjYzMDAwMDAgKDY0LWJpdCwgbm9uLXByZWZldGNoYWJsZSkg
W3NpemU9MTZLXQoJQ2FwYWJpbGl0aWVzOiBbNTBdIFBvd2VyIE1hbmFnZW1l
bnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1
eEN1cnJlbnQ9NTVtQSBQTUUoRDArLEQxLSxEMi0sRDNob3QrLEQzY29sZCsp
CgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBE
U2NhbGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6IFs2MF0gTVNJOiBFbmFibGUr
IENvdW50PTEvMSBNYXNrYWJsZS0gNjRiaXQrCgkJQWRkcmVzczogMDAwMDAw
MDBmZWUwZjAwYyAgRGF0YTogNDFiMQoJQ2FwYWJpbGl0aWVzOiBbNzBdIEV4
cHJlc3MgKHYxKSBSb290IENvbXBsZXggSW50ZWdyYXRlZCBFbmRwb2ludCwg
TVNJIDAwCgkJRGV2Q2FwOglNYXhQYXlsb2FkIDEyOCBieXRlcywgUGhhbnRG
dW5jIDAsIExhdGVuY3kgTDBzIDw2NG5zLCBMMSA8MXVzCgkJCUV4dFRhZy0g
UkJFLSBGTFJlc2V0KwoJCURldkN0bDoJUmVwb3J0IGVycm9yczogQ29ycmVj
dGFibGUtIE5vbi1GYXRhbC0gRmF0YWwtIFVuc3VwcG9ydGVkLQoJCQlSbHhk
T3JkLSBFeHRUYWctIFBoYW50RnVuYy0gQXV4UHdyLSBOb1Nub29wLQoJCQlN
YXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSAxMjggYnl0ZXMKCQlE
ZXZTdGE6CUNvcnJFcnItIFVuY29yckVyci0gRmF0YWxFcnItIFVuc3VwcFJl
cS0gQXV4UHdyKyBUcmFuc1BlbmQtCgkJTG5rQ2FwOglQb3J0ICMwLCBTcGVl
ZCB1bmtub3duLCBXaWR0aCB4MCwgQVNQTSB1bmtub3duLCBMYXRlbmN5IEww
IDw2NG5zLCBMMSA8MXVzCgkJCUNsb2NrUE0tIFN1cnByaXNlLSBMTEFjdFJl
cC0gQndOb3QtCgkJTG5rQ3RsOglBU1BNIERpc2FibGVkOyBEaXNhYmxlZC0g
UmV0cmFpbi0gQ29tbUNsay0KCQkJRXh0U3luY2gtIENsb2NrUE0tIEF1dFdp
ZERpcy0gQldJbnQtIEF1dEJXSW50LQoJCUxua1N0YToJU3BlZWQgdW5rbm93
biwgV2lkdGggeDAsIFRyRXJyLSBUcmFpbi0gU2xvdENsay0gRExBY3RpdmUt
IEJXTWdtdC0gQUJXTWdtdC0KCUNhcGFiaWxpdGllczogWzEwMCB2MV0gVmly
dHVhbCBDaGFubmVsCgkJQ2FwczoJTFBFVkM9MCBSZWZDbGs9MTAwbnMgUEFU
RW50cnlCaXRzPTEKCQlBcmI6CUZpeGVkLSBXUlIzMi0gV1JSNjQtIFdSUjEy
OC0KCQlDdHJsOglBcmJTZWxlY3Q9Rml4ZWQKCQlTdGF0dXM6CUluUHJvZ3Jl
c3MtCgkJVkMwOglDYXBzOglQQVRPZmZzZXQ9MDAgTWF4VGltZVNsb3RzPTEg
UmVqU25vb3BUcmFucy0KCQkJQXJiOglGaXhlZC0gV1JSMzItIFdSUjY0LSBX
UlIxMjgtIFRXUlIxMjgtIFdSUjI1Ni0KCQkJQ3RybDoJRW5hYmxlKyBJRD0w
IEFyYlNlbGVjdD1GaXhlZCBUQy9WQz0wMQoJCQlTdGF0dXM6CU5lZ29QZW5k
aW5nLSBJblByb2dyZXNzLQoJCVZDMToJQ2FwczoJUEFUT2Zmc2V0PTAwIE1h
eFRpbWVTbG90cz0xIFJlalNub29wVHJhbnMtCgkJCUFyYjoJRml4ZWQtIFdS
UjMyLSBXUlI2NC0gV1JSMTI4LSBUV1JSMTI4LSBXUlIyNTYtCgkJCUN0cmw6
CUVuYWJsZSsgSUQ9MSBBcmJTZWxlY3Q9Rml4ZWQgVEMvVkM9MjIKCQkJU3Rh
dHVzOglOZWdvUGVuZGluZy0gSW5Qcm9ncmVzcy0KCUNhcGFiaWxpdGllczog
WzEzMCB2MV0gUm9vdCBDb21wbGV4IExpbmsKCQlEZXNjOglQb3J0TnVtYmVy
PTBmIENvbXBvbmVudElEPTAwIEVsdFR5cGU9Q29uZmlnCgkJTGluazA6CURl
c2M6CVRhcmdldFBvcnQ9MDAgVGFyZ2V0Q29tcG9uZW50PTAwIEFzc29jUkNS
Qi0gTGlua1R5cGU9TWVtTWFwcGVkIExpbmtWYWxpZCsKCQkJQWRkcjoJMDAw
MDAwMDBmZWQxYzAwMAoJS2VybmVsIGRyaXZlciBpbiB1c2U6IHNuZF9oZGFf
aW50ZWwKCUtlcm5lbCBtb2R1bGVzOiBzbmQtaGRhLWludGVsCgowMDoxYy4w
IFBDSSBicmlkZ2U6IEludGVsIENvcnBvcmF0aW9uIDYgU2VyaWVzL0MyMDAg
U2VyaWVzIENoaXBzZXQgRmFtaWx5IFBDSSBFeHByZXNzIFJvb3QgUG9ydCAx
IChyZXYgYjUpIChwcm9nLWlmIDAwIFtOb3JtYWwgZGVjb2RlXSkKCUNvbnRy
b2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0g
VkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERp
c0lOVHgtCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFy
RXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+
U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwLCBDYWNoZSBMaW5lIFNp
emU6IDY0IGJ5dGVzCglCdXM6IHByaW1hcnk9MDAsIHNlY29uZGFyeT0wMiwg
c3Vib3JkaW5hdGU9MDIsIHNlYy1sYXRlbmN5PTAKCUkvTyBiZWhpbmQgYnJp
ZGdlOiAwMDAwZjAwMC0wMDAwMGZmZgoJTWVtb3J5IGJlaGluZCBicmlkZ2U6
IGZmZjAwMDAwLTAwMGZmZmZmCglQcmVmZXRjaGFibGUgbWVtb3J5IGJlaGlu
ZCBicmlkZ2U6IDAwMDAwMDAwZmZmMDAwMDAtMDAwMDAwMDAwMDBmZmZmZgoJ
U2Vjb25kYXJ5IHN0YXR1czogNjZNSHotIEZhc3RCMkItIFBhckVyci0gREVW
U0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydCsgPFNFUlItIDxQ
RVJSLQoJQnJpZGdlQ3RsOiBQYXJpdHktIFNFUlItIE5vSVNBLSBWR0EtIE1B
Ym9ydC0gPlJlc2V0LSBGYXN0QjJCLQoJCVByaURpc2NUbXItIFNlY0Rpc2NU
bXItIERpc2NUbXJTdGF0LSBEaXNjVG1yU0VSUkVuLQoJQ2FwYWJpbGl0aWVz
OiBbNDBdIEV4cHJlc3MgKHYyKSBSb290IFBvcnQgKFNsb3QrKSwgTVNJIDAw
CgkJRGV2Q2FwOglNYXhQYXlsb2FkIDEyOCBieXRlcywgUGhhbnRGdW5jIDAs
IExhdGVuY3kgTDBzIDw2NG5zLCBMMSA8MXVzCgkJCUV4dFRhZy0gUkJFKyBG
TFJlc2V0LQoJCURldkN0bDoJUmVwb3J0IGVycm9yczogQ29ycmVjdGFibGUt
IE5vbi1GYXRhbC0gRmF0YWwtIFVuc3VwcG9ydGVkLQoJCQlSbHhkT3JkLSBF
eHRUYWctIFBoYW50RnVuYy0gQXV4UHdyLSBOb1Nub29wLQoJCQlNYXhQYXls
b2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSAxMjggYnl0ZXMKCQlEZXZTdGE6
CUNvcnJFcnItIFVuY29yckVyci0gRmF0YWxFcnItIFVuc3VwcFJlcS0gQXV4
UHdyKyBUcmFuc1BlbmQtCgkJTG5rQ2FwOglQb3J0ICMxLCBTcGVlZCA1R1Qv
cywgV2lkdGggeDQsIEFTUE0gTDBzIEwxLCBMYXRlbmN5IEwwIDwxdXMsIEwx
IDw0dXMKCQkJQ2xvY2tQTS0gU3VycHJpc2UtIExMQWN0UmVwKyBCd05vdC0K
CQlMbmtDdGw6CUFTUE0gRGlzYWJsZWQ7IFJDQiA2NCBieXRlcyBEaXNhYmxl
ZC0gUmV0cmFpbi0gQ29tbUNsay0KCQkJRXh0U3luY2gtIENsb2NrUE0tIEF1
dFdpZERpcy0gQldJbnQtIEF1dEJXSW50LQoJCUxua1N0YToJU3BlZWQgMi41
R1QvcywgV2lkdGggeDAsIFRyRXJyLSBUcmFpbi0gU2xvdENsaysgRExBY3Rp
dmUtIEJXTWdtdC0gQUJXTWdtdC0KCQlTbHRDYXA6CUF0dG5CdG4tIFB3ckN0
cmwtIE1STC0gQXR0bkluZC0gUHdySW5kLSBIb3RQbHVnLSBTdXJwcmlzZS0K
CQkJU2xvdCAjMCwgUG93ZXJMaW1pdCAyNS4wMDBXOyBJbnRlcmxvY2stIE5v
Q29tcGwrCgkJU2x0Q3RsOglFbmFibGU6IEF0dG5CdG4tIFB3ckZsdC0gTVJM
LSBQcmVzRGV0LSBDbWRDcGx0LSBIUElycS0gTGlua0NoZy0KCQkJQ29udHJv
bDogQXR0bkluZCBVbmtub3duLCBQd3JJbmQgVW5rbm93biwgUG93ZXItIElu
dGVybG9jay0KCQlTbHRTdGE6CVN0YXR1czogQXR0bkJ0bi0gUG93ZXJGbHQt
IE1STC0gQ21kQ3BsdC0gUHJlc0RldC0gSW50ZXJsb2NrLQoJCQlDaGFuZ2Vk
OiBNUkwtIFByZXNEZXQtIExpbmtTdGF0ZS0KCQlSb290Q3RsOiBFcnJDb3Jy
ZWN0YWJsZS0gRXJyTm9uLUZhdGFsLSBFcnJGYXRhbC0gUE1FSW50RW5hLSBD
UlNWaXNpYmxlLQoJCVJvb3RDYXA6IENSU1Zpc2libGUtCgkJUm9vdFN0YTog
UE1FIFJlcUlEIDAwMDAsIFBNRVN0YXR1cy0gUE1FUGVuZGluZy0KCQlEZXZD
YXAyOiBDb21wbGV0aW9uIFRpbWVvdXQ6IFJhbmdlIEJDLCBUaW1lb3V0RGlz
KyBBUklGd2QtCgkJRGV2Q3RsMjogQ29tcGxldGlvbiBUaW1lb3V0OiA1MHVz
IHRvIDUwbXMsIFRpbWVvdXREaXMtIEFSSUZ3ZC0KCQlMbmtDdGwyOiBUYXJn
ZXQgTGluayBTcGVlZDogMi41R1QvcywgRW50ZXJDb21wbGlhbmNlLSBTcGVl
ZERpcy0sIFNlbGVjdGFibGUgRGUtZW1waGFzaXM6IC02ZEIKCQkJIFRyYW5z
bWl0IE1hcmdpbjogTm9ybWFsIE9wZXJhdGluZyBSYW5nZSwgRW50ZXJNb2Rp
ZmllZENvbXBsaWFuY2UtIENvbXBsaWFuY2VTT1MtCgkJCSBDb21wbGlhbmNl
IERlLWVtcGhhc2lzOiAtNmRCCgkJTG5rU3RhMjogQ3VycmVudCBEZS1lbXBo
YXNpcyBMZXZlbDogLTMuNWRCCglDYXBhYmlsaXRpZXM6IFs4MF0gTVNJOiBF
bmFibGUtIENvdW50PTEvMSBNYXNrYWJsZS0gNjRiaXQtCgkJQWRkcmVzczog
MDAwMDAwMDAgIERhdGE6IDAwMDAKCUNhcGFiaWxpdGllczogWzkwXSBTdWJz
eXN0ZW06IEFTVVNUZUsgQ29tcHV0ZXIgSW5jLiBEZXZpY2UgODQ0ZAoJQ2Fw
YWJpbGl0aWVzOiBbYTBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJ
RmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBN
RShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5v
U29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUtl
cm5lbCBkcml2ZXIgaW4gdXNlOiBwY2llcG9ydAoJS2VybmVsIG1vZHVsZXM6
IHNocGNocAoKMDA6MWMuNCBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlv
biA2IFNlcmllcy9DMjAwIFNlcmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhw
cmVzcyBSb290IFBvcnQgNSAocmV2IGI1KSAocHJvZy1pZiAwMCBbTm9ybWFs
IGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVj
Q3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBV
REYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRB
Ym9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTog
MCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRlcwoJQnVzOiBwcmltYXJ5PTAw
LCBzZWNvbmRhcnk9MDMsIHN1Ym9yZGluYXRlPTAzLCBzZWMtbGF0ZW5jeT0w
CglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGQwMDAtMDAwMGRmZmYKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBmNjIwMDAwMC1mNjJmZmZmZgoJUHJlZmV0Y2hh
YmxlIG1lbW9yeSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGZmZjAwMDAwLTAw
MDAwMDAwMDAwZmZmZmYKCVNlY29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0
QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxN
QWJvcnQtIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFyaXR5LSBTRVJS
LSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJF
bi0KCUNhcGFiaWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0
IChTbG90KyksIE1TSSAwMAoJCURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0
ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEwwcyA8NjRucywgTDEgPDF1cwoJ
CQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJlcG9ydCBlcnJv
cnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9T
bm9vcC0KCQkJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4
IGJ5dGVzCgkJRGV2U3RhOglDb3JyRXJyLSBVbmNvcnJFcnItIEZhdGFsRXJy
LSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQZW5kLQoJCUxua0NhcDoJUG9y
dCAjNSwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEwwcyBMMSwgTGF0
ZW5jeSBMMCA8MXVzLCBMMSA8NHVzCgkJCUNsb2NrUE0tIFN1cnByaXNlLSBM
TEFjdFJlcCsgQndOb3QtCgkJTG5rQ3RsOglBU1BNIERpc2FibGVkOyBSQ0Ig
NjQgYnl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGstCgkJCUV4dFN5
bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlM
bmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4t
IFNsb3RDbGsrIERMQWN0aXZlKyBCV01nbXQrIEFCV01nbXQtCgkJU2x0Q2Fw
OglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3ckluZC0gSG90
UGx1Zy0gU3VycHJpc2UtCgkJCVNsb3QgIzQsIFBvd2VyTGltaXQgMTAuMDAw
VzsgSW50ZXJsb2NrLSBOb0NvbXBsKwoJCVNsdEN0bDoJRW5hYmxlOiBBdHRu
QnRuLSBQd3JGbHQtIE1STC0gUHJlc0RldC0gQ21kQ3BsdC0gSFBJcnEtIExp
bmtDaGctCgkJCUNvbnRyb2w6IEF0dG5JbmQgVW5rbm93biwgUHdySW5kIFVu
a25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJU2x0U3RhOglTdGF0dXM6IEF0
dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNEZXQrIEludGVy
bG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0LSBMaW5rU3RhdGUtCgkJ
Um9vdEN0bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0
YWwtIFBNRUludEVuYS0gQ1JTVmlzaWJsZS0KCQlSb290Q2FwOiBDUlNWaXNp
YmxlLQoJCVJvb3RTdGE6IFBNRSBSZXFJRCAwMDAwLCBQTUVTdGF0dXMtIFBN
RVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxldGlvbiBUaW1lb3V0OiBSYW5n
ZSBCQywgVGltZW91dERpcysgQVJJRndkLQoJCURldkN0bDI6IENvbXBsZXRp
b24gVGltZW91dDogNTB1cyB0byA1MG1zLCBUaW1lb3V0RGlzLSBBUklGd2Qt
CgkJTG5rQ3RsMjogVGFyZ2V0IExpbmsgU3BlZWQ6IDVHVC9zLCBFbnRlckNv
bXBsaWFuY2UtIFNwZWVkRGlzLSwgU2VsZWN0YWJsZSBEZS1lbXBoYXNpczog
LTZkQgoJCQkgVHJhbnNtaXQgTWFyZ2luOiBOb3JtYWwgT3BlcmF0aW5nIFJh
bmdlLCBFbnRlck1vZGlmaWVkQ29tcGxpYW5jZS0gQ29tcGxpYW5jZVNPUy0K
CQkJIENvbXBsaWFuY2UgRGUtZW1waGFzaXM6IC02ZEIKCQlMbmtTdGEyOiBD
dXJyZW50IERlLWVtcGhhc2lzIExldmVsOiAtMy41ZEIKCUNhcGFiaWxpdGll
czogWzgwXSBNU0k6IEVuYWJsZS0gQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJp
dC0KCQlBZGRyZXNzOiAwMDAwMDAwMCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0
aWVzOiBbOTBdIFN1YnN5c3RlbTogQVNVU1RlSyBDb21wdXRlciBJbmMuIERl
dmljZSA4NDRkCglDYXBhYmlsaXRpZXM6IFthMF0gUG93ZXIgTWFuYWdlbWVu
dCB2ZXJzaW9uIDIKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4
Q3VycmVudD0wbUEgUE1FKEQwKyxEMS0sRDItLEQzaG90KyxEM2NvbGQrKQoJ
CVN0YXR1czogRDAgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2VsPTAgRFNj
YWxlPTAgUE1FLQoJS2VybmVsIGRyaXZlciBpbiB1c2U6IHBjaWVwb3J0CglL
ZXJuZWwgbW9kdWxlczogc2hwY2hwCgowMDoxYy41IFBDSSBicmlkZ2U6IElu
dGVsIENvcnBvcmF0aW9uIDYgU2VyaWVzL0MyMDAgU2VyaWVzIENoaXBzZXQg
RmFtaWx5IFBDSSBFeHByZXNzIFJvb3QgUG9ydCA2IChyZXYgYjUpIChwcm9n
LWlmIDAwIFtOb3JtYWwgZGVjb2RlXSkKCUNvbnRyb2w6IEkvTysgTWVtKyBC
dXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVy
ci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6
IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFz
dCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElO
VHgtCglMYXRlbmN5OiAwLCBDYWNoZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglC
dXM6IHByaW1hcnk9MDAsIHNlY29uZGFyeT0wNCwgc3Vib3JkaW5hdGU9MDQs
IHNlYy1sYXRlbmN5PTAKCUkvTyBiZWhpbmQgYnJpZGdlOiAwMDAwZjAwMC0w
MDAwMGZmZgoJTWVtb3J5IGJlaGluZCBicmlkZ2U6IGY2MTAwMDAwLWY2MWZm
ZmZmCglQcmVmZXRjaGFibGUgbWVtb3J5IGJlaGluZCBicmlkZ2U6IDAwMDAw
MDAwZmZmMDAwMDAtMDAwMDAwMDAwMDBmZmZmZgoJU2Vjb25kYXJ5IHN0YXR1
czogNjZNSHotIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9y
dC0gPFRBYm9ydC0gPE1BYm9ydC0gPFNFUlItIDxQRVJSLQoJQnJpZGdlQ3Rs
OiBQYXJpdHktIFNFUlItIE5vSVNBLSBWR0EtIE1BYm9ydC0gPlJlc2V0LSBG
YXN0QjJCLQoJCVByaURpc2NUbXItIFNlY0Rpc2NUbXItIERpc2NUbXJTdGF0
LSBEaXNjVG1yU0VSUkVuLQoJQ2FwYWJpbGl0aWVzOiBbNDBdIEV4cHJlc3Mg
KHYyKSBSb290IFBvcnQgKFNsb3QrKSwgTVNJIDAwCgkJRGV2Q2FwOglNYXhQ
YXlsb2FkIDEyOCBieXRlcywgUGhhbnRGdW5jIDAsIExhdGVuY3kgTDBzIDw2
NG5zLCBMMSA8MXVzCgkJCUV4dFRhZy0gUkJFKyBGTFJlc2V0LQoJCURldkN0
bDoJUmVwb3J0IGVycm9yczogQ29ycmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0
YWwtIFVuc3VwcG9ydGVkLQoJCQlSbHhkT3JkLSBFeHRUYWctIFBoYW50RnVu
Yy0gQXV4UHdyLSBOb1Nub29wLQoJCQlNYXhQYXlsb2FkIDEyOCBieXRlcywg
TWF4UmVhZFJlcSAxMjggYnl0ZXMKCQlEZXZTdGE6CUNvcnJFcnItIFVuY29y
ckVyci0gRmF0YWxFcnItIFVuc3VwcFJlcS0gQXV4UHdyKyBUcmFuc1BlbmQt
CgkJTG5rQ2FwOglQb3J0ICM2LCBTcGVlZCA1R1QvcywgV2lkdGggeDEsIEFT
UE0gTDBzIEwxLCBMYXRlbmN5IEwwIDw1MTJucywgTDEgPDR1cwoJCQlDbG9j
a1BNLSBTdXJwcmlzZS0gTExBY3RSZXArIEJ3Tm90LQoJCUxua0N0bDoJQVNQ
TSBEaXNhYmxlZDsgUkNCIDY0IGJ5dGVzIERpc2FibGVkLSBSZXRyYWluLSBD
b21tQ2xrKwoJCQlFeHRTeW5jaC0gQ2xvY2tQTS0gQXV0V2lkRGlzLSBCV0lu
dC0gQXV0QldJbnQtCgkJTG5rU3RhOglTcGVlZCA1R1QvcywgV2lkdGggeDEs
IFRyRXJyLSBUcmFpbi0gU2xvdENsaysgRExBY3RpdmUrIEJXTWdtdCsgQUJX
TWdtdC0KCQlTbHRDYXA6CUF0dG5CdG4tIFB3ckN0cmwtIE1STC0gQXR0bklu
ZC0gUHdySW5kLSBIb3RQbHVnLSBTdXJwcmlzZS0KCQkJU2xvdCAjNSwgUG93
ZXJMaW1pdCAxMC4wMDBXOyBJbnRlcmxvY2stIE5vQ29tcGwrCgkJU2x0Q3Rs
OglFbmFibGU6IEF0dG5CdG4tIFB3ckZsdC0gTVJMLSBQcmVzRGV0LSBDbWRD
cGx0LSBIUElycS0gTGlua0NoZy0KCQkJQ29udHJvbDogQXR0bkluZCBVbmtu
b3duLCBQd3JJbmQgVW5rbm93biwgUG93ZXItIEludGVybG9jay0KCQlTbHRT
dGE6CVN0YXR1czogQXR0bkJ0bi0gUG93ZXJGbHQtIE1STC0gQ21kQ3BsdC0g
UHJlc0RldCsgSW50ZXJsb2NrLQoJCQlDaGFuZ2VkOiBNUkwtIFByZXNEZXQt
IExpbmtTdGF0ZS0KCQlSb290Q3RsOiBFcnJDb3JyZWN0YWJsZS0gRXJyTm9u
LUZhdGFsLSBFcnJGYXRhbC0gUE1FSW50RW5hLSBDUlNWaXNpYmxlLQoJCVJv
b3RDYXA6IENSU1Zpc2libGUtCgkJUm9vdFN0YTogUE1FIFJlcUlEIDAwMDAs
IFBNRVN0YXR1cy0gUE1FUGVuZGluZy0KCQlEZXZDYXAyOiBDb21wbGV0aW9u
IFRpbWVvdXQ6IFJhbmdlIEJDLCBUaW1lb3V0RGlzKyBBUklGd2QtCgkJRGV2
Q3RsMjogQ29tcGxldGlvbiBUaW1lb3V0OiA1MHVzIHRvIDUwbXMsIFRpbWVv
dXREaXMtIEFSSUZ3ZC0KCQlMbmtDdGwyOiBUYXJnZXQgTGluayBTcGVlZDog
NUdUL3MsIEVudGVyQ29tcGxpYW5jZS0gU3BlZWREaXMtLCBTZWxlY3RhYmxl
IERlLWVtcGhhc2lzOiAtNmRCCgkJCSBUcmFuc21pdCBNYXJnaW46IE5vcm1h
bCBPcGVyYXRpbmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlhbmNlLSBD
b21wbGlhbmNlU09TLQoJCQkgQ29tcGxpYW5jZSBEZS1lbXBoYXNpczogLTZk
QgoJCUxua1N0YTI6IEN1cnJlbnQgRGUtZW1waGFzaXMgTGV2ZWw6IC02ZEIK
CUNhcGFiaWxpdGllczogWzgwXSBNU0k6IEVuYWJsZS0gQ291bnQ9MS8xIE1h
c2thYmxlLSA2NGJpdC0KCQlBZGRyZXNzOiAwMDAwMDAwMCAgRGF0YTogMDAw
MAoJQ2FwYWJpbGl0aWVzOiBbOTBdIFN1YnN5c3RlbTogQVNVU1RlSyBDb21w
dXRlciBJbmMuIERldmljZSA4NDRkCglDYXBhYmlsaXRpZXM6IFthMF0gUG93
ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIKCQlGbGFnczogUE1FQ2xrLSBEU0kt
IEQxLSBEMi0gQXV4Q3VycmVudD0wbUEgUE1FKEQwKyxEMS0sRDItLEQzaG90
KyxEM2NvbGQrKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxl
LSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJS2VybmVsIGRyaXZlciBpbiB1c2U6
IHBjaWVwb3J0CglLZXJuZWwgbW9kdWxlczogc2hwY2hwCgowMDoxYy42IFBD
SSBicmlkZ2U6IEludGVsIENvcnBvcmF0aW9uIDYgU2VyaWVzL0MyMDAgU2Vy
aWVzIENoaXBzZXQgRmFtaWx5IFBDSSBFeHByZXNzIFJvb3QgUG9ydCA3IChy
ZXYgYjUpIChwcm9nLWlmIDAwIFtOb3JtYWwgZGVjb2RlXSkKCUNvbnRyb2w6
IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdB
U25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lO
VHgtCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJy
LSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VS
Ui0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwLCBDYWNoZSBMaW5lIFNpemU6
IDY0IGJ5dGVzCglCdXM6IHByaW1hcnk9MDAsIHNlY29uZGFyeT0wNSwgc3Vi
b3JkaW5hdGU9MDUsIHNlYy1sYXRlbmN5PTAKCUkvTyBiZWhpbmQgYnJpZGdl
OiAwMDAwYzAwMC0wMDAwY2ZmZgoJTWVtb3J5IGJlaGluZCBicmlkZ2U6IGZm
ZjAwMDAwLTAwMGZmZmZmCglQcmVmZXRjaGFibGUgbWVtb3J5IGJlaGluZCBi
cmlkZ2U6IDAwMDAwMDAwZWMxMDAwMDAtMDAwMDAwMDBlYzFmZmZmZgoJU2Vj
b25kYXJ5IHN0YXR1czogNjZNSHotIEZhc3RCMkItIFBhckVyci0gREVWU0VM
PWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPFNFUlItIDxQRVJS
LQoJQnJpZGdlQ3RsOiBQYXJpdHktIFNFUlItIE5vSVNBLSBWR0EtIE1BYm9y
dC0gPlJlc2V0LSBGYXN0QjJCLQoJCVByaURpc2NUbXItIFNlY0Rpc2NUbXIt
IERpc2NUbXJTdGF0LSBEaXNjVG1yU0VSUkVuLQoJQ2FwYWJpbGl0aWVzOiBb
NDBdIEV4cHJlc3MgKHYyKSBSb290IFBvcnQgKFNsb3QrKSwgTVNJIDAwCgkJ
RGV2Q2FwOglNYXhQYXlsb2FkIDEyOCBieXRlcywgUGhhbnRGdW5jIDAsIExh
dGVuY3kgTDBzIDw2NG5zLCBMMSA8MXVzCgkJCUV4dFRhZy0gUkJFKyBGTFJl
c2V0LQoJCURldkN0bDoJUmVwb3J0IGVycm9yczogQ29ycmVjdGFibGUtIE5v
bi1GYXRhbC0gRmF0YWwtIFVuc3VwcG9ydGVkLQoJCQlSbHhkT3JkLSBFeHRU
YWctIFBoYW50RnVuYy0gQXV4UHdyLSBOb1Nub29wLQoJCQlNYXhQYXlsb2Fk
IDEyOCBieXRlcywgTWF4UmVhZFJlcSAxMjggYnl0ZXMKCQlEZXZTdGE6CUNv
cnJFcnItIFVuY29yckVyci0gRmF0YWxFcnItIFVuc3VwcFJlcS0gQXV4UHdy
KyBUcmFuc1BlbmQtCgkJTG5rQ2FwOglQb3J0ICM3LCBTcGVlZCA1R1Qvcywg
V2lkdGggeDEsIEFTUE0gTDBzIEwxLCBMYXRlbmN5IEwwIDw1MTJucywgTDEg
PDR1cwoJCQlDbG9ja1BNLSBTdXJwcmlzZS0gTExBY3RSZXArIEJ3Tm90LQoJ
CUxua0N0bDoJQVNQTSBEaXNhYmxlZDsgUkNCIDY0IGJ5dGVzIERpc2FibGVk
LSBSZXRyYWluLSBDb21tQ2xrKwoJCQlFeHRTeW5jaC0gQ2xvY2tQTS0gQXV0
V2lkRGlzLSBCV0ludC0gQXV0QldJbnQtCgkJTG5rU3RhOglTcGVlZCAyLjVH
VC9zLCBXaWR0aCB4MSwgVHJFcnItIFRyYWluLSBTbG90Q2xrKyBETEFjdGl2
ZSsgQldNZ210KyBBQldNZ210LQoJCVNsdENhcDoJQXR0bkJ0bi0gUHdyQ3Ry
bC0gTVJMLSBBdHRuSW5kLSBQd3JJbmQtIEhvdFBsdWctIFN1cnByaXNlLQoJ
CQlTbG90ICM2LCBQb3dlckxpbWl0IDEwLjAwMFc7IEludGVybG9jay0gTm9D
b21wbCsKCQlTbHRDdGw6CUVuYWJsZTogQXR0bkJ0bi0gUHdyRmx0LSBNUkwt
IFByZXNEZXQtIENtZENwbHQtIEhQSXJxLSBMaW5rQ2hnLQoJCQlDb250cm9s
OiBBdHRuSW5kIFVua25vd24sIFB3ckluZCBVbmtub3duLCBQb3dlci0gSW50
ZXJsb2NrLQoJCVNsdFN0YToJU3RhdHVzOiBBdHRuQnRuLSBQb3dlckZsdC0g
TVJMLSBDbWRDcGx0LSBQcmVzRGV0KyBJbnRlcmxvY2stCgkJCUNoYW5nZWQ6
IE1STC0gUHJlc0RldC0gTGlua1N0YXRlLQoJCVJvb3RDdGw6IEVyckNvcnJl
Y3RhYmxlLSBFcnJOb24tRmF0YWwtIEVyckZhdGFsLSBQTUVJbnRFbmEtIENS
U1Zpc2libGUtCgkJUm9vdENhcDogQ1JTVmlzaWJsZS0KCQlSb290U3RhOiBQ
TUUgUmVxSUQgMDAwMCwgUE1FU3RhdHVzLSBQTUVQZW5kaW5nLQoJCURldkNh
cDI6IENvbXBsZXRpb24gVGltZW91dDogUmFuZ2UgQkMsIFRpbWVvdXREaXMr
IEFSSUZ3ZC0KCQlEZXZDdGwyOiBDb21wbGV0aW9uIFRpbWVvdXQ6IDUwdXMg
dG8gNTBtcywgVGltZW91dERpcy0gQVJJRndkLQoJCUxua0N0bDI6IFRhcmdl
dCBMaW5rIFNwZWVkOiA1R1QvcywgRW50ZXJDb21wbGlhbmNlLSBTcGVlZERp
cy0sIFNlbGVjdGFibGUgRGUtZW1waGFzaXM6IC02ZEIKCQkJIFRyYW5zbWl0
IE1hcmdpbjogTm9ybWFsIE9wZXJhdGluZyBSYW5nZSwgRW50ZXJNb2RpZmll
ZENvbXBsaWFuY2UtIENvbXBsaWFuY2VTT1MtCgkJCSBDb21wbGlhbmNlIERl
LWVtcGhhc2lzOiAtNmRCCgkJTG5rU3RhMjogQ3VycmVudCBEZS1lbXBoYXNp
cyBMZXZlbDogLTMuNWRCCglDYXBhYmlsaXRpZXM6IFs4MF0gTVNJOiBFbmFi
bGUtIENvdW50PTEvMSBNYXNrYWJsZS0gNjRiaXQtCgkJQWRkcmVzczogMDAw
MDAwMDAgIERhdGE6IDAwMDAKCUNhcGFiaWxpdGllczogWzkwXSBTdWJzeXN0
ZW06IEFTVVNUZUsgQ29tcHV0ZXIgSW5jLiBEZXZpY2UgODQ0ZAoJQ2FwYWJp
bGl0aWVzOiBbYTBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxh
Z3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShE
MCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5vU29m
dFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUtlcm5l
bCBkcml2ZXIgaW4gdXNlOiBwY2llcG9ydAoJS2VybmVsIG1vZHVsZXM6IHNo
cGNocAoKMDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA4
MjgwMSBQQ0kgQnJpZGdlIChyZXYgYjUpIChwcm9nLWlmIDAxIFtTdWJ0cmFj
dGl2ZSBkZWNvZGVdKQoJQ29udHJvbDogSS9PKyBNZW0rIEJ1c01hc3Rlcisg
U3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGlu
Zy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1I
ei0gVURGLSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQt
IDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVu
Y3k6IDAsIENhY2hlIExpbmUgU2l6ZTogNjQgYnl0ZXMKCUJ1czogcHJpbWFy
eT0wMCwgc2Vjb25kYXJ5PTA2LCBzdWJvcmRpbmF0ZT0wNywgc2VjLWxhdGVu
Y3k9MAoJSS9PIGJlaGluZCBicmlkZ2U6IDAwMDBmMDAwLTAwMDAwZmZmCglN
ZW1vcnkgYmVoaW5kIGJyaWRnZTogZmZmMDAwMDAtMDAwZmZmZmYKCVByZWZl
dGNoYWJsZSBtZW1vcnkgYmVoaW5kIGJyaWRnZTogMDAwMDAwMDBmZmYwMDAw
MC0wMDAwMDAwMDAwMGZmZmZmCglTZWNvbmRhcnkgc3RhdHVzOiA2Nk1Iei0g
RmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0
LSA8TUFib3J0KyA8U0VSUi0gPFBFUlItCglCcmlkZ2VDdGw6IFBhcml0eS0g
U0VSUi0gTm9JU0EtIFZHQS0gTUFib3J0LSA+UmVzZXQtIEZhc3RCMkItCgkJ
UHJpRGlzY1Rtci0gU2VjRGlzY1Rtci0gRGlzY1RtclN0YXQtIERpc2NUbXJT
RVJSRW4tCglDYXBhYmlsaXRpZXM6IFs0MF0gRXhwcmVzcyAodjIpIFJvb3Qg
UG9ydCAoU2xvdCspLCBNU0kgMDAKCQlEZXZDYXA6CU1heFBheWxvYWQgMTI4
IGJ5dGVzLCBQaGFudEZ1bmMgMCwgTGF0ZW5jeSBMMHMgPDY0bnMsIEwxIDwx
dXMKCQkJRXh0VGFnLSBSQkUrIEZMUmVzZXQtCgkJRGV2Q3RsOglSZXBvcnQg
ZXJyb3JzOiBDb3JyZWN0YWJsZS0gTm9uLUZhdGFsLSBGYXRhbC0gVW5zdXBw
b3J0ZWQtCgkJCVJseGRPcmQtIEV4dFRhZy0gUGhhbnRGdW5jLSBBdXhQd3It
IE5vU25vb3AtCgkJCU1heFBheWxvYWQgMTI4IGJ5dGVzLCBNYXhSZWFkUmVx
IDEyOCBieXRlcwoJCURldlN0YToJQ29yckVyci0gVW5jb3JyRXJyLSBGYXRh
bEVyci0gVW5zdXBwUmVxLSBBdXhQd3IrIFRyYW5zUGVuZC0KCQlMbmtDYXA6
CVBvcnQgIzgsIFNwZWVkIDVHVC9zLCBXaWR0aCB4MSwgQVNQTSBMMHMgTDEs
IExhdGVuY3kgTDAgPDF1cywgTDEgPDR1cwoJCQlDbG9ja1BNLSBTdXJwcmlz
ZS0gTExBY3RSZXArIEJ3Tm90LQoJCUxua0N0bDoJQVNQTSBEaXNhYmxlZDsg
UkNCIDY0IGJ5dGVzIERpc2FibGVkLSBSZXRyYWluLSBDb21tQ2xrLQoJCQlF
eHRTeW5jaC0gQ2xvY2tQTS0gQXV0V2lkRGlzLSBCV0ludC0gQXV0QldJbnQt
CgkJTG5rU3RhOglTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgVHJFcnItIFRy
YWluLSBTbG90Q2xrKyBETEFjdGl2ZSsgQldNZ210LSBBQldNZ210LQoJCVNs
dENhcDoJQXR0bkJ0bi0gUHdyQ3RybC0gTVJMLSBBdHRuSW5kLSBQd3JJbmQt
IEhvdFBsdWctIFN1cnByaXNlLQoJCQlTbG90ICM3LCBQb3dlckxpbWl0IDEw
LjAwMFc7IEludGVybG9jay0gTm9Db21wbCsKCQlTbHRDdGw6CUVuYWJsZTog
QXR0bkJ0bi0gUHdyRmx0LSBNUkwtIFByZXNEZXQtIENtZENwbHQtIEhQSXJx
LSBMaW5rQ2hnLQoJCQlDb250cm9sOiBBdHRuSW5kIFVua25vd24sIFB3cklu
ZCBVbmtub3duLCBQb3dlci0gSW50ZXJsb2NrLQoJCVNsdFN0YToJU3RhdHVz
OiBBdHRuQnRuLSBQb3dlckZsdC0gTVJMLSBDbWRDcGx0LSBQcmVzRGV0KyBJ
bnRlcmxvY2stCgkJCUNoYW5nZWQ6IE1STC0gUHJlc0RldC0gTGlua1N0YXRl
LQoJCVJvb3RDdGw6IEVyckNvcnJlY3RhYmxlLSBFcnJOb24tRmF0YWwtIEVy
ckZhdGFsLSBQTUVJbnRFbmEtIENSU1Zpc2libGUtCgkJUm9vdENhcDogQ1JT
VmlzaWJsZS0KCQlSb290U3RhOiBQTUUgUmVxSUQgMDAwMCwgUE1FU3RhdHVz
LSBQTUVQZW5kaW5nLQoJCURldkNhcDI6IENvbXBsZXRpb24gVGltZW91dDog
UmFuZ2UgQkMsIFRpbWVvdXREaXMrIEFSSUZ3ZC0KCQlEZXZDdGwyOiBDb21w
bGV0aW9uIFRpbWVvdXQ6IDUwdXMgdG8gNTBtcywgVGltZW91dERpcy0gQVJJ
RndkLQoJCUxua0N0bDI6IFRhcmdldCBMaW5rIFNwZWVkOiA1R1QvcywgRW50
ZXJDb21wbGlhbmNlLSBTcGVlZERpcy0sIFNlbGVjdGFibGUgRGUtZW1waGFz
aXM6IC02ZEIKCQkJIFRyYW5zbWl0IE1hcmdpbjogTm9ybWFsIE9wZXJhdGlu
ZyBSYW5nZSwgRW50ZXJNb2RpZmllZENvbXBsaWFuY2UtIENvbXBsaWFuY2VT
T1MtCgkJCSBDb21wbGlhbmNlIERlLWVtcGhhc2lzOiAtNmRCCgkJTG5rU3Rh
MjogQ3VycmVudCBEZS1lbXBoYXNpcyBMZXZlbDogLTMuNWRCCglDYXBhYmls
aXRpZXM6IFs4MF0gTVNJOiBFbmFibGUtIENvdW50PTEvMSBNYXNrYWJsZS0g
NjRiaXQtCgkJQWRkcmVzczogMDAwMDAwMDAgIERhdGE6IDAwMDAKCUNhcGFi
aWxpdGllczogWzkwXSBTdWJzeXN0ZW06IEFTVVNUZUsgQ29tcHV0ZXIgSW5j
LiBEZXZpY2UgODQ0ZAoJQ2FwYWJpbGl0aWVzOiBbYTBdIFBvd2VyIE1hbmFn
ZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDIt
IEF1eEN1cnJlbnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xk
KykKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0w
IERTY2FsZT0wIFBNRS0KCjAwOjFkLjAgVVNCIGNvbnRyb2xsZXI6IEludGVs
IENvcnBvcmF0aW9uIDYgU2VyaWVzL0MyMDAgU2VyaWVzIENoaXBzZXQgRmFt
aWx5IFVTQiBFbmhhbmNlZCBIb3N0IENvbnRyb2xsZXIgIzEgKHJldiAwNSkg
KHByb2ctaWYgMjAgW0VIQ0ldKQoJU3Vic3lzdGVtOiBBU1VTVGVLIENvbXB1
dGVyIEluYy4gUDhQNjcgRGVsdXhlIE1vdGhlcmJvYXJkCglDb250cm9sOiBJ
L08tIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNu
b29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4
LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkIrIFBhckVyci0g
REVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VS
Ui0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJbnRlcnJ1cHQ6IHBpbiBB
IHJvdXRlZCB0byBJUlEgMjMKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgZjYzMDYw
MDAgKDMyLWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9MUtdCglDYXBh
YmlsaXRpZXM6IFs1MF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIKCQlG
bGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD0zNzVtQSBQ
TUUoRDArLEQxLSxEMi0sRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBEMCBO
b1NvZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglD
YXBhYmlsaXRpZXM6IFs1OF0gRGVidWcgcG9ydDogQkFSPTEgb2Zmc2V0PTAw
YTAKCUNhcGFiaWxpdGllczogWzk4XSBQQ0kgQWR2YW5jZWQgRmVhdHVyZXMK
CQlBRkNhcDogVFArIEZMUisKCQlBRkN0cmw6IEZMUi0KCQlBRlN0YXR1czog
VFArCglLZXJuZWwgZHJpdmVyIGluIHVzZTogZWhjaV9oY2QKCjAwOjFmLjAg
SVNBIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gSDY3IEV4cHJlc3MgQ2hp
cHNldCBGYW1pbHkgTFBDIENvbnRyb2xsZXIgKHJldiAwNSkKCVN1YnN5c3Rl
bTogQVNVU1RlSyBDb21wdXRlciBJbmMuIERldmljZSA4NDRkCglDb250cm9s
OiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZH
QVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJ
TlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVy
ci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+
U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglDYXBhYmlsaXRpZXM6
IFtlMF0gVmVuZG9yIFNwZWNpZmljIEluZm9ybWF0aW9uOiBMZW49MGMgPD8+
CglLZXJuZWwgbW9kdWxlczogaVRDT193ZHQKCjAwOjFmLjIgSURFIGludGVy
ZmFjZTogSW50ZWwgQ29ycG9yYXRpb24gNiBTZXJpZXMvQzIwMCBTZXJpZXMg
Q2hpcHNldCBGYW1pbHkgNCBwb3J0IFNBVEEgSURFIENvbnRyb2xsZXIgKHJl
diAwNSkgKHByb2ctaWYgOGYgW01hc3RlciBTZWNQIFNlY08gUHJpUCBQcmlP
XSkKCVN1YnN5c3RlbTogQVNVU1RlSyBDb21wdXRlciBJbmMuIERldmljZSA4
NDRkCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUt
IE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBG
YXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6KyBVREYtIEZh
c3RCMkIrIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0
LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJ
bnRlcnJ1cHQ6IHBpbiBCIHJvdXRlZCB0byBJUlEgMTkKCVJlZ2lvbiAwOiBJ
L08gcG9ydHMgYXQgZjBkMCBbc2l6ZT04XQoJUmVnaW9uIDE6IEkvTyBwb3J0
cyBhdCBmMGMwIFtzaXplPTRdCglSZWdpb24gMjogSS9PIHBvcnRzIGF0IGYw
YjAgW3NpemU9OF0KCVJlZ2lvbiAzOiBJL08gcG9ydHMgYXQgZjBhMCBbc2l6
ZT00XQoJUmVnaW9uIDQ6IEkvTyBwb3J0cyBhdCBmMDkwIFtzaXplPTE2XQoJ
UmVnaW9uIDU6IEkvTyBwb3J0cyBhdCBmMDgwIFtzaXplPTE2XQoJQ2FwYWJp
bGl0aWVzOiBbNzBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAzCgkJRmxh
Z3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShE
MC0sRDEtLEQyLSxEM2hvdC0sRDNjb2xkLSkKCQlTdGF0dXM6IEQwIE5vU29m
dFJzdCsgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFi
aWxpdGllczogW2IwXSBQQ0kgQWR2YW5jZWQgRmVhdHVyZXMKCQlBRkNhcDog
VFArIEZMUisKCQlBRkN0cmw6IEZMUi0KCQlBRlN0YXR1czogVFAtCglLZXJu
ZWwgZHJpdmVyIGluIHVzZTogYXRhX3BpaXgKCjAwOjFmLjMgU01CdXM6IElu
dGVsIENvcnBvcmF0aW9uIDYgU2VyaWVzL0MyMDAgU2VyaWVzIENoaXBzZXQg
RmFtaWx5IFNNQnVzIENvbnRyb2xsZXIgKHJldiAwNSkKCVN1YnN5c3RlbTog
QVNVU1RlSyBDb21wdXRlciBJbmMuIFA4UDY3IERlbHV4ZSBNb3RoZXJib2Fy
ZAoJQ29udHJvbDogSS9PKyBNZW0rIEJ1c01hc3Rlci0gU3BlY0N5Y2xlLSBN
ZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFz
dEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwLSA2Nk1Iei0gVURGLSBGYXN0
QjJCKyBQYXJFcnItIERFVlNFTD1tZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0g
PE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJSW50ZXJydXB0OiBwaW4g
QyByb3V0ZWQgdG8gSVJRIDEwCglSZWdpb24gMDogTWVtb3J5IGF0IGY2MzA1
MDAwICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTI1Nl0KCVJl
Z2lvbiA0OiBJL08gcG9ydHMgYXQgZjAwMCBbc2l6ZT0zMl0KCUtlcm5lbCBt
b2R1bGVzOiBpMmMtaTgwMQoKMDA6MWYuNSBJREUgaW50ZXJmYWNlOiBJbnRl
bCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNlcmllcyBDaGlwc2V0IEZh
bWlseSAyIHBvcnQgU0FUQSBJREUgQ29udHJvbGxlciAocmV2IDA1KSAocHJv
Zy1pZiA4NSBbTWFzdGVyIFNlY08gUHJpT10pCglTdWJzeXN0ZW06IEFTVVNU
ZUsgQ29tcHV0ZXIgSW5jLiBEZXZpY2UgODQ0ZAoJQ29udHJvbDogSS9PKyBN
ZW0tIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0g
UGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0
YXR1czogQ2FwKyA2Nk1IeisgVURGLSBGYXN0QjJCKyBQYXJFcnItIERFVlNF
TD1tZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQ
RVJSLSBJTlR4LQoJTGF0ZW5jeTogMAoJSW50ZXJydXB0OiBwaW4gQiByb3V0
ZWQgdG8gSVJRIDE5CglSZWdpb24gMDogSS9PIHBvcnRzIGF0IGYwNzAgW3Np
emU9OF0KCVJlZ2lvbiAxOiBJL08gcG9ydHMgYXQgZjA2MCBbc2l6ZT00XQoJ
UmVnaW9uIDI6IEkvTyBwb3J0cyBhdCBmMDUwIFtzaXplPThdCglSZWdpb24g
MzogSS9PIHBvcnRzIGF0IGYwNDAgW3NpemU9NF0KCVJlZ2lvbiA0OiBJL08g
cG9ydHMgYXQgZjAzMCBbc2l6ZT0xNl0KCVJlZ2lvbiA1OiBJL08gcG9ydHMg
YXQgZjAyMCBbc2l6ZT0xNl0KCUNhcGFiaWxpdGllczogWzcwXSBQb3dlciBN
YW5hZ2VtZW50IHZlcnNpb24gMwoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDEt
IEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDAtLEQxLSxEMi0sRDNob3QtLEQz
Y29sZC0pCgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QrIFBNRS1FbmFibGUtIERT
ZWw9MCBEU2NhbGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6IFtiMF0gUENJIEFk
dmFuY2VkIEZlYXR1cmVzCgkJQUZDYXA6IFRQKyBGTFIrCgkJQUZDdHJsOiBG
TFItCgkJQUZTdGF0dXM6IFRQLQoJS2VybmVsIGRyaXZlciBpbiB1c2U6IGF0
YV9waWl4CgowMTowMC4wIFZHQSBjb21wYXRpYmxlIGNvbnRyb2xsZXI6IE5W
SURJQSBDb3Jwb3JhdGlvbiBHRjExNiBbR2VGb3JjZSBHVFggNTUwIFRpXSAo
cmV2IGExKSAocHJvZy1pZiAwMCBbVkdBIGNvbnRyb2xsZXJdKQoJU3Vic3lz
dGVtOiBHaWdhLWJ5dGUgVGVjaG5vbG9neSBEZXZpY2UgMzUzNgoJQ29udHJv
bDogSS9PKyBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBW
R0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlz
SU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJF
cnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5T
RVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAKCUludGVycnVwdDogcGlu
IEEgcm91dGVkIHRvIElSUSAxNgoJUmVnaW9uIDA6IE1lbW9yeSBhdCBmNDAw
MDAwMCAoMzItYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0zMk1dCglS
ZWdpb24gMTogTWVtb3J5IGF0IGUwMDAwMDAwICg2NC1iaXQsIHByZWZldGNo
YWJsZSkgW3NpemU9MTI4TV0KCVJlZ2lvbiAzOiBNZW1vcnkgYXQgZTgwMDAw
MDAgKDY0LWJpdCwgcHJlZmV0Y2hhYmxlKSBbc2l6ZT02NE1dCglSZWdpb24g
NTogSS9PIHBvcnRzIGF0IGUwMDAgW3NpemU9MTI4XQoJW3ZpcnR1YWxdIEV4
cGFuc2lvbiBST00gYXQgZjYwMDAwMDAgW2Rpc2FibGVkXSBbc2l6ZT01MTJL
XQoJQ2FwYWJpbGl0aWVzOiBbNjBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lv
biAzCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9
MG1BIFBNRShEMC0sRDEtLEQyLSxEM2hvdC0sRDNjb2xkLSkKCQlTdGF0dXM6
IEQwIE5vU29mdFJzdCsgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBN
RS0KCUNhcGFiaWxpdGllczogWzY4XSBNU0k6IEVuYWJsZS0gQ291bnQ9MS8x
IE1hc2thYmxlLSA2NGJpdCsKCQlBZGRyZXNzOiAwMDAwMDAwMDAwMDAwMDAw
ICBEYXRhOiAwMDAwCglDYXBhYmlsaXRpZXM6IFs3OF0gRXhwcmVzcyAodjIp
IEVuZHBvaW50LCBNU0kgMDAKCQlEZXZDYXA6CU1heFBheWxvYWQgMTI4IGJ5
dGVzLCBQaGFudEZ1bmMgMCwgTGF0ZW5jeSBMMHMgPDR1cywgTDEgPDY0dXMK
CQkJRXh0VGFnKyBBdHRuQnRuLSBBdHRuSW5kLSBQd3JJbmQtIFJCRSsgRkxS
ZXNldC0KCQlEZXZDdGw6CVJlcG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBO
b24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0KCQkJUmx4ZE9yZCsgRXh0
VGFnKyBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcCsKCQkJTWF4UGF5bG9h
ZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgNTEyIGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyLSBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3
ci0gVHJhbnNQZW5kLQoJCUxua0NhcDoJUG9ydCAjMCwgU3BlZWQgMi41R1Qv
cywgV2lkdGggeDE2LCBBU1BNIEwwcyBMMSwgTGF0ZW5jeSBMMCA8MjU2bnMs
IEwxIDw0dXMKCQkJQ2xvY2tQTSsgU3VycHJpc2UtIExMQWN0UmVwLSBCd05v
dC0KCQlMbmtDdGw6CUFTUE0gRGlzYWJsZWQ7IFJDQiA2NCBieXRlcyBEaXNh
YmxlZC0gUmV0cmFpbi0gQ29tbUNsaysKCQkJRXh0U3luY2gtIENsb2NrUE0r
IEF1dFdpZERpcy0gQldJbnQtIEF1dEJXSW50LQoJCUxua1N0YToJU3BlZWQg
Mi41R1QvcywgV2lkdGggeDE2LCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERM
QWN0aXZlLSBCV01nbXQtIEFCV01nbXQtCgkJRGV2Q2FwMjogQ29tcGxldGlv
biBUaW1lb3V0OiBOb3QgU3VwcG9ydGVkLCBUaW1lb3V0RGlzKwoJCURldkN0
bDI6IENvbXBsZXRpb24gVGltZW91dDogNTB1cyB0byA1MG1zLCBUaW1lb3V0
RGlzLQoJCUxua0N0bDI6IFRhcmdldCBMaW5rIFNwZWVkOiAyLjVHVC9zLCBF
bnRlckNvbXBsaWFuY2UtIFNwZWVkRGlzLSwgU2VsZWN0YWJsZSBEZS1lbXBo
YXNpczogLTZkQgoJCQkgVHJhbnNtaXQgTWFyZ2luOiBOb3JtYWwgT3BlcmF0
aW5nIFJhbmdlLCBFbnRlck1vZGlmaWVkQ29tcGxpYW5jZS0gQ29tcGxpYW5j
ZVNPUy0KCQkJIENvbXBsaWFuY2UgRGUtZW1waGFzaXM6IC02ZEIKCQlMbmtT
dGEyOiBDdXJyZW50IERlLWVtcGhhc2lzIExldmVsOiAtNmRCCglDYXBhYmls
aXRpZXM6IFtiNF0gVmVuZG9yIFNwZWNpZmljIEluZm9ybWF0aW9uOiBMZW49
MTQgPD8+CglDYXBhYmlsaXRpZXM6IFsxMDAgdjFdIFZpcnR1YWwgQ2hhbm5l
bAoJCUNhcHM6CUxQRVZDPTAgUmVmQ2xrPTEwMG5zIFBBVEVudHJ5Qml0cz0x
CgkJQXJiOglGaXhlZC0gV1JSMzItIFdSUjY0LSBXUlIxMjgtCgkJQ3RybDoJ
QXJiU2VsZWN0PUZpeGVkCgkJU3RhdHVzOglJblByb2dyZXNzLQoJCVZDMDoJ
Q2FwczoJUEFUT2Zmc2V0PTAwIE1heFRpbWVTbG90cz0xIFJlalNub29wVHJh
bnMtCgkJCUFyYjoJRml4ZWQtIFdSUjMyLSBXUlI2NC0gV1JSMTI4LSBUV1JS
MTI4LSBXUlIyNTYtCgkJCUN0cmw6CUVuYWJsZSsgSUQ9MCBBcmJTZWxlY3Q9
Rml4ZWQgVEMvVkM9MDEKCQkJU3RhdHVzOglOZWdvUGVuZGluZy0gSW5Qcm9n
cmVzcy0KCUNhcGFiaWxpdGllczogWzEyOCB2MV0gUG93ZXIgQnVkZ2V0aW5n
IDw/PgoJQ2FwYWJpbGl0aWVzOiBbNjAwIHYxXSBWZW5kb3IgU3BlY2lmaWMg
SW5mb3JtYXRpb246IElEPTAwMDEgUmV2PTEgTGVuPTAyNCA8Pz4KCUtlcm5l
bCBkcml2ZXIgaW4gdXNlOiBudmlkaWEKCUtlcm5lbCBtb2R1bGVzOiBudmlk
aWFfY3VycmVudCwgbnZpZGlhX2N1cnJlbnRfdXBkYXRlcywgbm91dmVhdSwg
bnZpZGlhZmIKCjAxOjAwLjEgQXVkaW8gZGV2aWNlOiBOVklESUEgQ29ycG9y
YXRpb24gR0YxMTYgSGlnaCBEZWZpbml0aW9uIEF1ZGlvIENvbnRyb2xsZXIg
KHJldiBhMSkKCVN1YnN5c3RlbTogR2lnYS1ieXRlIFRlY2hub2xvZ3kgRGV2
aWNlIDM1MzYKCUNvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNwZWND
eWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNF
UlItIEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcCsgNjZNSHotIFVE
Ri0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFi
b3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAw
LCBDYWNoZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglJbnRlcnJ1cHQ6IHBpbiBC
IHJvdXRlZCB0byBJUlEgMTcKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgZjYwODAw
MDAgKDMyLWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9MTZLXQoJQ2Fw
YWJpbGl0aWVzOiBbNjBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAzCgkJ
RmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBN
RShEMC0sRDEtLEQyLSxEM2hvdC0sRDNjb2xkLSkKCQlTdGF0dXM6IEQwIE5v
U29mdFJzdCsgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUNh
cGFiaWxpdGllczogWzY4XSBNU0k6IEVuYWJsZS0gQ291bnQ9MS8xIE1hc2th
YmxlLSA2NGJpdCsKCQlBZGRyZXNzOiAwMDAwMDAwMDAwMDAwMDAwICBEYXRh
OiAwMDAwCglDYXBhYmlsaXRpZXM6IFs3OF0gRXhwcmVzcyAodjIpIEVuZHBv
aW50LCBNU0kgMDAKCQlEZXZDYXA6CU1heFBheWxvYWQgMTI4IGJ5dGVzLCBQ
aGFudEZ1bmMgMCwgTGF0ZW5jeSBMMHMgPDR1cywgTDEgPDY0dXMKCQkJRXh0
VGFnKyBBdHRuQnRuLSBBdHRuSW5kLSBQd3JJbmQtIFJCRSsgRkxSZXNldC0K
CQlEZXZDdGw6CVJlcG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0
YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQ
aGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcCsKCQkJTWF4UGF5bG9hZCAxMjgg
Ynl0ZXMsIE1heFJlYWRSZXEgNTEyIGJ5dGVzCgkJRGV2U3RhOglDb3JyRXJy
LSBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3ci0gVHJh
bnNQZW5kLQoJCUxua0NhcDoJUG9ydCAjMCwgU3BlZWQgMi41R1QvcywgV2lk
dGggeDE2LCBBU1BNIEwwcyBMMSwgTGF0ZW5jeSBMMCA8MjU2bnMsIEwxIDw0
dXMKCQkJQ2xvY2tQTSsgU3VycHJpc2UtIExMQWN0UmVwLSBCd05vdC0KCQlM
bmtDdGw6CUFTUE0gRGlzYWJsZWQ7IFJDQiAxMjggYnl0ZXMgRGlzYWJsZWQt
IFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9ja1BNKyBBdXRX
aWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdU
L3MsIFdpZHRoIHgxNiwgVHJFcnItIFRyYWluLSBTbG90Q2xrKyBETEFjdGl2
ZS0gQldNZ210LSBBQldNZ210LQoJCURldkNhcDI6IENvbXBsZXRpb24gVGlt
ZW91dDogTm90IFN1cHBvcnRlZCwgVGltZW91dERpcysKCQlEZXZDdGwyOiBD
b21wbGV0aW9uIFRpbWVvdXQ6IDUwdXMgdG8gNTBtcywgVGltZW91dERpcy0K
CQlMbmtDdGwyOiBUYXJnZXQgTGluayBTcGVlZDogMi41R1QvcywgRW50ZXJD
b21wbGlhbmNlLSBTcGVlZERpcy0sIFNlbGVjdGFibGUgRGUtZW1waGFzaXM6
IC02ZEIKCQkJIFRyYW5zbWl0IE1hcmdpbjogTm9ybWFsIE9wZXJhdGluZyBS
YW5nZSwgRW50ZXJNb2RpZmllZENvbXBsaWFuY2UtIENvbXBsaWFuY2VTT1Mt
CgkJCSBDb21wbGlhbmNlIERlLWVtcGhhc2lzOiAtNmRCCgkJTG5rU3RhMjog
Q3VycmVudCBEZS1lbXBoYXNpcyBMZXZlbDogLTZkQgoJS2VybmVsIGRyaXZl
ciBpbiB1c2U6IHNuZF9oZGFfaW50ZWwKCUtlcm5lbCBtb2R1bGVzOiBzbmQt
aGRhLWludGVsCgowMzowMC4wIElERSBpbnRlcmZhY2U6IFZJQSBUZWNobm9s
b2dpZXMsIEluYy4gVlQ2NDE1IFBBVEEgSURFIEhvc3QgQ29udHJvbGxlciAo
cHJvZy1pZiA4NSBbTWFzdGVyIFNlY08gUHJpT10pCglTdWJzeXN0ZW06IEFT
VVNUZUsgQ29tcHV0ZXIgSW5jLiBNNUE4OC1WIEVWTwoJQ29udHJvbDogSS9P
KyBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9v
cC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0K
CVN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJFcnItIERF
VlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8
UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAsIENhY2hlIExpbmUgU2l6ZTogNjQg
Ynl0ZXMKCUludGVycnVwdDogcGluIEEgcm91dGVkIHRvIElSUSAxNgoJUmVn
aW9uIDA6IEkvTyBwb3J0cyBhdCBkMDQwIFtzaXplPThdCglSZWdpb24gMTog
SS9PIHBvcnRzIGF0IGQwMzAgW3NpemU9NF0KCVJlZ2lvbiAyOiBJL08gcG9y
dHMgYXQgZDAyMCBbc2l6ZT04XQoJUmVnaW9uIDM6IEkvTyBwb3J0cyBhdCBk
MDEwIFtzaXplPTRdCglSZWdpb24gNDogSS9PIHBvcnRzIGF0IGQwMDAgW3Np
emU9MTZdCglFeHBhbnNpb24gUk9NIGF0IGY2MjAwMDAwIFtkaXNhYmxlZF0g
W3NpemU9NjRLXQoJQ2FwYWJpbGl0aWVzOiBbNTBdIFBvd2VyIE1hbmFnZW1l
bnQgdmVyc2lvbiAzCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMSsgRDIrIEF1
eEN1cnJlbnQ9MG1BIFBNRShEMC0sRDErLEQyKyxEM2hvdCssRDNjb2xkLSkK
CQlTdGF0dXM6IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERT
Y2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogWzcwXSBNU0k6IEVuYWJsZS0g
Q291bnQ9MS8xIE1hc2thYmxlKyA2NGJpdCsKCQlBZGRyZXNzOiAwMDAwMDAw
MDAwMDAwMDAwICBEYXRhOiAwMDAwCgkJTWFza2luZzogMDAwMDAwMDAgIFBl
bmRpbmc6IDAwMDAwMDAwCglDYXBhYmlsaXRpZXM6IFs5MF0gRXhwcmVzcyAo
djEpIExlZ2FjeSBFbmRwb2ludCwgTVNJIDAwCgkJRGV2Q2FwOglNYXhQYXls
b2FkIDEyOCBieXRlcywgUGhhbnRGdW5jIDAsIExhdGVuY3kgTDBzIDw2NG5z
LCBMMSA8MXVzCgkJCUV4dFRhZy0gQXR0bkJ0bi0gQXR0bkluZC0gUHdySW5k
LSBSQkUrIEZMUmVzZXQtCgkJRGV2Q3RsOglSZXBvcnQgZXJyb3JzOiBDb3Jy
ZWN0YWJsZS0gTm9uLUZhdGFsLSBGYXRhbC0gVW5zdXBwb3J0ZWQtCgkJCVJs
eGRPcmQtIEV4dFRhZy0gUGhhbnRGdW5jLSBBdXhQd3ItIE5vU25vb3AtCgkJ
CU1heFBheWxvYWQgMTI4IGJ5dGVzLCBNYXhSZWFkUmVxIDUxMiBieXRlcwoJ
CURldlN0YToJQ29yckVyci0gVW5jb3JyRXJyLSBGYXRhbEVyci0gVW5zdXBw
UmVxLSBBdXhQd3ItIFRyYW5zUGVuZC0KCQlMbmtDYXA6CVBvcnQgIzAsIFNw
ZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEwwcyBMMSwgTGF0ZW5jeSBM
MCA8MXVzLCBMMSA8NjR1cwoJCQlDbG9ja1BNLSBTdXJwcmlzZS0gTExBY3RS
ZXAtIEJ3Tm90LQoJCUxua0N0bDoJQVNQTSBEaXNhYmxlZDsgUkNCIDY0IGJ5
dGVzIERpc2FibGVkLSBSZXRyYWluLSBDb21tQ2xrLQoJCQlFeHRTeW5jaC0g
Q2xvY2tQTS0gQXV0V2lkRGlzLSBCV0ludC0gQXV0QldJbnQtCgkJTG5rU3Rh
OglTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgVHJFcnItIFRyYWluLSBTbG90
Q2xrLSBETEFjdGl2ZS0gQldNZ210LSBBQldNZ210LQoJQ2FwYWJpbGl0aWVz
OiBbMTAwIHYxXSBBZHZhbmNlZCBFcnJvciBSZXBvcnRpbmcKCQlVRVN0YToJ
RExQLSBTREVTLSBUTFAtIEZDUC0gQ21wbHRUTy0gQ21wbHRBYnJ0LSBVbnhD
bXBsdC0gUnhPRi0gTWFsZlRMUC0gRUNSQy0gVW5zdXBSZXEtIEFDU1Zpb2wt
CgkJVUVNc2s6CURMUC0gU0RFUy0gVExQLSBGQ1AtIENtcGx0VE8tIENtcGx0
QWJydC0gVW54Q21wbHQtIFJ4T0YtIE1hbGZUTFAtIEVDUkMtIFVuc3VwUmVx
LSBBQ1NWaW9sLQoJCVVFU3ZydDoJRExQKyBTREVTKyBUTFAtIEZDUCsgQ21w
bHRUTy0gQ21wbHRBYnJ0LSBVbnhDbXBsdC0gUnhPRisgTWFsZlRMUCsgRUNS
Qy0gVW5zdXBSZXEtIEFDU1Zpb2wtCgkJQ0VTdGE6CVJ4RXJyLSBCYWRUTFAt
IEJhZERMTFAtIFJvbGxvdmVyLSBUaW1lb3V0LSBOb25GYXRhbEVyci0KCQlD
RU1zazoJUnhFcnItIEJhZFRMUC0gQmFkRExMUC0gUm9sbG92ZXItIFRpbWVv
dXQtIE5vbkZhdGFsRXJyKwoJCUFFUkNhcDoJRmlyc3QgRXJyb3IgUG9pbnRl
cjogMTQsIEdlbkNhcCsgQ0dlbkVuLSBDaGtDYXArIENoa0VuLQoJQ2FwYWJp
bGl0aWVzOiBbMTMwIHYxXSBEZXZpY2UgU2VyaWFsIE51bWJlciAwMC00MC02
My1mZi1mZi02My00MC0wMAoJS2VybmVsIGRyaXZlciBpbiB1c2U6IHBhdGFf
dmlhCglLZXJuZWwgbW9kdWxlczogcGF0YV92aWEKCjA0OjAwLjAgVVNCIGNv
bnRyb2xsZXI6IEFTTWVkaWEgVGVjaG5vbG9neSBJbmMuIEFTTTEwNDIgU3Vw
ZXJTcGVlZCBVU0IgSG9zdCBDb250cm9sbGVyIChwcm9nLWlmIDMwIFtYSENJ
XSkKCVN1YnN5c3RlbTogQVNVU1RlSyBDb21wdXRlciBJbmMuIERldmljZSA4
NDg4CglDb250cm9sOiBJL08tIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUt
IE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBG
YXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZh
c3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0g
PE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2Fj
aGUgTGluZSBTaXplOiA2NCBieXRlcwoJSW50ZXJydXB0OiBwaW4gQSByb3V0
ZWQgdG8gSVJRIDE3CglSZWdpb24gMDogTWVtb3J5IGF0IGY2MTAwMDAwICg2
NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTMyS10KCUNhcGFiaWxp
dGllczogWzUwXSBNU0k6IEVuYWJsZS0gQ291bnQ9MS84IE1hc2thYmxlLSA2
NGJpdCsKCQlBZGRyZXNzOiAwMDAwMDAwMDAwMDAwMDAwICBEYXRhOiAwMDAw
CglDYXBhYmlsaXRpZXM6IFs2OF0gTVNJLVg6IEVuYWJsZSsgQ291bnQ9OCBN
YXNrZWQtCgkJVmVjdG9yIHRhYmxlOiBCQVI9MCBvZmZzZXQ9MDAwMDIwMDAK
CQlQQkE6IEJBUj0wIG9mZnNldD0wMDAwMjA4MAoJQ2FwYWJpbGl0aWVzOiBb
NzhdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAzCgkJRmxhZ3M6IFBNRUNs
ay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9NTVtQSBQTUUoRDAtLEQxLSxE
Mi0sRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QtIFBN
RS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6
IFs4MF0gRXhwcmVzcyAodjIpIExlZ2FjeSBFbmRwb2ludCwgTVNJIDAwCgkJ
RGV2Q2FwOglNYXhQYXlsb2FkIDUxMiBieXRlcywgUGhhbnRGdW5jIDAsIExh
dGVuY3kgTDBzIDw2NG5zLCBMMSA8MnVzCgkJCUV4dFRhZy0gQXR0bkJ0bi0g
QXR0bkluZC0gUHdySW5kLSBSQkUrIEZMUmVzZXQtCgkJRGV2Q3RsOglSZXBv
cnQgZXJyb3JzOiBDb3JyZWN0YWJsZS0gTm9uLUZhdGFsLSBGYXRhbC0gVW5z
dXBwb3J0ZWQtCgkJCVJseGRPcmQtIEV4dFRhZy0gUGhhbnRGdW5jLSBBdXhQ
d3ItIE5vU25vb3ArCgkJCU1heFBheWxvYWQgMTI4IGJ5dGVzLCBNYXhSZWFk
UmVxIDUxMiBieXRlcwoJCURldlN0YToJQ29yckVycisgVW5jb3JyRXJyLSBG
YXRhbEVyci0gVW5zdXBwUmVxLSBBdXhQd3ItIFRyYW5zUGVuZC0KCQlMbmtD
YXA6CVBvcnQgIzEsIFNwZWVkIDVHVC9zLCBXaWR0aCB4MSwgQVNQTSBMMHMg
TDEsIExhdGVuY3kgTDAgdW5saW1pdGVkLCBMMSB1bmxpbWl0ZWQKCQkJQ2xv
Y2tQTS0gU3VycHJpc2UtIExMQWN0UmVwLSBCd05vdC0KCQlMbmtDdGw6CUFT
UE0gRGlzYWJsZWQ7IFJDQiA2NCBieXRlcyBEaXNhYmxlZC0gUmV0cmFpbi0g
Q29tbUNsaysKCQkJRXh0U3luY2gtIENsb2NrUE0tIEF1dFdpZERpcy0gQldJ
bnQtIEF1dEJXSW50LQoJCUxua1N0YToJU3BlZWQgNUdUL3MsIFdpZHRoIHgx
LCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlLSBCV01nbXQtIEFC
V01nbXQtCgkJRGV2Q2FwMjogQ29tcGxldGlvbiBUaW1lb3V0OiBOb3QgU3Vw
cG9ydGVkLCBUaW1lb3V0RGlzLQoJCURldkN0bDI6IENvbXBsZXRpb24gVGlt
ZW91dDogNTB1cyB0byA1MG1zLCBUaW1lb3V0RGlzLQoJCUxua0N0bDI6IFRh
cmdldCBMaW5rIFNwZWVkOiA1R1QvcywgRW50ZXJDb21wbGlhbmNlLSBTcGVl
ZERpcy0sIFNlbGVjdGFibGUgRGUtZW1waGFzaXM6IC02ZEIKCQkJIFRyYW5z
bWl0IE1hcmdpbjogTm9ybWFsIE9wZXJhdGluZyBSYW5nZSwgRW50ZXJNb2Rp
ZmllZENvbXBsaWFuY2UtIENvbXBsaWFuY2VTT1MtCgkJCSBDb21wbGlhbmNl
IERlLWVtcGhhc2lzOiAtNmRCCgkJTG5rU3RhMjogQ3VycmVudCBEZS1lbXBo
YXNpcyBMZXZlbDogLTZkQgoJQ2FwYWJpbGl0aWVzOiBbMTAwIHYxXSBWaXJ0
dWFsIENoYW5uZWwKCQlDYXBzOglMUEVWQz0wIFJlZkNsaz0xMDBucyBQQVRF
bnRyeUJpdHM9MQoJCUFyYjoJRml4ZWQtIFdSUjMyLSBXUlI2NC0gV1JSMTI4
LQoJCUN0cmw6CUFyYlNlbGVjdD1GaXhlZAoJCVN0YXR1czoJSW5Qcm9ncmVz
cy0KCQlWQzA6CUNhcHM6CVBBVE9mZnNldD0wMCBNYXhUaW1lU2xvdHM9MSBS
ZWpTbm9vcFRyYW5zLQoJCQlBcmI6CUZpeGVkLSBXUlIzMi0gV1JSNjQtIFdS
UjEyOC0gVFdSUjEyOC0gV1JSMjU2LQoJCQlDdHJsOglFbmFibGUrIElEPTAg
QXJiU2VsZWN0PUZpeGVkIFRDL1ZDPTAxCgkJCVN0YXR1czoJTmVnb1BlbmRp
bmctIEluUHJvZ3Jlc3MtCglLZXJuZWwgZHJpdmVyIGluIHVzZTogeGhjaV9o
Y2QKCjA1OjAwLjAgRXRoZXJuZXQgY29udHJvbGxlcjogUmVhbHRlayBTZW1p
Y29uZHVjdG9yIENvLiwgTHRkLiBSVEw4MTExLzgxNjhCIFBDSSBFeHByZXNz
IEdpZ2FiaXQgRXRoZXJuZXQgY29udHJvbGxlciAocmV2IDA2KQoJU3Vic3lz
dGVtOiBBU1VTVGVLIENvbXB1dGVyIEluYy4gUDhQNjcgYW5kIG90aGVyIG1v
dGhlcmJvYXJkcwoJQ29udHJvbDogSS9PKyBNZW0rIEJ1c01hc3RlcisgU3Bl
Y0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0g
U0VSUi0gRmFzdEIyQi0gRGlzSU5UeCsKCVN0YXR1czogQ2FwKyA2Nk1Iei0g
VURGLSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxU
QWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6
IDAsIENhY2hlIExpbmUgU2l6ZTogNjQgYnl0ZXMKCUludGVycnVwdDogcGlu
IEEgcm91dGVkIHRvIElSUSA0NgoJUmVnaW9uIDA6IEkvTyBwb3J0cyBhdCBj
MDAwIFtzaXplPTI1Nl0KCVJlZ2lvbiAyOiBNZW1vcnkgYXQgZWMxMDQwMDAg
KDY0LWJpdCwgcHJlZmV0Y2hhYmxlKSBbc2l6ZT00S10KCVJlZ2lvbiA0OiBN
ZW1vcnkgYXQgZWMxMDAwMDAgKDY0LWJpdCwgcHJlZmV0Y2hhYmxlKSBbc2l6
ZT0xNktdCglDYXBhYmlsaXRpZXM6IFs0MF0gUG93ZXIgTWFuYWdlbWVudCB2
ZXJzaW9uIDMKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxKyBEMisgQXV4Q3Vy
cmVudD0zNzVtQSBQTUUoRDArLEQxKyxEMissRDNob3QrLEQzY29sZCspCgkJ
U3RhdHVzOiBEMCBOb1NvZnRSc3QrIFBNRS1FbmFibGUtIERTZWw9MCBEU2Nh
bGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6IFs1MF0gTVNJOiBFbmFibGUrIENv
dW50PTEvMSBNYXNrYWJsZS0gNjRiaXQrCgkJQWRkcmVzczogMDAwMDAwMDBm
ZWUwMTAwYyAgRGF0YTogNDE5MQoJQ2FwYWJpbGl0aWVzOiBbNzBdIEV4cHJl
c3MgKHYyKSBFbmRwb2ludCwgTVNJIDAxCgkJRGV2Q2FwOglNYXhQYXlsb2Fk
IDI1NiBieXRlcywgUGhhbnRGdW5jIDAsIExhdGVuY3kgTDBzIDw1MTJucywg
TDEgPDY0dXMKCQkJRXh0VGFnLSBBdHRuQnRuLSBBdHRuSW5kLSBQd3JJbmQt
IFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJlcG9ydCBlcnJvcnM6IENvcnJl
Y3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0KCQkJUmx4
ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgNDA5NiBieXRlcwoJ
CURldlN0YToJQ29yckVyci0gVW5jb3JyRXJyLSBGYXRhbEVyci0gVW5zdXBw
UmVxLSBBdXhQd3IrIFRyYW5zUGVuZC0KCQlMbmtDYXA6CVBvcnQgIzAsIFNw
ZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEwwcyBMMSwgTGF0ZW5jeSBM
MCA8NTEybnMsIEwxIDw2NHVzCgkJCUNsb2NrUE0rIFN1cnByaXNlLSBMTEFj
dFJlcC0gQndOb3QtCgkJTG5rQ3RsOglBU1BNIERpc2FibGVkOyBSQ0IgNjQg
Ynl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNo
LSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtT
dGE6CVNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNs
b3RDbGsrIERMQWN0aXZlLSBCV01nbXQtIEFCV01nbXQtCgkJRGV2Q2FwMjog
Q29tcGxldGlvbiBUaW1lb3V0OiBOb3QgU3VwcG9ydGVkLCBUaW1lb3V0RGlz
KwoJCURldkN0bDI6IENvbXBsZXRpb24gVGltZW91dDogNTB1cyB0byA1MG1z
LCBUaW1lb3V0RGlzLQoJCUxua0N0bDI6IFRhcmdldCBMaW5rIFNwZWVkOiAy
LjVHVC9zLCBFbnRlckNvbXBsaWFuY2UtIFNwZWVkRGlzLSwgU2VsZWN0YWJs
ZSBEZS1lbXBoYXNpczogLTZkQgoJCQkgVHJhbnNtaXQgTWFyZ2luOiBOb3Jt
YWwgT3BlcmF0aW5nIFJhbmdlLCBFbnRlck1vZGlmaWVkQ29tcGxpYW5jZS0g
Q29tcGxpYW5jZVNPUy0KCQkJIENvbXBsaWFuY2UgRGUtZW1waGFzaXM6IC02
ZEIKCQlMbmtTdGEyOiBDdXJyZW50IERlLWVtcGhhc2lzIExldmVsOiAtNmRC
CglDYXBhYmlsaXRpZXM6IFtiMF0gTVNJLVg6IEVuYWJsZS0gQ291bnQ9NCBN
YXNrZWQtCgkJVmVjdG9yIHRhYmxlOiBCQVI9NCBvZmZzZXQ9MDAwMDAwMDAK
CQlQQkE6IEJBUj00IG9mZnNldD0wMDAwMDgwMAoJQ2FwYWJpbGl0aWVzOiBb
ZDBdIFZpdGFsIFByb2R1Y3QgRGF0YQoJCVVua25vd24gc21hbGwgcmVzb3Vy
Y2UgdHlwZSAwMCwgd2lsbCBub3QgZGVjb2RlIG1vcmUuCglDYXBhYmlsaXRp
ZXM6IFsxMDAgdjFdIEFkdmFuY2VkIEVycm9yIFJlcG9ydGluZwoJCVVFU3Rh
OglETFAtIFNERVMtIFRMUC0gRkNQKyBDbXBsdFRPLSBDbXBsdEFicnQtIFVu
eENtcGx0LSBSeE9GLSBNYWxmVExQLSBFQ1JDLSBVbnN1cFJlcS0gQUNTVmlv
bC0KCQlVRU1zazoJRExQLSBTREVTLSBUTFAtIEZDUC0gQ21wbHRUTy0gQ21w
bHRBYnJ0LSBVbnhDbXBsdC0gUnhPRi0gTWFsZlRMUC0gRUNSQy0gVW5zdXBS
ZXEtIEFDU1Zpb2wtCgkJVUVTdnJ0OglETFArIFNERVMrIFRMUC0gRkNQKyBD
bXBsdFRPLSBDbXBsdEFicnQtIFVueENtcGx0LSBSeE9GKyBNYWxmVExQKyBF
Q1JDLSBVbnN1cFJlcS0gQUNTVmlvbC0KCQlDRVN0YToJUnhFcnIrIEJhZFRM
UC0gQmFkRExMUCsgUm9sbG92ZXItIFRpbWVvdXQtIE5vbkZhdGFsRXJyKwoJ
CUNFTXNrOglSeEVyci0gQmFkVExQLSBCYWRETExQLSBSb2xsb3Zlci0gVGlt
ZW91dC0gTm9uRmF0YWxFcnIrCgkJQUVSQ2FwOglGaXJzdCBFcnJvciBQb2lu
dGVyOiAwZCwgR2VuQ2FwKyBDR2VuRW4tIENoa0NhcCsgQ2hrRW4tCglDYXBh
YmlsaXRpZXM6IFsxNDAgdjFdIFZpcnR1YWwgQ2hhbm5lbAoJCUNhcHM6CUxQ
RVZDPTAgUmVmQ2xrPTEwMG5zIFBBVEVudHJ5Qml0cz0xCgkJQXJiOglGaXhl
ZC0gV1JSMzItIFdSUjY0LSBXUlIxMjgtCgkJQ3RybDoJQXJiU2VsZWN0PUZp
eGVkCgkJU3RhdHVzOglJblByb2dyZXNzLQoJCVZDMDoJQ2FwczoJUEFUT2Zm
c2V0PTAwIE1heFRpbWVTbG90cz0xIFJlalNub29wVHJhbnMtCgkJCUFyYjoJ
Rml4ZWQtIFdSUjMyLSBXUlI2NC0gV1JSMTI4LSBUV1JSMTI4LSBXUlIyNTYt
CgkJCUN0cmw6CUVuYWJsZSsgSUQ9MCBBcmJTZWxlY3Q9Rml4ZWQgVEMvVkM9
MDEKCQkJU3RhdHVzOglOZWdvUGVuZGluZy0gSW5Qcm9ncmVzcy0KCUNhcGFi
aWxpdGllczogWzE2MCB2MV0gRGV2aWNlIFNlcmlhbCBOdW1iZXIgMGEtMDAt
MDAtMDAtNjgtNGMtZTAtMDAKCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiByODE2
OQoJS2VybmVsIG1vZHVsZXM6IHI4MTY5CgowNjowMC4wIFBDSSBicmlkZ2U6
IEFTTWVkaWEgVGVjaG5vbG9neSBJbmMuIEFTTTEwODMvMTA4NSBQQ0llIHRv
IFBDSSBCcmlkZ2UgKHJldiAwMSkgKHByb2ctaWYgMDEgW1N1YnRyYWN0aXZl
IGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVj
Q3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBV
REYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRB
Ym9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTog
MCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRlcwoJQnVzOiBwcmltYXJ5PTA2
LCBzZWNvbmRhcnk9MDcsIHN1Ym9yZGluYXRlPTA3LCBzZWMtbGF0ZW5jeT0z
MgoJSS9PIGJlaGluZCBicmlkZ2U6IDAwMDBmMDAwLTAwMDAwZmZmCglNZW1v
cnkgYmVoaW5kIGJyaWRnZTogZmZmMDAwMDAtMDAwZmZmZmYKCVByZWZldGNo
YWJsZSBtZW1vcnkgYmVoaW5kIGJyaWRnZTogMDAwMDAwMDBmZmYwMDAwMC0w
MDAwMDAwMDAwMGZmZmZmCglTZWNvbmRhcnkgc3RhdHVzOiA2Nk1IeisgRmFz
dEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8
TUFib3J0KyA8U0VSUi0gPFBFUlItCglCcmlkZ2VDdGw6IFBhcml0eS0gU0VS
Ui0gTm9JU0EtIFZHQS0gTUFib3J0LSA+UmVzZXQtIEZhc3RCMkItCgkJUHJp
RGlzY1Rtci0gU2VjRGlzY1Rtci0gRGlzY1RtclN0YXQtIERpc2NUbXJTRVJS
RW4tCglDYXBhYmlsaXRpZXM6IFtjMF0gU3Vic3lzdGVtOiBBU1VTVGVLIENv
bXB1dGVyIEluYy4gRGV2aWNlIDg0ODkKCg==

--1771772517-281753162-1353598043=:25176--
