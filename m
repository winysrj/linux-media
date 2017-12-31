Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout01.posteo.de ([185.67.36.65]:33074 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751119AbdLaPTL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 31 Dec 2017 10:19:11 -0500
Received: from submission (posteo.de [89.146.220.130])
        by mout01.posteo.de (Postfix) with ESMTPS id B51A320F59
        for <linux-media@vger.kernel.org>; Sun, 31 Dec 2017 16:19:08 +0100 (CET)
Subject: Re: [BUG] atomisp_ov2680 not initializing correctly
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        alan@linux.intel.com, hdegoede@redhat.com
References: <42dfd60f-2534-b9cd-eeab-3110d58ef7c0@posteo.de>
 <20171219120020.w7byb7bv3hhzn2jb@valkosipuli.retiisi.org.uk>
 <1513715821.7000.228.camel@linux.intel.com>
 <20171221125444.GB2935@ber-nb-001.aisec.fraunhofer.de>
 <1513866211.7000.250.camel@linux.intel.com>
 <6d1a2dc7-1d7b-78f3-9334-ccdedaa66510@posteo.de>
 <1514476996.7000.437.camel@linux.intel.com>
From: Kristian Beilke <beilke@posteo.de>
Message-ID: <5fbb0600-82a0-5d17-a812-81d7707a335b@posteo.de>
Date: Sun, 31 Dec 2017 16:19:05 +0100
MIME-Version: 1.0
In-Reply-To: <1514476996.7000.437.camel@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms090600080501010103020106"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090600080501010103020106
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 12/28/2017 05:03 PM, Andy Shevchenko wrote:
> On Sat, 2017-12-23 at 01:31 +0100, Kristian Beilke wrote:
>> On 12/21/2017 03:23 PM, Andy Shevchenko wrote:
>>> On Thu, 2017-12-21 at 13:54 +0100, Kristian Beilke wrote:
>>>> On Tue, Dec 19, 2017 at 10:37:01PM +0200, Andy Shevchenko wrote:
>>>>> On Tue, 2017-12-19 at 14:00 +0200, Sakari Ailus wrote:
>>>>>> Cc Alan and Andy.
>>>>>>
>>>>>> On Sat, Dec 16, 2017 at 04:50:04PM +0100, Kristian Beilke
>>>>>> wrote:
>>>>>>> Dear all,
>>>>>>>
>>>>>>> I am trying to get the cameras in a Lenovo IdeaPad Miix 320
>>>>>>> (Atom
>>>>>>> x5-Z8350 BayTrail) to work. The front camera is an ov2680.
>>>>>>> With
>>
>> CherryTrail

>>>>> WRT to the messages below it seems we have no platform data for
>>>>> that
>>>>> device. It needs to be added.
>>>>>
>>
>> I tried to do exactly this. Extracted some values from
>> acpidump/acpixtract and dmidecode, but unsure I nailed it.
>=20
> Can you share somewhere it (pastebin.com, gist.github.com, etc)?
>=20

https://gist.github.com/jdkbx/dabe0d000330dd2a04acf8d870e0e06f

dmidecode gives me

Handle 0x0002, DMI type 2, 17 bytes
Base Board Information
        Manufacturer: LENOVO
        Product Name: LNVNB161216
        Version: SDK0J91196WIN

what I assume works as identifier in:
DMI_MATCH(DMI_BOARD_NAME, "LNVNB161216")

diff --git
a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.=
c
b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.=
c
index 87216bc35648..716be4ace60e 100644
---
a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.=
c
+++
b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.=
c
@@ -503,6 +503,18 @@ static struct gmin_cfg_var cht_cr_vars[] =3D {
        {},
 };

+static struct gmin_cfg_var miix320_vars[] =3D {
+        {"OVTI2680:00_CamType", "1"},
+        {"OVTI2680:00_CsiPort", "0"},
+        {"OVTI2680:00_CsiLanes", "1"},
+        {"OVTI2680:00_CsiFmt", "15"},
+        {"OVTI2680:00_CsiBayer", "0"},
+        {"OVTI2680:00_CamClk", "1"},
+        {"OVTI2680:00_Regulator1p8v", "0"},
+        {"OVTI2680:00_Regulator2p8v", "0"},
+        {},
+};
+
 static struct gmin_cfg_var mrd7_vars[] =3D {
 	{"INT33F8:00_CamType", "1"},
 	{"INT33F8:00_CsiPort", "1"},
@@ -566,6 +578,13 @@ static const struct dmi_system_id gmin_vars[] =3D {
 		},
 		.driver_data =3D cht_cr_vars,
        	},
+	{
+                .ident =3D "MIIX320",
+                .matches =3D {
+                        DMI_MATCH(DMI_BOARD_NAME, "LNVNB161216"),
+                },
+                .driver_data =3D miix320_vars,
+        },
 	{
 		.ident =3D "MRD7",
 		.matches =3D {

>> After your set of patches I applied the CherryTrail support I found
>> here
>> https://github.com/croutor/atomisp2401
>>
>=20
> I have few hacks on top of this.
>=20
> First of all, take a base as atomisp branch of sakari's media_tree
> repository:
>=20
> https://git.linuxtv.org/sailus/media_tree.git/
>=20

I updated the mentioned patches by Vincent Hervieux to apply cleanly on
the media_tree atomisp branch.

https://github.com/jdkbx/atomisp2401

> Second, apply
>=20
> --- a/drivers/staging/media/atomisp/platform/intel-
> mid/atomisp_gmin_platform.c
> +++ b/drivers/staging/media/atomisp/platform/intel-
> mid/atomisp_gmin_platform.c
> @@ -499,6 +499,7 @@ static int gmin_v1p8_ctrl(struct v4l2_subdev
> *subdev, int on)
>                         return regulator_disable(gs->v1p8_reg);
>         }
> =20
> +return 0;
>         return -EINVAL;
>  }
> =20
> @@ -535,6 +536,7 @@ static int gmin_v2p8_ctrl(struct v4l2_subdev
> *subdev, int on)
>                         return regulator_disable(gs->v2p8_reg);
>         }
> =20
> +return 0;
>         return -EINVAL;
>  }
>=20
> ---
> a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
> +++
> b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
> @@ -184,6 +184,7 @@ sh_css_check_firmware_version(const char *fw_data)
>         firmware_header =3D (struct firmware_header *)fw_data;
>         file_header =3D &firmware_header->file_header;
> =20
> +return true;
>         if (strcmp(file_header->version, release_version) !=3D 0) {
>                 return false;
>=20
> --- a/drivers/staging/media/atomisp/pci/atomisp2/Makefile
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
> @@ -348,6 +348,8 @@ DEFINES :=3D -DHRT_HW -DHRT_ISP_CSS_CUSTOM_HOST
> -DHRT_USE_VIR_ADDRS -D__HOST__
>  #DEFINES +=3D -DPUNIT_CAMERA_BUSY
>  #DEFINES +=3D -DUSE_KMEM_CACHE
> =20
> +DEFINES +=3D -DDEBUG
> +
>  DEFINES +=3D -DATOMISP_POSTFIX=3D\"css2400b0_v21\" -DISP2400B0
>=20
> For CHT you have to change define in this file to 2401 here and line
> below AFAIU (never did this).
>=20
> Third, you need to change pmic_id to be PMIC_AXP (I have longer patch
> for this, that's why don't post here). Just hard code it for now in gmi=
n
> file.
>=20

I assume the given patch set does already what you suggest here, apart
from the DDEBUG DEFINE.

> Fourth, you have to be sure the clock rate is chosen correctly
> (currently there is a bug in clk_set_rate() where parameter is clock
> source index instead of frequency!). I think you need to hardcode
> 19200000 there instead of gs->clock_src.

I found nothing about this in the patch set, so I will do this manually.

>> I am still not sure the FW gets loaded, and there is still no
>> /dev/camera, but it looks promising.
>=20
> You may add a debug print in necessary function inside ->probe (in
> atomisp_v4l2.c). I dont't remember if -DDEBUG will enable something lik=
e
> that. Perhaps.

Thats what I will do next.

> You are expecting /dev/video<N> nodes. /dev/camera is usually a udev's
> alias against one of /dev/video<N> nodes.

As described by Alan in a later mail, this actually gives me 10
/dev/video[0-10] nodes, but none producing any images. video4 and
video10 cause a kernel oops when opened.

[  425.667704] BUG: unable to handle kernel NULL pointer dereference at
00000000000000b8
[  425.667761] IP: atomisp_g_parm+0x4a/0x80 [atomisp]
[  425.667765] PGD 0 P4D 0
[  425.667771] Oops: 0000 [#1] SMP
[  425.667776] Modules linked in: rfcomm bnep snd_soc_sst_cht_bsw_rt5645
wmi_bmof cmdlinepart intel_spi_platform intel_spi spi_nor mtd
snd_intel_sst_acpi snd_intel_sst_core snd_soc_sst_atom_hifi2_platform
snd_soc_acpi snd_soc_rt5645 snd_soc_acpi_intel_match gpio_keys
snd_soc_rl6231 nls_iso8859_1 intel_rapl intel_powerclamp coretemp
punit_atom_debug intel_cstate iwlmvm mac80211 axp288_fuel_gauge
extcon_axp288 axp288_charger axp288_adc axp20x_pek cdc_mbim cdc_wdm
cdc_ncm usbnet joydev mii hid_multitouch iwlwifi input_leds btusb btrtl
btbcm btintel atomisp(C) bluetooth cfg80211 mei_txe mei lpc_ich
videobuf_vmalloc processor_thermal_device shpchp videobuf_core
intel_soc_dts_iosf snd_seq_midi snd_seq_midi_event snd_rawmidi
snd_soc_core snd_seq snd_compress ac97_bus snd_pcm_dmaengine
bmc150_accel_i2c dw_dmac
[  425.667850]  bmc150_accel_core dw_dmac_core
industrialio_triggered_buffer snd_pcm kfifo_buf industrialio
atomisp_ov2680(C) snd_seq_device v4l2_common snd_timer videodev snd
media soundcore pwm_lpss_platform 8250_dw tpm_crb spi_pxa2xx_platform
pwm_lpss wmi acpi_pad int3403_thermal int3400_thermal
int340x_thermal_zone acpi_thermal_rel soc_button_array
intel_int0002_vgpio parport_pc ppdev lp parport ip_tables x_tables
hid_generic usbhid dm_crypt mmc_block i915 intel_gtt i2c_algo_bit
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm video
i2c_hid hid sdhci_acpi sdhci
[  425.667909] CPU: 1 PID: 2385 Comm: mplayer Tainted: G         C
4.15.0-rc3 #5
[  425.667912] Hardware name: LENOVO 80XF/LNVNB161216, BIOS 5HCN31WW
09/11/2017
[  425.667949] RIP: 0010:atomisp_g_parm+0x4a/0x80 [atomisp]
[  425.667952] RSP: 0018:ffffaca6c2917c90 EFLAGS: 00010246
[  425.667957] RAX: 0000000000000000 RBX: ffff9b50343aeea0 RCX:
ffffffffc0a872c0
[  425.667960] RDX: ffff9b4ff816c140 RSI: 0000000000000000 RDI:
ffff9b50343aeea0
[  425.667963] RBP: ffff9b5036075200 R08: ffffffffc0a87200 R09:
ffff9b5038843300
[  425.667965] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff9b5038843c80
[  425.667968] R13: 0000000000000000 R14: 00000000000000cc R15:
ffff9b50332d5e00
[  425.667972] FS:  00007fbc6ba72440(0000) GS:ffff9b503fc80000(0000)
knlGS:0000000000000000
[  425.667976] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  425.667979] CR2: 00000000000000b8 CR3: 0000000175f4b000 CR4:
00000000001006e0
[  425.667982] Call Trace:
[  425.668001]  ? v4l_g_parm+0x54/0xd0 [videodev]
[  425.668014]  ? __video_do_ioctl+0x34d/0x360 [videodev]
[  425.668022]  ? path_openat+0x5bb/0x1620
[  425.668028]  ? _cond_resched+0x15/0x40
[  425.668034]  ? __kmalloc_node+0x1ea/0x2a0
[  425.668046]  ? video_ioctl2+0x20/0x20 [videodev]
[  425.668058]  ? video_usercopy+0x97/0x5b0 [videodev]
[  425.668071]  ? v4l2_ioctl+0xbb/0xe0 [videodev]
[  425.668076]  ? do_vfs_ioctl+0xa4/0x630
[  425.668081]  ? SyS_ioctl+0x7c/0x90
[  425.668087]  ? entry_SYSCALL_64_fastpath+0x1e/0x81
[  425.668091] Code: 01 4c 8b a0 78 09 00 00 48 8b 9b 50 02 00 00 75 2f
48 81 c3 88 0e 00 00 48 89 df e8 f1 51 d6 ec 49 8b 84 24 c0 44 00 00 48
8d 3b <8b> 80 b8 00 00 00 89 45 08 e8 78 4d d6 ec 31 c0 5b 5d 41 5c c3
[  425.668185] RIP: atomisp_g_parm+0x4a/0x80 [atomisp] RSP: ffffaca6c2917=
c90
[  425.668188] CR2: 00000000000000b8
[  425.668237] ---[ end trace fb76f36afd55319e ]---
[  425.672735] ------------[ cut here ]------------
[  425.672748] rtmutex deadlock detected
[  425.672767] WARNING: CPU: 1 PID: 2385 at kernel/locking/rtmutex.h:28
rt_mutex_slowlock+0x176/0x1e0
[  425.672771] Modules linked in: rfcomm bnep snd_soc_sst_cht_bsw_rt5645
wmi_bmof cmdlinepart intel_spi_platform intel_spi spi_nor mtd
snd_intel_sst_acpi snd_intel_sst_core snd_soc_sst_atom_hifi2_platform
snd_soc_acpi snd_soc_rt5645 snd_soc_acpi_intel_match gpio_keys
snd_soc_rl6231 nls_iso8859_1 intel_rapl intel_powerclamp coretemp
punit_atom_debug intel_cstate iwlmvm mac80211 axp288_fuel_gauge
extcon_axp288 axp288_charger axp288_adc axp20x_pek cdc_mbim cdc_wdm
cdc_ncm usbnet joydev mii hid_multitouch iwlwifi input_leds btusb btrtl
btbcm btintel atomisp(C) bluetooth cfg80211 mei_txe mei lpc_ich
videobuf_vmalloc processor_thermal_device shpchp videobuf_core
intel_soc_dts_iosf snd_seq_midi snd_seq_midi_event snd_rawmidi
snd_soc_core snd_seq snd_compress ac97_bus snd_pcm_dmaengine
bmc150_accel_i2c dw_dmac
[  425.672845]  bmc150_accel_core dw_dmac_core
industrialio_triggered_buffer snd_pcm kfifo_buf industrialio
atomisp_ov2680(C) snd_seq_device v4l2_common snd_timer videodev snd
media soundcore pwm_lpss_platform 8250_dw tpm_crb spi_pxa2xx_platform
pwm_lpss wmi acpi_pad int3403_thermal int3400_thermal
int340x_thermal_zone acpi_thermal_rel soc_button_array
intel_int0002_vgpio parport_pc ppdev lp parport ip_tables x_tables
hid_generic usbhid dm_crypt mmc_block i915 intel_gtt i2c_algo_bit
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm video
i2c_hid hid sdhci_acpi sdhci
[  425.672906] CPU: 1 PID: 2385 Comm: mplayer Tainted: G      D  C
4.15.0-rc3 #5
[  425.672909] Hardware name: LENOVO 80XF/LNVNB161216, BIOS 5HCN31WW
09/11/2017
[  425.672913] RIP: 0010:rt_mutex_slowlock+0x176/0x1e0
[  425.672916] RSP: 0018:ffffaca6c2917c88 EFLAGS: 00010046
[  425.672921] RAX: 0000000000000000 RBX: ffff9b50343aeea0 RCX:
0000000000000006
[  425.672924] RDX: 0000000000000007 RSI: 0000000000000002 RDI:
ffff9b503fc8cdd0
[  425.672927] RBP: ffffaca6c2917ca0 R08: 0000000000000382 R09:
000000000000000f
[  425.672930] R10: 0000000000000000 R11: ffffffffae3e0e0d R12:
0000000000000000
[  425.672933] R13: 0000000000000002 R14: 00000000ffffffdd R15:
0000000000000000
[  425.672937] FS:  0000000000000000(0000) GS:ffff9b503fc80000(0000)
knlGS:0000000000000000
[  425.672945] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  425.672948] CR2: 00000000000000b8 CR3: 0000000167808000 CR4:
00000000001006e0
[  425.672951] Call Trace:
[  425.673008]  ? atomisp_release+0x8f/0x520 [atomisp]
[  425.673016]  ? kmem_cache_free+0x195/0x1c0
[  425.673033]  ? v4l2_release+0x30/0x80 [videodev]
[  425.673038]  ? __fput+0xd8/0x210
[  425.673046]  ? task_work_run+0x89/0xb0
[  425.673052]  ? do_exit+0x2ed/0xb30
[  425.673058]  ? rewind_stack_do_exit+0x17/0x20
[  425.673062] Code: 48 8d 75 00 48 8d 3b e8 f9 09 3f ff 41 83 fe dd 0f
85 70 ff ff ff 45 85 ff 0f 85 67 ff ff ff 48 c7 c7 99 04 bb ad e8 9a f5
39 ff <0f> ff 48 c7 44 24 10 01 00 00 00 65 48 8b 14 25 40 c4 00 00 48
[  425.673123] ---[ end trace fb76f36afd55319f ]---

