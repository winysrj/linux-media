Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:44752 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935024AbdCLRwI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 13:52:08 -0400
Date: Sun, 12 Mar 2017 17:51:18 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
Message-ID: <20170312175118.GP21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've just looked at my test system's dmesg, and spotted this in the log.
It's been a while since these popped out of the kernel, so I don't know
what caused them (other than the obvious, a media-ctl command.)

My script which sets this up only enables links, and then configures the
formats etc, and doesn't disable them, so I don't see why the power
count should be going negative.

------------[ cut here ]------------
WARNING: CPU: 1 PID: 1889 at drivers/staging/media/imx/imx-media-csi.c:806 csi_s_power+0x9c/0xa8 [imx_media_csi]
Modules linked in: caam_jr uvcvideo snd_soc_imx_sgtl5000 snd_soc_fsl_asoc_card snd_soc_imx_spdif imx_media_csi(C) imx6_mipi_csi2(C) snd_soc_imx_audmux snd_soc_sgtl5000 imx219 imx_media_ic(C) imx_media_capture(C) imx_media_vdic(C) caam video_multiplexer imx_sdma coda v4l2_mem2mem videobuf2_v4l2 imx2_wdt imx_vdoa videobuf2_dma_contig videobuf2_core videobuf2_vmalloc videobuf2_memops snd_soc_fsl_ssi
imx_thermal snd_soc_fsl_spdif imx_pcm_dma imx_media(C) imx_media_common(C) nfsd
rc_pinnacle_pctv_hd dw_hdmi_ahb_audio dw_hdmi_cec etnaviv
CPU: 1 PID: 1889 Comm: media-ctl Tainted: G         C      4.11.0-rc1+ #2125
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Backtrace:
[<c0013ba4>] (dump_backtrace) from [<c0013de4>] (show_stack+0x18/0x1c)
 r6:600e0013 r5:ffffffff r4:00000000 r3:00000000
[<c0013dcc>] (show_stack) from [<c033f728>] (dump_stack+0xa4/0xdc)
[<c033f684>] (dump_stack) from [<c00326cc>] (__warn+0xdc/0x108)
 r6:bf124014 r5:00000000 r4:00000000 r3:c09ea4a8
[<c00325f0>] (__warn) from [<c0032720>] (warn_slowpath_null+0x28/0x30)
 r10:ede00010 r8:ede4a348 r7:d039501c r6:d0395140 r5:00000000 r4:d0395010
[<c00326f8>] (warn_slowpath_null) from [<bf1229e0>] (csi_s_power+0x9c/0xa8 [imx_media_csi])
[<bf122944>] (csi_s_power [imx_media_csi]) from [<bf04a930>] (imx_media_set_power+0x3c/0x108 [imx_media_common])
 r7:d039501c r6:00000000 r5:00000000 r4:0000000c
[<bf04a8f4>] (imx_media_set_power [imx_media_common]) from [<bf04aa34>] (imx_media_pipeline_set_power+0x38/0x40 [imx_media_common])
 r10:00000001 r9:00000001 r8:ede4a348 r7:ede00010 r6:ede4a348 r5:d039501c
 r4:00000001
[<bf04a9fc>] (imx_media_pipeline_set_power [imx_media_common]) from [<bf052148>] (imx_media_link_notify+0xf0/0x144 [imx_media])
 r7:ede00010 r6:ed59f900 r5:00000000 r4:d039501c
[<bf052058>] (imx_media_link_notify [imx_media]) from [<c04fa858>] (__media_entity_setup_link+0x110/0x1d8)
 r10:c0347c03 r9:d7eb3dc8 r8:befe92b0 r7:ede00010 r6:00000000 r5:00000001
 r4:ed59f900 r3:bf052058
[<c04fa748>] (__media_entity_setup_link) from [<c04f9bb0>] (media_device_setup_link+0x84/0x90)
 r7:ede00010 r6:ede00010 r5:ef3fd810 r4:d7eb3dc8
[<c04f9b2c>] (media_device_setup_link) from [<c04f9e94>] (media_device_ioctl+0xa4/0x148)
 r6:00000000 r5:d7eb3dc8 r4:c077b014 r3:c04f9b2c
[<c04f9df0>] (media_device_ioctl) from [<c04fa3a0>] (media_ioctl+0x38/0x4c)
 r10:ed5eca68 r9:d7eb2000 r8:befe92b0 r7:00000003 r6:00000003 r5:e82ca280
 r4:c0190304
[<c04fa368>] (media_ioctl) from [<c018f9c0>] (do_vfs_ioctl+0x98/0x9a0)
[<c018f928>] (do_vfs_ioctl) from [<c0190304>] (SyS_ioctl+0x3c/0x60)
 r10:00000000 r9:d7eb2000 r8:befe92b0 r7:00000003 r6:c0347c03 r5:e82ca280
 r4:e82ca280
