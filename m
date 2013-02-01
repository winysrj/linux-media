Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:63773 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab3BAUXF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 15:23:05 -0500
Received: by mail-ee0-f52.google.com with SMTP id b15so2286982eek.39
        for <linux-media@vger.kernel.org>; Fri, 01 Feb 2013 12:23:03 -0800 (PST)
Message-ID: <510C2424.1050904@gmail.com>
Date: Fri, 01 Feb 2013 21:23:00 +0100
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: j@jannau.net, jarod@redhat.com, 699470@bugs.debian.org
Subject: [PATCH] crystalhd git.linuxtv.org kernel driver: FIX kernel unhandled
 paging request BUG triggered by multithreaded or faulty apps
References: <50E3E643.7070701@gmail.com> <50E5A116.9070307@schinagl.nl> <50E8203C.20603@gmail.com> <50EB5B44.6020603@gmail.com> <50EF6042.7010908@gmail.com>
In-Reply-To: <50EF6042.7010908@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060603020607030507070802"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060603020607030507070802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch should pass the 3rd test case of this bug (kernel unhandled paging request) and maybe the PM resume issue, too:

21370-Feb  1 18:39:52 tom3 kernel: [59853.620636] crystalhd 0000:03:00.0: Opening new user[0] handle
21371-Feb  1 18:39:52 tom3 kernel: [59853.875306] crystalhd 0000:03:00.0: Closing user[0] handle with mode ffffffff
21372-Feb  1 18:39:52 tom3 kernel: [59854.079584] crystalhd 0000:03:00.0: Opening new user[0] handle
21373-Feb  1 18:39:52 tom3 kernel: [59854.079607] crystalhd 0000:03:00.0: Opening new user[0] handle
21374-Feb  1 18:39:52 tom3 kernel: [59854.079633] crystalhd 0000:03:00.0: Closing user[0] handle with mode ffffffff
21375-Feb  1 18:39:52 tom3 kernel: [59854.080022] crystalhd 0000:03:00.0: Opening new user[0] handle
21376:Feb  1 18:39:52 tom3 kernel: [59854.283228] BUG: unable to handle kernel paging request at 0000071e00000000
21377-Feb  1 18:39:52 tom3 kernel: [59854.283358] IP: [<0000071e00000000>] 0x71dffffffff
21378-Feb  1 18:39:52 tom3 kernel: [59854.283447] PGD 0
21379-Feb  1 18:39:52 tom3 kernel: [59854.283490] Oops: 0010 [#1] PREEMPT SMP
21380-Feb  1 18:39:52 tom3 kernel: [59854.283575] CPU 0
21381-Feb  1 18:39:52 tom3 kernel: [59854.283609] Modules linked in: crystalhd(O) nfs fscache uinput parport_pc ppdev lp parport bluetooth nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs acpi_cpufreq mperf cpufreq_powersave cpufreq_stats cpufreq_conservative cpufreq_performance cpufreq_ondemand freq_table fuse dm_mod ext3 jbd pciehp arc4 ath5k ath mac80211 snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_usb_audio snd_pcm_oss cfg80211 thinkpad_acpi snd_mixer_oss snd_hwdep snd_pcm snd_usbmidi_lib snd_seq_dummy snd_seq_oss rfkill snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer pcmcia snd_seq_device gspca_zc3xx gspca_main snd yenta_socket psmouse pcmcia_rsrc videodev tpm_tis tpm tpm_bios v4l2_compat_ioctl32 pcmcia_core i2c_i801 nvram pcspkr usb_storage soundcore serio_raw snd_page_alloc rtc_cmos wmi ac battery processor evdev nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_limit xt_tcpudp iptable_filte
r ip_tables x_tables ext4 mbcach
21382-Feb  1 18:39:52 tom3 kernel: e jbd2 crc16 usbhid hid sg sr_mod sd_mod cdrom crc_t10dif ata_generic uhci_hcd ahci libahci xhci_hcd ata_piix libata ehci_hcd atkbd thermal e1000e usbcore usb_common [last unloaded: crystalhd]
21383-Feb  1 18:39:52 tom3 kernel: [59854.284016]
21384-Feb  1 18:39:52 tom3 kernel: [59854.284016] Pid: 12285, comm: matroskademux0: Tainted: G           O 3.2.37-dirty #8 LENOVO 7735Y1T/7735Y1T
21385-Feb  1 18:39:52 tom3 kernel: [59854.284016] RIP: 0010:[<0000071e00000000>]  [<0000071e00000000>] 0x71dffffffff
21386-Feb  1 18:39:52 tom3 kernel: [59854.284016] RSP: 0018:ffff8800164d3b50  EFLAGS: 00010292
21387-Feb  1 18:39:52 tom3 kernel: [59854.284016] RAX: 000000000000007f RBX: ffff880004b9a400 RCX: 0000000000000000
21388-Feb  1 18:39:52 tom3 kernel: [59854.284016] RDX: 0000000000000001 RSI: 0000000000340000 RDI: ffff88000f437400
21389-Feb  1 18:39:52 tom3 kernel: [59854.284016] RBP: ffff8800164d3b68 R08: 0000000000000001 R09: 0000000000000000
21390-Feb  1 18:39:52 tom3 kernel: [59854.284016] R10: 0000000000000000 R11: ffff8800084d86c0 R12: ffff88007c256090
21391-Feb  1 18:39:52 tom3 kernel: [59854.284016] R13: ffff88000f437400 R14: ffff88000f4374d0 R15: ffffffffa0489f20
21392-Feb  1 18:39:52 tom3 kernel: [59854.284016] FS:  00007f70d559c700(0000) GS:ffff88007f400000(0000) knlGS:0000000000000000
21393-Feb  1 18:39:52 tom3 kernel: [59854.284016] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
21394-Feb  1 18:39:52 tom3 kernel: [59854.284016] CR2: 0000071e00000000 CR3: 00000000339b1000 CR4: 00000000000006f0
21395-Feb  1 18:39:52 tom3 kernel: [59854.284016] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
21396-Feb  1 18:39:52 tom3 kernel: [59854.284016] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
21397-Feb  1 18:39:52 tom3 kernel: [59854.284016] Process matroskademux0: (pid: 12285, threadinfo ffff8800164d2000, task ffff8800084d8000)
21398-Feb  1 18:39:52 tom3 kernel: [59854.284016] Stack:
21399-Feb  1 18:39:52 tom3 kernel: [59854.284016]  ffffffffa047df98 ffff8800164d3b88 ffff880004b9a400 ffff8800164d3b88
21400-Feb  1 18:39:52 tom3 kernel: [59854.284016]  ffffffffa047e48b ffff880004b9a400 ffff88007c256090 ffff8800164d3bb8
21401-Feb  1 18:39:52 tom3 kernel: [59854.284016]  ffffffffa047c6fa 0000000000000000 ffff88000f4374c0 0000000000000000
21402-Feb  1 18:39:52 tom3 kernel: [59854.284016] Call Trace:
21403-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffffa047df98>] ? crystalhd_link_soft_rst+0x28/0x80 [crystalhd]
21404-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffffa047e48b>] crystalhd_link_start_device+0xcb/0x150 [crystalhd]
21405-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffffa047c6fa>] crystalhd_hw_open+0x23a/0x400 [crystalhd]
21406-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffffa047a760>] crystalhd_user_open+0x160/0x180 [crystalhd]
21407-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffff811621d4>] ? chrdev_open+0x64/0x290
21408-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffffa0476377>] chd_dec_open+0x67/0x110 [crystalhd]
21409-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffff811622c0>] chrdev_open+0x150/0x290
21410-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffff8115ee98>] ? files_lglock_local_unlock+0x48/0x70
21411-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffff81162170>] ? register_chrdev_region+0xc0/0xc0
21412-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffff8115c752>] __dentry_open+0x242/0x400
21413-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffff81493495>] ? _raw_spin_unlock+0x35/0x60
21414-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffff811f5120>] ? devcgroup_seq_read+0x150/0x150
21415-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffff8115ca11>] nameidata_to_filp+0x71/0x80
21416-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffff8116b4a8>] do_last+0x3f8/0x7f0
21417-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffff8116c9b5>] path_openat+0xd5/0x3c0
21418-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffff8116cdb9>] do_filp_open+0x49/0xa0
21419-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffff81493495>] ? _raw_spin_unlock+0x35/0x60
21420-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffff8117acda>] ? alloc_fd+0xfa/0x140
21421-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffff8115cc08>] do_sys_open+0x108/0x1f0
21422-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffff8115cd30>] sys_open+0x20/0x30
21423-Feb  1 18:39:52 tom3 kernel: [59854.284016]  [<ffffffff8149ad6b>] system_call_fastpath+0x16/0x1b
21424-Feb  1 18:39:52 tom3 kernel: [59854.284016] Code:  Bad RIP value.
21425-Feb  1 18:39:52 tom3 kernel: [59854.284016] RIP  [<0000071e00000000>] 0x71dffffffff
21426-Feb  1 18:39:52 tom3 kernel: [59854.284016]  RSP <ffff8800164d3b50>
21427-Feb  1 18:39:52 tom3 kernel: [59854.284016] CR2: 0000071e00000000
21428-Feb  1 18:39:52 tom3 kernel: [59854.342607] ---[ end trace f9fc7381abc03c15 ]---
21429-Feb  1 18:39:55 tom3 kernel: [59856.776490] start_capture: pause_th:12, resume_th:5
21430-Feb  1 18:39:55 tom3 kernel: [59856.927007] crystalhd 0000:03:00.0: [FMT CH] PIB:0 1 420 2 780 438 780 0 0 0
21431-Feb  1 18:39:55 tom3 kernel: [59857.031972] crystalhd 0000:03:00.0: MISSING 3 PICTURES
21432-Feb  1 19:25:07 tom3 kernel: [62569.274438] crystalhd 0000:03:00.0: Closing user[0] handle with mode 1c200
21433-Feb  1 19:25:15 tom3 kernel: [62576.649821] ------------[ cut here ]------------

