Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42852 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751791AbdBBWuw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 17:50:52 -0500
Date: Thu, 2 Feb 2017 22:50:04 +0000
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
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v3 16/24] media: Add i.MX media core driver
Message-ID: <20170202225004.GZ27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-17-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483755102-24785-17-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 06, 2017 at 06:11:34PM -0800, Steve Longerbeam wrote:
> +/* register an internal subdev as a platform device */
> +static struct imx_media_subdev *
> +add_internal_subdev(struct imx_media_dev *imxmd,
> +		    const struct internal_subdev *isd,
> +		    int ipu_id)
> +{
> +	struct imx_media_internal_sd_platformdata pdata;
> +	struct platform_device_info pdevinfo = {0};
> +	struct imx_media_subdev *imxsd;
> +	struct platform_device *pdev;
> +
> +	switch (isd->id->grp_id) {
> +	case IMX_MEDIA_GRP_ID_CAMIF0...IMX_MEDIA_GRP_ID_CAMIF1:
> +		pdata.grp_id = isd->id->grp_id +
> +			((2 * ipu_id) << IMX_MEDIA_GRP_ID_CAMIF_BIT);
> +		break;
> +	default:
> +		pdata.grp_id = isd->id->grp_id;
> +		break;
> +	}
> +
> +	/* the id of IPU this subdev will control */
> +	pdata.ipu_id = ipu_id;
> +
> +	/* create subdev name */
> +	imx_media_grp_id_to_sd_name(pdata.sd_name, sizeof(pdata.sd_name),
> +				    pdata.grp_id, ipu_id);
> +
> +	pdevinfo.name = isd->id->name;
> +	pdevinfo.id = ipu_id * num_isd + isd->id->index;
> +	pdevinfo.parent = imxmd->dev;
> +	pdevinfo.data = &pdata;
> +	pdevinfo.size_data = sizeof(pdata);
> +	pdevinfo.dma_mask = DMA_BIT_MASK(32);
> +
> +	pdev = platform_device_register_full(&pdevinfo);
> +	if (IS_ERR(pdev))
> +		return ERR_CAST(pdev);
> +
> +	imxsd = imx_media_add_async_subdev(imxmd, NULL, dev_name(&pdev->dev));
> +	if (IS_ERR(imxsd))
> +		return imxsd;
> +
> +	imxsd->num_sink_pads = isd->num_sink_pads;
> +	imxsd->num_src_pads = isd->num_src_pads;
> +
> +	return imxsd;
> +}

You seem to create platform devices here, but I see nowhere that you
ever remove them - so if you get to the lucky point of being able to
rmmod imx-media and then try to re-insert it, you end up with a load
of kernel warnings, one for each device created this way, and
platform_device_register_full() fails:

WARNING: CPU: 0 PID: 2143 at /home/rmk/git/linux-rmk/fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80
sysfs: cannot create duplicate filename '/devices/soc0/soc/soc:media@0/imx-ipuv3-smfc.2'
Modules linked in: imx_media(C+) rfcomm bnep bluetooth nfsd imx_camif(C) imx_ic(C) imx_smfc(C) caam_jr snd_soc_imx_sgtl5000 snd_soc_fsl_asoc_card uvcvideo snd_soc_imx_spdif imx_mipi_csi2(C) imx_media_common(C) snd_soc_imx_audmux imx219 snd_soc_sgtl5000 video_multiplexer imx_sdma caam imx2_wdt rc_cec coda v4l2_mem2mem videobuf2_v4l2 snd_soc_fsl_ssi snd_soc_fsl_spdif videobuf2_dma_contig imx_pcm_dma videobuf2_core videobuf2_vmalloc videobuf2_memops imx_thermal dw_hdmi_cec dw_hdmi_ahb_audio etnaviv fuse rc_pinnacle_pctv_hd [last unloaded: imx_media]
CPU: 0 PID: 2143 Comm: modprobe Tainted: G         C      4.10.0-rc6+ #2103
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Backtrace:
[<c0013ba4>] (dump_backtrace) from [<c0013de4>] (show_stack+0x18/0x1c)
 r6:60000013 r5:ffffffff r4:00000000 r3:00000000
[<c0013dcc>] (show_stack) from [<c03334e8>] (dump_stack+0xa4/0xdc)
[<c0333444>] (dump_stack) from [<c0033210>] (__warn+0xdc/0x108)
 r6:c08ad998 r5:00000000 r4:cf4e9a78 r3:ec984980
[<c0033134>] (__warn) from [<c00332f4>] (warn_slowpath_fmt+0x40/0x48)
 r10:e5800010 r8:ef1fa818 r7:ef1fa810 r6:ef202300 r5:e9809000 r4:ee868000
[<c00332b8>] (warn_slowpath_fmt) from [<c01f5918>] (sysfs_warn_dup+0x64/0x80)
 r3:ee868000 r2:c08ad9c0
[<c01f58b4>] (sysfs_warn_dup) from [<c01f5a10>] (sysfs_create_dir_ns+0x90/0x98)
 r6:ffffffef r5:ef202300 r4:eb5e3418
