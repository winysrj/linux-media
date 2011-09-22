Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab1IVPyZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Sep 2011 11:54:25 -0400
From: David Howells <dhowells@redhat.com>
To: mchehab@infradead.org
cc: dhowells@redhat.com, linux-media@vger.kernel.org
Subject: Soft lockup in mb86a16_search()
Date: Thu, 22 Sep 2011 16:53:43 +0100
Message-ID: <21678.1316706823@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


My mythtv receiver machine crashes when I start mythbackend with a soft lockup
warning in mb86a16_search().  Shortly thereafter the machine becomes
unresponsive and has to be reset.  Relevant highlights of dmesg attached
below.

The kernel is Fedora 15's kernel-2.6.40.4-5.fc15.x86_64.

David
---
IR Sony protocol handler initialized
dib0700: loaded with support for 20 different device-types
dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
lirc_dev: IR Remote Control driver registered, major 250 
IR LIRC bridge handler initialized
DVB: registering adapter 1 frontend 0 (DiBcom 3000MC/P)...
MT2060: successfully identified (IF1 = 1257)
DVB: registering adapter 0 frontend 0 (Fujitsu MB86A16 DVB-S)...
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
DVB: registering adapter 2 frontend 0 (DiBcom 3000MC/P)...
MT2060: successfully identified (IF1 = 1243)
input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1e.0/0000:05:00.2/usb3/3-1/rc/rc0/input3
rc0: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1e.0/0000:05:00.2/usb3/3-1/rc/rc0
dvb-usb: schedule remote query interval to 50 msecs.
dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully initialized and connected.
dib0700: rc submit urb failed

usbcore: registered new interface driver dvb_usb_dib0700
mb86a16_write: writing to [0x08],Reg[0x16],Data[0x80]
mb86a16_write: writing to [0x08],Reg[0x1e],Data[0x00]
mb86a16_write: writing to [0x08],Reg[0x20],Data[0x04]
mb86a16_write: writing to [0x08],Reg[0x16],Data[0x80]
mb86a16_write: writing to [0x08],Reg[0x1e],Data[0x00]
mb86a16_write: writing to [0x08],Reg[0x20],Data[0x04]
mb86a16_write: writing to [0x08],Reg[0x16],Data[0x80]
mb86a16_write: writing to [0x08],Reg[0x1e],Data[0x00]
mb86a16_write: writing to [0x08],Reg[0x20],Data[0x04]
mb86a16_write: writing to [0x08],Reg[0x16],Data[0x80]
mb86a16_write: writing to [0x08],Reg[0x1e],Data[0x00]
mb86a16_write: writing to [0x08],Reg[0x20],Data[0x04]
mb86a16_write: writing to [0x08],Reg[0x16],Data[0x80]
mb86a16_write: writing to [0x08],Reg[0x1e],Data[0x00]
mb86a16_write: writing to [0x08],Reg[0x20],Data[0x04]
mb86a16_write: writing to [0x08],Reg[0x16],Data[0x80]
mb86a16_write: writing to [0x08],Reg[0x1e],Data[0x00]
mb86a16_write: writing to [0x08],Reg[0x20],Data[0x04]
mb86a16_write: writing to [0x08],Reg[0x16],Data[0x80]
mb86a16_write: writing to [0x08],Reg[0x1e],Data[0x00]
mb86a16_write: writing to [0x08],Reg[0x20],Data[0x04]
mb86a16_write: writing to [0x08],Reg[0x16],Data[0x80]
mb86a16_write: writing to [0x08],Reg[0x1e],Data[0x00]
mb86a16_write: writing to [0x08],Reg[0x20],Data[0x04]
mb86a16_write: writing to [0x08],Reg[0x16],Data[0x80]
mb86a16_write: writing to [0x08],Reg[0x1e],Data[0x00]
mb86a16_write: writing to [0x08],Reg[0x20],Data[0x04]
mb86a16_set_fe: freq=0 Mhz, symbrt=0 Ksps
mb86a16_write: writing to [0x08],Reg[0x32],Data[0x02]
mb86a16_write: writing to [0x08],Reg[0x06],Data[0xdf]
mb86a16_write: writing to [0x08],Reg[0x0a],Data[0x3d]
mb86a16_write: writing to [0x08],Reg[0x2b],Data[0x00]
mb86a16_write: writing to [0x08],Reg[0x2c],Data[0x00]
mb86a16_write: writing to [0x08],Reg[0x58],Data[0x00]
mb86a16_write: writing to [0x08],Reg[0x59],Data[0x00]
mb86a16_write: writing to [0x08],Reg[0x08],Data[0x16]
mb86a16_write: writing to [0x08],Reg[0x2f],Data[0x21]
mb86a16_write: writing to [0x08],Reg[0x39],Data[0x38]
mb86a16_write: writing to [0x08],Reg[0x3d],Data[0x00]
mb86a16_write: writing to [0x08],Reg[0x3e],Data[0x1c]
mb86a16_write: writing to [0x08],Reg[0x3f],Data[0x20]
mb86a16_write: writing to [0x08],Reg[0x40],Data[0x1e]
mb86a16_write: writing to [0x08],Reg[0x41],Data[0x23]
mb86a16_write: writing to [0x08],Reg[0x54],Data[0xff]
mb86a16_write: writing to [0x08],Reg[0x00],Data[0x00]
mb86a16_write: writing to [0x08],Reg[0x2d],Data[0x1a]
mb86a16_write: writing to [0x08],Reg[0x49],Data[0x7a]
mb86a16_write: writing to [0x08],Reg[0x2a],Data[0x26]
mb86a16_write: writing to [0x08],Reg[0x36],Data[0x06]
mb86a16_write: writing to [0x08],Reg[0x33],Data[0x00]
mb86a16_write: writing to [0x08],Reg[0x03],Data[0x17]
mb86a16_write: writing to [0x08],Reg[0x04],Data[0x00]
mb86a16_write: writing to [0x08],Reg[0x05],Data[0x00]
BUG: soft lockup - CPU#1 stuck for 22s! [kdvb-ad-0-fe-0:2831]
Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq mperf w83627ehf hwmon_vid coretemp rc_dib0700_rc5 xfs mb86a16 mt2060 ir_lirc_codec lirc_dev dvb_usb_dib0700 dib7000p ir_sony_decoder dib0090 dib7000m dib0070 dvb_usb dib8000 dib9000 dib3000mc dibx000_common ir_jvc_decoder ir_rc6_decoder iTCO_wdt atl1e i2c_i801 iTCO_vendor_support ir_rc5_decoder microcode mantis mantis_core dvb_core ir_nec_decoder asus_atk0110 rc_core ipv6 pata_acpi ata_generic pata_jmicron nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core mxm_wmi wmi video [last unloaded: scsi_wait_scan]
CPU 1 
Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq mperf w83627ehf hwmon_vid coretemp rc_dib0700_rc5 xfs mb86a16 mt2060 ir_lirc_codec lirc_dev dvb_usb_dib0700 dib7000p ir_sony_decoder dib0090 dib7000m dib0070 dvb_usb dib8000 dib9000 dib3000mc dibx000_common ir_jvc_decoder ir_rc6_decoder iTCO_wdt atl1e i2c_i801 iTCO_vendor_support ir_rc5_decoder microcode mantis mantis_core dvb_core ir_nec_decoder asus_atk0110 rc_core ipv6 pata_acpi ata_generic pata_jmicron nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core mxm_wmi wmi video [last unloaded: scsi_wait_scan]