Increased sys usage with totem with the patch could be a sign that something is wrong due to blocking pointer checks and debian stable

$ transmageddon
Traceback (most recent call last):
   File "transmageddon.py", line 676, in on_presetchoice_changed
     self.devicename= self.presetchoices[presetchoice]
KeyError: 'Keine Voreinstellungen'
Running DIL (3.22.0) Version
DtsDeviceOpen: Opening HW in mode 0
Clock set to 180
DtsDrvCmd Failed with status -1
DtsPushFwBinToLink: DeviceIoControl Failed
DtsPushAuthFwToLink: Failed to download firmware
DtsSetupHardware: Failed from Open
DtsGetDriveStats: Ioctl failed: 1
...
txThreadProc: Got status 1 from GetDriverStatus
DtsGetDriveStats: Ioctl failed: 1
txThreadProc: Got status 1 from GetDriverStatus
DtsAllocIoctlData Error
Unable to detach from Dil shared memory ...
DtsDelDilShMem:Unable get shmid ...
Stream with high frequencies VQ coding
/usr/bin/transmageddon: Zeile 3:  6692 Speicherzugriffsfehler  python transmageddon.py
schorpp@tom3:~$

Feb  1 20:21:44 tom3 kernel: [ 1900.117133] crystalhd 0000:03:00.0: Opening new user[0] handle
Feb  1 20:21:46 tom3 kernel: [ 1902.371194] start_capture: pause_th:12, resume_th:5
Feb  1 20:21:47 tom3 kernel: [ 1902.726493] crystalhd 0000:03:00.0: Closing user[0] handle via ioctl with mode 1c200
Feb  1 20:21:59 tom3 kernel: [ 1914.586429] crystalhd 0000:03:00.0: Opening new user[0] handle
Feb  1 20:21:59 tom3 kernel: [ 1914.841273] crystalhd 0000:03:00.0: Closing user[0] handle with mode ffffffff
Feb  1 20:21:59 tom3 kernel: [ 1915.045784] crystalhd 0000:03:00.0: Opening new user[0] handle
Feb  1 20:21:59 tom3 kernel: [ 1915.045988] crystalhd 0000:03:00.0: Opening new user[0] handle
Feb  1 20:21:59 tom3 kernel: [ 1915.046103] crystalhd 0000:03:00.0: Closing user[0] handle with mode ffffffff
Feb  1 20:21:59 tom3 kernel: [ 1915.046802] crystalhd 0000:03:00.0: Opening new user[0] handle
Feb  1 20:21:59 tom3 kernel: [ 1915.300288] crystalhd 0000:03:00.0: Closing user[0] handle with mode ffffffff
Feb  1 20:21:59 tom3 kernel: [ 1915.493945] crystalhd 0000:03:00.0: Invalid hw config.. otp not programmed
Feb  1 20:21:59 tom3 kernel: [ 1915.493955] crystalhd 0000:03:00.0: Firmware Download Failure!! - -1
Feb  1 20:21:59 tom3 kernel: [ 1915.505631] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg ctx,hw,data: 0x0 0xffff880079ecf0c0 0xffff880036e82c00
Feb  1 20:21:59 tom3 kernel: [ 1915.507970] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg ctx,hw,data: 0x0 0xffff880079ecf0c0 0xffff880036e82c00
...
Feb  1 20:22:00 tom3 kernel: [ 1915.589897] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg ctx,hw,data: 0x0 0xffff880079ecf0c0 0xffff880036e82c00
Feb  1 20:22:00 tom3 kernel: [ 1915.592526] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg ctx,hw,data: 0x0 0xffff880079ecf0c0 0xffff880036e82c00
Feb  1 20:22:00 tom3 kernel: [ 1915.594811] crystalhd 0000:03:00.0: bc_cproc_get_stats: Invalid Arg ctx,hw,data: 0x0 0xffff880079ecf0c0 0xffff880036e82c00
Feb  1 20:22:00 tom3 kernel: [ 1915.597345] crystalhd 0000:03:00.0: bc_cproc_flush_cap_buffs: Invalid Arg
Feb  1 20:22:00 tom3 kernel: [ 1915.602438] crystalhd 0000:03:00.0: Closing user[0] handle via ioctl with mode 1c200
Feb  1 20:22:00 tom3 kernel: [ 1915.602444] crystalhd_hw_stop_capture: Invalid Arguments
Feb  1 20:22:00 tom3 kernel: [ 1915.602448] crystalhd_hw_free_dma_rings: Invalid Arguments
Feb  1 20:22:00 tom3 kernel: [ 1915.602537] crystalhd_hw_close: Invalid Arguments
Feb  1 20:22:02 tom3 kernel: [ 1917.532285] matroskademux0:[6701]: segfault at 7fbc69548018 ip 00007fbc6ac044d2 sp 00007fbc4f7fd080 error 6 in libpthread-2.11.3.so[7fbc6abf7000+17000]