[<c01f5980>] (sysfs_create_dir_ns) from [<c03361a4>] (kobject_add_internal+0xa4/0x2d8)
 r6:ef1fa818 r5:00000000 r4:eb5e3418
[<c0336100>] (kobject_add_internal) from [<c033657c>] (kobject_add+0x50/0x98)
 r8:bf1f9018 r7:ef1fa810 r6:ef1fa818 r5:00000000 r4:eb5e3418
[<c0336530>] (kobject_add) from [<c0415fd8>] (device_add+0xc8/0x538)
 r3:ef1fa834 r2:00000000
 r6:eb5e3418 r5:00000000 r4:eb5e3410
[<c0415f10>] (device_add) from [<c041ae24>] (platform_device_add+0xb0/0x214)
 r10:e5800010 r9:00000000 r8:bf1f9018 r7:e5806fd4 r6:eb5e3410 r5:eb5e3400
 r4:00000000
[<c041ad74>] (platform_device_add) from [<c041b7f4>] (platform_device_register_full+0xe8/0x110)
 r7:e5806fd4 r6:00000002 r5:eb5e3400 r4:cf4e9c18
[<c041b70c>] (platform_device_register_full) from [<bf1f7f54>] (add_ipu_internal_subdevs+0x128/0x2c8 [imx_media])
 r5:bf1f9000 r4:00000918
[<bf1f7e2c>] (add_ipu_internal_subdevs [imx_media]) from [<bf1f8120>] (imx_media_add_internal_subdevs+0x2c/0x70 [imx_media])
 r10:00000048 r9:f31ceef8 r8:ef7f1d94 r7:e5800230 r6:e5800200 r5:e5800010
 r4:cf4e9c90
[<bf1f80f4>] (imx_media_add_internal_subdevs [imx_media]) from [<bf1f71ec>] (imx_media_probe+0xc4/0x1c0 [imx_media])
 r5:00000000 r4:e5800010
[<bf1f7128>] (imx_media_probe [imx_media]) from [<c041ac80>] (platform_drv_probe+0x58/0xb8)
 r8:00000000 r7:bf1fbd48 r6:fffffdfb r5:ef1fa810 r4:fffffffe
[<c041ac28>] (platform_drv_probe) from [<c0418c90>] (driver_probe_device+0x204/0x2c8)
 r7:bf1fbd48 r6:00000000 r5:c1419de8 r4:ef1fa810
[<c0418a8c>] (driver_probe_device) from [<c0418e10>] (__driver_attach+0xbc/0xc0)
 r10:00000124 r8:00000001 r7:00000000 r6:ef1fa844 r5:bf1fbd48 r4:ef1fa810
[<c0418d54>] (__driver_attach) from [<c04170b0>] (bus_for_each_dev+0x5c/0x90)
 r6:c0418d54 r5:bf1fbd48 r4:00000000 r3:00000000
[<c0417054>] (bus_for_each_dev) from [<c04184f4>] (driver_attach+0x24/0x28)
 r6:c0a45e90 r5:ed5a8980 r4:bf1fbd48
[<c04184d0>] (driver_attach) from [<c04181f4>] (bus_add_driver+0xf4/0x200)
[<c0418100>] (bus_add_driver) from [<c0419c90>] (driver_register+0x80/0xfc)
 r7:00000000 r6:bf1fe000 r5:c0a70528 r4:bf1fbd48
[<c0419c10>] (driver_register) from [<c041ab54>] (__platform_driver_register+0x48/0x4c)
 r5:c0a70528 r4:bf1fbdc0
[<c041ab0c>] (__platform_driver_register) from [<bf1fe018>] (imx_media_pdrv_init+0x18/0x24 [imx_media])
[<bf1fe000>] (imx_media_pdrv_init [imx_media]) from [<c00098ac>] (do_one_initcall+0x44/0x170)
[<c0009868>] (do_one_initcall) from [<c011b090>] (do_init_module+0x68/0x1d8)
 r8:00000001 r7:bf1fbdc0 r6:e9809540 r5:c0a70528 r4:bf1fbdc0
[<c011b028>] (do_init_module) from [<c00d2d44>] (load_module+0x195c/0x2080)
 r7:bf1fbdc0 r6:c09e04ec r5:c0a70528 r4:c09f5f27
[<c00d13e8>] (load_module) from [<c00d3640>] (SyS_finit_module+0x94/0xa0)
 r10:00000000 r9:cf4e8000 r8:7f6b2398 r7:00000003 r6:00000000 r5:00000000
 r4:7fffffff
[<c00d35ac>] (SyS_finit_module) from [<c000fd60>] (ret_fast_syscall+0x0/0x1c)
 r8:c000ff04 r7:0000017b r6:80c95148 r5:80c95b10 r4:80c95370
---[ end trace 05abce0bbb26bc34 ]---

imx-media: add_internal_subdevs failed with -17
imx-media: probe of soc:media@0 failed with error -17

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