Pid: 2831, comm: kdvb-ad-0-fe-0 Not tainted 2.6.40.4-5.fc15.x86_64 #1 System manufacturer System Product Name/P5Q PRO TURBO
RIP: 0010:[<ffffffffa021e69d>]  [<ffffffffa021e69d>] mb86a16_set_fe+0x3d6/0x19c5 [mb86a16]
RSP: 0018:ffff880037a63c30  EFLAGS: 00000217
RAX: 0000000000000bb8 RBX: ffff880037a63bf0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8801287900b0
RBP: ffff880037a63e30 R08: 0000000000000000 R09: 0000000000000400
R10: 0000000000000400 R11: ffff880128790090 R12: ffffffff8148f20e
R13: 0000000000000000 R14: 0000000000002000 R15: ffff8801273f1c00
FS:  0000000000000000(0000) GS:ffff88012fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000378f6ab9d0 CR3: 0000000001a03000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kdvb-ad-0-fe-0 (pid: 2831, threadinfo ffff880037a62000, task ffff880128a75cc0)
Stack:
 0000000000000000 0000000000000000 0000000000000000 ffff880128a75cc0
 0000000027d40000 00000000000001f4 0000000000000000 0000000301a76080
 ffff880000000000 ffffffff810451ae ffff880127d40048 7c51ccf02fc925b0
Call Trace:
 [<ffffffff810451ae>] ? perf_event_task_sched_out+0x29/0x61
 [<ffffffff81486e97>] ? schedule_timeout+0xb0/0xde
 [<ffffffff810834ff>] ? arch_local_irq_save+0x15/0x1b
 [<ffffffffa021fcc1>] mb86a16_search+0x35/0x80 [mb86a16]
 [<ffffffffa01735f4>] dvb_frontend_thread+0x40c/0x59d [dvb_core]
 [<ffffffff81070566>] ? remove_wait_queue+0x3a/0x3a
 [<ffffffffa01731e8>] ? dvb_frontend_open+0x359/0x359 [dvb_core]
 [<ffffffff8106fe77>] kthread+0x84/0x8c
 [<ffffffff8148f964>] kernel_thread_helper+0x4/0x10
 [<ffffffff8106fdf3>] ? kthread_worker_fn+0x148/0x148
 [<ffffffff8148f960>] ? gs_change+0x13/0x13
Code: 00 00 00 00 89 85 40 fe ff ff 89 c8 99 f7 fe 8b 95 40 fe ff ff 05 b8 0b 00 00 44 01 fa 81 fa 70 ce 20 00 7f 1e ff 85 5c fe ff ff 
 fa 70 ce 20 00 74 10 69 b3 c8 03 00 00 18 fc ff ff 01 d6 39 
Call Trace:
 [<ffffffff810451ae>] ? perf_event_task_sched_out+0x29/0x61
 [<ffffffff81486e97>] ? schedule_timeout+0xb0/0xde
 [<ffffffff810834ff>] ? arch_local_irq_save+0x15/0x1b
 [<ffffffffa021fcc1>] mb86a16_search+0x35/0x80 [mb86a16]
 [<ffffffffa01735f4>] dvb_frontend_thread+0x40c/0x59d [dvb_core]
 [<ffffffff81070566>] ? remove_wait_queue+0x3a/0x3a
 [<ffffffffa01731e8>] ? dvb_frontend_open+0x359/0x359 [dvb_core]
 [<ffffffff8106fe77>] kthread+0x84/0x8c
 [<ffffffff8148f964>] kernel_thread_helper+0x4/0x10
 [<ffffffff8106fdf3>] ? kthread_worker_fn+0x148/0x148
 [<ffffffff8148f960>] ? gs_change+0x13/0x13