is still not working but not crashing my kernel anymore. totem, ffmpeg, mplayer tests passed.
Since none of the "maintainers" nor Broadcom corp. care or agree on a common codebase, I've no motivation to fix

21372-Feb  1 18:39:52 tom3 kernel: [59854.079584] crystalhd 0000:03:00.0: Opening new user[0] handle
21373-Feb  1 18:39:52 tom3 kernel: [59854.079607] crystalhd 0000:03:00.0: Opening new user[0] handle

or any more.

Future efforts should focus on the new kernel staging GPL driver.
--------------------------

Patch attached.

crystalhd git.linuxtv.org kernel driver: FIX kernel unhandled paging request BUG triggered by multithreaded or faulty apps

Signed-off-by: Thomas Schorpp <thomas.schorpp@gmail.com>

y
tom




--------------060603020607030507070802
Content-Type: text/x-diff;
 name="crystalhd-paging-bugfix.schorpp.01.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="crystalhd-paging-bugfix.schorpp.01.patch"

diff --git a/driver/linux/crystalhd_cmds.c b/driver/linux/crystalhd_cmds.c
index cecd710..ba743df 100644
--- a/driver/linux/crystalhd_cmds.c
+++ b/driver/linux/crystalhd_cmds.c
@@ -32,6 +32,11 @@ static struct crystalhd_user *bc_cproc_get_uid(struct crystalhd_cmd *ctx)
 	struct crystalhd_user *user = NULL;
 	int i;
 
