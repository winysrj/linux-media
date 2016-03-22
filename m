Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55725 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbcCVNFg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2016 09:05:36 -0400
Subject: Re: [PATCH] media: au0828 fix au0828_v4l2_close() dev_state race
 condition
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	inki.dae@samsung.com, nenggun.kim@samsung.com,
	jh1009.sung@samsung.com, chehabrafael@gmail.com, tiwai@suse.com
References: <1458619445-9483-1-git-send-email-shuahkh@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56F1431D.3010603@osg.samsung.com>
Date: Tue, 22 Mar 2016 07:05:33 -0600
MIME-Version: 1.0
In-Reply-To: <1458619445-9483-1-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/21/2016 10:04 PM, Shuah Khan wrote:
> au0828_v4l2_close() check for dev_state == DEV_DISCONNECTED will fail to
> detect the device disconnected state correctly, if au0828_v4l2_open() runs
> to set the DEV_INITIALIZED bit. A loop test of bind/unbind found this bug
> by increasing the likelihood of au0828_v4l2_open() occurring while unbind
> is in progress. When au0828_v4l2_close() fails to detect that the device
> is in disconnect state, it attempts to power down the device and fails with
> the following general protection fault:
> 
> [  260.992962] Call Trace:
> [  260.993008]  [<ffffffffa0f80f0f>] ? xc5000_sleep+0x8f/0xd0 [xc5000]
> [  260.993095]  [<ffffffffa0f6803c>] ? fe_standby+0x3c/0x50 [tuner]
> [  260.993186]  [<ffffffffa0ef541c>] au0828_v4l2_close+0x53c/0x620 [au0828]
> [  260.993298]  [<ffffffffa0d08ec0>] v4l2_release+0xf0/0x210 [videodev]
> [  260.993382]  [<ffffffff81570f9c>] __fput+0x1fc/0x6c0
> [  260.993449]  [<ffffffff815714ce>] ____fput+0xe/0x10
> [  260.993519]  [<ffffffff8116eb83>] task_work_run+0x133/0x1f0
> [  260.993602]  [<ffffffff810035d0>] exit_to_usermode_loop+0x140/0x170
> [  260.993681]  [<ffffffff810061ca>] syscall_return_slowpath+0x16a/0x1a0
> [  260.993754]  [<ffffffff82835fb3>] entry_SYSCALL_64_fastpath+0xa6/0xa8
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>

Hi Mauro,

Reproduced this problem on Linux 4.5. This patch should be marked for
stable releases.