>>  Am I on the right track here, or am
>> I wasting my (and your) time?
>=20
> It's both: track is right and it's waste of time.
>=20

I see your point, Still it feels, as if this could go somewhere. Anyway,
thanks for your explanations and the time you invested into this.

Happy New Year to everyone.


--------------ms090600080501010103020106
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
1OX1+9Sa12i3fYdFURvLL0M/M8gOS9OaKxS0e7zvSIFUdj2Rik+RtFyQT7YI+Ts/Dz3i3gZL
goDRjt02MNYFc/PSQpppYrOlEmyhfO2gyUxDrbfyUVeHGJb+qDCk8MQvcqtpAmWPUWXh9EVm
+MtPWkuVl7KE0t7L7Fo1PfW8Z0njbbItC8IsYP/5DPpZNn+b0i4HlQIDAQABo4IBZjCCAWIw
EgYDVR0TAQH/BAgwBgEB/wIBATAdBgNVHQ4EFgQU+thxMjzc6tI1fl/YZOLx/xxmq20wCwYD
VR0PBAQDAgGGMBAGCSsGAQQBgjcVAQQDAgEAME0GA1UdIARGMEQwOgYHYIV0BQ4EAjAvMC0G
CCsGAQUFBwIBFiFodHRwOi8vd3d3Lndpc2VrZXkuY29tL3JlcG9zaXRvcnkwBgYEVR0gADAZ
BgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAfBgNVHSMEGDAWgBSzA36uNrywedHclCa2Eb4h
smmGlDA7BgNVHR8ENDAyMDCgLqAshipodHRwOi8vcHVibGljLndpc2VrZXkuY29tL2NybC9v
d2dyZ2FjYS5jcmwwRgYIKwYBBQUHAQEEOjA4MDYGCCsGAQUFBzAChipodHRwOi8vcHVibGlj
Lndpc2VrZXkuY29tL2NydC9vd2dyZ2FjYS5jcnQwDQYJKoZIhvcNAQEFBQADggEBAF+vdwQb
bzXBAKeD1wJN9Hi6GFioVn31+3JEY+C/IfMpj7WgUxgFDn8Y1wgJGmYqBVqibJgSISzX641T
oJb/dqCMz3a96HYCe50hoBR7ofAeW2+ygwjP+hZ3tgYEPOgHSa3XxWWy89EsipbK9FCGa8m/
/Mqep9zQWay1N01BLX8/nh32Rc++tJfCayDARN68goiHeeAxgMqW6qsTBCJgyHNQz8FowXbn
y7uQeORA7035VWA1ZrF30sxkUy+EX/URuwLoKWkap6CTmjLj7O7RI4l+OF8GWX1tqT7dCbZ9
BQX1xQcVdTOOC0b2v8q3Xap++4XsaVH6i97i19iQmarCTAkwggUNMIID9aADAgECAgoS44FT
AAAAAAAdMA0GCSqGSIb3DQEBBQUAMIGKMQswCQYDVQQGEwJDSDEQMA4GA1UEChMHV0lTZUtl
eTEmMCQGA1UECxMdQ29weXJpZ2h0IChjKSAyMDA1IFdJU2VLZXkgU0ExFjAUBgNVBAsTDUlu
dGVybmF0aW9uYWwxKTAnBgNVBAMTIFdJU2VLZXkgQ2VydGlmeUlEIFN0YW5kYXJkIEcxIENB
MB4XDTEyMDEyMzE1MzIyMFoXDTIwMTIyMzEwNTUzMlowgZIxCzAJBgNVBAYTAkNIMRAwDgYD
VQQKEwdXSVNlS2V5MSYwJAYDVQQLEx1Db3B5cmlnaHQgKGMpIDIwMTIgV0lTZUtleSBTQTEW
MBQGA1UECxMNSW50ZXJuYXRpb25hbDExMC8GA1UEAxMoV0lTZUtleSBDZXJ0aWZ5SUQgU3Rh
bmRhcmQgU2VydmljZXMgQ0EgMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMTB
EkIPma0JnAXCAqL/qZBhlgp2fDqIl3dFFRBhoncFDXczDZFb5gCRaftONrBxFvvAakL/XooN
oQzXd3kCzrV6BVmxdvhyAjXEtkjiiT22WH5IebpJffwcJw4qDhhPjfFyrVvmlx6uGnn8ewj7
Ci+JzZYi4D8FUPhO/S3joQ/Zq+OKNA8JxE9iFoYsLp22p9KHT+Ny608klEb0Cfb0pw9/HXft
tOQWtCdRlNHRJOGSLGFamxiIJUUJrMoweXBQNcprSbjUEjqrTWWYN/PUd+5+3mvz2W1OEIqR
O+j/9reC6XPjcM72q/l6ZMchKplc6Lx9EJZrTlM/lD4ArlGGNM8CAwEAAaOCAWkwggFlMBIG
A1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFLv1zq5bKCFL3AK0TU2Ps0ritOGTMAsGA1Ud
DwQEAwIBhjAQBgkrBgEEAYI3FQEEAwIBADBOBgNVHSAERzBFMDsGCGCFdAUOBAIBMC8wLQYI
KwYBBQUHAgEWIWh0dHA6Ly93d3cud2lzZWtleS5jb20vcmVwb3NpdG9yeTAGBgRVHSAAMBkG
CSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMB8GA1UdIwQYMBaAFPrYcTI83OrSNX5f2GTi8f8c
ZqttMDwGA1UdHwQ1MDMwMaAvoC2GK2h0dHA6Ly9wdWJsaWMud2lzZWtleS5jb20vY3JsL3dj
aWRzZzFjYS5jcmwwRwYIKwYBBQUHAQEEOzA5MDcGCCsGAQUFBzAChitodHRwOi8vcHVibGlj
Lndpc2VrZXkuY29tL2NydC93Y2lkc2cxY2EuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQB7RWBe
cGw5/ee/JqALLMYbruDEWiijxCsdJiEDR1r1Os+HQmWfQWQSHjM3mkD6GAvfne0EBgOQ+Ftw
LBb63nSf1HzLdVVppIKo/Y2lT4ZN938Pw4zywZ/soYXNWH/ULHbHvCFoFnXDUX8ENf8sSY/h
olfT7aX5cczt6NtkG/naGpnEcXFjapOXRtXZZ9oOHtRiSqPOQTsdb2+AsPXdfkENqJ2XVNpr
bOOi5b8FO7CYP/xZtNI/gomluWJr7Yu3M7pUlX+J/vCpdmvhQDSSlNjAqjfPHZZ0VWw4tie3
9Cw5lLxax2U1HfRX/TjTA8f4Xpc0+dOeXDRTFnO3+adaZ5QQMYIEFDCCBBACAQEwgaEwgZIx
CzAJBgNVBAYTAkNIMRAwDgYDVQQKEwdXSVNlS2V5MSYwJAYDVQQLEx1Db3B5cmlnaHQgKGMp
IDIwMTIgV0lTZUtleSBTQTEWMBQGA1UECxMNSW50ZXJuYXRpb25hbDExMC8GA1UEAxMoV0lT
ZUtleSBDZXJ0aWZ5SUQgU3RhbmRhcmQgU2VydmljZXMgQ0EgMgIKdfdTVAAAAABJ8zANBglg
hkgBZQMEAgEFAKCCAkMwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMTcxMjMxMTUxOTA1WjAvBgkqhkiG9w0BCQQxIgQgxvB+/69NIbsguHkMsumYPDzF1Tw9
xNweWrkfTn1YdB8wbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAEC
MAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzAN
BggqhkiG9w0DAgIBKDCBsgYJKwYBBAGCNxAEMYGkMIGhMIGSMQswCQYDVQQGEwJDSDEQMA4G
A1UEChMHV0lTZUtleTEmMCQGA1UECxMdQ29weXJpZ2h0IChjKSAyMDEyIFdJU2VLZXkgU0Ex
FjAUBgNVBAsTDUludGVybmF0aW9uYWwxMTAvBgNVBAMTKFdJU2VLZXkgQ2VydGlmeUlEIFN0
YW5kYXJkIFNlcnZpY2VzIENBIDICCnX3U1QAAAAASfMwgbQGCyqGSIb3DQEJEAILMYGkoIGh
MIGSMQswCQYDVQQGEwJDSDEQMA4GA1UEChMHV0lTZUtleTEmMCQGA1UECxMdQ29weXJpZ2h0
IChjKSAyMDEyIFdJU2VLZXkgU0ExFjAUBgNVBAsTDUludGVybmF0aW9uYWwxMTAvBgNVBAMT
KFdJU2VLZXkgQ2VydGlmeUlEIFN0YW5kYXJkIFNlcnZpY2VzIENBIDICCnX3U1QAAAAASfMw
DQYJKoZIhvcNAQEBBQAEggEAMAy07Tu1fPo2iO4+e8TilPiO1CrJYY1Trwpt+mh6klsq0aYo
A5EaJzXGimsTKJP8I0XoxnFxDxTZ7he5EcNb0f0JLPY07mZpYW+ZmMlDZSxtkyZRYbz4/VSr
CJva/entQeSn+hejdCCa8n4YPwEmpED4gRCOUbNtd4XujTzWrL/iAXP9poF3XPZToSr0ioxc
O6LreX5cYMazjfkLW+djl76lOWpMEVgkb27i8f+IhVvcgaY+W6DENqP/sea8YIfgekjzBLbS
nOhQ/ykBP/zIBov3Kjqg4H9R+6nmCTj3GjhR0VtC/CKbYglxPc3bnbkiTWIwiUaCWY4aDNnA
KVncAQAAAAAAAA==
--------------ms090600080501010103020106--
