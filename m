Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:34871 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbbLNN7j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 08:59:39 -0500
MIME-Version: 1.0
Date: Mon, 14 Dec 2015 14:59:38 +0100
Message-ID: <CAMuHMdXqNvTLtYQGogJQMwAtw2q_Ox4UTs_HZM1ODYpTR679hA@mail.gmail.com>
Subject: vsp1 BUG_ON() and crash (Re: [PATCH v9 03/12] media: Entities, pads
 and links)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	ALSA Development Mailing List <alsa-devel@alsa-project.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	sakari.ailus@maxwell.research.nokia.com,
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 14, 2011 at 1:20 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> +media_entity_create_link(struct media_entity *source, u16 source_pad,
> +                        struct media_entity *sink, u16 sink_pad, u32 flags)
> +{
> +       struct media_link *link;
> +       struct media_link *backlink;
> +
> +       BUG_ON(source == NULL || sink == NULL);
> +       BUG_ON(source_pad >= source->num_pads);
> +       BUG_ON(sink_pad >= sink->num_pads);

This triggers on r8a7791/koelsch:

    vsp1 fe928000.vsp1: Entity type for entity fe928000.vsp1 bru was
not initialized!
    vsp1 fe928000.vsp1: Entity type for entity fe928000.vsp1 hsi was
not initialized!
    vsp1 fe928000.vsp1: Entity type for entity fe928000.vsp1 hst was
not initialized!
    vsp1 fe928000.vsp1: Entity type for entity fe928000.vsp1 lut was
not initialized!
    vsp1 fe928000.vsp1: Entity type for entity fe928000.vsp1 rpf.0 was
not initialized!
    vsp1 fe928000.vsp1: Entity type for entity fe928000.vsp1 rpf.1 was
not initialized!
    vsp1 fe928000.vsp1: Entity type for entity fe928000.vsp1 rpf.2 was
not initialized!
    vsp1 fe928000.vsp1: Entity type for entity fe928000.vsp1 rpf.3 was
not initialized!
    vsp1 fe928000.vsp1: Entity type for entity fe928000.vsp1 rpf.4 was
not initialized!
    vsp1 fe928000.vsp1: Entity type for entity fe928000.vsp1 sru was
not initialized!
    vsp1 fe928000.vsp1: Entity type for entity fe928000.vsp1 uds.0 was
not initialized!
    vsp1 fe928000.vsp1: Entity type for entity fe928000.vsp1 uds.1 was
not initialized!
    vsp1 fe928000.vsp1: Entity type for entity fe928000.vsp1 uds.2 was
not initialized!
    vsp1 fe928000.vsp1: Entity type for entity fe928000.vsp1 wpf.0 was
not initialized!
    vsp1 fe928000.vsp1: Entity type for entity fe928000.vsp1 wpf.1 was
not initialized!
    vsp1 fe928000.vsp1: Entity type for entity fe928000.vsp1 wpf.2 was
not initialized!
    vsp1 fe928000.vsp1: Entity type for entity fe928000.vsp1 wpf.3 was
not initialized!
    vsp1 fe930000.vsp1: Entity type for entity fe930000.vsp1 bru was
not initialized!
    vsp1 fe930000.vsp1: Entity type for entity fe930000.vsp1 hsi was
not initialized!
    vsp1 fe930000.vsp1: Entity type for entity fe930000.vsp1 hst was
not initialized!
    vsp1 fe930000.vsp1: Entity type for entity fe930000.vsp1 lif was
not initialized!
    vsp1 fe930000.vsp1: Entity type for entity fe930000.vsp1 lut was
not initialized!
    vsp1 fe930000.vsp1: Entity type for entity fe930000.vsp1 rpf.0 was
not initialized!
    vsp1 fe930000.vsp1: Entity type for entity fe930000.vsp1 rpf.1 was
not initialized!
    vsp1 fe930000.vsp1: Entity type for entity fe930000.vsp1 rpf.2 was
not initialized!
    vsp1 fe930000.vsp1: Entity type for entity fe930000.vsp1 rpf.3 was
not initialized!
    vsp1 fe930000.vsp1: Entity type for entity fe930000.vsp1 uds.0 was
not initialized!
    vsp1 fe930000.vsp1: Entity type for entity fe930000.vsp1 wpf.0 was
not initialized!
    vsp1 fe930000.vsp1: Entity type for entity fe930000.vsp1 wpf.1 was
not initialized!
    vsp1 fe930000.vsp1: Entity type for entity fe930000.vsp1 wpf.2 was
not initialized!
    vsp1 fe930000.vsp1: Entity type for entity fe930000.vsp1 wpf.3 was
not initialized!
    ------------[ cut here ]------------
    kernel BUG at drivers/media/media-entity.c:521!
    Internal error: Oops - BUG: 0 [#1] SMP ARM
    CPU: 0 PID: 1 Comm: swapper/0 Not tainted
4.4.0-rc5-03225-g596de581263544d2 #400
    Hardware name: Generic R8A7791 (Flattened Device Tree)
    task: ee84fb40 ti: ee850000 task.ti: ee850000
    PC is at media_create_pad_link+0x50/0x13c
    LR is at vsp1_wpf_create_links+0x4c/0x54
    pc : [<c034fd90>]    lr : [<c03761cc>]    psr: 60000013
    sp : ee851d50  ip : ee851d80  fp : ee851d7c
    r10: 00000001  r9 : ee9e9600  r8 : 00000000
    r7 : ee111c80  r6 : 00000000  r5 : ee114a40  r4 : ee114b18
    r3 : 00000000  r2 : ee114b18  r1 : 00000001  r0 : ee114a40
    Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
    Control: 10c5307d  Table: 4000406a  DAC: 00000051
    Process swapper/0 (pid: 1, stack limit = 0xee850210)
    Stack: (0xee851d50 to 0xee852000)
    1d40:                                     00000000 ee111c10
ee114a10 ee111c90
    1d60: ee111c80 ee9e9610 ee9e9600 ee111c98 ee851d94 ee851d80
c03761cc c034fd4c
    1d80: 00000001 ee111c98 ee851de4 ee851d98 c03730c0 c037618c
00000000 ee9eac00
    1da0: ee111c10 ee851db0 00000000 ee114840 ee114c40 00000000
c071b678 00000000
    1dc0: ee9e9610 c06d3414 c071b678 c06d3414 00000000 00000000
ee851e04 ee851de8
    1de0: c028f2b0 c0372bbc c028f258 ee9e9610 c071b668 00000000
ee851e2c ee851e08
    1e00: c028dd4c c028f264 ee9e9610 ee9e9644 c06d3414 c06cb3a8
c069e010 c06e2000
    1e20: ee851e4c ee851e30 c028df04 c028dc1c 00000001 00000000
c06d3414 c028de94
    1e40: ee851e74 ee851e50 c028c47c c028dea0 ee884f5c ee9e7bb4
ee884f70 c06d3414
    1e60: 00000000 eeaeb980 ee851e84 ee851e78 c028e138 c028c414
ee851eac ee851e88
    1e80: c028cc18 c028e124 c0646a6b ee851e98 c06d3414 c0681dc8
00000000 c069e010
    1ea0: ee851ec4 ee851eb0 c028e848 c028cb50 ee0bd380 c0681dc8
ee851ed4 ee851ec8
    1ec0: c028fcbc c028e7b0 ee851ee4 ee851ed8 c0681de0 c028fc90
ee851f5c ee851ee8
    1ee0: c0664df8 c0681dd4 ee851f0c ee851ef8 c0664604 c01c94bc
efffcc00 efffcc10
    1f00: ee851f5c ee851f10 c003f90c c06645f4 00000000 c0661740
c0661740 00000006
    1f20: 00000006 000000b6 c0660908 efffcc38 ee851f5c 00000006
00000006 000000b6
    1f40: c069e83c c06aad08 c06e2000 c06e2000 ee851f94 ee851f60
c0664fd4 c0664cfc
    1f60: 00000006 00000006 00000000 c06645e8 00000000 c04e752c
00000000 00000000
    1f80: 00000000 00000000 ee851fac ee851f98 c04e753c c0664eb8
ee850000 00000000
    1fa0: 00000000 ee851fb0 c000fe98 c04e7538 00000000 00000000
00000000 00000000
    1fc0: 00000000 00000000 00000000 00000000 00000000 00000000
00000000 00000000
    1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
00000000 00000000
    Backtrace:
    [<c034fd40>] (media_create_pad_link) from [<c03761cc>]
(vsp1_wpf_create_links+0x4c/0x54)
     r10:ee111c98 r9:ee9e9600 r8:ee9e9610 r7:ee111c80 r6:ee111c90 r5:ee114a10
     r4:ee111c10 r3:00000000
    [<c0376180>] (vsp1_wpf_create_links) from [<c03730c0>]
(vsp1_probe+0x510/0x700)
    [<c0372bb0>] (vsp1_probe) from [<c028f2b0>] (platform_drv_probe+0x58/0xa8)
     r10:00000000 r9:00000000 r8:c06d3414 r7:c071b678 r6:c06d3414 r5:ee9e9610
     r4:00000000

While bisecting, I arrived at a NULL pointer dereference:

        Unable to handle kernel NULL pointer dereference at virtual
address 00000250
        pgd = c0004000
        [00000250] *pgd=00000000
        Internal error: Oops: 5 [#1] SMP ARM
        CPU: 0 PID: 1 Comm: swapper/0 Not tainted
4.4.0-rc2-00170-gf9836d92a3c8c143 #417
        ata1: SATA link down (SStatus 0 SControl 300)
        Hardware name: Generic R8A7791 (Flattened Device Tree)
        task: ee84fb40 ti: ee850000 task.ti: ee850000
        PC is at media_gobj_init+0x20/0x68
        LR is at media_entity_create_link+0xe4/0x108
        pc : [<c0342428>]    lr : [<c0342a80>]    psr: 60000013
        sp : ee851d10  ip : ee851d20  fp : ee851d1c
        r10: 00000000  r9 : ee103890  r8 : 00000000
        r7 : ee159920  r6 : ee103740  r5 : ee103840  r4 : ee159840
        r3 : 00000003  r2 : ee103840  r1 : 00000002  r0 : 00000000
        Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
        Control: 10c5307d  Table: 4000406a  DAC: 00000051
        Process swapper/0 (pid: 1, stack limit = 0xee850210)
        Stack: (0xee851d10 to 0xee852000)
        1d00:                                     ee851d4c ee851d20
c0342a80 c0342414
        1d20: 00000000 ee159810 00000000 ee159840 ee159910 00000000
ee9e6800 ee102898
        1d40: ee851d94 ee851d50 c036506c c03429a8 00000003 00000000
000000ff 00000000
        1d60: 00000001 00000000 000000ff 00000000 c0366740 ee102810
ee102890 00000000
        1d80: ee102858 ee9e6810 ee851de4 ee851d98 c0362a44 c0364ef4
00000080 ee9e8f00
        1da0: ee102810 ee851db0 c012bcac ee9e6810 ee9e6810 c06b1f88
c06e76b4 00000000
        1dc0: ee9e6810 c06b1f88 c06e76b4 00000000 c06b1f88 00000000
ee851e04 ee851de8
        1de0: c0285b14 c0362694 c0285abc ee9e6810 00000000 c06e76a8
ee851e2c ee851e08
        1e00: c028457c c0285ac8 ee9e6810 ee9e6844 c06b1f88 c06aab38
c067d010 c06c1000
        1e20: ee851e4c ee851e30 c0284770 c028446c 00000001 00000000
c06b1f88 c0284700
        1e40: ee851e74 ee851e50 c0282d78 c028470c ee884f5c ee9e4cb4
ee884f70 c06b1f88
        1e60: 00000000 ee9c4700 ee851e84 ee851e78 c028499c c0282d10
ee851eac ee851e88
        1e80: c0283514 c0284988 c0627e00 ee851e98 c06b1f88 c06618a8
00000000 c067d010
        1ea0: ee851ec4 ee851eb0 c02850ac c028344c eea9a200 c06618a8
ee851ed4 ee851ec8
        1ec0: c02864e0 c0285014 ee851ee4 ee851ed8 c06618c0 c02864b4
ee851f5c ee851ee8
        1ee0: c0644df8 c06618b4 ee851f0c ee851ef8 c0644604 c01c91bc
efffcc00 efffcc10
        1f00: ee851f5c ee851f10 c003f908 c06445f4 00000000 c0641c1c
c0641c1c 00000006
        1f20: 00000006 000000b1 c0640e48 efffcc38 ee851f5c 00000006
00000006 000000b1
        1f40: c067d83c c0689c84 c06c1000 c06c1000 ee851f94 ee851f60
c0644fd4 c0644cfc
        1f60: 00000006 00000006 00000000 c06445e8 00000000 c04d00ac
00000000 00000000
        1f80: 00000000 00000000 ee851fac ee851f98 c04d00bc c0644eb8
ee850000 00000000
        1fa0: 00000000 ee851fb0 c000fe98 c04d00b8 00000000 00000000
00000000 00000000
        1fc0: 00000000 00000000 00000000 00000000 00000000 00000000
00000000 00000000
        1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
00000000 00000000
        Backtrace:
        [<c0342408>] (media_gobj_init) from [<c0342a80>]
(media_entity_create_link+0xe4/0x108)
        [<c034299c>] (media_entity_create_link) from [<c036506c>]
(vsp1_rpf_create+0x184/0x1c8)
         r10:ee102898 r9:ee9e6800 r8:00000000 r7:ee159910 r6:ee159840
r5:00000000
         r4:ee159810 r3:00000000
        [<c0364ee8>] (vsp1_rpf_create) from [<c0362a44>]
(vsp1_probe+0x3bc/0x6c0)
         r8:ee9e6810 r7:ee102858 r6:00000000 r5:ee102890 r4:ee102810
        [<c0362688>] (vsp1_probe) from [<c0285b14>]
(platform_drv_probe+0x58/0xa8)
         r10:00000000 r9:c06b1f88 r8:00000000 r7:c06e76b4 r6:c06b1f88
r5:ee9e6810
         r4:00000000

The NULL pointer dereference was introduced by:

        commit f9836d92a3c8c143c6f5fe89c558c37767628fa6
        Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
        Date:   Fri Aug 14 12:54:36 2015 -0300

            [media] media: use media_gobj inside links

and triggers until the following commit, after which the BUG_ON() takes over:

        commit eb9e998983338811c3328294ed2f093367161df1
        Author: Javier Martinez Canillas <javier@osg.samsung.com>
        Date:   Thu Sep 3 12:19:25 2015 -0300

            [media] v4l: vsp1: separate links creation from entities init


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
