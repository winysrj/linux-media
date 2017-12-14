Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout5.zih.tu-dresden.de ([141.30.67.74]:59139 "EHLO
        mailout5.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751093AbdLNJpV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 04:45:21 -0500
From: Oleksandr Ostrenko <oleksandr.ostrenko@tu-dresden.de>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mike Isely <isely@pobox.com>
Subject: Re: [PATCH] pvrusb2: correctly return V4L2_PIX_FMT_MPEG in enum_fmt
Date: Thu, 14 Dec 2017 10:46:04 +0100
Message-ID: <2928887.fXdr7x88TB@optiplex-980-apb-1025>
In-Reply-To: <3c98b33d-c92d-6fd1-ac69-215fa70de1b7@xs4all.nl>
References: <3c98b33d-c92d-6fd1-ac69-215fa70de1b7@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2462820.1jYm70o8x4"; micalg="sha256"; protocol="application/pkcs7-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart2462820.1jYm70o8x4
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Dear all,

There seems to be another issue, which may have cause the original 
kernel panic. Whenever I unplug my TV tuner my the following errors show 
up on my dmesg:

[ 1076.718444] usb 1-1: USB disconnect, device number 6
[ 1076.718634] pvrusb2: Device being rendered inoperable
[ 1076.718768] BUG: unable to handle kernel NULL pointer dereference at 
00000000000004f8
[ 1076.718870] IP: [<ffffffffc08b0018>] 
pvr2_v4l2_internal_check+0x48/0x70 [pvrusb2]
[ 1076.718960] PGD 0
[ 1076.718988] Oops: 0000 [#1] SMP
[ 1076.719022] Modules linked in: tda10048 tda18271 tda8290 tuner 
lirc_zilog(C) lirc_dev rc_core cx25840 pvrusb2(OE) tveeprom cx2341x 
dvb_core v4l2_common ccm rfcomm pci_stub vboxpci(OE) vboxnetadp(OE) 
vboxnetflt(OE) vboxdrv(OE) bbswitch(OE) bnep binfmt_misc xfs 
hid_multitouch arc4 snd_hda_codec_hdmi(OE) i2c_designware_platform 
i2c_designware_core snd_hda_codec_generic(OE) dell_wmi sparse_keymap 
mxm_wmi dell_laptop dell_smbios dcdbas intel_rapl x86_pkg_temp_thermal 
intel_powerclamp coretemp dell_smm_hwmon kvm_intel snd_hda_intel(OE) 
snd_hda_codec(OE) kvm iwlmvm snd_hda_core(OE) snd_hwdep irqbypass 
uvcvideo mac80211 crct10dif_pclmul snd_pcm crc32_pclmul 
videobuf2_vmalloc ghash_clmulni_intel videobuf2_memops aesni_intel 
aes_x86_64 videobuf2_v4l2 lrw snd_seq_midi videobuf2_core 
snd_seq_midi_event glue_helper
[ 1076.719969]  videodev ablk_helper snd_rawmidi media cryptd snd_seq 
btusb snd_seq_device btrtl snd_timer iwlwifi snd intel_cstate joydev 
input_leds intel_rapl_perf idma64 soundcore virt_dma serio_raw 
rtsx_pci_ms memstick cfg80211 mei_me mei intel_lpss_pci 
processor_thermal_device shpchp hci_uart intel_soc_dts_iosf btbcm 
int3403_thermal btqca btintel bluetooth intel_lpss_acpi wmi intel_lpss 
dell_rbtn int3402_thermal int3400_thermal acpi_als int340x_thermal_zone 
acpi_thermal_rel tpm_crb mac_hid kfifo_buf acpi_pad industrialio 
parport_pc sunrpc ppdev lp parport autofs4 btrfs raid10 raid456 
async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq 
libcrc32c raid0 multipath linear dm_mirror dm_region_hash dm_log raid1 
hid_generic usbhid rtsx_pci_sdmmc i915 i2c_algo_bit drm_kms_helper 
syscopyarea
[ 1076.720900]  sysfillrect psmouse sysimgblt fb_sys_fops r8169 drm 
rtsx_pci ahci mii libahci pinctrl_sunrisepoint i2c_hid video 
pinctrl_intel hid fjes [last unloaded: nvidia]
[ 1076.721193] CPU: 0 PID: 2323 Comm: pvrusb2-context Tainted: P 
C OE   4.8.17-040817-generic #201701090438
[ 1076.721282] Hardware name: Dell Inc. Inspiron 7559/0H0CC0, BIOS 1.1.8 
04/17/2016
[ 1076.721348] task: ffff9cb6be1dbc00 task.stack: ffff9cb65aefc000
[ 1076.721402] RIP: 0010:[<ffffffffc08b0018>]  [<ffffffffc08b0018>] 
pvr2_v4l2_internal_check+0x48/0x70 [pvrusb2]
[ 1076.721508] RSP: 0018:ffff9cb65aeffe60  EFLAGS: 00010246
[ 1076.721557] RAX: 0000000000000000 RBX: ffff9cb6a47ff540 RCX: 
ffffffffc08c1ab8
[ 1076.721620] RDX: ffff9cb6bec414f8 RSI: 0000000000000000 RDI: 
0000000000000000
[ 1076.721683] RBP: ffff9cb65aeffe68 R08: ffff9cb65aefc000 R09: 
0000000000000001
[ 1076.721748] R10: 0000000000000000 R11: 0000000000000000 R12: 
ffff9cb6610da3c0
[ 1076.721812] R13: ffff9cb65aeffe90 R14: ffff9cb6bdd41e00 R15: 
0000000000019200
[ 1076.721876] FS:  0000000000000000(0000) GS:ffff9cb6c1c00000(0000) 
knlGS:0000000000000000
[ 1076.721949] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1076.722002] CR2: 00000000000004f8 CR3: 0000000477e06000 CR4: 
00000000003406f0
[ 1076.722066] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 1076.722138] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[ 1076.722200] Stack:
[ 1076.722223]  ffff9cb6bec45000 ffff9cb65aeffec0 ffffffffc08b25ec 
ffff9cb600000000
[ 1076.722305]  ffff9cb6be1dbc00 ffffffff8d4c6d20 ffff9cb65aeffe90 
ffff9cb65aeffe90
[ 1076.722390]  000000000932d1e4 ffff9cb65ad92400 0000000000000000 
ffffffffc08b2520
[ 1076.722475] Call Trace:
[ 1076.722513]  [<ffffffffc08b25ec>] pvr2_context_thread_func+0xcc/0x330 
[pvrusb2]
[ 1076.722582]  [<ffffffff8d4c6d20>] ? wake_atomic_t_function+0x60/0x60
[ 1076.722647]  [<ffffffffc08b2520>] ? pvr2_context_destroy+0xd0/0xd0 
[pvrusb2]
[ 1076.722713]  [<ffffffff8d4a3a38>] kthread+0xd8/0xf0
[ 1076.722764]  [<ffffffff8dc8371f>] ret_from_fork+0x1f/0x40
[ 1076.722816]  [<ffffffff8d4a3960>] ? kthread_create_on_node+0x1b0/0x1b0
[ 1076.722876] Code: 2f e4 ff ff 48 8b 7b 40 e8 26 e4 ff ff 48 8b 43 38 
48 8b 90 f8 04 00 00 48 05 f8 04 00 00 48 39 d0 74 04 5b 5d f3 c3 48 8b 
43 40 <48> 8b 90 f8 04 00 00 48 05 f8 04 00 00 48 39 d0 75 e6 48 89 df
[ 1076.723309] RIP  [<ffffffffc08b0018>] 
pvr2_v4l2_internal_check+0x48/0x70 [pvrusb2]
[ 1076.723390]  RSP <ffff9cb65aeffe60>
[ 1076.723423] CR2: 00000000000004f8
[ 1076.730967] ---[ end trace 732b17d35db357ef ]---
[ 1076.731013] BUG: unable to handle kernel paging request at 
000000000932d1e4
[ 1076.731039] IP: [<ffffffff8d4c663b>] __wake_up_common+0x2b/0x80
[ 1076.731061] PGD 0
[ 1076.731070] Oops: 0000 [#2] SMP
[ 1076.731080] Modules linked in: tda10048 tda18271 tda8290 tuner 
lirc_zilog(C) lirc_dev rc_core cx25840 pvrusb2(OE) tveeprom cx2341x 
dvb_core v4l2_common ccm rfcomm pci_stub vboxpci(OE) vboxnetadp(OE) 
vboxnetflt(OE) vboxdrv(OE) bbswitch(OE) bnep binfmt_misc xfs 
hid_multitouch arc4 snd_hda_codec_hdmi(OE) i2c_designware_platform 
i2c_designware_core snd_hda_codec_generic(OE) dell_wmi sparse_keymap 
mxm_wmi dell_laptop dell_smbios dcdbas intel_rapl x86_pkg_temp_thermal 
intel_powerclamp coretemp dell_smm_hwmon kvm_intel snd_hda_intel(OE) 
snd_hda_codec(OE) kvm iwlmvm snd_hda_core(OE) snd_hwdep irqbypass 
uvcvideo mac80211 crct10dif_pclmul snd_pcm crc32_pclmul 
videobuf2_vmalloc ghash_clmulni_intel videobuf2_memops aesni_intel 
aes_x86_64 videobuf2_v4l2 lrw snd_seq_midi videobuf2_core 
snd_seq_midi_event glue_helper
[ 1076.731351]  videodev ablk_helper snd_rawmidi media cryptd snd_seq 
btusb snd_seq_device btrtl snd_timer iwlwifi snd intel_cstate joydev 
input_leds intel_rapl_perf idma64 soundcore virt_dma serio_raw 
rtsx_pci_ms memstick cfg80211 mei_me mei intel_lpss_pci 
processor_thermal_device shpchp hci_uart intel_soc_dts_iosf btbcm 
int3403_thermal btqca btintel bluetooth intel_lpss_acpi wmi intel_lpss 
dell_rbtn int3402_thermal int3400_thermal acpi_als int340x_thermal_zone 
acpi_thermal_rel tpm_crb mac_hid kfifo_buf acpi_pad industrialio 
parport_pc sunrpc ppdev lp parport autofs4 btrfs raid10 raid456 
async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq 
libcrc32c raid0 multipath linear dm_mirror dm_region_hash dm_log raid1 
hid_generic usbhid rtsx_pci_sdmmc i915 i2c_algo_bit drm_kms_helper 
syscopyarea
[ 1076.731634]  sysfillrect psmouse sysimgblt fb_sys_fops r8169 drm 
rtsx_pci ahci mii libahci pinctrl_sunrisepoint i2c_hid video 
pinctrl_intel hid fjes [last unloaded: nvidia]
[ 1076.731695] CPU: 0 PID: 2323 Comm: pvrusb2-context Tainted: P      D 
C OE   4.8.17-040817-generic #201701090438
[ 1076.731725] Hardware name: Dell Inc. Inspiron 7559/0H0CC0, BIOS 1.1.8 
04/17/2016
[ 1076.731746] task: ffff9cb6be1dbc00 task.stack: ffff9cb65aefc000
[ 1076.731763] RIP: 0010:[<ffffffff8d4c663b>]  [<ffffffff8d4c663b>] 
__wake_up_common+0x2b/0x80
[ 1076.731788] RSP: 0018:ffff9cb65aeffe38  EFLAGS: 00010082
[ 1076.731803] RAX: 0000000000000282 RBX: ffff9cb65aefff10 RCX: 
0000000000000000
[ 1076.731824] RDX: 000000000932d1e4 RSI: 0000000000000003 RDI: 
ffff9cb65aefff10
[ 1076.731849] RBP: ffff9cb65aeffe70 R08: 0000000000000000 R09: 
0000000000000005
[ 1076.731869] R10: ffff9cb6a4ae5e00 R11: 0000000000000436 R12: 
ffff9cb65aefff18
[ 1076.731889] R13: 0000000000000282 R14: 0000000000000001 R15: 
0000000000000003
[ 1076.731910] FS:  0000000000000000(0000) GS:ffff9cb6c1c00000(0000) 
knlGS:0000000000000000
[ 1076.731932] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1076.731948] CR2: 000000000932d1e4 CR3: 0000000477e06000 CR4: 
00000000003406f0
[ 1076.733640] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 1076.735312] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[ 1076.736987] Stack:
[ 1076.738645]  0000000100000005 0000000000000000 ffff9cb65aefff10 
ffff9cb65aefff08
[ 1076.740325]  0000000000000282 0000000000000001 0000000000000046 
ffff9cb65aeffe80
[ 1076.741933]  ffffffff8d4c66f3 ffff9cb65aeffea8 ffffffff8d4c7167 
ffff9cb6be1dc338
[ 1076.743502] Call Trace:
[ 1076.744980]  [<ffffffff8d4c66f3>] __wake_up_locked+0x13/0x20
[ 1076.746405]  [<ffffffff8d4c7167>] complete+0x37/0x50
[ 1076.747811]  [<ffffffff8d48027f>] mm_release+0xbf/0x140
[ 1076.749187]  [<ffffffff8d486ad5>] do_exit+0x155/0xb20
[ 1076.750511]  [<ffffffff8dc84c97>] rewind_stack_do_exit+0x17/0x20
[ 1076.751797]  [<ffffffff8d4a3960>] ? kthread_create_on_node+0x1b0/0x1b0
[ 1076.753088] Code: 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 
4c 8d 67 08 53 41 89 f7 48 83 ec 10 89 55 cc 48 8b 57 08 4c 89 45 d0 49 
39 d4 <48> 8b 32 74 40 48 8d 42 e8 4c 8d 6e e8 41 89 ce 8b 18 48 8b 4d
[ 1076.754510] RIP  [<ffffffff8d4c663b>] __wake_up_common+0x2b/0x80
[ 1076.755853]  RSP <ffff9cb65aeffe38>
[ 1076.757194] CR2: 000000000932d1e4
[ 1076.758524] ---[ end trace 732b17d35db357f0 ]---
[ 1076.758525] Fixing recursive fault but reboot is needed!

