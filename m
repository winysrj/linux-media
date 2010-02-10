Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:32850 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346Ab0BJCQF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 21:16:05 -0500
Subject: Re: Driver crash on kernel 2.6.32.7.  Interaction between cx8800
 (DVB-S) and USB HVR Hauppauge 950q
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Richard Lemieux <rlemieu@cooptel.qc.ca>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4B70E7DB.7060101@cooptel.qc.ca>
References: <4B70E7DB.7060101@cooptel.qc.ca>
Content-Type: text/plain
Date: Tue, 09 Feb 2010 21:14:51 -0500
Message-Id: <1265768091.3064.109.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-02-08 at 23:43 -0500, Richard Lemieux wrote:
> Hi,
> 
> I got some driver crashes after upgrading to kernel 2.6.32.7.  It seems that
> activating either TBS8920 (DVB-S) and HVR950Q (ATSC) after the other one has
> run (and is no longer in use by an application) triggers a driver crash.
>
> Each device individually works fine (as long as the other one does not run).

Both Ooops below are related to userspace loading of firmware for the
HVR-950Q.


> I don't know how to investigate this by myself, but I am available to help.
> This is not critical.  The system is otherwise stable.
> 
> Here is the last event recorded in syslog.  I activated the DVBS after
> turning off applications running ATSC.
> 
> Feb  8 16:18:16 pc3 kernel: DVB: registering adapter 1 frontend 0 (Auvitek 
> AU8522 QAM/8VSB Frontend)...
> Feb  8 21:37:17 pc3 kernel: cx88[0]/0: unknown tv audio mode [0]
> Feb  8 23:00:45 pc3 kernel: cx88[0]/0: unknown tv audio mode [0]
> Feb  8 23:01:24 pc3 last message repeated 2 times
> Feb  8 23:04:00 pc3 kernel: BUG: unable to handle kernel NULL pointer 
> dereference at 00000004
> Feb  8 23:04:00 pc3 kernel: IP: [<c11ae628>] firmware_loading_store+0x68/0x1a0
> Feb  8 23:04:00 pc3 kernel: *pdpt = 000000003650e001 *pde = 0000000000000000
> Feb  8 23:04:00 pc3 kernel: Oops: 0000 [#1] SMP
> Feb  8 23:04:00 pc3 kernel: last sysfs file: 
> /sys/class/firmware/0000:08:00.0/loading
> Feb  8 23:04:00 pc3 kernel: Modules linked in: xc5000 tuner au8522 au0828 
> videobuf_vmalloc snd_seq rtc hid_logitech ext4 jbd2 crc16 nls_iso8859_1 
> nls_cp437 bsd_comp ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic slhc 
> parport_pc lp parport joydev usb_storage usblp snd_usb_audio snd_usb_lib 
> snd_rawmidi snd_seq_device usbhid snd_hwdep cx24116 cx88_dvb cx88_vp3054_i2c 
> videobuf_dvb dvb_core snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
> snd_pcm_oss cx8802 snd_mixer_oss cx8800 cx88xx snd_pcm ir_common i2c_i801 
> i2c_algo_bit v4l2_common snd_timer tveeprom ohci1394 sky2 ehci_hcd snd videodev 
> v4l1_compat videobuf_dma_sg btcx_risc ieee1394 8250_pnp 8250 serial_core 
> uhci_hcd bitrev nvidia(P) crc32 agpgart videobuf_core soundcore snd_page_alloc 
> i2c_core usbcore sg evdev
> Feb  8 23:04:00 pc3 kernel:
> Feb  8 23:04:00 pc3 kernel: Pid: 6390, comm: firmware.agent Tainted: P 
>   (2.6.32.7 #1) P5E WS Pro
> Feb  8 23:04:00 pc3 kernel: EIP: 0060:[<c11ae628>] EFLAGS: 00010296 CPU: 1
> Feb  8 23:04:00 pc3 kernel: EIP is at firmware_loading_store+0x68/0x1a0
> Feb  8 23:04:00 pc3 kernel: EAX: 00000000 EBX: f66a1140 ECX: 00000002 EDX: 2f1dc161
> Feb  8 23:04:00 pc3 kernel: ESI: f7513440 EDI: f05b8380 EBP: 00000002 ESP: f0c15f1c
> Feb  8 23:04:00 pc3 kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Feb  8 23:04:00 pc3 kernel: Process firmware.agent (pid: 6390, ti=f0c14000 
> task=f6e65850 task.ti=f0c14000)
> Feb  8 23:04:00 pc3 kernel: Stack:
> Feb  8 23:04:00 pc3 kernel:  00000161 80000000 0810b408 c430ed60 c10713d2 
> c11ae5c0 00000002 c13ab7c0
> Feb  8 23:04:00 pc3 kernel: <0> 00000002 c11a6965 00000002 f66dc940 f75242f8 
> c10cc0d9 00000002 0810b408
> Feb  8 23:04:00 pc3 kernel: <0> f66dc954 f7513448 f0c6cac0 00000002 0810b408 
> c10cc040 c1086ff0 f0c15f9c
> Feb  8 23:04:00 pc3 kernel: Call Trace:
> Feb  8 23:04:00 pc3 kernel:  [<c10713d2>] ? handle_mm_fault+0x612/0x9f0
> Feb  8 23:04:00 pc3 kernel:  [<c11ae5c0>] ? firmware_loading_store+0x0/0x1a0
> Feb  8 23:04:00 pc3 kernel:  [<c11a6965>] ? dev_attr_store+0x25/0x40
> Feb  8 23:04:00 pc3 kernel:  [<c10cc0d9>] ? sysfs_write_file+0x99/0x100
> Feb  8 23:04:00 pc3 kernel:  [<c10cc040>] ? sysfs_write_file+0x0/0x100
> Feb  8 23:04:00 pc3 kernel:  [<c1086ff0>] ? vfs_write+0xa0/0x160
> Feb  8 23:04:00 pc3 kernel:  [<c1087171>] ? sys_write+0x41/0x70
> Feb  8 23:04:00 pc3 kernel:  [<c1002e08>] ? sysenter_do_call+0x12/0x26
> Feb  8 23:04:00 pc3 kernel: Code: 04 e8 dd c8 ec ff 8b 53 40 31 c9 8b 43 3c 8b 
> 7b 34 c7 04 24 61 01 00 00 c7 44 24 04 00 00 00 80 e8 8e cf ec ff 89 47 04 8b 43 
> 34 <8b> 78 04 85 ff 0f 84 f4 00 00 00 c7 43 44 00 00 00 00 8d 43 04
> Feb  8 23:04:00 pc3 kernel: EIP: [<c11ae628>] firmware_loading_store+0x68/0x1a0 
> SS:ESP 0068:f0c15f1c
> Feb  8 23:04:00 pc3 kernel: CR2: 0000000000000004
> Feb  8 23:04:00 pc3 kernel: ---[ end trace c07258db2013e403 ]---
> 

So we know the oops happens in
linux/drivers/base/firmware_class.c:firmware_loading_store().  This is
the function that handles the firmware loading status feedback from
userspace.  udev writes "1" to a device specific sysfs node when
firmware loading begins, and writes "0" to that sysfs node when the
firmware copying is completed by udev.

You can use udevadm as root to monitor udev events.
You can examine /lib/udev/firmware.sh to see the script that udev runs
in response to firmware load requests that you see with udevadm.

Anyway here is the source code that Ooops'ed:

/**
 * firmware_loading_store - set value in the 'loading' control file
 * @dev: device pointer
 * @attr: device attribute pointer
 * @buf: buffer to scan for loading control value
 * @count: number of bytes in @buf
 *      
 *      The relevant values are:
 *      
 *       1: Start a load, discarding any previous partial load.
 *       0: Conclude the load and hand the data to the driver code.
 *      -1: Conclude the load with an error and discard any written data.
 **/            
static ssize_t firmware_loading_store(struct device *dev,
                                      struct device_attribute *attr,
                                      const char *buf, size_t count)
{       
        struct firmware_priv *fw_priv = dev_get_drvdata(dev);
        int loading = simple_strtol(buf, NULL, 10);
        int i;

        switch (loading) {
        case 1:
                ...
                break;
        case 0:
               if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
                        vfree(fw_priv->fw->data);
                        fw_priv->fw->data = vmap(fw_priv->pages,
                                                 fw_priv->nr_pages,
                                                 0, PAGE_KERNEL_RO);
                        if (!fw_priv->fw->data) {                              <------------ Ooops here: fw_priv->fw is NULL
                               dev_err(dev, "%s: vmap() failed\n", __func__);
                                goto err;
                        }
                        /* Pages will be freed by vfree() */
                        fw_priv->page_array_size = 0;
               ....


Here's how I know that:

$ echo "00 04 e8 dd c8 ec ff 8b 53 40 31 c9 8b 43 3c 8b 7b 34 c7 04 24
61 01 00 00 c7 44 24 04 00 00 00 80 e8 8e cf ec ff 89 47 04 8b 43 34 8b
78 04 85 ff 0f 84 f4 00 00 00 c7 43 44 00 00 00 00 8d 43 04" | xxd -r -g
1 -c 64 > foo.bin

$ objdump -D -b binary -m i386 foo.bin --adjust-vma=0x3d --start-addr=0x3e

foo.bin:     file format binary

Disassembly of section .data:

0000003e <.data+0x1>:
  3e:	e8 dd c8 ec ff       	call   0xffecc920
  43:	8b 53 40             	mov    0x40(%ebx),%edx;  fw_priv->nr_pages
  46:	31 c9                	xor    %ecx,%ecx;        0
  48:	8b 43 3c             	mov    0x3c(%ebx),%eax;  fw_priv->pages
  4b:	8b 7b 34             	mov    0x34(%ebx),%edi;  fw_priv->fw
  4e:	c7 04 24 61 01 00 00 	movl   $0x161,(%esp);    PAGE_KERNEL_RO
  55:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp); ???
  5c:	80 
  5d:	e8 8e cf ec ff       	call   0xffeccff0;       vmap(fw_priv->pages, fw_priv->nr_pages, 0, PAGE_KERNEL_RO);
  62:	89 47 04             	mov    %eax,0x4(%edi);   fw_priv->fw->data = vmap(fw_priv->pages, fw_priv->nr_pages, 0, PAGE_KERNEL_RO);
  65:	8b 43 34             	mov    0x34(%ebx),%eax;  fw_priv->fw
  68:	8b 78 04             	mov    0x4(%eax),%edi     <--- Ooops here; fw_priv->fw->data and %eax (fw_priv->fw) is NULL
  6b:	85 ff                	test   %edi,%edi;        if (!fw_priv->fw->data) {
  6d:	0f 84 f4 00 00 00    	je     0x167
  73:	c7 43 44 00 00 00 00 	movl   $0x0,0x44(%ebx);  fw_priv->page_array_size = 0;
  7a:	8d 43 04             	lea    0x4(%ebx),%eax


So there seems to be some sort of race condition where fw_priv->fw is
getting deallocated while still being operated upon.

<wild speculation>
This means the xc5000 or au0828 driver or might need to be examined to
see how this race could happen.  Maybe something odd like
xc5000_fwupload being called concurrently? It could be a USB subsystem
thing too.
</wild speculation>

I'm out of my depth on how the HVR-950Q works.  Devin would be the
expert here.


> Here is another event.  I booted in between.  The system is stable otherwise.
> 
> 
> Feb  7 14:15:06 pc3 kernel: DVB: registering adapter 1 frontend 0 (Auvitek
> AU8522 QAM/8VSB Frontend)...
> Feb  7 14:15:30 pc3 udevd-event[15971]: run_program: '/lib/udev/firmware.sh'
> abnormal exit
> Feb  7 14:15:30 pc3 kernel: BUG: unable to handle kernel NULL pointer
> dereference at 00000004
> Feb  7 14:15:30 pc3 kernel: IP: [<c11ae622>] firmware_loading_store+0x62/0x1a0
> Feb  7 14:15:30 pc3 kernel: *pdpt = 0000000036bc4001 *pde = 0000000000000000
> Feb  7 14:15:30 pc3 kernel: Oops: 0002 [#1] SMP
> Feb  7 14:15:30 pc3 kernel: last sysfs file: /sys/class/firmware/7-4/loading
> Feb  7 14:15:30 pc3 kernel: Modules linked in: snd_usb_audio snd_usb_lib
> snd_rawmidi snd_hwdep xc5000 tuner au8522 au0828 videobuf_vmalloc nvidia(P)
> snd_seq snd_seq_device rtc hid_logitech ext4 jbd2 crc16 nls_iso8859_1 nls_cp437
> bsd_comp ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic slhc agpgart
> parport_pc lp parport joydev usb_storage usbhid usblp cx24116 cx88_dvb
> cx88_vp3054_i2c videobuf_dvb dvb_core snd_hda_codec_realtek snd_hda_intel cx8802
> cx8800 snd_hda_codec cx88xx snd_pcm_oss ir_common snd_mixer_oss i2c_algo_bit
> ohci1394 v4l2_common tveeprom i2c_i801 snd_pcm 8250_pnp 8250 serial_core
> videodev v4l1_compat videobuf_dma_sg i2c_core sky2 videobuf_core ehci_hcd
> ieee1394 btcx_risc snd_timer snd bitrev crc32 soundcore snd_page_alloc uhci_hcd
> usbcore sg evdev [last unloaded: nvidia]
> Feb  7 14:15:30 pc3 kernel:
> Feb  7 14:15:30 pc3 kernel: Pid: 15972, comm: firmware.sh Tainted: P
> (2.6.32.7 #1) P5E WS Pro
> Feb  7 14:15:30 pc3 kernel: EIP: 0060:[<c11ae622>] EFLAGS: 00010296 CPU: 1
> Feb  7 14:15:30 pc3 kernel: EIP is at firmware_loading_store+0x62/0x1a0
> Feb  7 14:15:30 pc3 kernel: EAX: 00000000 EBX: f2428ac0 ECX: 00000000 EDX: e19bc000
> Feb  7 14:15:30 pc3 kernel: ESI: ed92fe00 EDI: 00000000 EBP: 00000002 ESP: e19bdf1c
> Feb  7 14:15:30 pc3 kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Feb  7 14:15:30 pc3 kernel: Process firmware.sh (pid: 15972, ti=e19bc000
> task=f6fa2760 task.ti=e19bc000)
> Feb  7 14:15:30 pc3 kernel: Stack:
> Feb  7 14:15:30 pc3 kernel:  00000161 80000000 0810b408 c4ff6dc0 c10713d2
> c11ae5c0 00000002 c13ab7c0
> Feb  7 14:15:30 pc3 kernel: <0> 00000002 c11a6965 00000002 f3f387c0 f147d744
> c10cc0d9 00000002 0810b408
> Feb  7 14:15:30 pc3 kernel: <0> f3f387d4 ed92fe08 ed91d940 00000002 0810b408
> c10cc040 c1086ff0 e19bdf9c
> Feb  7 14:15:30 pc3 kernel: Call Trace:
> Feb  7 14:15:30 pc3 kernel:  [<c10713d2>] ? handle_mm_fault+0x612/0x9f0
> Feb  7 14:15:30 pc3 kernel:  [<c11ae5c0>] ? firmware_loading_store+0x0/0x1a0
> Feb  7 14:15:30 pc3 kernel:  [<c11a6965>] ? dev_attr_store+0x25/0x40
> Feb  7 14:15:30 pc3 kernel:  [<c10cc0d9>] ? sysfs_write_file+0x99/0x100
> Feb  7 14:15:30 pc3 kernel:  [<c10cc040>] ? sysfs_write_file+0x0/0x100
> Feb  7 14:15:30 pc3 kernel:  [<c1086ff0>] ? vfs_write+0xa0/0x160
> Feb  7 14:15:30 pc3 kernel:  [<c1087171>] ? sys_write+0x41/0x70
> Feb  7 14:15:30 pc3 kernel:  [<c1002e08>] ? sysenter_do_call+0x12/0x26
> Feb  7 14:15:30 pc3 kernel: Code: 62 8b 43 34 8b 40 04 e8 dd c8 ec ff 8b 53 40
> 31 c9 8b 43 3c 8b 7b 34 c7 04 24 61 01 00 00 c7 44 24 04 00 00 00 80 e8 8e cf ec
> ff <89> 47 04 8b 43 34 8b 78 04 85 ff 0f 84 f4 00 00 00 c7 43 44 00
> Feb  7 14:15:30 pc3 kernel: EIP: [<c11ae622>] firmware_loading_store+0x62/0x1a0
> SS:ESP 0068:e19bdf1c
> Feb  7 14:15:30 pc3 kernel: CR2: 0000000000000004
> Feb  7 14:15:30 pc3 kernel: ---[ end trace dfa955c34e6458e9 ]---


Same function.  Similar oops as fw_priv->fw is NULL, only this time it
happens two lines of assembly code earlier.  This definitely smells like
a race.

Your ability to reproduce this should be rather limited.  If you know
steps that make it more likely to reproduce, please remember what they
are.

Regards,
Andy


