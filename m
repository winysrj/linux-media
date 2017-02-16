Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33737 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933060AbdBPSoa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 13:44:30 -0500
Subject: Re: [PATCH v4 20/36] media: imx: Add CSI subdev driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-21-git-send-email-steve_longerbeam@mentor.com>
 <20170216115206.GL27312@n2100.armlinux.org.uk>
 <20170216124027.GM27312@n2100.armlinux.org.uk>
Cc: mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, sakari.ailus@linux.intel.com,
        nick@shmanahar.org, songjun.wu@microchip.com,
        Steve Longerbeam <steve_longerbeam@mentor.com>, pavel@ucw.cz,
        robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, shuah@kernel.org,
        geert@linux-m68k.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de, arnd@arndb.de,
        mchehab@kernel.org, bparrot@ti.com, robh+dt@kernel.org,
        horms+renesas@verge.net.au, tiffany.lin@mediatek.com,
        linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        p.zabel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <fa52c59e-f582-672c-8df0-2b959f880fa1@gmail.com>
Date: Thu, 16 Feb 2017 10:44:16 -0800
MIME-Version: 1.0
In-Reply-To: <20170216124027.GM27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/16/2017 04:40 AM, Russell King - ARM Linux wrote:
> On Thu, Feb 16, 2017 at 11:52:06AM +0000, Russell King - ARM Linux wrote:
>> On Wed, Feb 15, 2017 at 06:19:22PM -0800, Steve Longerbeam wrote:
>>> +static const struct platform_device_id imx_csi_ids[] = {
>>> +	{ .name = "imx-ipuv3-csi" },
>>> +	{ },
>>> +};
>>> +MODULE_DEVICE_TABLE(platform, imx_csi_ids);
>>> +
>>> +static struct platform_driver imx_csi_driver = {
>>> +	.probe = imx_csi_probe,
>>> +	.remove = imx_csi_remove,
>>> +	.id_table = imx_csi_ids,
>>> +	.driver = {
>>> +		.name = "imx-ipuv3-csi",
>>> +	},
>>> +};
>>> +module_platform_driver(imx_csi_driver);
>>> +
>>> +MODULE_DESCRIPTION("i.MX CSI subdev driver");
>>> +MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
>>> +MODULE_LICENSE("GPL");
>>> +MODULE_ALIAS("platform:imx-ipuv3-csi");
>>
>> Just a reminder that automatic module loading of this is completely
>> broken right now (not your problem) due to this stupid idea in the
>> IPUv3 code:
>>
>> 		if (!ret)
>> 			ret = platform_device_add(pdev);
>> 		if (ret) {
>> 			platform_device_put(pdev);
>> 			goto err_register;
>> 		}
>>
>> 		/*
>> 		 * Set of_node only after calling platform_device_add. Otherwise
>> 		 * the platform:imx-ipuv3-crtc modalias won't be used.
>> 		 */
>> 		pdev->dev.of_node = of_node;
>>
>> setting pdev->dev.of_node changes the modalias exported to userspace,
>> so udev sees a DT based modalias, which causes it to totally miss any
>> driver using a non-DT based modalias.
>>
>> The IPUv3 code needs fixing, not only for imx-media-csi, but also for
>> imx-ipuv3-crtc too, because that module will also suffer the same
>> issue.
>>
>> The only solution is... don't fsck with dev->of_node assignment.  In
>> this case, it's probably much better to pass it in via platform data.
>> If you then absolutely must have dev->of_node, doing it in the driver
>> means that you avoid the modalias mess before the appropriate driver
>> is loaded.  However, that's still not a nice solution because the
>> modalias file still ends up randomly changing its contents.
>>
>> As I say, not _your_ problem, but it's still a problem that needs
>> solving, and I don't want it forgotten about.
>
> I've just hacked up a solution to this, and unfortunately it reveals a
> problem with Steve's code.  Picking out the imx & media-related messages:
>
> [    8.012191] imx_media_common: module is from the staging directory, the quality is unknown, you have been warned.
> [    8.018175] imx_media: module is from the staging directory, the quality is unknown, you have been warned.
> [    8.748345] imx-media: Registered subdev ipu1_csi0_mux
> [    8.753451] imx-media: Registered subdev ipu2_csi1_mux
> [    9.055196] imx219 0-0010: detected IMX219 sensor
> [    9.090733] imx6_mipi_csi2: module is from the staging directory, the quality is unknown, you have been warned.
> [    9.092247] imx-media: Registered subdev imx219 0-0010
> [    9.334338] imx-media: Registered subdev imx6-mipi-csi2
> [    9.372452] imx_media_capture: module is from the staging directory, the quality is unknown, you have been warned.
> [    9.378163] imx_media_capture: module is from the staging directory, the quality is unknown, you have been warned.
> [    9.390033] imx_media_csi: module is from the staging directory, the quality is unknown, you have been warned.
> [    9.394362] imx-media: Received unknown subdev ipu1_csi0