I guess, originally, I may have power-cycled the TV tuner many times in 
a row and this may have driven the kernel into a frenzy till it panicked.

Best,
Oleksandr

Upd: Also, my computer crashed shortly after I uplugged the TV tuner just 
once. Seems like a crash is imminent with this error.

On 14.12.17 00:44, Hans Verkuil wrote:
> The pvrusb2 code appears to have a some old workaround code for xawtv that 
causes a
> WARN() due to an unrecognized pixelformat 0 in v4l2_ioctl.c.
> 
> Since all other MPEG drivers fill this in correctly, it is a safe assumption 
that
> this particular problem no longer exists.
> 
> While I'm at it, clean up the code a bit.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> I'll try to give this a spin in the morning with xawtv and my ivtv card 
(that also
> uses V4L2_PIX_FMT_MPEG), just to make sure xawtv no longer breaks if it sees 
it.
> 
> Oleksandr, are you able to test this as well on your pvrusb2?

Thanks, Hans, this fixes the original issue on Linux Mint with kernel 
4.8.17. Haven't tried it on openSUSE yet. Still, in xawtv I get no TV 
reception but just a black screen and error messages like:

no way to get: 128x96 32 bit TrueColor (LE: bgr-)
no way to get: 128x96 32 bit TrueColor (LE: bgr-)
no way to get: 128x96 32 bit TrueColor (LE: bgr-)
no way to get: 128x96 32 bit TrueColor (LE: bgr-)
no way to get: 384x288 32 bit TrueColor (LE: bgr-)

