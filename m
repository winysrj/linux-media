Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8509hh1002527
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 20:09:43 -0400
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8509C9T020843
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 20:09:12 -0400
Received: by yx-out-2324.google.com with SMTP id 31so131362yxl.81
	for <video4linux-list@redhat.com>; Thu, 04 Sep 2008 17:09:12 -0700 (PDT)
Message-ID: <6b961cb20809041709r5646f358gcde60fc0fc76f909@mail.gmail.com>
Date: Fri, 5 Sep 2008 12:09:12 +1200
From: "brandon wong" <brandon.wong.nz@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Osprey 530 help
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi all,

I have a borrowed ViewCast Niagara 6116 server which has Osprey 530 stamped
on the back.

Reading the list I haven't been able to determine if this is workable in
Linux.

What I'd like to do is capture SDI input and stream it (with vlc?).

I found a posting (elsewhere) that vlc doesn't work with v4l on 2.6.25, and
a posting about Osprey & v4l targeting 2.6.20 here. This was of course after
trying both CentOS5.2 (2.6.18) and Fedora-9 (2.6.25), so now I am trying
Fedora-8 (2.6.23).

I tried getting down a recent (monday) source for v4l and building on
CentOS5.2 and managed to create a kernel panic on boot. So I've given up
this route now. So I'll stick with Fedora-8 for the time being. Unless
someone can suggest a distro that works better?

I'm currently trying analog input, (I have a SONY J-30SDI {also borrowed} to
try later - just need some digibeta tapes with content)

Managed to install xawtv, this shows S-Video, Composite1, Composite2,
Composite3 input. If I set Capture to 'grabdisplay' I get a blue display on
all four.

On another machine I have an Osprey 230 that works with Composite1 from an
analog source. Audio is another story (Chipmunks & silence being inserted
when output to the on-board snd-intel8x0 using vlc, and streamed to anoher
machine, I'm not too sure - static?)

I've been trying nightly vlc's 0.9.1+

Here is some info, if it is useful

[root@localhost ~]# dmesg|grep bt
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv0: Bt878 (rev 17) at 0000:03:04.0, irq: 21, latency: 32, mmio:
0x48001000
bttv0: detected: Osprey-540 [card=91], PCI subsystem ID is 0070:ff04
bttv0: using: Osprey 540 [card=91,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00fffbff [init]
bttv0: osprey eeprom: unknown card type 0x00b6
bttv0: osprey eeprom: card=-1 'Unknown' serial=7350314
bttv0: tuner absent
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: PLL: 28636363 => 35468950 .. ok
bt878: AUDIO driver version 0.0.0 loaded
bt878: Bt878 AUDIO function found (0).
bt878_probe: card id=[0xff040070], Unknown card.
bt878: probe of 0000:03:04.1 failed with error -22
bt87x0: Using board 0, analog, digital (rate 32000 Hz)
bttv0: PLL can sleep, using XTAL (28636363).

It seems that I have to manually modprobe snd-bt87x. (Though I've tried
/etc/modprobe.conf /etc/modprobe.d/bttv)
[root@localhost ~]# lsmod|grep snd
[root@localhost ~]# modprobe snd-bt87x index=0 load_all
[root@localhost ~]# lsmod|grep bt
snd_bt87x              15973  0
snd_pcm                63685  2 snd_bt87x,snd_pcm_oss
snd                    43461  8
snd_bt87x,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer
snd_page_alloc         11337  2 snd_bt87x,snd_pcm
bt878                  12665  0
bttv                  159797  2 bt878
video_buf              22469  1 bttv
ir_common              33477  1 bttv
compat_ioctl32          5313  1 bttv
i2c_algo_bit            9157  1 bttv
btcx_risc               7881  1 bttv
tveeprom               17617  1 bttv
videodev               28097  2 bttv
v4l2_common            18625  2 bttv,videodev
v4l1_compat            15941  2 bttv,videodev
i2c_core               21825  4 bttv,i2c_algo_bit,tveeprom,i2c_i801
[root@localhost ~]# lsmod|grep snd
snd_bt87x              15973  0
snd_seq_dummy           6725  0
snd_seq_oss            29889  0
snd_seq_midi_event      9793  1 snd_seq_oss
snd_seq                44849  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_seq_device         10061  3 snd_seq_dummy,snd_seq_oss,snd_seq
snd_pcm_oss            37569  0
snd_mixer_oss          16705  1 snd_pcm_oss
snd_pcm                63685  2 snd_bt87x,snd_pcm_oss
snd_timer              20549  2 snd_seq,snd_pcm
snd                    43461  8
snd_bt87x,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer
soundcore               9633  1 snd
snd_page_alloc         11337  2 snd_bt87x,snd_pcm
[root@localhost ~]# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            3050  @ 2.13GHz
stepping        : 2
cpu MHz         : 1596.000
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc
arch_perfmon pebs bts pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 4268.72
clflush size    : 64

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            3050  @ 2.13GHz
stepping        : 2
cpu MHz         : 1596.000
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc
arch_perfmon pebs bts pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 4266.22
clflush size    : 64

[root@localhost ~]#

I'd appreciate greatly any guidance and / or experiences

Thanks,
Brandon
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