The root problem is here. I don't know why the CSI entities are not
being recognized. Can you share the changes you made?

So imx_media_subdev_bound() returns error because it didn't recognize
the subdev that was bound.

And for some reason, even though some of the subdev bound ops return
error, v4l2-core still calls the async completion notifier
(imx_media_probe_complete()).

I'll add some checks to imx_media_probe_complete() to try and detect
when not all subdevs were bound correctly to get around this issue.
That should prevent the kernel BUG() below.

Steve


> [    9.394699] imx-ipuv3-csi: probe of imx-ipuv3-csi.0 failed with error -22
> [    9.394840] imx-media: Received unknown subdev ipu1_csi1
> [    9.394887] imx-ipuv3-csi: probe of imx-ipuv3-csi.1 failed with error -22
> [    9.394992] imx-media: Received unknown subdev ipu2_csi0
> [    9.395026] imx-ipuv3-csi: probe of imx-ipuv3-csi.4 failed with error -22
> [    9.395119] imx-media: Received unknown subdev ipu2_csi1
> [    9.395159] imx-ipuv3-csi: probe of imx-ipuv3-csi.5 failed with error -22
> [    9.411722] imx_media_vdic: module is from the staging directory, the quality is unknown, you have been warned.
> [    9.412820] imx-media: Registered subdev ipu1_vdic
> [    9.424687] imx-media: Registered subdev ipu2_vdic
> [    9.436074] imx_media_ic: module is from the staging directory, the quality is unknown, you have been warned.
> [    9.437455] imx-media: Registered subdev ipu1_ic_prp
> [    9.437788] imx_media_ic: module is from the staging directory, the quality is unknown, you have been warned.
> [    9.447542] imx-media: Registered subdev ipu1_ic_prpenc
> [    9.455225] ipu1_ic_prpenc: Registered ipu1_ic_prpenc capture as /dev/video3
> [    9.459203] imx-media: Registered subdev ipu1_ic_prpvf
> [    9.460484] imx_media_ic: module is from the staging directory, the quality is unknown, you have been warned.
> [    9.460726] ipu1_ic_prpvf: Registered ipu1_ic_prpvf capture as /dev/video4
> [    9.460983] imx-media: Registered subdev ipu2_ic_prp
> [    9.461161] imx-media: Registered subdev ipu2_ic_prpenc
> [    9.461737] ipu2_ic_prpenc: Registered ipu2_ic_prpenc capture as /dev/video5
> [    9.463767] imx-media: Registered subdev ipu2_ic_prpvf
> [    9.464294] ipu2_ic_prpvf: Registered ipu2_ic_prpvf capture as /dev/video6
> [    9.464345] imx-media: imx_media_create_link: (null):1 -> ipu1_ic_prp:0
> [    9.464413] ------------[ cut here ]------------
> [    9.469134] kernel BUG at /home/rmk/git/linux-rmk/drivers/media/media-entity.c:628!
> [    9.476924] Internal error: Oops - BUG: 0 [#1] SMP ARM
> [    9.482246] Modules linked in: imx_media_ic(C+) imx_media_vdic(C) imx_media_csi(C) imx_media_capture(C) uvcvideo imx6_mipi_csi2(C) snd_soc_imx_audmux imx219 snd_soc_sgtl5000 video_multiplexer caam imx_sdma imx2_wdt snd_soc_fsl_ssi snd_soc_fsl_spdif imx_pcm_dma coda imx_thermal v4l2_mem2mem videobuf2_v4l2 videobuf2_dma_contig videobuf2_core videobuf2_vmalloc videobuf2_memops imx_media(C) imx_media_common(C) rc_pinnacle_pctv_hd nfsd dw_hdmi_cec dw_hdmi_ahb_audio etnaviv
> [    9.524500] CPU: 1 PID: 263 Comm: systemd-udevd Tainted: G         C      4.10.0-rc7+ #2112
> [    9.532995] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> [    9.539619] task: edef1880 task.stack: d03ca000
> [    9.544313] PC is at media_create_pad_link+0x134/0x140
> [    9.549541] LR is at imx_media_probe_complete+0x164/0x24c [imx_media]
> [    9.556080] pc : [<c04f0eb0>]    lr : [<bf052524>]    psr: 60070013
>                sp : d03cbbc8  ip : d03cbbf8  fp : d03cbbf4
> [    9.567712] r10: 00000001  r9 : 00000000  r8 : d0170d14
> [    9.573007] r7 : 00000000  r6 : 00000001  r5 : 00000000  r4 : d0170d14
> [    9.579612] r3 : 00000000  r2 : d0170d14  r1 : 00000001  r0 : 00000000
> [    9.586256] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none[    9.593486] Control: 10c5387d  Table: 3e77c04a  DAC: 00000051
> [    9.599317] Process systemd-udevd (pid: 263, stack limit = 0xd03ca210)
> [    9.605950] Stack: (0xd03cbbc8 to 0xd03cc000)
> [    9.610368] bbc0:                   00000000 00000000 ee980410 00000000 00000000 d0170d14
> [    9.618658] bbe0: 00000000 00000001 d03cbc54 d03cbbf8 bf052524 c04f0d88 00000000 d0170d88
> [    9.626961] bc00: 00000000 c0a57dc4 0004a364 ee98011c 00000000 00000003 00000001 ee980230
> [    9.635267] bc20: ee980274 ee980010 d03cbc54 d0170f14 ee9ca4cc ee9974c4 bf0523c0 c0a57dc4
> [    9.643539] bc40: f184bb30 00000026 d03cbc74 d03cbc58 c0502f50 bf0523cc ee9ca4cc d0170f14
> [    9.651824] bc60: c0a57e08 d0170fc0 d03cbc9c d03cbc78 c0502fdc c0502e70 00000000 d0170f10
> [    9.660132] bc80: 00000000 d02c0c10 bf122cd0 d0170f14 d03cbcc4 d03cbca0 bf121154 c0502f68
> [    9.668423] bca0: bf12104c ffffffed d02c0c10 fffffdfb bf123248 00000000 d03cbce4 d03cbcc8
> [    9.676713] bcc0: c041aeb4 bf121058 d02c0c10 c1419d70 00000000 bf123248 d03cbd0c d03cbce8
> [    9.684992] bce0: c0418ec4 c041ae68 d02c0c10 bf123248 d02c0c44 00000000 00000001 00000124
> [    9.693282] bd00: d03cbd2c d03cbd10 c0419044 c0418ccc 00000000 00000000 bf123248 c0418f88
> [    9.701618] bd20: d03cbd54 d03cbd30 c04172e4 c0418f94 ef0f64a4 d01b8cd0 d03d9858 bf123248
> [    9.709900] bd40: d03d9c00 c0a45e10 d03cbd64 d03cbd58 c0418728 c0417294 d03cbd8c d03cbd68
> [    9.718203] bd60: c0418428 c0418710 bf122e48 d03cbd78 bf123248 c0a704a8 bf126000 00000000
> [    9.729180] bd80: d03cbda4 d03cbd90 c0419ec4 c0418340 bf123480 c0a704a8 d03cbdb4 d03cbda8
> [    9.739950] bda0: c041ad88 c0419e50 d03cbdc4 d03cbdb8 bf126018 c041ad4c d03cbe34 d03cbdc8
> [    9.751089] bdc0: c00098ac bf12600c d03cbdec d03cbdd8 c00a8888 c0087240 00000000 ed4a9440
> [    9.761941] bde0: d03cbe34 d03cbdf0 c016c690 c00a8814 c016b554 c016aa60 00000001 c015f3f8
> [    9.772940] be00: 00000005 0000000c edef1880 bf123480 c0a704a8 bf123480 c0a704a8 ed4a9440
> [    9.784008] be20: bf123480 00000001 d03cbe5c d03cbe38 c011b1e4 c0009874 d03cbe5c d03cbe48
> [    9.795017] be40: c09f5ea7 c0a704a8 c09e04ec bf123480 d03cbf14 d03cbe60 c00d2dd0 c011b188
> [    9.806069] be60: bf12348c 00007fff bf123480 c00d09f0 f1847000 bf12792c f18495c0 bf123680
> [    9.817194] be80: bf12348c bf1236f0 00000000 bf1234c8 c017c1d0 c017bfac f1847000 00004f68
> [    9.828347] bea0: c017c2e8 00000000 edef1880 00000000 00000000 00000000 00000000 00000000
> [    9.839542] bec0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [    9.850754] bee0: 00000000 00000000 00000003 7fffffff 00000000 00000000 00000007 b6c9e63c
> [    9.861991] bf00: d03ca000 00000000 d03cbfa4 d03cbf18 c00d36cc c00d1480 7fffffff 00000000
> [    9.873266] bf20: 00000003 ee0384d4 d03cbf74 f1847000 00004f68 00000000 00000002 f1847000
> [    9.884593] bf40: 00004f68 f184bb30 f184989b f184a7d8 000026f0 00002dd0 00000000 00000000
> [    9.895998] bf60: 00000000 0000192c 00000019 0000001a 00000011 00000000 0000000a 00000000
> [    9.907408] bf80: c008b848 80c36630 00000000 2529fc00 0000017b c000ff04 00000000 d03cbfa8
> [    9.918858] bfa0: c000fd60 c00d3644 80c36630 00000000 00000007 b6c9e63c 00000000 80c38178
> [    9.930354] bfc0: 80c36630 00000000 2529fc00 0000017b 00020000 7f96eb0c 80c37848 00000000
> [    9.941900] bfe0: bed55928 bed55918 b6c988ff b6bea572 600f0030 00000007 3fffd861 3fffdc61
> [    9.953532] Backtrace:
> [    9.959442] [<c04f0d7c>] (media_create_pad_link) from [<bf052524>] (imx_media_probe_complete+0x164/0x24c [imx_media])
> [    9.973644]  r10:00000001 r9:00000000 r8:d0170d14 r7:00000000 r6:00000000 r5:ee980410
> [    9.985112]  r4:00000000 r3:00000000
> [    9.992696] [<bf0523c0>] (imx_media_probe_complete [imx_media]) from [<c0502f50>] (v4l2_async_test_notify+0xec/0xf8)
> [   10.007413]  r10:00000026 r9:f184bb30 r8:c0a57dc4 r7:bf0523c0 r6:ee9974c4 r5:ee9ca4cc
> [   10.019212]  r4:d0170f14
> [   10.025650] [<c0502e64>] (v4l2_async_test_notify) from [<c0502fdc>] (v4l2_async_register_subdev+0x80/0xdc)
> [   10.039736]  r7:d0170fc0 r6:c0a57e08 r5:d0170f14 r4:ee9ca4cc
> [   10.049613] [<c0502f5c>] (v4l2_async_register_subdev) from [<bf121154>] (imx_ic_probe+0x108/0x144 [imx_media_ic])
> [   10.063953]  r8:d0170f14 r7:bf122cd0 r6:d02c0c10 r5:00000000 r4:d0170f10 r3:00000000
> [   10.075786] [<bf12104c>] (imx_ic_probe [imx_media_ic]) from [<c041aeb4>] (platform_drv_probe+0x58/0xb8)
> [   10.089118]  r8:00000000 r7:bf123248 r6:fffffdfb r5:d02c0c10 r4:ffffffed r3:bf12104c
> [   10.100683] [<c041ae5c>] (platform_drv_probe) from [<c0418ec4>] (driver_probe_device+0x204/0x2c8)
> [   10.113279]  r7:bf123248 r6:00000000 r5:c1419d70 r4:d02c0c10
> [   10.122765] [<c0418cc0>] (driver_probe_device) from [<c0419044>] (__driver_attach+0xbc/0xc0)
> [   10.135098]  r10:00000124 r8:00000001 r7:00000000 r6:d02c0c44 r5:bf123248 r4:d02c0c10
> [   10.146785] [<c0418f88>] (__driver_attach) from [<c04172e4>] (bus_for_each_dev+0x5c/0x90)
> [   10.158811]  r6:c0418f88 r5:bf123248 r4:00000000 r3:00000000
> [   10.168375] [<c0417288>] (bus_for_each_dev) from [<c0418728>] (driver_attach+0x24/0x28)
> [   10.180413]  r6:c0a45e10 r5:d03d9c00 r4:bf123248
> [   10.188959] [<c0418704>] (driver_attach) from [<c0418428>] (bus_add_driver+0xf4/0x200)
> [   10.200775] [<c0418334>] (bus_add_driver) from [<c0419ec4>] (driver_register+0x80/0xfc)
> [   10.212707]  r7:00000000 r6:bf126000 r5:c0a704a8 r4:bf123248
> [   10.222254] [<c0419e44>] (driver_register) from [<c041ad88>] (__platform_driver_register+0x48/0x4c)
> [   10.235212]  r5:c0a704a8 r4:bf123480
> [   10.242694] [<c041ad40>] (__platform_driver_register) from [<bf126018>] (imx_ic_driver_init+0x18/0x24 [imx_media_ic])
> [   10.257308] [<bf126000>] (imx_ic_driver_init [imx_media_ic]) from [<c00098ac>] (do_one_initcall+0x44/0x170)
> [   10.271043] [<c0009868>] (do_one_initcall) from [<c011b1e4>] (do_init_module+0x68/0x1d8)
> [   10.283139]  r8:00000001 r7:bf123480 r6:ed4a9440 r5:c0a704a8 r4:bf123480
> [   10.293849] [<c011b17c>] (do_init_module) from [<c00d2dd0>] (load_module+0x195c/0x2080)
> [   10.305867]  r7:bf123480 r6:c09e04ec r5:c0a704a8 r4:c09f5ea7
> [   10.315523] [<c00d1474>] (load_module) from [<c00d36cc>] (SyS_finit_module+0x94/0xa0)
> [   10.327382]  r10:00000000 r9:d03ca000 r8:b6c9e63c r7:00000007 r6:00000000 r5:00000000
> [   10.339238]  r4:7fffffff
> [   10.345766] [<c00d3638>] (SyS_finit_module) from [<c000fd60>] (ret_fast_syscall+0x0/0x1c)
> [   10.357994]  r8:c000ff04 r7:0000017b r6:2529fc00 r5:00000000 r4:80c36630
> [   10.368747] Code: e1a01007 ebfffce1 e3e0000b e89daff8 (e7f001f2)
> [   10.378883] ---[ end trace 2051fac455b36c5a ]---
> [   11.228961] imx_media_ic: module is from the staging directory, the quality is unknown, you have been warned.
> [   11.247536] imx_media_ic: module is from the staging directory, the quality is unknown, you have been warned.
> [   11.301366] imx_media_ic: module is from the staging directory, the quality is unknown, you have been warned.
>
> So there's probably some sort of race going on.
>
> However, the following is primerily directed at Laurent as the one who
> introduced the BUG_ON() in question...
>
> NEVER EVER USE BUG_ON() IN A PATH THAT CAN RETURN AN ERROR.
>
> It's possible to find Linus rants about this, eg,
> https://www.spinics.net/lists/stable/msg146439.html
>
>  I should have reacted to the damn added BUG_ON() lines. I suspect I
>  will have to finally just remove the idiotic BUG_ON() concept once and
>  for all, because there is NO F*CKING EXCUSE to knowingly kill the
>  kernel.
>
> Also: http://yarchive.net/comp/linux/BUG.html
>
>  Rule of thumb: BUG() is only good for something that never happens and
>  that we really have no other option for (ie state is so corrupt that
>  continuing is deadly).
>
> So, _unless_ people want to see BUG_ON() removed from the kernel, I
> strongly suggest to _STOP_ using it as "we didn't like the function
> arguments, let's use it as an assert() statement instead of returning
> an error."
>
> There's no excuse what so ever to be killing the machine in
> media_create_pad_link().  If it doesn't like a NULL pointer, it's damn
> well got an error path to report that fact.  Use that mechanism and
> stop needlessly killing the kernel.
>
> BUG_ON() IS NOT ASSERT().  DO NOT USE IT AS SUCH.
>
> Linus is absolutely right about BUG_ON() - it hurts debuggability,
> because now the only way to do further tests is to reboot the damned
> machine after removing those fscking BUG_ON()s that should *never*
> have been there in the first place.
>
> As Linus went on to say:
>
>  And dammit, if anybody else feels that they had done "debugging
>  messages with BUG_ON()", I would suggest you
>
>   (a) rethink your approach to programming
>
>   (b) send me patches to remove the crap entirely, or make them real
>  *DEBUGGING* messages, not "kill the whole machine" messages.
>
>  I've ranted against people using BUG_ON() for debugging in the past.
>  Why the f*ck does this still happen? And Andrew - please stop taking
>  those kinds of patches! Lookie here:
>
>      https://lwn.net/Articles/13183/
>
>  so excuse me for being upset that people still do this shit almost 15
>  years later.
>
> So I suggest people heed that advice and start fixing these stupid
> BUG_ON()s that they've created.
>
> Thanks.
>