Is this another bug?

> 
> Regards,
> 
> 	Hans
> ---
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/
pvrusb2/pvrusb2-v4l2.c
> index 4320bda9352d..cc90be364a30 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> @@ -78,18 +78,6 @@ static int vbi_nr[PVR_NUM] = {[0 ... PVR_NUM-1] = -1};
>   module_param_array(vbi_nr, int, NULL, 0444);
>   MODULE_PARM_DESC(vbi_nr, "Offset for device's vbi dev minor");
> 
> -static struct v4l2_fmtdesc pvr_fmtdesc [] = {
> -	{
> -		.index          = 0,
> -		.type           = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> -		.flags          = V4L2_FMT_FLAG_COMPRESSED,
> -		.description    = "MPEG1/2",
> -		// This should really be V4L2_PIX_FMT_MPEG, but xawtv
> -		// breaks when I do that.
> -		.pixelformat    = 0, // V4L2_PIX_FMT_MPEG,
> -	}
> -};
> -
>   #define PVR_FORMAT_PIX  0
>   #define PVR_FORMAT_VBI  1
> 
> @@ -99,17 +87,11 @@ static struct v4l2_format pvr_format [] = {
>   		.fmt    = {
>   			.pix        = {
>   				.width          = 720,
> -				.height             = 576,
> -				// This should really be V4L2_PIX_FMT_MPEG,
> -				// but xawtv breaks when I do that.
> -				.pixelformat    = 0, // V4L2_PIX_FMT_MPEG,
> +				.height         = 576,
> +				.pixelformat    = V4L2_PIX_FMT_MPEG,
>   				.field          = V4L2_FIELD_INTERLACED,
> -				.bytesperline   = 0,  // doesn't make sense
> -						      // here
> -				//FIXME : Don't know what to put here...
> -				.sizeimage          = (32*1024),
> -				.colorspace     = 0, // doesn't make sense here
> -				.priv           = 0
> +				/* FIXME : Don't know what to put here... */
> +				.sizeimage      = 32 * 1024,
>   			}
>   		}
>   	},
> @@ -407,11 +389,11 @@ static int pvr2_g_frequency(struct file *file, void 
*priv, struct v4l2_frequency
> 
>   static int pvr2_enum_fmt_vid_cap(struct file *file, void *priv, struct 
v4l2_fmtdesc *fd)
>   {
> -	/* Only one format is supported : mpeg.*/
> -	if (fd->index != 0)
> +	/* Only one format is supported: MPEG. */
> +	if (fd->index)
>   		return -EINVAL;
> 
> -	memcpy(fd, pvr_fmtdesc, sizeof(struct v4l2_fmtdesc));
> +	fd->pixelformat = V4L2_PIX_FMT_MPEG;
>   	return 0;
>   }
> 

--nextPart2462820.1jYm70o8x4
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEA4w
ggTVMIIDvaADAgECAghQTsb1PRG0ZDANBgkqhkiG9w0BAQsFADBxMQswCQYDVQQGEwJERTEcMBoG
A1UEChMTRGV1dHNjaGUgVGVsZWtvbSBBRzEfMB0GA1UECxMWVC1UZWxlU2VjIFRydXN0IENlbnRl
cjEjMCEGA1UEAxMaRGV1dHNjaGUgVGVsZWtvbSBSb290IENBIDIwHhcNMTQwNzIyMTIwODI2WhcN
MTkwNzA5MjM1OTAwWjBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZlcmVpbjEQMA4GA1UE
CxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFsIC0gRzAxMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6ZvDZ4X5Da71jVTDllA1PWLpbkztlNcAW5UidNQg6zSP
1uzAMQQLmYHiphTSUqAoI4SLdIkEXlvg4njBeMsWyyg1OXstkEXQ7aAAeny/Sg4bAMOG6VwrMRF7
DPOCJEOMHDiLamgAmu7cT3ir0sYTm3at7t4m6O8Br3QPwQmi9mvOvdPNFDBP9eXjpMhim4IaAycw
DQJlYE3t0QkjKpY1WCfTdsZxtpAdxO3/NYZ9bzOz2w/FEcKKg6GUXUFr2NIQ9Uz9ylGs2b3vkoO7
2uuLFlZWQ8/h1RM9ph8nMM1JVNvJEzSacXXFbOqnC5j5IZ0nrz6jOTlIaoytyZn7wxLyvQIDAQAB
o4IBhjCCAYIwDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBRJt8bP6D0ff+pEexMp9/EKcD7eZDAf
BgNVHSMEGDAWgBQxw3kbuvVT1xfgiXotF2wKsyudMzASBgNVHRMBAf8ECDAGAQH/AgECMGIGA1Ud
IARbMFkwEQYPKwYBBAGBrSGCLAEBBAICMBEGDysGAQQBga0hgiwBAQQDADARBg8rBgEEAYGtIYIs
AQEEAwEwDwYNKwYBBAGBrSGCLAEBBDANBgsrBgEEAYGtIYIsHjA+BgNVHR8ENzA1MDOgMaAvhi1o
dHRwOi8vcGtpMDMzNi50ZWxlc2VjLmRlL3JsL0RUX1JPT1RfQ0FfMi5jcmwweAYIKwYBBQUHAQEE
bDBqMCwGCCsGAQUFBzABhiBodHRwOi8vb2NzcDAzMzYudGVsZXNlYy5kZS9vY3NwcjA6BggrBgEF
BQcwAoYuaHR0cDovL3BraTAzMzYudGVsZXNlYy5kZS9jcnQvRFRfUk9PVF9DQV8yLmNlcjANBgkq
hkiG9w0BAQsFAAOCAQEAYyAo/ZwhhnK+OUZZOTIlvKkBmw3Myn1BnIZtCm4ssxNZdbEzkhthJxb/
w7LVNYL7hCoBSb1mu2YvssIGXW4/buMBWlvKQ2NclbbhMacf1QdfTeZlgk4y+cN8ekvNTVx07iHy
dQLsUj7SyWrTkCNuSWc1vn9NVqTszC/Pt6GXqHI+ybxA1lqkCD3WvILDt7cyjrEsjmpttzUCGc/1
OURYY6ckABCwu/xOr24vOLulV0k/2G5QbyyXltwdRpplic+uzPLl2Z9Tsz6hL5Kp2AvGhB8Exuse
6J99tXulAvEkxSRjETTMWpMgKnmIOiVCkKllO3yG0xIVIyn8LNrMOVtUFzCCBWEwggRJoAMCAQIC
BxekJHloXI4wDQYJKoZIhvcNAQELBQAwWjELMAkGA1UEBhMCREUxEzARBgNVBAoTCkRGTi1WZXJl
aW4xEDAOBgNVBAsTB0RGTi1QS0kxJDAiBgNVBAMTG0RGTi1WZXJlaW4gUENBIEdsb2JhbCAtIEcw
MTAeFw0xNDA1MjcxNDUzMjlaFw0xOTA3MDkyMzU5MDBaMIGFMQswCQYDVQQGEwJERTEoMCYGA1UE
ChMfVGVjaG5pc2NoZSBVbml2ZXJzaXRhZXQgRHJlc2RlbjEMMAoGA1UECxMDWklIMRwwGgYDVQQD
ExNUVSBEcmVzZGVuIENBIC0gRzAyMSAwHgYJKoZIhvcNAQkBFhFwa2lAdHUtZHJlc2Rlbi5kZTCC
ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMEOHpPzRPbs0Cf3UHphCwQ0FZP8sR9sY9qA
7OEzXDUKPHcgIKKVgKAl4g9CYFlP1FqXHEXbPY4YM9xFO6pxoU+SC10ZrDUEUQhf6QZ7ci3PYaVo
os+dAEfByn44OPw52C8PjBmpiS+yNoPHVyTaykcdXEsSH/vJt7Ekvd/XNq2o8mQrZ8m4555TPcin
viw+qEqfdADlDkTglQeW+HeXhMMWtuYQgye1Gqsn4tobYkJDYb2F8RS/F6jdmvrLzwh0b53sdun5
cmRlig56dUi2b3P5q3Oj40HF2ZbycPTTEkAbnbFBLA3gdH6q2PQJycy2PjXNe/q6XYTuW1G5uo0z
eycCAwEAAaOCAf4wggH6MBIGA1UdEwEB/wQIMAYBAf8CAQEwDgYDVR0PAQH/BAQDAgEGMBEGA1Ud
IAQKMAgwBgYEVR0gADAdBgNVHQ4EFgQUxStTkxeDyfVGQu1Dat+2gKZH8uAwHwYDVR0jBBgwFoAU
SbfGz+g9H3/qRHsTKffxCnA+3mQwHAYDVR0RBBUwE4ERcGtpQHR1LWRyZXNkZW4uZGUwgYgGA1Ud
HwSBgDB+MD2gO6A5hjdodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9j
cmwvY2FjcmwuY3JsMD2gO6A5hjdodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNh
L3B1Yi9jcmwvY2FjcmwuY3JsMIHXBggrBgEFBQcBAQSByjCBxzAzBggrBgEFBQcwAYYnaHR0cDov
L29jc3AucGNhLmRmbi5kZS9PQ1NQLVNlcnZlci9PQ1NQMEcGCCsGAQUFBzAChjtodHRwOi8vY2Rw
MS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNydDBHBggrBgEF
BQcwAoY7aHR0cDovL2NkcDIucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1jYS9wdWIvY2FjZXJ0L2Nh
Y2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEBAImEwEPg6Hg9eFHAQKtaCiYMOcQsMMWHgU3V7aDS
BhsouD+QDSDDpEoiaHgaFNEBsQ3FbYzL60dooWO3BB0FpqeKWTgM3nzWOrGOjfuM8TAOY03NPxTi
yyLCaQwPZtYza9NxzuUOPaDvD6xHMgnzOLUC0JXjdslPzEFWPQ9CkW6phW9jOAyr4o20afhjKIEA
zINjUTM8SC06i83uypdveMYNrvWCp0dYgp/2it8NYJn9jx35j6tKq0EAePR+cDOOciC0m9QiJ/4B
/H/hG/HLQwePerq4eE8Vxn1AE+b6/FfadZcQyUlx/UD8iB1qHmFSmSYBAhRQmyjxBsTiBcFL8E8w
ggXMMIIEtKADAgECAgwcoFu5gNqsV1sjNq4wDQYJKoZIhvcNAQELBQAwgYUxCzAJBgNVBAYTAkRF
MSgwJgYDVQQKEx9UZWNobmlzY2hlIFVuaXZlcnNpdGFldCBEcmVzZGVuMQwwCgYDVQQLEwNaSUgx
HDAaBgNVBAMTE1RVIERyZXNkZW4gQ0EgLSBHMDIxIDAeBgkqhkiG9w0BCQEWEXBraUB0dS1kcmVz
ZGVuLmRlMB4XDTE3MDExOTE1NDEyOVoXDTE5MDcwOTIzNTkwMFowZzELMAkGA1UEBhMCREUxKDAm
BgNVBAoMH1RlY2huaXNjaGUgVW5pdmVyc2l0YWV0IERyZXNkZW4xETAPBgNVBAsMCElNQywgWklI
MRswGQYDVQQDDBJPbGVrc2FuZHIgT3N0cmVua28wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
AoIBAQC67X5mkD1X1PEnkC7OsqRcIz1ze+tnPix1bWtoaKIv6Fo4qhK/0Nb2kdaN8JyzWKCrfm12
97J/8Irbvt6mzWa4T+pDhc/JT5o/RvlxCy8pw2uSul7O3zi04H9jLVxRgjFjw9TSOjwrgYTSXUCT
PZkRDWjxr4kVd2nQoxIb+wq8O/tPTTKWbLSx4LIrjraJI1dcU179YrcanBtB+WMvlyDGibHpylQ7
mu2IcVjVHmku5Qh33KdQU5r8yacC2Omx/B8lQVQjlPmLRgFITpqsHHF8FtlhVLJqrjwhIrmtuCRx
CKm3Ip6FS4X0k2SjXJ9HwRLaEODMCDQqXVE0zjSiBAKVAgMBAAGjggJXMIICUzBABgNVHSAEOTA3
MBEGDysGAQQBga0hgiwBAQQDBTARBg8rBgEEAYGtIYIsAgEEAwEwDwYNKwYBBAGBrSGCLAEBBDAJ
BgNVHRMEAjAAMA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQw
HQYDVR0OBBYEFLoxHfuufLcgCk/TT07kIFsUvfXdMB8GA1UdIwQYMBaAFMUrU5MXg8n1RkLtQ2rf
toCmR/LgMCsGA1UdEQQkMCKBIG9sZWtzYW5kci5vc3RyZW5rb0B0dS1kcmVzZGVuLmRlMIGLBgNV
HR8EgYMwgYAwPqA8oDqGOGh0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvdHUtZHJlc2Rlbi1jYS9wdWIv
Y3JsL2dfY2FjcmwuY3JsMD6gPKA6hjhodHRwOi8vY2RwMi5wY2EuZGZuLmRlL3R1LWRyZXNkZW4t
Y2EvcHViL2NybC9nX2NhY3JsLmNybDCB2QYIKwYBBQUHAQEEgcwwgckwMwYIKwYBBQUHMAGGJ2h0
dHA6Ly9vY3NwLnBjYS5kZm4uZGUvT0NTUC1TZXJ2ZXIvT0NTUDBIBggrBgEFBQcwAoY8aHR0cDov
L2NkcDEucGNhLmRmbi5kZS90dS1kcmVzZGVuLWNhL3B1Yi9jYWNlcnQvZ19jYWNlcnQuY3J0MEgG
CCsGAQUFBzAChjxodHRwOi8vY2RwMi5wY2EuZGZuLmRlL3R1LWRyZXNkZW4tY2EvcHViL2NhY2Vy
dC9nX2NhY2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEBAKJbgBIa5I+mUCOsmPUWTmjYw3eX22a1
FRhr/bbeg6/pUtcOwOb0XL4y1PAxL7yl2VYAQcB6RXNRUNc+rhUP5oNRDk/9+ZGp9l0/8uycopXz
AA7tR/OxzxIOEPJI8QITETmiZit0GLaIuDACbij7gxVR+UKZ3izqOh/rl1YTuOt6cRP12qqNzRXT
O/c2tqZ+bu72k05QrKUMh3M0/7njRTg15FnTdWRyYEm5uNGUaDa45+JWmcV9BkwrOlDwORg0OhMS
n7q96y+PA9GR2/n5FwgZTzS99CIdUnOHED+Th8O3GQOaMG4m+SljkYvWl6q6yYcpemRHvLQNQ79C
mxIg0woxggJYMIICVAIBATCBljCBhTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1RlY2huaXNjaGUg
VW5pdmVyc2l0YWV0IERyZXNkZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMTVFUgRHJlc2RlbiBD
QSAtIEcwMjEgMB4GCSqGSIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUCDBygW7mA2qxXWyM2rjAN
BglghkgBZQMEAgEFAKCBkzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEP
Fw0xNzEyMTQwOTQ2MDRaMCgGCSqGSIb3DQEJDzEbMBkwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMH
MC8GCSqGSIb3DQEJBDEiBCBhYH9NOTGYO+D2QXd6XdSSSPixGSwM9j/E2DlXV2yITTANBgkqhkiG
9w0BAQEFAASCAQAIcr6kCUBBazg564CR1LuH+1wVumUyTeBzvksgc0axKLDAAL3Hyknksym6b1mX
1ti1UiKir42ZP9vaKwBlvacwNzrNwOowrA+zhgktz3+kNwKo7i0A0+P+FSQBYbELbt8s0xQ8DMZP
j29obZdmqirTy3qbTzDlgi0Ph2ornlbHZNeNpXC3SlFG+kHooadZJm4aMhPFvy/vWYpBEiPsNcbi
FI8/SWE0G+KGdXx976tAtoMBzsXTC+oX7hUgM1S2WNS49tNvB/GMpq2o4Ts7h9/QGyzAcgIee/As
AVhCCS7hlgOt4bME8ENHGbSFAsL469sYjHQ4vWueCIq3VCeezCOJAAAAAAAA


--nextPart2462820.1jYm70o8x4--