+	if (!ctx) {
+		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
+		return user;
+	}
+
 	for (i = 0; i < BC_LINK_MAX_OPENS; i++) {
 		if (!ctx->user[i].in_use) {
 			user = &ctx->user[i];
@@ -46,6 +51,11 @@ int bc_get_userhandle_count(struct crystalhd_cmd *ctx)
 {
 	int i, count = 0;
 
+	if (!ctx) {
+		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
+		return BC_STS_INV_ARG;
+	}
+
 	for (i = 0; i < BC_LINK_MAX_OPENS; i++) {
 		if (ctx->user[i].in_use)
 			count++;
@@ -154,7 +164,7 @@ static BC_STATUS bc_cproc_get_hwtype(struct crystalhd_cmd *ctx, crystalhd_ioctl_
 static BC_STATUS bc_cproc_reg_rd(struct crystalhd_cmd *ctx,
 				 crystalhd_ioctl_data *idata)
 {
-	if (!ctx || !idata)
+	if (!ctx || !ctx->hw_ctx || !idata)
 		return BC_STS_INV_ARG;
 	idata->udata.u.regAcc.Value = ctx->hw_ctx->pfnReadDevRegister(ctx->adp,
 					idata->udata.u.regAcc.Offset);
@@ -164,7 +174,7 @@ static BC_STATUS bc_cproc_reg_rd(struct crystalhd_cmd *ctx,
 static BC_STATUS bc_cproc_reg_wr(struct crystalhd_cmd *ctx,
 				 crystalhd_ioctl_data *idata)
 {
-	if (!ctx || !idata)
+	if (!ctx || !ctx->hw_ctx || !idata)
 		return BC_STS_INV_ARG;
 
 	ctx->hw_ctx->pfnWriteDevRegister(ctx->adp, idata->udata.u.regAcc.Offset,
@@ -176,7 +186,7 @@ static BC_STATUS bc_cproc_reg_wr(struct crystalhd_cmd *ctx,
 static BC_STATUS bc_cproc_link_reg_rd(struct crystalhd_cmd *ctx,
 				      crystalhd_ioctl_data *idata)
 {
-	if (!ctx || !idata)
+	if (!ctx || !ctx->hw_ctx || !idata)
 		return BC_STS_INV_ARG;
 
 	idata->udata.u.regAcc.Value = ctx->hw_ctx->pfnReadFPGARegister(ctx->adp,
@@ -187,7 +197,7 @@ static BC_STATUS bc_cproc_link_reg_rd(struct crystalhd_cmd *ctx,
 static BC_STATUS bc_cproc_link_reg_wr(struct crystalhd_cmd *ctx,
 				      crystalhd_ioctl_data *idata)
 {
-	if (!ctx || !idata)
+	if (!ctx || !ctx->hw_ctx || !idata)
 		return BC_STS_INV_ARG;
 
 	ctx->hw_ctx->pfnWriteFPGARegister(ctx->adp, idata->udata.u.regAcc.Offset,
@@ -201,7 +211,7 @@ static BC_STATUS bc_cproc_mem_rd(struct crystalhd_cmd *ctx,
 {
 	BC_STATUS sts = BC_STS_SUCCESS;
 
-	if (!ctx || !idata || !idata->add_cdata)
+	if (!ctx || !ctx->hw_ctx || !idata || !idata->add_cdata)
 		return BC_STS_INV_ARG;
 
 	if (idata->udata.u.devMem.NumDwords > (idata->add_cdata_sz / 4)) {
@@ -220,7 +230,7 @@ static BC_STATUS bc_cproc_mem_wr(struct crystalhd_cmd *ctx,
 {
 	BC_STATUS sts = BC_STS_SUCCESS;
 
-	if (!ctx || !idata || !idata->add_cdata)
+	if (!ctx || !ctx->hw_ctx || !idata || !idata->add_cdata)
 		return BC_STS_INV_ARG;
 
 	if (idata->udata.u.devMem.NumDwords > (idata->add_cdata_sz / 4)) {
@@ -307,7 +317,7 @@ static BC_STATUS bc_cproc_download_fw(struct crystalhd_cmd *ctx,
 
 	dev_dbg(chddev(), "Downloading FW\n");
 
-	if (!ctx || !idata || !idata->add_cdata || !idata->add_cdata_sz) {
+	if (!ctx || !ctx->hw_ctx || !idata || !idata->add_cdata || !idata->add_cdata_sz) {
 		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
@@ -350,7 +360,7 @@ static BC_STATUS bc_cproc_do_fw_cmd(struct crystalhd_cmd *ctx, crystalhd_ioctl_d
 	BC_STATUS sts;
 	uint32_t *cmd;
 
-	if (!(ctx->state & BC_LINK_INIT)) {
+	if ( !ctx || !idata || !(ctx->state & BC_LINK_INIT) || !ctx->hw_ctx) {
 		dev_dbg(dev, "Link invalid state do fw cmd %x \n", ctx->state);
 		return BC_STS_ERR_USAGE;
 	}
@@ -395,7 +405,7 @@ static void bc_proc_in_completion(struct crystalhd_dio_req *dio_hnd,
 		return;
 	}
 	if (sts == BC_STS_IO_USER_ABORT || sts == BC_STS_PWR_MGMT)
-		 return;
+		return;
 
 	dio_hnd->uinfo.comp_sts = sts;
 	dio_hnd->uinfo.ev_sts = 1;
@@ -407,6 +417,9 @@ static BC_STATUS bc_cproc_codein_sleep(struct crystalhd_cmd *ctx)
 	wait_queue_head_t sleep_ev;
 	int rc = 0;
 
+	if (!ctx)
+		return BC_STS_INV_ARG;
+
 	if (ctx->state & BC_LINK_SUSPEND)
 		return BC_STS_PWR_MGMT;
 
@@ -432,7 +445,7 @@ static BC_STATUS bc_cproc_hw_txdma(struct crystalhd_cmd *ctx,
 	wait_queue_head_t event;
 	int rc = 0;
 
-	if (!ctx || !idata || !dio) {
+	if (!ctx || !ctx->hw_ctx || !idata || !dio) {
 		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
@@ -573,7 +586,7 @@ static BC_STATUS bc_cproc_add_cap_buff(struct crystalhd_cmd *ctx,
 	struct crystalhd_dio_req *dio_hnd = NULL;
 	BC_STATUS sts = BC_STS_SUCCESS;
 
-	if (!ctx || !idata) {
+	if (!ctx || !ctx->hw_ctx || !idata) {
 		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
@@ -612,6 +625,11 @@ static BC_STATUS bc_cproc_fmt_change(struct crystalhd_cmd *ctx,
 {
 	BC_STATUS sts = BC_STS_SUCCESS;
 
+	if (!ctx || !dio) {
+		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
+		return BC_STS_INV_ARG;
+	}
+
 	sts = crystalhd_hw_add_cap_buffer(ctx->hw_ctx, dio, 0);
 	if (sts != BC_STS_SUCCESS)
 		return sts;
@@ -673,6 +691,10 @@ static BC_STATUS bc_cproc_fetch_frame(struct crystalhd_cmd *ctx,
 static BC_STATUS bc_cproc_start_capture(struct crystalhd_cmd *ctx,
 					crystalhd_ioctl_data *idata)
 {
+	if (!ctx || !ctx->hw_ctx || !idata) {
+		return BC_STS_INV_ARG;
+	}
+
 	ctx->state |= BC_LINK_CAP_EN;
 
 	if( idata->udata.u.RxCap.PauseThsh )
@@ -705,7 +727,7 @@ static BC_STATUS bc_cproc_flush_cap_buffs(struct crystalhd_cmd *ctx,
 	struct device *dev = chddev();
 	struct crystalhd_rx_dma_pkt *rpkt;
 
-	if (!ctx || !idata) {
+	if (!ctx || !ctx->hw_ctx || !idata) {
 		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
@@ -745,8 +767,8 @@ static BC_STATUS bc_cproc_get_stats(struct crystalhd_cmd *ctx,
 	bool readTxOnly = false;
 	unsigned long irqflags;
 
-	if (!ctx || !idata) {
-		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
+	if (!ctx || !ctx->hw_ctx || !idata) {
+		dev_err(chddev(), "%s: Invalid Arg ctx,hw,data: 0x%lx 0x%lx 0x%lx\n", __func__, (uintptr_t)(ctx->hw_ctx), (uintptr_t)ctx, (uintptr_t)idata);
 		return BC_STS_INV_ARG;
 	}
 
@@ -828,6 +850,10 @@ get_out:
 static BC_STATUS bc_cproc_reset_stats(struct crystalhd_cmd *ctx,
 				      crystalhd_ioctl_data *idata)
 {
+	if (!ctx || !ctx->hw_ctx || !idata) {
+		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
+		return BC_STS_INV_ARG;
+	}
 	crystalhd_hw_stats(ctx->hw_ctx, NULL);
 
 	return BC_STS_SUCCESS;
@@ -948,9 +974,9 @@ BC_STATUS crystalhd_suspend(struct crystalhd_cmd *ctx, crystalhd_ioctl_data *ida
 	BC_STATUS sts = BC_STS_SUCCESS;
 	struct crystalhd_rx_dma_pkt *rpkt = NULL;
 
-	if (!ctx || !idata) {
-		dev_err(dev, "Invalid Parameters\n");
-		return BC_STS_ERROR;
+	if (!ctx || !ctx->hw_ctx || !idata) {
+		dev_err(dev, "%s: Invalid Arg\n", __func__);
+		return BC_STS_INV_ARG;
 	}
 
 	if (ctx->state & BC_LINK_SUSPEND)
@@ -1017,6 +1043,11 @@ BC_STATUS crystalhd_resume(struct crystalhd_cmd *ctx)
 {
 	BC_STATUS sts = BC_STS_SUCCESS;
 
+	if (!ctx) {
+		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
+		return BC_STS_INV_ARG;
+	}
+
 	sts = crystalhd_hw_resume(ctx->hw_ctx);
 	if (sts != BC_STS_SUCCESS)
 		return sts;
@@ -1049,13 +1080,13 @@ BC_STATUS crystalhd_user_open(struct crystalhd_cmd *ctx,
 	struct crystalhd_user *uc;
 
 	if (!ctx || !user_ctx) {
-		dev_err(dev, "Invalid arg..\n");
+		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	uc = bc_cproc_get_uid(ctx);
 	if (!uc) {
-		dev_info(dev, "No free user context...\n");
+		dev_info(dev, "%s No free user context.\n", __func__);
 		return BC_STS_BUSY;
 	}
 
@@ -1093,19 +1124,21 @@ BC_STATUS crystalhd_user_open(struct crystalhd_cmd *ctx,
  *
  * Called at the time of driver load.
  */
-BC_STATUS __devinit crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx,
+BC_STATUS crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx,
 				    struct crystalhd_adp *adp)
 {
-	struct device *dev = &adp->pdev->dev;
+	struct device *dev;
 	int i = 0;
 
-	if (!ctx || !adp) {
-		dev_err(dev, "%s: Invalid arg\n", __func__);
+	if (!ctx || !adp || !adp->pdev) {
+		printk(KERN_ERR "%s: Invalid arg.\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
+	dev = &adp->pdev->dev;
+
 	if (ctx->adp)
-		dev_dbg(dev, "Resetting Cmd context delete missing..\n");
+		dev_dbg(dev, "Resetting Cmd context delete missing.\n");
 
 	ctx->adp = adp;
 	for (i = 0; i < BC_LINK_MAX_OPENS; i++) {
@@ -1114,15 +1147,19 @@ BC_STATUS __devinit crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx,
 		ctx->user[i].mode = DTS_MODE_INV;
 	}
 
-	ctx->hw_ctx = (struct crystalhd_hw*)kmalloc(sizeof(struct crystalhd_hw), GFP_KERNEL);
-
-	memset(ctx->hw_ctx, 0, sizeof(struct crystalhd_hw));
+	if(ctx->hw_ctx == NULL) {
+		ctx->hw_ctx = (struct crystalhd_hw*)kmalloc(sizeof(struct crystalhd_hw), GFP_KERNEL);
+		if(ctx->hw_ctx != NULL)
+			memset(ctx->hw_ctx, 0, sizeof(struct crystalhd_hw));
+		else
+			return BC_STS_ERROR;
 
-	/*Open and Close the Hardware to put it in to sleep state*/
-	crystalhd_hw_open(ctx->hw_ctx, ctx->adp);
-	crystalhd_hw_close(ctx->hw_ctx, ctx->adp);
-	kfree(ctx->hw_ctx);
-	ctx->hw_ctx = NULL;
+		/*Open and Close the Hardware to put it in to sleep state*/
+		crystalhd_hw_open(ctx->hw_ctx, ctx->adp);
+		crystalhd_hw_close(ctx->hw_ctx, ctx->adp);
+		kfree(ctx->hw_ctx);
+		ctx->hw_ctx = NULL;
+	}
 
 	return BC_STS_SUCCESS;
 }
@@ -1136,10 +1173,15 @@ BC_STATUS __devinit crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx,
  *
  * Called at the time of driver un-load.
  */
-BC_STATUS __devexit crystalhd_delete_cmd_context(struct crystalhd_cmd *ctx)
+BC_STATUS crystalhd_delete_cmd_context(struct crystalhd_cmd *ctx)
 {
 	dev_dbg(chddev(), "Deleting Command context..\n");
 
+	if (!ctx) {
+		dev_err(chddev(), "%s: Invalid arg\n", __func__);
+		return BC_STS_INV_ARG;
+	}
+
 	ctx->adp = NULL;
 
 	return BC_STS_SUCCESS;
@@ -1165,8 +1207,8 @@ crystalhd_cmd_proc crystalhd_get_cmd_proc(struct crystalhd_cmd *ctx, uint32_t cm
 	crystalhd_cmd_proc cproc = NULL;
 	unsigned int i, tbl_sz;
 
-	if (!ctx) {
-		dev_err(dev, "Invalid arg.. Cmd[%d]\n", cmd);
+	if (!ctx || !uc) {
+		dev_err(dev, "Invalid arg. Cmd[%d]\n", cmd);
 		return NULL;
 	}
 
diff --git a/driver/linux/crystalhd_fleafuncs.c b/driver/linux/crystalhd_fleafuncs.c
index 1aa7115..f76d122 100644
--- a/driver/linux/crystalhd_fleafuncs.c
+++ b/driver/linux/crystalhd_fleafuncs.c
@@ -1344,7 +1344,9 @@ BCHP_SCRUB_CTRL_BI_CMAC_127_96		0x000f6018			CMAC Bits[127:96]
 bool crystalhd_flea_start_device(struct crystalhd_hw *hw)
 {
 	uint32_t	regVal	= 0;
-	bool		bRetVal = false;
+
+	if (!hw)
+		return false;
 
 	/*
 	-- Issue Core reset to bring in the default values in place
@@ -1430,7 +1432,7 @@ bool crystalhd_flea_start_device(struct crystalhd_hw *hw)
 
 	msleep_interruptible(1);
 
-	return bRetVal;
+	return true;
 }
 
 
diff --git a/driver/linux/crystalhd_hw.c b/driver/linux/crystalhd_hw.c
index cf8fefb..4ff488e 100644
--- a/driver/linux/crystalhd_hw.c
+++ b/driver/linux/crystalhd_hw.c
@@ -38,7 +38,7 @@
 BC_STATUS crystalhd_hw_open(struct crystalhd_hw *hw, struct crystalhd_adp *adp)
 {
 	struct device *dev;
-	if (!hw || !adp) {
+	if (!hw || !adp || !adp->pdev) {
 		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
@@ -110,7 +110,10 @@ BC_STATUS crystalhd_hw_open(struct crystalhd_hw *hw, struct crystalhd_adp *adp)
 	hw->rx_pkt_tag_seed = 0x70029070;
 
 	hw->stop_pending = 0;
-	hw->pfnStartDevice(hw);
+	if (!hw->pfnStartDevice(hw)) {
+		printk(KERN_ERR "%s: Failed to Start Device! \n", __func__);
+		return BC_STS_ERROR;
+	}
 	hw->dev_started = true;
 
 	dev_dbg(dev, "Opening HW. hw:0x%lx, hw->adp:0x%lx\n",
@@ -121,9 +124,9 @@ BC_STATUS crystalhd_hw_open(struct crystalhd_hw *hw, struct crystalhd_adp *adp)
 
 BC_STATUS crystalhd_hw_close(struct crystalhd_hw *hw, struct crystalhd_adp *adp)
 {
-	if (!hw) {
+	if (!hw || !adp) {
 		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
-		return BC_STS_SUCCESS;
+		return BC_STS_INV_ARG;
 	}
 
 	if (!hw->dev_started)
@@ -1047,8 +1050,8 @@ BC_STATUS crystalhd_hw_resume(struct crystalhd_hw *hw)
 	hw->rx_list_post_index = 0;
 	hw->tx_list_post_index = 0;
 
-	if (hw->pfnStartDevice(hw)) {
-		dev_info(&hw->adp->pdev->dev, "Failed to Start Device!!\n");
+	if (!hw->pfnStartDevice(hw)) {
+		dev_info(&hw->adp->pdev->dev, "Failed to resume start device!\n");
 		return BC_STS_ERROR;
 	}
 
diff --git a/driver/linux/crystalhd_linkfuncs.c b/driver/linux/crystalhd_linkfuncs.c
index 8366cc3..514e218 100644
--- a/driver/linux/crystalhd_linkfuncs.c
+++ b/driver/linux/crystalhd_linkfuncs.c
@@ -469,8 +469,8 @@ bool crystalhd_link_start_device(struct crystalhd_hw *hw)
 	uint32_t dbg_options, glb_cntrl = 0, reg_pwrmgmt = 0;
 	struct device *dev;
 
-	if (!hw)
-		return -EINVAL;
+	if (!hw || !hw->adp || !hw->adp->pdev)
+		return false;
 
 	dev = &hw->adp->pdev->dev;
 
diff --git a/driver/linux/crystalhd_lnx.c b/driver/linux/crystalhd_lnx.c
index 64e66ad..8608aea 100644
--- a/driver/linux/crystalhd_lnx.c
+++ b/driver/linux/crystalhd_lnx.c
@@ -431,7 +431,7 @@ static const struct file_operations chd_dec_fops = {
 	.llseek		= noop_llseek,
 };
 
-static int __devinit chd_dec_init_chdev(struct crystalhd_adp *adp)
+static int chd_dec_init_chdev(struct crystalhd_adp *adp)
 {
 	struct device *xdev = &adp->pdev->dev;
 	struct device *dev;
@@ -498,7 +498,7 @@ fail:
 	return rc;
 }
 
-static void __devexit chd_dec_release_chdev(struct crystalhd_adp *adp)
+static void chd_dec_release_chdev(struct crystalhd_adp *adp)
 {
 	crystalhd_ioctl_data *temp = NULL;
 	if (!adp)
@@ -523,7 +523,7 @@ static void __devexit chd_dec_release_chdev(struct crystalhd_adp *adp)
 	/*crystalhd_delete_elem_pool(adp); */
 }
 
-static int __devinit chd_pci_reserve_mem(struct crystalhd_adp *pinfo)
+static int chd_pci_reserve_mem(struct crystalhd_adp *pinfo)
 {
 	struct device *dev = &pinfo->pdev->dev;
 	int rc;
@@ -582,7 +582,7 @@ static int __devinit chd_pci_reserve_mem(struct crystalhd_adp *pinfo)
 	return 0;
 }
 
-static void __devexit chd_pci_release_mem(struct crystalhd_adp *pinfo)
+static void chd_pci_release_mem(struct crystalhd_adp *pinfo)
 {
 	if (!pinfo)
 		return;
@@ -597,7 +597,7 @@ static void __devexit chd_pci_release_mem(struct crystalhd_adp *pinfo)
 }
 
 
-static void __devexit chd_dec_pci_remove(struct pci_dev *pdev)
+static void chd_dec_pci_remove(struct pci_dev *pdev)
 {
 	struct crystalhd_adp *pinfo;
 	BC_STATUS sts = BC_STS_SUCCESS;
@@ -625,7 +625,7 @@ static void __devexit chd_dec_pci_remove(struct pci_dev *pdev)
 	g_adp_info = NULL;
 }
 
-static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
+static int chd_dec_pci_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *entry)
 {
 	struct device *dev = &pdev->dev;
@@ -815,7 +815,7 @@ MODULE_DEVICE_TABLE(pci, chd_dec_pci_id_table);
 static struct pci_driver bc_chd_driver = {
 	.name     = "crystalhd",
 	.probe    = chd_dec_pci_probe,
-	.remove   = __devexit_p(chd_dec_pci_remove),
+	.remove   = chd_dec_pci_remove,
 	.id_table = chd_dec_pci_id_table,
 	.suspend  = chd_dec_pci_suspend,
 	.resume   = chd_dec_pci_resume
diff --git a/driver/linux/crystalhd_misc.c b/driver/linux/crystalhd_misc.c
index 410ab9d..56fbb51 100644
--- a/driver/linux/crystalhd_misc.c
+++ b/driver/linux/crystalhd_misc.c
@@ -512,8 +512,8 @@ void *crystalhd_dioq_fetch_wait(struct crystalhd_hw *hw, uint32_t to_secs, uint3
 			if(down_interruptible(&hw->fetch_sem))
 				goto sem_error;
 			r_pkt = crystalhd_dioq_fetch(ioq);
-			/* If format change packet, then return with out checking anything */
-			if (r_pkt->flags & (COMP_FLAG_PIB_VALID | COMP_FLAG_FMT_CHANGE))
+			/* If format change packet then return without checking anything */
+			if (!r_pkt || r_pkt->flags & (COMP_FLAG_PIB_VALID | COMP_FLAG_FMT_CHANGE))
 				goto sem_rel_return;
 			if (hw->adp->pdev->device == BC_PCI_DEVID_LINK) {
 				picYcomp = link_GetRptDropParam(hw, hw->PICHeight, hw->PICWidth, (void *)r_pkt);

--------------060603020607030507070802--