[<c01902c8>] (SyS_ioctl) from [<c000fd60>] (ret_fast_syscall+0x0/0x1c)
 r8:c000ff04 r7:00000036 r6:000261d0 r5:00000001 r4:009162e8 r3:00000001
---[ end trace 4fdd40e5adfc4485 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 1889 at drivers/staging/media/imx/imx-media-csi.c:806 csi_s_power+0x9c/0xa8 [imx_media_csi]
Modules linked in: caam_jr uvcvideo snd_soc_imx_sgtl5000 snd_soc_fsl_asoc_card snd_soc_imx_spdif imx_media_csi(C) imx6_mipi_csi2(C) snd_soc_imx_audmux snd_soc_sgtl5000 imx219 imx_media_ic(C) imx_media_capture(C) imx_media_vdic(C) caam video_multiplexer imx_sdma coda v4l2_mem2mem videobuf2_v4l2 imx2_wdt imx_vdoa videobuf2_dma_contig videobuf2_core videobuf2_vmalloc videobuf2_memops snd_soc_fsl_ssi
imx_thermal snd_soc_fsl_spdif imx_pcm_dma imx_media(C) imx_media_common(C) nfsd
rc_pinnacle_pctv_hd dw_hdmi_ahb_audio dw_hdmi_cec etnaviv
CPU: 1 PID: 1889 Comm: media-ctl Tainted: G        WC      4.11.0-rc1+ #2125
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Backtrace:
[<c0013ba4>] (dump_backtrace) from [<c0013de4>] (show_stack+0x18/0x1c)
 r6:600e0013 r5:ffffffff r4:00000000 r3:00000000
[<c0013dcc>] (show_stack) from [<c033f728>] (dump_stack+0xa4/0xdc)
[<c033f684>] (dump_stack) from [<c00326cc>] (__warn+0xdc/0x108)
 r6:bf124014 r5:00000000 r4:00000000 r3:c09ea4a8
[<c00325f0>] (__warn) from [<c0032720>] (warn_slowpath_null+0x28/0x30)
 r10:ede00010 r8:ede4a348 r7:ee000800 r6:d0395140 r5:00000000 r4:d0395010
[<c00326f8>] (warn_slowpath_null) from [<bf1229e0>] (csi_s_power+0x9c/0xa8 [imx_media_csi])
[<bf122944>] (csi_s_power [imx_media_csi]) from [<bf04a930>] (imx_media_set_power+0x3c/0x108 [imx_media_common])
 r7:ee000800 r6:00000000 r5:00000000 r4:0000000c
[<bf04a8f4>] (imx_media_set_power [imx_media_common]) from [<bf04aa34>] (imx_media_pipeline_set_power+0x38/0x40 [imx_media_common])
 r10:00000001 r9:00000001 r8:ede4a348 r7:ede00010 r6:ede4a348 r5:ee000800
 r4:00000001
[<bf04a9fc>] (imx_media_pipeline_set_power [imx_media_common]) from [<bf052148>] (imx_media_link_notify+0xf0/0x144 [imx_media])
 r7:ede00010 r6:d0320480 r5:ee000800 r4:ee000800
[<bf052058>] (imx_media_link_notify [imx_media]) from [<c04fa858>] (__media_entity_setup_link+0x110/0x1d8)
 r10:c0347c03 r9:d7eb3dc8 r8:befe92b0 r7:ede00010 r6:00000000 r5:00000001
 r4:d0320480 r3:bf052058
[<c04fa748>] (__media_entity_setup_link) from [<c04f9bb0>] (media_device_setup_link+0x84/0x90)
 r7:ede00010 r6:ede00010 r5:d039501c r4:d7eb3dc8
[<c04f9b2c>] (media_device_setup_link) from [<c04f9e94>] (media_device_ioctl+0xa4/0x148)
 r6:00000000 r5:d7eb3dc8 r4:c077b014 r3:c04f9b2c
[<c04f9df0>] (media_device_ioctl) from [<c04fa3a0>] (media_ioctl+0x38/0x4c)
 r10:ed5eca68 r9:d7eb2000 r8:befe92b0 r7:00000003 r6:00000003 r5:e82ca500
 r4:c0190304
[<c04fa368>] (media_ioctl) from [<c018f9c0>] (do_vfs_ioctl+0x98/0x9a0)
[<c018f928>] (do_vfs_ioctl) from [<c0190304>] (SyS_ioctl+0x3c/0x60)
 r10:00000000 r9:d7eb2000 r8:befe92b0 r7:00000003 r6:c0347c03 r5:e82ca500
 r4:e82ca500
[<c01902c8>] (SyS_ioctl) from [<c000fd60>] (ret_fast_syscall+0x0/0x1c)
 r8:c000ff04 r7:00000036 r6:000261d0 r5:00000001 r4:0091737c r3:00000001
---[ end trace 4fdd40e5adfc4486 ]---

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