Mar 22 06:55:16 anduin kernel: [  883.235413] PM: Removing info for No Bus:video1
Mar 22 06:55:16 anduin kernel: [  883.236165] device: 'vbi0': device_unregister
Mar 22 06:55:16 anduin kernel: [  883.237883] kasan: CONFIG_KASAN_INLINE enabled
Mar 22 06:55:16 anduin kernel: [  883.237893] kasan: GPF could be caused by NULL-ptr deref or user memory accessgeneral protection fault: 0000 [#1] SMP KASAN
Mar 22 06:55:16 anduin kernel: [  883.237988] Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables snd_usb_audio snd_usbmidi_lib snd_seq_midi snd_seq_midi_event snd_seq snd_rawmidi ir_lirc_codec snd_seq_device lirc_dev binfmt_misc rc_hauppauge au8522_dig nls_iso8859_1 xc5000 tuner au8522_decoder au8522_common hp_wmi sparse_keymap au0828 ghash_clmulni_intel aesni_intel tveeprom aes_x86_64 ablk_helper dvb_core cryptd lrw gf128mul uvcvideo glue_helper rc_core v4l2_common joydev videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core serio_raw videodev media k10temp i2c_piix4 snd_hda_codec_idt snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_hda_codec tpm_infineon snd_hda_core snd_hwdep snd_pcm hp_accel lis3lv02d input_polldev mac_hid snd_timer kvm_amd tpm_tis kvm irqbypass parport_pc ppdev lp parport a
 utofs4 p
 l
2303 usbserial hid_generic psmouse usbhid hid radeon i2c_algo_bit ttm drm_kms_helper syscopyarea sysfillrect sysimgblt firewire_ohci fb_sys_fops sdhci_pci firewire_core sdhci crc_itu_t r8169 drm mii wmi video
Mar 22 06:55:16 anduin kernel: [  883.239547] CPU: 1 PID: 2793 Comm: v4l_id Not tainted 4.5.0 #16
Mar 22 06:55:16 anduin kernel: [  883.239613] Hardware name: Hewlett-Packard HP ProBook 6475b/180F, BIOS 68TTU Ver. F.04 08/03/2012
Mar 22 06:55:16 anduin kernel: [  883.239709] task: ffff88009a0fcd80 ti: ffff8800942f0000 task.ti: ffff8800942f0000
Mar 22 06:55:16 anduin kernel: [  883.239790] RIP: 0010:[<ffffffff82102264>]  [<ffffffff82102264>] usb_set_interface+0x34/0x9d0
Mar 22 06:55:16 anduin kernel: [  883.239896] PM: Removing info for No Bus:vbi0
Mar 22 06:55:16 anduin kernel: [  883.239947] RSP: 0018:ffff8800942f7d10  EFLAGS: 00010212
Mar 22 06:55:16 anduin kernel: [  883.240007] RAX: dffffc0000000000 RBX: ffff8801eef75338 RCX: ffff88009a0fd5b8
Mar 22 06:55:16 anduin kernel: [  883.240093] RDX: 0000000000000008 RSI: 0000000000000000 RDI: 0000000000000040
Mar 22 06:55:16 anduin kernel: [  883.240189] RBP: ffff8800942f7d88 R08: 0000000000000006 R09: 0000000000000000
Mar 22 06:55:16 anduin kernel: [  883.240284] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801eef76874
Mar 22 06:55:16 anduin kernel: [  883.240381] R13: 0000000000000000 R14: dffffc0000000000 R15: ffff8801eef74000
Mar 22 06:55:16 anduin kernel: [  883.240478] FS:  00007f83985c4700(0000) GS:ffff8801fa880000(0000) knlGS:0000000000000000
Mar 22 06:55:16 anduin kernel: [  883.240586] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Mar 22 06:55:16 anduin kernel: [  883.240664] CR2: 000055fd2e0ec000 CR3: 000000009426d000 CR4: 00000000000406e0
Mar 22 06:55:16 anduin kernel: [  883.240754] Stack:
Mar 22 06:55:16 anduin kernel: [  883.240779]  dffffc0000000000 ffff8801eef74000 ffff8800942f7d40 ffffffffa0f58f0f
Mar 22 06:55:16 anduin kernel: [  883.240873]  ffff88009a0fd5d8 ffff8801eeee4050 ffff8800942f7d58 ffffffffa0e3803c
Mar 22 06:55:16 anduin kernel: [  883.240966]  ffff880100000000 ffff880000000000 ffff8801eef75338 ffff8801eef76874
Mar 22 06:55:16 anduin kernel: [  883.241058] Call Trace:
Mar 22 06:55:16 anduin kernel: [  883.241095]  [<ffffffffa0f58f0f>] ? xc5000_sleep+0x8f/0xd0 [xc5000]
Mar 22 06:55:16 anduin kernel: [  883.241166]  [<ffffffffa0e3803c>] ? fe_standby+0x3c/0x50 [tuner]
Mar 22 06:55:16 anduin kernel: [  883.241242]  [<ffffffffa0e8bade>] au0828_v4l2_close+0x36e/0x570 [au0828]
Mar 22 06:55:16 anduin kernel: [  883.241348]  [<ffffffffa0c70ec0>] v4l2_release+0xf0/0x210 [videodev]
Mar 22 06:55:16 anduin kernel: [  883.241438]  [<ffffffff815662fc>] __fput+0x1fc/0x6c0
Mar 22 06:55:16 anduin kernel: [  883.241508]  [<ffffffff8156682e>] ____fput+0xe/0x10
Mar 22 06:55:16 anduin kernel: [  883.241583]  [<ffffffff8116a813>] task_work_run+0x133/0x1f0
Mar 22 06:55:16 anduin kernel: [  883.241664]  [<ffffffff810035d0>] exit_to_usermode_loop+0x140/0x170
Mar 22 06:55:16 anduin kernel: [  883.241747]  [<ffffffff810061b6>] syscall_return_slowpath+0x156/0x1b0
Mar 22 06:55:16 anduin kernel: [  883.241838]  [<ffffffff82829db1>] int_ret_from_sys_call+0x25/0x9f
Mar 22 06:55:16 anduin kernel: [  883.241921] Code: 00 00 00 00 fc ff df 48 89 e5 41 57 41 56 41 55 41 54 49 89 fd 53 48 83 c7 40 48 83 ec 50 89 55 c8 48 89 fa 48 c1 ea 03 89 75 d0 <80> 3c 02 00 0f 85 7b 07 00 00 49 8d 7d 18 48 b8 00 00 00 00 00
Mar 22 06:55:16 anduin kernel: [  883.242471] RIP  [<ffffffff82102264>] usb_set_interface+0x34/0x9d0
Mar 22 06:55:16 anduin kernel: [  883.242612]  RSP <ffff8800942f7d10>

thanks,
-- Shuah

> ---
>  drivers/media/usb/au0828/au0828-video.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 13f6dab..88dcc6e 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -1075,7 +1075,7 @@ static int au0828_v4l2_close(struct file *filp)
>  		del_timer_sync(&dev->vbi_timeout);
>  	}
>  
> -	if (dev->dev_state == DEV_DISCONNECTED)
> +	if (dev->dev_state & DEV_DISCONNECTED)
>  		goto end;
>  
>  	if (dev->users == 1) {
> 


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
