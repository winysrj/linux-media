Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6O70ZuF029975
	for <video4linux-list@redhat.com>; Thu, 24 Jul 2008 03:00:35 -0400
Received: from pantheon-po29.its.yale.edu (pantheon-po29.its.yale.edu
	[130.132.50.124])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6O70AsN031440
	for <video4linux-list@redhat.com>; Thu, 24 Jul 2008 03:00:20 -0400
Received: from desktop (c-68-55-64-109.hsd1.md.comcast.net [68.55.64.109])
	(authenticated bits=0)
	by pantheon-po29.its.yale.edu (8.12.11.20060308/8.12.11) with ESMTP id
	m6O704Zg005212
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <video4linux-list@redhat.com>; Thu, 24 Jul 2008 03:00:04 -0400
From: "Gabriel J. Michael" <gabriel.michael@yale.edu>
To: <video4linux-list@redhat.com>
Date: Thu, 24 Jul 2008 03:00:08 -0400
Message-ID: <011b01c8ed5a$e89927d0$b9cb7770$@michael@yale.edu>
MIME-Version: 1.0
Content-Language: en-us
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Subject: kernel BUG in videobuf-dma-sg.c
Reply-To: gabriel.michael@yale.edu
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

Hello,

 

I am a KnoppMyth user experiencing some trouble with the saa7134-alsa
module. The module loads fine, but as soon as I launch MythTV and try to use
the tuner, the application locks up and I get a message about a kernel bug.

 

I have tried compiling and using several different versions of the v4l
drivers (including the most recent), but to no avail. Also, there is another
KnoppMyth user experiencing the same issue.

 

I thought my problem might be fixed by using the drivers that included this
patch: http://linuxtv.org/hg/v4l-dvb/rev/b978c6ede10a , but that did not
work either.

 

Here is the output from dmesg after the error:

 

saa7134 ALSA driver for DMA sound loaded

saa7133[0]/alsa: saa7133[0] at 0xdc001000 irq 5 registered as card -1

{here is where I launched mythfrontend and began using the tuner}

magic mismatch: 0 (expected 19721112)

------------[ cut here ]------------

kernel BUG at /home/gjm/v4l-dvb-b978c6ede10a/v4l/videobuf-dma-sg.c:278!

invalid opcode: 0000 [#1]

PREEMPT SMP

Modules linked in: saa7134_alsa autofs4 nfsd exportfs cx8800 cx88xx bttv
btcx_risc lirc_i2c lirc_dev ipv6 af_packet fuse usbhid ff_memless pcmcia
yenta_socket rsrc_nonstatic pcmcia_core aufs sbp2 ohci1394 ieee1394
usb_storage ohci_hcd ehci_hcd nvram wm8775 cx25840 snd_via82xx gameport
snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss ivtv snd_pcm saa7115
snd_page_alloc snd_mpu401_uart snd_seq_dummy snd_seq_oss hostap_pci hostap
ieee80211_crypt_rtl msp3400 snd_seq_midi snd_seq_midi_event tuner_simple
tuner_types snd_seq snd_timer tuner snd_rawmidi orinoco_pci orinoco hermes
via686a hwmon snd_seq_device firmware_class 8250_pnp 8250 saa7134
compat_ioctl32 i2c_algo_bit serial_core videobuf_dma_sg videobuf_core
cx2341x i2c_viapro via_agp v4l2_common videodev v4l1_compat agpgart uhci_hcd
ir_kbd_i2c ir_common tveeprom snd i2c_core parport_pc parport shpchp
pci_hotplug usbcore prism2_pci p80211 soundcore pcspkr rtc_cmos rtc_core
rtc_lib evdev tsdev

CPU:    0

EIP:    0060:[<f0c93438>]    Not tainted VLI

EFLAGS: 00010292   (2.6.23-chw-4 #1)

EIP is at videobuf_dma_unmap+0x58/0x60 [videobuf_dma_sg]

eax: 00000029   ebx: efaf50cc   ecx: ffffffff   edx: 00000000

esi: e74c53c0   edi: df511400   ebp: e405ff44   esp: e405fe24

ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068

Process mythbackend (pid: 3304, ti=e405e000 task=eff5a1d0 task.ti=e405e000)

Stack: f0c94218 00000000 19721112 efaf5000 f0c93451 e405fe9d f0dd25a3
00000000

       e15915e0 eff5a220 00000000 e74c53c0 e34fca44 e295d720 eff23448
eacac1f4

       e34fc800 e3ab7000 e15915e0 00000af5 00000000 e34fc4a4 e34fc558
00000000

Call Trace:

 [<f0c93451>] videobuf_sg_dma_unmap+0x11/0x20 [videobuf_dma_sg]

 [<f0dd25a3>] snd_pcm_oss_change_params+0x1f3/0xd80 [snd_pcm_oss]

 [<f0dd353b>] snd_pcm_oss_get_active_substream+0x5b/0x70 [snd_pcm_oss]

 [<c0567c1d>] __mutex_lock_slowpath+0x12d/0x290

 [<f178e564>] snd_card_saa7134_hw_free+0x44/0x70 [saa7134_alsa]

 [<f0dc0f36>] snd_pcm_release_substream+0x36/0x70 [snd_pcm]

 [<f0dd3709>] snd_pcm_oss_release_file+0x19/0x30 [snd_pcm_oss]

 [<f0dd4ee4>] snd_pcm_oss_release+0x44/0xa0 [snd_pcm_oss]

 [<c01854d2>] __fput+0xa2/0x1d0

 [<c01824b7>] filp_close+0x47/0x80

 [<c01838b9>] sys_close+0x69/0xc0

 [<c0104412>] syscall_call+0x7/0xb

 =======================

Code: c7 43 14 00 00 00 00 c7 43 18 00 00 00 00 83 c4 0c 5b c3 c7 44 24 08
12 11 72 19 89 44 24 04 c7 04 24 18 42 c9 f0 e8 b8 65 49 cf <0f> 0b eb fe 0f
0b eb fe 81 ec ec 00 00 00 89 44 24 24 89 e0 e8

EIP: [<f0c93438>] videobuf_dma_unmap+0x58/0x60 [videobuf_dma_sg] SS:ESP
0068:e405fe24

root@mythtv:/home/gjm#

 

root@mythtv:/home/gjm# uname -a

Linux mythtv 2.6.23-chw-4 #1 SMP PREEMPT Mon May 26 14:44:56 PDT 2008 i686
GNU/Linux

 

The function in which the error appears in videobuf-dma-sg.c is this:

 

int videobuf_dma_unmap(struct videobuf_queue* q,struct videobuf_dmabuf *dma)

{

        MAGIC_CHECK(dma->magic, MAGIC_DMABUF); /* this is line 278 in the
last driver I tried */

        if (!dma->sglen)

                return 0;

 

        dma_unmap_sg(q->dev, dma->sglist, dma->nr_pages, dma->direction);

 

        kfree(dma->sglist);

        dma->sglist = NULL;

        dma->sglen = 0;

        return 0;

}

 

If you need any more information, please let me know.

 

Thanks,

 

Gabriel 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
