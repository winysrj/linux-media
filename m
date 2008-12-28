Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Andy Walls <awalls@radix.net>
To: Mark Jenks <mjenks1968@gmail.com>
In-Reply-To: <e5df86c90812270840w2fd6be64l40f9838aef23db4f@mail.gmail.com>
References: <e5df86c90812270840w2fd6be64l40f9838aef23db4f@mail.gmail.com>
Date: Sun, 28 Dec 2008 16:36:16 -0500
Message-Id: <1230500176.3120.60.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problems with kernel oops when installing HVR-1800.
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

On Sat, 2008-12-27 at 10:40 -0600, Mark Jenks wrote:
> G'morning all!  (at least it's morning here.)
> 
> I have a running Mythtv server that is running Suse 10.3 with a
> hvr-1250 just fine on Kernel 2.6.24, and haven't had any problems at
> all.
> 
> I tried to install a hvr-1800 in it yesterday, and I get a kernel oops
> on it and X won't start.   I compiled up a 2.6.27.10 kernel for it,
> and moved to that, and I still get the oops.    Checked my vmalloc and
> I am fine, but increased it anyways to 384 just for grins.
> 
> I compiled v4l-dvb-cae6de452897 up against the 2.6.24, and the 2.6.27
> kernels without any changes.   Server boots just fine without the
> 1800, but with I get the oops.
> 
> The only thing that I can see, is that the 1250 and the 1800 look to
> be using the same interrupt.
> 
> Here is more than enough debug info, I hope.  :)
> 
> Thanks!
> 
> -Mark
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at 000001a0
> IP: [<f8e5a594>] :cx23885:video_open+0x2c/0x150
> *pde = 00000000
> Oops: 0000 [#1] SMP
> Modules linked in: iptable_filter ip_tables ip6_tables x_tables
> cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8
> xfs loop dm_mod cx25840 mt2131 s5h1409 nvidia(P) cx23885
> v4l2_compat_ioctl32 cx2341x videobuf_dma_sg button videobuf_dvb
> dvb_core videobuf_core v4l2_common snd_hda_intel snd_usb_audio
> snd_usb_lib snd_mpu401 snd_cs4232 snd_opl3_lib snd_cs4231_lib snd_pcm
> ohci1394 videodev v4l1_compat osst agpgart btcx_risc rtc_cmos
> i2c_nforce2 snd_timer ieee1394 snd_mpu401_uart tveeprom sr_mod
> snd_hwdep i2c_core rtc_core rtc_lib parport_pc parport st lirc_mceusb2
> snd_rawmidi snd_seq_device snd k8temp hwmon cdrom forcedeth soundcore
> snd_page_alloc lirc_dev sg usbhid hid ff_memless ohci_hcd ehci_hcd
> usbcore sd_mod edd ext3 mbcache jbd fan aic7xxx scsi_transport_spi
> sata_nv pata_amd libata scsi_mod dock thermal processor thermal_sys
> 
> Pid: 3178, comm: X Tainted: P          (2.6.27.10-default #3)
> EIP: 0060:[<f8e5a594>] EFLAGS: 00013287 CPU: 1
> EIP is at video_open+0x2c/0x150 [cx23885]
> EAX: 00000000 EBX: 00000000 ECX: f7a9f000 EDX: f7a0e000
> ESI: 00000000 EDI: 00000000 EBP: 00000000 ESP: f764de90
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process X (pid: 3178, ti=f764c000 task=f7398c00 task.ti=f764c000)
> Stack: f7a6e540 00000000 f7b16538 00000000 f7bc30a0 c016bee5 f7a6e540
> 00000000
>        f7a6e540 f7bc30a0 00000000 c016bdd9 c01683cd f701ebc0 f6d756c0
> f764df14
>        f7a6e540 f764df14 00000003 c01684d8 f7a6e540 00000000 00000000
> f764df14
> Call Trace:
>  [<c016bee5>] chrdev_open+0x10c/0x122
>  [<c016bdd9>] chrdev_open+0x0/0x122
>  [<c01683cd>] __dentry_open+0x10d/0x1fc
>  [<c01684d8>] nameidata_to_filp+0x1c/0x2c
>  [<c0172986>] do_filp_open+0x33d/0x63e
>  [<f9b7d8ce>] _nv004117rm+0x9/0x12 [nvidia]
>  [<c01582f8>] handle_mm_fault+0x2b3/0x5dd
>  [<c017ab2d>] alloc_fd+0x57/0xd3
>  [<c01681e8>] do_sys_open+0x3f/0xb8
>  [<c01682a5>] sys_open+0x1e/0x23
>  [<c01037ad>] sysenter_do_call+0x12/0x21
>  =======================
> Code: 31 ed 57 31 ff 56 31 f6 53 83 ec 04 89 14 24 8b 58 34 e8 16 18
> 46 c7 8b 15 d0 ad e6 f8 81 e3 ff ff 0f 00 eb 49 8b 82 84 0d 00 00 <39>
> 98 a0 01 00 00 75 07 89 d6 bf 01 00 00 00 8b 82 88 0d 00 00
> EIP: [<f8e5a594>] video_open+0x2c/0x150 [cx23885] SS:ESP 0068:f764de90
> ---[ end trace c26ff07c077248e0 ]---

Mark, 

Using the same interrupt isn't the problem.

Here's the gory translation of the Ooops data:


The problem is tripped in cx23885-video.c:video_open():

 777 static int video_open(struct inode *inode, struct file *file)
 778 {
 779         int minor = iminor(inode);
 780         struct cx23885_dev *h, *dev = NULL;
 781         struct cx23885_fh *fh;
 782         struct list_head *list;
 783         enum v4l2_buf_type type = 0;
 784         int radio = 0;
 785 
 786         lock_kernel();
 787         list_for_each(list, &cx23885_devlist) {
 788                 h = list_entry(list, struct cx23885_dev, devlist);
 789                 if (h->video_dev->minor == minor) {
 790                         dev  = h;
 791                         type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 792                 }
 793                 if (h->vbi_dev &&
 794                    h->vbi_dev->minor == minor) {
 795                         dev  = h;
 796                         type = V4L2_BUF_TYPE_VBI_CAPTURE;
 797                 }
[...]

Also note the list_entry()  & list_for_each() macro definitions:

425 #define list_entry(ptr, type, member) \
426         container_of(ptr, type, member)
[...]
444 #define list_for_each(pos, head) \
445         for (pos = (head)->next; prefetch(pos->next), pos != (head); \
446                 pos = pos->next)



The code bytes dumped in the Oops disassemble to:

   1:   31 ed                   xor    %ebp,%ebp
   3:   57                      push   %edi
   4:   31 ff                   xor    %edi,%edi
   6:   56                      push   %esi
   7:   31 f6                   xor    %esi,%esi
   9:   53                      push   %ebx
   a:   83 ec 04                sub    $0x4,%esp
   d:   89 14 24                mov    %edx,(%esp)
  10:   8b 58 34                mov    0x34(%eax),%ebx   <--- line 779: minor = iminor(inode);
  13:   e8 16 18 46 c7          call   0xc746182e        <--- line 786: lock_kernel()
  18:   8b 15 d0 ad e6 f8       mov    0xf8e6add0,%edx   <--- line 445: list = (&cx23885_devlist)->next;
  1e:   81 e3 ff ff 0f 00       and    $0xfffff,%ebx     <--- line 779: minor = iminor(inode);
  24:   eb 49                   jmp    0x6f              <--- jmp to for loop condition check: line 445: prefetch(list->next), list != &cx23885_devlist;
  26:   8b 82 84 0d 00 00       mov    0xd84(%edx),%eax  <--- line 426 & 789: h = container_of(list, struct cx23885_dev, devlist); if (h->video_dev...
  2c:   39 98 a0 01 00 00       cmp    %ebx,0x1a0(%eax)  <--- Ooops occurs here: line 789: if (h->video_dev->minor == minor) {
  32:   75 07                   jne    0x3b
  34:   89 d6                   mov    %edx,%esi         <--- line 790: dev = h;
  36:   bf 01 00 00 00          mov    $0x1,%edi         <--- line 791: type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
  3b:   8b 82 88 0d 00 00       mov    0xd88(%edx),%eax  <--- line 793: if (h->vbi_dev ...


So "h->video_dev" (I think) was "NULL" in this call to video_open().
This is a problem with the creation or manipulation of the "struct
cx23885_dev" members of the "cx23885_devlist".

This appears to be a problem with this list iteration in
cx23885-video.c:video_open().

If one of these devices only has DVB support and no analog V4L support,
then it would make sense why one of them would have "h->video_dev" set
to NULL.  The device shouldn't have a V4L2 "video_dev" if it doesn't
support analog (V4L2) devices.  I believe the 1800 supports analog video
but the 1250 does not (someone correct me on this if I'm wrong - I'm no
expert on these devices).

The iteration loop in video_open() needs to be careful about NULL
pointer dereference of h->video_dev for DVB only devices.

Try this patch:

diff -r cae6de452897 linux/drivers/media/video/cx23885/cx23885-video.c
--- a/linux/drivers/media/video/cx23885/cx23885-video.c Fri Dec 26 08:07:39 2008 -0200
+++ b/linux/drivers/media/video/cx23885/cx23885-video.c Sun Dec 28 16:34:04 2008 -0500
@@ -786,7 +786,8 @@ static int video_open(struct inode *inod
        lock_kernel();
        list_for_each(list, &cx23885_devlist) {
                h = list_entry(list, struct cx23885_dev, devlist);
-               if (h->video_dev->minor == minor) {
+               if (h->video_dev &&
+                   h->video_dev->minor == minor) {
                        dev  = h;
                        type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
                }



If it doesn't work you'll need to find someone with access to a HVR-1250
and HVR-1800 in the same machine to do more interactive debugging (Andy
Walls' thought experiments can only take one so far....).
  
I can't help further since I don't have any CX23885 based cards.

Regards,
Andy

> # dmesg | grep cx
> cx23885 driver version 0.0.1 loaded
> cx23885 0000:02:00.0: PCI INT A -> Link[APC5] -> GSI 16 (level, low)
> -> IRQ 16
> CORE cx23885[0]: subsystem: 0070:7911, board: Hauppauge WinTV-HVR1250
> [card=3,autodetected]
> cx23885[0]: warning: unknown hauppauge model #0
> cx23885[0]: hauppauge eeprom: model=0
> cx23885_dvb_register() allocating 1 frontend(s)
> cx23885[0]: cx23885 based dvb card
> DVB: registering new adapter (cx23885[0])
> cx23885_dev_checkrevision() Hardware revision = 0xc0
> cx23885[0]/0: found at 0000:02:00.0, rev: 3, irq: 16, latency: 0,
> mmio: 0xfd400000
> cx23885 0000:02:00.0: setting latency timer to 64
> cx23885 0000:03:00.0: PCI INT A -> Link[APC5] -> GSI 16 (level, low)
> -> IRQ 16
> CORE cx23885[1]: subsystem: 0070:7801, board: Hauppauge WinTV-HVR1800
> [card=2,autodetected]
> cx23885[1]: hauppauge eeprom: model=78521
> cx25840' 4-0044: cx25  0-21 found @ 0x88 (cx23885[0])
> cx25840' 7-0044: cx25  0-21 found @ 0x88 (cx23885[1])
> cx23885[1]/0: registered device video0 [v4l2]
> cx23885[1]: registered device video1 [mpeg]
> cx23885_dvb_register() allocating 1 frontend(s)
> cx23885[1]: cx23885 based dvb card
> DVB: registering new adapter (cx23885[1])
> cx23885_dev_checkrevision() Hardware revision = 0xb1
> cx23885[1]/0: found at 0000:03:00.0, rev: 15, irq: 16, latency: 0,
> mmio: 0xfd600000
> cx23885 0000:03:00.0: setting latency timer to 64
> 
> # dmesg | grep DVB
> DVB: registering new adapter (cx23885[0])
> DVB: registering adapter 0 frontend 671089123 (Samsung S5H1409
> QAM/8VSB Frontend)...
> tveeprom 5-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
> DVB: registering new adapter (cx23885[1])
> DVB: registering adapter 1 frontend 0 (Samsung S5H1409 QAM/8VSB
> Frontend)...
> 
> 
> 
> # ls -l vid*
> lrwxrwxrwx 1 root root      6 Dec 27 03:35 video -> video0
> crw-rw---- 1 root video 81, 0 Dec 27 03:35 video0
> crw-rw---- 1 root video 81, 1 Dec 27 03:35 video1
> 
> 
> # ls -lR dvb*
> dvb:
> total 0
> drwxr-xr-x 2 root root 120 Dec 27 03:35 adapter0
> drwxr-xr-x 2 root root 120 Dec 27 03:35 adapter1
> 
> dvb/adapter0:
> total 0
> crw-rw---- 1 root video 212, 1 Dec 27 03:35 demux0
> crw-rw---- 1 root video 212, 2 Dec 27 03:35 dvr0
> crw-rw---- 1 root video 212, 0 Dec 27 03:35 frontend0
> crw-rw---- 1 root video 212, 3 Dec 27 03:35 net0
> 
> dvb/adapter1:
> total 0
> crw-rw---- 1 root video 212, 5 Dec 27 03:35 demux0
> crw-rw---- 1 root video 212, 6 Dec 27 03:35 dvr0
> crw-rw---- 1 root video 212, 4 Dec 27 03:35 frontend0
> crw-rw---- 1 root video 212, 7 Dec 27 03:35 net0
> 
>  # cat /proc/meminfo
> MemTotal:      3115468 kB
> MemFree:       2787964 kB
> Buffers:          9580 kB
> Cached:         224572 kB
> SwapCached:          0 kB
> Active:         106360 kB
> Inactive:       185368 kB
> HighTotal:     2489280 kB
> HighFree:      2191700 kB
> LowTotal:       626188 kB
> LowFree:        596264 kB
> SwapTotal:     2104504 kB
> SwapFree:      2104504 kB
> Dirty:            2000 kB
> Writeback:           0 kB
> AnonPages:       57640 kB
> Mapped:          27928 kB
> Slab:            14800 kB
> SReclaimable:     8112 kB
> SUnreclaim:       6688 kB
> PageTables:        972 kB
> NFS_Unstable:        0 kB
> Bounce:              0 kB
> WritebackTmp:        0 kB
> CommitLimit:   3662236 kB
> Committed_AS:   321112 kB
> VmallocTotal:   376824 kB
> VmallocUsed:     22080 kB
> VmallocChunk:   354048 kB
> HugePages_Total:     0
> HugePages_Free:      0
> HugePages_Rsvd:      0
> HugePages_Surp:      0
> Hugepagesize:     4096 kB
> DirectMap4k:     20480 kB
> DirectMap4M:    634880 kB
> 
> # cat /proc/interrupts
>            CPU0       CPU1
>   0:         43          1   IO-APIC-edge      timer
>   1:          0          8   IO-APIC-edge      i8042
>   7:          1          0   IO-APIC-edge      parport0
>   8:          0         79   IO-APIC-edge      rtc0
>   9:          0          0   IO-APIC-fasteoi   acpi
>  10:          0          0   IO-APIC-edge      MPU401 UART
>  12:          0        114   IO-APIC-edge      i8042
>  14:          0          0   IO-APIC-edge      pata_amd
>  15:          8         70   IO-APIC-edge      pata_amd
>  16:          0         14   IO-APIC-fasteoi   cx23885[0], cx23885[1]
>  17:          4         55   IO-APIC-fasteoi   aic7xxx
>  19:          0          3   IO-APIC-fasteoi   ohci1394
>  20:          0          4   IO-APIC-fasteoi   ehci_hcd:usb2
>  21:         50        639   IO-APIC-fasteoi   ohci_hcd:usb1
>  22:          0          0   IO-APIC-fasteoi   sata_nv
>  23:       4394       9058   IO-APIC-fasteoi   sata_nv, eth0
> NMI:          0          0   Non-maskable interrupts
> LOC:       6058       6020   Local timer interrupts
> RES:       3291       1978   Rescheduling interrupts
> CAL:       2402        122   function call interrupts
> TLB:        261        129   TLB shootdowns
> TRM:          0          0   Thermal event interrupts
> SPU:          0          0   Spurious interrupts
> ERR:          1
> MIS:          0
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
