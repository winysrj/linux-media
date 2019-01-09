Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A3AEC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 16:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06112206BB
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 16:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfAIQmS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 11:42:18 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:40297 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfAIQkj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 11:40:39 -0500
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 2264B100008;
        Wed,  9 Jan 2019 16:40:30 +0000 (UTC)
Date:   Wed, 9 Jan 2019 17:40:37 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Yong Zhi <yong.zhi@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        Cao Bing Bu <bingbu.cao@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Message-ID: <20190109164037.yvtluixvua7cm2tl@uno.localdomain>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1819843.KIqgResAvh@avalon>
 <2135468.G1bK1392oW@avalon>
 <3475971.piroVKfGO7@avalon>
 <CAAFQd5CN3dhTviSnFbzSOjkMTQqUyOajYv+CVxSLLAih522CgQ@mail.gmail.com>
 <CAAFQd5AWLi=UD+LtuiQdc5QD8v5B1WX0Jcoe6=QUy+392FSeng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="45ord6jdbxrcktt5"
Content-Disposition: inline
In-Reply-To: <CAAFQd5AWLi=UD+LtuiQdc5QD8v5B1WX0Jcoe6=QUy+392FSeng@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--45ord6jdbxrcktt5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello,

On Tue, Jan 08, 2019 at 03:54:34PM +0900, Tomasz Figa wrote:
> Hi Raj, Yong, Bingbu, Tianshu,
>
> On Fri, Dec 21, 2018 at 12:04 PM Tomasz Figa <tfiga@chromium.org> wrote:
> >
> > On Fri, Dec 21, 2018 at 7:24 AM Laurent Pinchart
> > <laurent.pinchart@ideasonboard.com> wrote:
> > >
> > > Hellon
> > >
> > > On Sunday, 16 December 2018 09:26:18 EET Laurent Pinchart wrote:
> > > > Hello Yong,
> > > >
> > > > Could you please have a look at the crash reported below ?
> > >
> > > A bit more information to help you debugging this. I've enabled KASAN in the
> > > kernel configuration, and get the following use-after-free reports.

I tested as well using the ipu-process.sh script shared by Laurent,
with the following command line:
./ipu3-process.sh --out 2560x1920 --vf 1920x1080 frame-2592x1944.cio2

and I got a very similar trace available at:
https://paste.debian.net/hidden/5855e15a/

Please note I have been able to process a set of images (with KASAN
enabled the machine does not freeze) but the kernel log gets flooded
and it is not possible to process any other frame after this.

The issue is currently quite annoying and it's a blocker for libcamera
development on IPU3. Please let me know if I can support with more
testing.

Thanks
   j

> > >
> > > [  166.332920] ==================================================================
> > > [  166.332937] BUG: KASAN: use-after-free in __cached_rbnode_delete_update+0x36/0x202
> > > [  166.332944] Read of size 8 at addr ffff888133823718 by task yavta/1305
> > >
> > > [  166.332955] CPU: 3 PID: 1305 Comm: yavta Tainted: G         C        4.20.0-rc6+ #3
> > > [  166.332958] Hardware name: HP Soraka/Soraka, BIOS  08/30/2018
> > > [  166.332959] Call Trace:
> > > [  166.332967]  dump_stack+0x5b/0x81
> > > [  166.332974]  print_address_description+0x65/0x227
> > > [  166.332979]  ? __cached_rbnode_delete_update+0x36/0x202
> > > [  166.332983]  kasan_report+0x247/0x285
> > > [  166.332989]  __cached_rbnode_delete_update+0x36/0x202
> > > [  166.332995]  private_free_iova+0x57/0x6d
> > > [  166.332999]  __free_iova+0x23/0x31
> > > [  166.333011]  ipu3_dmamap_free+0x118/0x1d6 [ipu3_imgu]
> >
> > Thanks Laurent, I think this is a very good hint. It looks like we're
> > basically freeing and already freed IOVA and corrupting some allocator
> > state?
>
> Did you have any luck in reproducing and fixing this double free issue?
>
> Best regards,
> Tomasz
>
> >
> > > [  166.333022]  ipu3_css_pool_cleanup+0x25/0x2f [ipu3_imgu]
> > > [  166.333032]  ipu3_css_pipeline_cleanup+0x79/0xcf [ipu3_imgu]
> > > [  166.333043]  ipu3_css_stop_streaming+0x2fe/0x4dc [ipu3_imgu]
> > > [  166.333056]  imgu_s_stream+0xc0/0x6c0 [ipu3_imgu]
> > > [  166.333067]  ? ipu3_all_nodes_streaming+0x1ee/0x20d [ipu3_imgu]
> > > [  166.333079]  ipu3_vb2_stop_streaming+0x27c/0x2d2 [ipu3_imgu]
> > > [  166.333088]  __vb2_queue_cancel+0xa8/0x705 [videobuf2_common]
> > > [  166.333096]  ? __mutex_lock_interruptible_slowpath+0xf/0xf
> > > [  166.333104]  vb2_core_streamoff+0x68/0xf8 [videobuf2_common]
> > > [  166.333123]  __video_do_ioctl+0x625/0x887 [videodev]
> > > [  166.333142]  ? copy_overflow+0x14/0x14 [videodev]
> > > [  166.333147]  ? slab_free_freelist_hook+0x46/0x94
> > > [  166.333151]  ? kfree+0x107/0x1a0
> > > [  166.333169]  video_usercopy+0x3a3/0x8ae [videodev]
> > > [  166.333187]  ? copy_overflow+0x14/0x14 [videodev]
> > > [  166.333203]  ? v4l_enumstd+0x49/0x49 [videodev]
> > > [  166.333207]  ? __wake_up_common+0x342/0x342
> > > [  166.333215]  ? atomic_long_add_return+0x15/0x24
> > > [  166.333219]  ? ldsem_up_read+0x15/0x29
> > > [  166.333223]  ? tty_write+0x4c6/0x4d8
> > > [  166.333227]  ? n_tty_receive_char_special+0x1152/0x1152
> > > [  166.333244]  ? video_usercopy+0x8ae/0x8ae [videodev]
> > > [  166.333260]  v4l2_ioctl+0xb7/0xc5 [videodev]
> > > [  166.333266]  vfs_ioctl+0x76/0x89
> > > [  166.333271]  do_vfs_ioctl+0xb33/0xb7e
> > > [  166.333275]  ? __switch_to_asm+0x40/0x70
> > > [  166.333279]  ? __switch_to_asm+0x40/0x70
> > > [  166.333282]  ? __switch_to_asm+0x34/0x70
> > > [  166.333286]  ? __switch_to_asm+0x40/0x70
> > > [  166.333290]  ? ioctl_preallocate+0x174/0x174
> > > [  166.333294]  ? __switch_to+0x71c/0xb00
> > > [  166.333299]  ? compat_start_thread+0x6b/0x6b
> > > [  166.333302]  ? __switch_to_asm+0x34/0x70
> > > [  166.333305]  ? __switch_to_asm+0x40/0x70
> > > [  166.333309]  ? mmdrop+0x12/0x23
> > > [  166.333313]  ? finish_task_switch+0x34d/0x3de
> > > [  166.333319]  ? __schedule+0x1004/0x1045
> > > [  166.333325]  ? firmware_map_remove+0x119/0x119
> > > [  166.333330]  ksys_ioctl+0x50/0x70
> > > [  166.333335]  __x64_sys_ioctl+0x82/0x89
> > > [  166.333340]  do_syscall_64+0xa0/0xd2
> > > [  166.333345]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > [  166.333349] RIP: 0033:0x7f2481541f47
> > > [  166.333354] Code: 00 00 00 48 8b 05 51 6f 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 21 6f 2c 00 f7 d8 64 89 01 48
> > > [  166.333357] RSP: 002b:00007fffd6aff9b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > > [  166.333362] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2481541f47
> > > [  166.333364] RDX: 00007fffd6aff9c4 RSI: 0000000040045613 RDI: 0000000000000003
> > > [  166.333367] RBP: 0000555f1c494af8 R08: 00007f247f34c000 R09: 00007f2481c24700
> > > [  166.333369] R10: 0000000000000020 R11: 0000000000000246 R12: 0000555f1c494b06
> > > [  166.333372] R13: 0000000000000004 R14: 00007fffd6affb90 R15: 00007fffd6b00825
> > >
> > > [  166.333383] Allocated by task 1305:
> > > [  166.333389]  kasan_kmalloc+0x8a/0x98
> > > [  166.333392]  slab_post_alloc_hook+0x31/0x51
> > > [  166.333396]  kmem_cache_alloc+0xd7/0x174
> > > [  166.333399]  alloc_iova+0x24/0x2ea
> > > [  166.333407]  ipu3_dmamap_alloc+0x193/0x83f [ipu3_imgu]
> > > [  166.333415]  ipu3_css_pool_init+0x80/0xdf [ipu3_imgu]
> > > [  166.333424]  ipu3_css_start_streaming+0x58df/0x5ddc [ipu3_imgu]
> > > [  166.333433]  imgu_s_stream+0x2dd/0x6c0 [ipu3_imgu]
> > > [  166.333442]  ipu3_vb2_start_streaming+0x35f/0x3de [ipu3_imgu]
> > > [  166.333449]  vb2_start_streaming+0x164/0x33b [videobuf2_common]
> > > [  166.333455]  vb2_core_streamon+0x1a1/0x208 [videobuf2_common]
> > > [  166.333471]  __video_do_ioctl+0x625/0x887 [videodev]
> > > [  166.333487]  video_usercopy+0x3a3/0x8ae [videodev]
> > > [  166.333501]  v4l2_ioctl+0xb7/0xc5 [videodev]
> > > [  166.333505]  vfs_ioctl+0x76/0x89
> > > [  166.333508]  do_vfs_ioctl+0xb33/0xb7e
> > > [  166.333511]  ksys_ioctl+0x50/0x70
> > > [  166.333514]  __x64_sys_ioctl+0x82/0x89
> > > [  166.333518]  do_syscall_64+0xa0/0xd2
> > > [  166.333521]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > >
> > > [  166.333526] Freed by task 1301:
> > > [  166.333532]  __kasan_slab_free+0xfa/0x11c
> > > [  166.333535]  slab_free_freelist_hook+0x46/0x94
> > > [  166.333538]  kmem_cache_free+0x7b/0x172
> > > [  166.333542]  __free_iova+0x23/0x31
> > > [  166.333550]  ipu3_dmamap_free+0x118/0x1d6 [ipu3_imgu]
> > > [  166.333557]  ipu3_css_pool_cleanup+0x25/0x2f [ipu3_imgu]
> > > [  166.333566]  ipu3_css_pipeline_cleanup+0x79/0xcf [ipu3_imgu]
> > > [  166.333574]  ipu3_css_stop_streaming+0x2fe/0x4dc [ipu3_imgu]
> > > [  166.333584]  imgu_s_stream+0xc0/0x6c0 [ipu3_imgu]
> > > [  166.333593]  ipu3_vb2_stop_streaming+0x27c/0x2d2 [ipu3_imgu]
> > > [  166.333599]  __vb2_queue_cancel+0xa8/0x705 [videobuf2_common]
> > > [  166.333606]  vb2_core_streamoff+0x68/0xf8 [videobuf2_common]
> > > [  166.333621]  __video_do_ioctl+0x625/0x887 [videodev]
> > > [  166.333637]  video_usercopy+0x3a3/0x8ae [videodev]
> > > [  166.333652]  v4l2_ioctl+0xb7/0xc5 [videodev]
> > > [  166.333655]  vfs_ioctl+0x76/0x89
> > > [  166.333658]  do_vfs_ioctl+0xb33/0xb7e
> > > [  166.333662]  ksys_ioctl+0x50/0x70
> > > [  166.333665]  __x64_sys_ioctl+0x82/0x89
> > > [  166.333668]  do_syscall_64+0xa0/0xd2
> > > [  166.333671]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > >
> > > [  166.333678] The buggy address belongs to the object at ffff888133823700
> > >                 which belongs to the cache iommu_iova of size 40
> > > [  166.333685] The buggy address is located 24 bytes inside of
> > >                 40-byte region [ffff888133823700, ffff888133823728)
> > > [  166.333690] The buggy address belongs to the page:
> > > [  166.333696] page:ffffea0004ce0880 count:1 mapcount:0 mapping:ffff8881519e8640 index:0x0 compound_mapcount: 0
> > > [  166.333703] flags: 0x200000000010200(slab|head)
> > > [  166.333710] raw: 0200000000010200 ffffea0004dfc488 ffff88814bfbde70 ffff8881519e8640
> > > [  166.333717] raw: 0000000000000000 0000000000120012 00000001ffffffff 0000000000000000
> > > [  166.333720] page dumped because: kasan: bad access detected
> > >
> > > [  166.333726] Memory state around the buggy address:
> > > [  166.333732]  ffff888133823600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > > [  166.333737]  ffff888133823680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > > [  166.333742] >ffff888133823700: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc
> > > [  166.333745]                             ^
> > > [  166.333750]  ffff888133823780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > > [  166.333755]  ffff888133823800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > > [  166.333759] ==================================================================
> > > [  166.333762] Disabling lock debugging due to kernel taint
> > > [  166.333764] ==================================================================
> > > [  166.333770] BUG: KASAN: double-free or invalid-free in kmem_cache_free+0x7b/0x172
> > >
> > > [  166.333780] CPU: 3 PID: 1305 Comm: yavta Tainted: G    B    C        4.20.0-rc6+ #3
> > > [  166.333782] Hardware name: HP Soraka/Soraka, BIOS  08/30/2018
> > > [  166.333783] Call Trace:
> > > [  166.333789]  dump_stack+0x5b/0x81
> > > [  166.333795]  print_address_description+0x65/0x227
> > > [  166.333799]  ? kmem_cache_free+0x7b/0x172
> > > [  166.333803]  kasan_report_invalid_free+0x67/0xa0
> > > [  166.333807]  ? kmem_cache_free+0x7b/0x172
> > > [  166.333812]  __kasan_slab_free+0x86/0x11c
> > > [  166.333817]  slab_free_freelist_hook+0x46/0x94
> > > [  166.333822]  kmem_cache_free+0x7b/0x172
> > > [  166.333826]  ? __free_iova+0x23/0x31
> > > [  166.333831]  __free_iova+0x23/0x31
> > > [  166.333840]  ipu3_dmamap_free+0x118/0x1d6 [ipu3_imgu]
> > > [  166.333851]  ipu3_css_pool_cleanup+0x25/0x2f [ipu3_imgu]
> > > [  166.333861]  ipu3_css_pipeline_cleanup+0x79/0xcf [ipu3_imgu]
> > > [  166.333872]  ipu3_css_stop_streaming+0x2fe/0x4dc [ipu3_imgu]
> > > [  166.333885]  imgu_s_stream+0xc0/0x6c0 [ipu3_imgu]
> > > [  166.333896]  ? ipu3_all_nodes_streaming+0x1ee/0x20d [ipu3_imgu]
> > > [  166.333908]  ipu3_vb2_stop_streaming+0x27c/0x2d2 [ipu3_imgu]
> > > [  166.333917]  __vb2_queue_cancel+0xa8/0x705 [videobuf2_common]
> > > [  166.333923]  ? __mutex_lock_interruptible_slowpath+0xf/0xf
> > > [  166.333932]  vb2_core_streamoff+0x68/0xf8 [videobuf2_common]
> > > [  166.333950]  __video_do_ioctl+0x625/0x887 [videodev]
> > > [  166.333970]  ? copy_overflow+0x14/0x14 [videodev]
> > > [  166.333974]  ? slab_free_freelist_hook+0x46/0x94
> > > [  166.333979]  ? kfree+0x107/0x1a0
> > > [  166.333997]  video_usercopy+0x3a3/0x8ae [videodev]
> > > [  166.334015]  ? copy_overflow+0x14/0x14 [videodev]
> > > [  166.334031]  ? v4l_enumstd+0x49/0x49 [videodev]
> > > [  166.334035]  ? __wake_up_common+0x342/0x342
> > > [  166.334042]  ? atomic_long_add_return+0x15/0x24
> > > [  166.334046]  ? ldsem_up_read+0x15/0x29
> > > [  166.334050]  ? tty_write+0x4c6/0x4d8
> > > [  166.334054]  ? n_tty_receive_char_special+0x1152/0x1152
> > > [  166.334071]  ? video_usercopy+0x8ae/0x8ae [videodev]
> > > [  166.334087]  v4l2_ioctl+0xb7/0xc5 [videodev]
> > > [  166.334092]  vfs_ioctl+0x76/0x89
> > > [  166.334097]  do_vfs_ioctl+0xb33/0xb7e
> > > [  166.334101]  ? __switch_to_asm+0x40/0x70
> > > [  166.334105]  ? __switch_to_asm+0x40/0x70
> > > [  166.334108]  ? __switch_to_asm+0x34/0x70
> > > [  166.334111]  ? __switch_to_asm+0x40/0x70
> > > [  166.334116]  ? ioctl_preallocate+0x174/0x174
> > > [  166.334120]  ? __switch_to+0x71c/0xb00
> > > [  166.334124]  ? compat_start_thread+0x6b/0x6b
> > > [  166.334127]  ? __switch_to_asm+0x34/0x70
> > > [  166.334130]  ? __switch_to_asm+0x40/0x70
> > > [  166.334134]  ? mmdrop+0x12/0x23
> > > [  166.334137]  ? finish_task_switch+0x34d/0x3de
> > > [  166.334143]  ? __schedule+0x1004/0x1045
> > > [  166.334148]  ? firmware_map_remove+0x119/0x119
> > > [  166.334153]  ksys_ioctl+0x50/0x70
> > > [  166.334158]  __x64_sys_ioctl+0x82/0x89
> > > [  166.334163]  do_syscall_64+0xa0/0xd2
> > > [  166.334167]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > [  166.334171] RIP: 0033:0x7f2481541f47
> > > [  166.334175] Code: 00 00 00 48 8b 05 51 6f 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 21 6f 2c 00 f7 d8 64 89 01 48
> > > [  166.334177] RSP: 002b:00007fffd6aff9b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > > [  166.334181] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2481541f47
> > > [  166.334184] RDX: 00007fffd6aff9c4 RSI: 0000000040045613 RDI: 0000000000000003
> > > [  166.334186] RBP: 0000555f1c494af8 R08: 00007f247f34c000 R09: 00007f2481c24700
> > > [  166.334189] R10: 0000000000000020 R11: 0000000000000246 R12: 0000555f1c494b06
> > > [  166.334191] R13: 0000000000000004 R14: 00007fffd6affb90 R15: 00007fffd6b00825
> > >
> > > [  166.334201] Allocated by task 1305:
> > > [  166.334207]  kasan_kmalloc+0x8a/0x98
> > > [  166.334210]  slab_post_alloc_hook+0x31/0x51
> > > [  166.334213]  kmem_cache_alloc+0xd7/0x174
> > > [  166.334216]  alloc_iova+0x24/0x2ea
> > > [  166.334225]  ipu3_dmamap_alloc+0x193/0x83f [ipu3_imgu]
> > > [  166.334233]  ipu3_css_pool_init+0x80/0xdf [ipu3_imgu]
> > > [  166.334241]  ipu3_css_start_streaming+0x58df/0x5ddc [ipu3_imgu]
> > > [  166.334250]  imgu_s_stream+0x2dd/0x6c0 [ipu3_imgu]
> > > [  166.334259]  ipu3_vb2_start_streaming+0x35f/0x3de [ipu3_imgu]
> > > [  166.334266]  vb2_start_streaming+0x164/0x33b [videobuf2_common]
> > > [  166.334273]  vb2_core_streamon+0x1a1/0x208 [videobuf2_common]
> > > [  166.334288]  __video_do_ioctl+0x625/0x887 [videodev]
> > > [  166.334304]  video_usercopy+0x3a3/0x8ae [videodev]
> > > [  166.334319]  v4l2_ioctl+0xb7/0xc5 [videodev]
> > > [  166.334322]  vfs_ioctl+0x76/0x89
> > > [  166.334325]  do_vfs_ioctl+0xb33/0xb7e
> > > [  166.334328]  ksys_ioctl+0x50/0x70
> > > [  166.334332]  __x64_sys_ioctl+0x82/0x89
> > > [  166.334335]  do_syscall_64+0xa0/0xd2
> > > [  166.334338]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > >
> > > [  166.334343] Freed by task 1301:
> > > [  166.334349]  __kasan_slab_free+0xfa/0x11c
> > > [  166.334352]  slab_free_freelist_hook+0x46/0x94
> > > [  166.334355]  kmem_cache_free+0x7b/0x172
> > > [  166.334359]  __free_iova+0x23/0x31
> > > [  166.334367]  ipu3_dmamap_free+0x118/0x1d6 [ipu3_imgu]
> > > [  166.334375]  ipu3_css_pool_cleanup+0x25/0x2f [ipu3_imgu]
> > > [  166.334383]  ipu3_css_pipeline_cleanup+0x79/0xcf [ipu3_imgu]
> > > [  166.334392]  ipu3_css_stop_streaming+0x2fe/0x4dc [ipu3_imgu]
> > > [  166.334401]  imgu_s_stream+0xc0/0x6c0 [ipu3_imgu]
> > > [  166.334410]  ipu3_vb2_stop_streaming+0x27c/0x2d2 [ipu3_imgu]
> > > [  166.334416]  __vb2_queue_cancel+0xa8/0x705 [videobuf2_common]
> > > [  166.334423]  vb2_core_streamoff+0x68/0xf8 [videobuf2_common]
> > > [  166.334438]  __video_do_ioctl+0x625/0x887 [videodev]
> > > [  166.334454]  video_usercopy+0x3a3/0x8ae [videodev]
> > > [  166.334469]  v4l2_ioctl+0xb7/0xc5 [videodev]
> > > [  166.334472]  vfs_ioctl+0x76/0x89
> > > [  166.334475]  do_vfs_ioctl+0xb33/0xb7e
> > > [  166.334479]  ksys_ioctl+0x50/0x70
> > > [  166.334482]  __x64_sys_ioctl+0x82/0x89
> > > [  166.334485]  do_syscall_64+0xa0/0xd2
> > > [  166.334488]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > >
> > > [  166.334494] The buggy address belongs to the object at ffff888133823700
> > >                 which belongs to the cache iommu_iova of size 40
> > > [  166.334501] The buggy address is located 0 bytes inside of
> > >                 40-byte region [ffff888133823700, ffff888133823728)
> > > [  166.334506] The buggy address belongs to the page:
> > > [  166.334511] page:ffffea0004ce0880 count:1 mapcount:0 mapping:ffff8881519e8640 index:0x0 compound_mapcount: 0
> > > [  166.334517] flags: 0x200000000010200(slab|head)
> > > [  166.334524] raw: 0200000000010200 ffffea0004dfc488 ffff88814bfbde70 ffff8881519e8640
> > > [  166.334530] raw: 0000000000000000 0000000000120012 00000001ffffffff 0000000000000000
> > > [  166.334533] page dumped because: kasan: bad access detected
> > >
> > > [  166.334539] Memory state around the buggy address:
> > > [  166.334544]  ffff888133823600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > > [  166.334549]  ffff888133823680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > > [  166.334554] >ffff888133823700: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc
> > > [  166.334558]                    ^
> > > [  166.334562]  ffff888133823780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > > [  166.334567]  ffff888133823800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > > [  166.334571] ==================================================================
> > > [  166.340377] ==================================================================
> > > [  166.340388] BUG: KASAN: double-free or invalid-free in kfree+0x107/0x1a0
> > >
> > > [  166.340399] CPU: 3 PID: 1305 Comm: yavta Tainted: G    B    C        4.20.0-rc6+ #3
> > > [  166.340401] Hardware name: HP Soraka/Soraka, BIOS  08/30/2018
> > > [  166.340403] Call Trace:
> > > [  166.340410]  dump_stack+0x5b/0x81
> > > [  166.340416]  print_address_description+0x65/0x227
> > > [  166.340420]  ? kfree+0x107/0x1a0
> > > [  166.340425]  kasan_report_invalid_free+0x67/0xa0
> > > [  166.340428]  ? kfree+0x107/0x1a0
> > > [  166.340433]  __kasan_slab_free+0x86/0x11c
> > > [  166.340438]  slab_free_freelist_hook+0x46/0x94
> > > [  166.340443]  kfree+0x107/0x1a0
> > > [  166.340454]  ? ipu3_dmamap_free+0x17b/0x1d6 [ipu3_imgu]
> > > [  166.340464]  ipu3_dmamap_free+0x17b/0x1d6 [ipu3_imgu]
> > > [  166.340475]  ipu3_css_pool_cleanup+0x25/0x2f [ipu3_imgu]
> > > [  166.340485]  ipu3_css_pipeline_cleanup+0x79/0xcf [ipu3_imgu]
> > > [  166.340495]  ipu3_css_stop_streaming+0x2fe/0x4dc [ipu3_imgu]
> > > [  166.340509]  imgu_s_stream+0xc0/0x6c0 [ipu3_imgu]
> > > [  166.340520]  ? ipu3_all_nodes_streaming+0x1ee/0x20d [ipu3_imgu]
> > > [  166.340531]  ipu3_vb2_stop_streaming+0x27c/0x2d2 [ipu3_imgu]
> > > [  166.340541]  __vb2_queue_cancel+0xa8/0x705 [videobuf2_common]
> > > [  166.340548]  ? __mutex_lock_interruptible_slowpath+0xf/0xf
> > > [  166.340557]  vb2_core_streamoff+0x68/0xf8 [videobuf2_common]
> > > [  166.340575]  __video_do_ioctl+0x625/0x887 [videodev]
> > > [  166.340595]  ? copy_overflow+0x14/0x14 [videodev]
> > > [  166.340600]  ? slab_free_freelist_hook+0x46/0x94
> > > [  166.340604]  ? kfree+0x107/0x1a0
> > > [  166.340622]  video_usercopy+0x3a3/0x8ae [videodev]
> > > [  166.340640]  ? copy_overflow+0x14/0x14 [videodev]
> > > [  166.340657]  ? v4l_enumstd+0x49/0x49 [videodev]
> > > [  166.340660]  ? __wake_up_common+0x342/0x342
> > > [  166.340668]  ? atomic_long_add_return+0x15/0x24
> > > [  166.340672]  ? ldsem_up_read+0x15/0x29
> > > [  166.340677]  ? tty_write+0x4c6/0x4d8
> > > [  166.340681]  ? n_tty_receive_char_special+0x1152/0x1152
> > > [  166.340698]  ? video_usercopy+0x8ae/0x8ae [videodev]
> > > [  166.340714]  v4l2_ioctl+0xb7/0xc5 [videodev]
> > > [  166.340720]  vfs_ioctl+0x76/0x89
> > > [  166.340725]  do_vfs_ioctl+0xb33/0xb7e
> > > [  166.340729]  ? __switch_to_asm+0x40/0x70
> > > [  166.340733]  ? __switch_to_asm+0x40/0x70
> > > [  166.340736]  ? __switch_to_asm+0x34/0x70
> > > [  166.340739]  ? __switch_to_asm+0x40/0x70
> > > [  166.340743]  ? ioctl_preallocate+0x174/0x174
> > > [  166.340748]  ? __switch_to+0x71c/0xb00
> > > [  166.340752]  ? compat_start_thread+0x6b/0x6b
> > > [  166.340756]  ? __switch_to_asm+0x34/0x70
> > > [  166.340759]  ? __switch_to_asm+0x40/0x70
> > > [  166.340762]  ? mmdrop+0x12/0x23
> > > [  166.340766]  ? finish_task_switch+0x34d/0x3de
> > > [  166.340772]  ? __schedule+0x1004/0x1045
> > > [  166.340777]  ? firmware_map_remove+0x119/0x119
> > > [  166.340782]  ksys_ioctl+0x50/0x70
> > > [  166.340788]  __x64_sys_ioctl+0x82/0x89
> > > [  166.340793]  do_syscall_64+0xa0/0xd2
> > > [  166.340797]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > [  166.340802] RIP: 0033:0x7f2481541f47
> > > [  166.340806] Code: 00 00 00 48 8b 05 51 6f 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 21 6f 2c 00 f7 d8 64 89 01 48
> > > [  166.340809] RSP: 002b:00007fffd6aff9b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > > [  166.340813] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2481541f47
> > > [  166.340816] RDX: 00007fffd6aff9c4 RSI: 0000000040045613 RDI: 0000000000000003
> > > [  166.340819] RBP: 0000555f1c494af8 R08: 00007f247f34c000 R09: 00007f2481c24700
> > > [  166.340821] R10: 0000000000000020 R11: 0000000000000246 R12: 0000555f1c494b06
> > > [  166.340824] R13: 0000000000000004 R14: 00007fffd6affb90 R15: 00007fffd6b00825
> > >
> > > [  166.340834] Allocated by task 1305:
> > > [  166.340840]  kasan_kmalloc+0x8a/0x98
> > > [  166.340844]  __kmalloc_node+0x193/0x1ba
> > > [  166.340848]  kvmalloc_node+0x44/0x6d
> > > [  166.340856]  ipu3_dmamap_alloc+0x1c9/0x83f [ipu3_imgu]
> > > [  166.340864]  ipu3_css_pool_init+0x80/0xdf [ipu3_imgu]
> > > [  166.340873]  ipu3_css_start_streaming+0x58df/0x5ddc [ipu3_imgu]
> > > [  166.340882]  imgu_s_stream+0x2dd/0x6c0 [ipu3_imgu]
> > > [  166.340891]  ipu3_vb2_start_streaming+0x35f/0x3de [ipu3_imgu]
> > > [  166.340897]  vb2_start_streaming+0x164/0x33b [videobuf2_common]
> > > [  166.340904]  vb2_core_streamon+0x1a1/0x208 [videobuf2_common]
> > > [  166.340920]  __video_do_ioctl+0x625/0x887 [videodev]
> > > [  166.340935]  video_usercopy+0x3a3/0x8ae [videodev]
> > > [  166.340950]  v4l2_ioctl+0xb7/0xc5 [videodev]
> > > [  166.340954]  vfs_ioctl+0x76/0x89
> > > [  166.340957]  do_vfs_ioctl+0xb33/0xb7e
> > > [  166.340960]  ksys_ioctl+0x50/0x70
> > > [  166.340963]  __x64_sys_ioctl+0x82/0x89
> > > [  166.340966]  do_syscall_64+0xa0/0xd2
> > > [  166.340969]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > >
> > > [  166.340974] Freed by task 1301:
> > > [  166.340980]  __kasan_slab_free+0xfa/0x11c
> > > [  166.340983]  slab_free_freelist_hook+0x46/0x94
> > > [  166.340986]  kfree+0x107/0x1a0
> > > [  166.340994]  ipu3_dmamap_free+0x17b/0x1d6 [ipu3_imgu]
> > > [  166.341002]  ipu3_css_pool_cleanup+0x25/0x2f [ipu3_imgu]
> > > [  166.341010]  ipu3_css_pipeline_cleanup+0x79/0xcf [ipu3_imgu]
> > > [  166.341019]  ipu3_css_stop_streaming+0x2fe/0x4dc [ipu3_imgu]
> > > [  166.341028]  imgu_s_stream+0xc0/0x6c0 [ipu3_imgu]
> > > [  166.341037]  ipu3_vb2_stop_streaming+0x27c/0x2d2 [ipu3_imgu]
> > > [  166.341043]  __vb2_queue_cancel+0xa8/0x705 [videobuf2_common]
> > > [  166.341050]  vb2_core_streamoff+0x68/0xf8 [videobuf2_common]
> > > [  166.341066]  __video_do_ioctl+0x625/0x887 [videodev]
> > > [  166.341081]  video_usercopy+0x3a3/0x8ae [videodev]
> > > [  166.341096]  v4l2_ioctl+0xb7/0xc5 [videodev]
> > > [  166.341100]  vfs_ioctl+0x76/0x89
> > > [  166.341103]  do_vfs_ioctl+0xb33/0xb7e
> > > [  166.341106]  ksys_ioctl+0x50/0x70
> > > [  166.341109]  __x64_sys_ioctl+0x82/0x89
> > > [  166.341112]  do_syscall_64+0xa0/0xd2
> > > [  166.341116]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > >
> > > [  166.341122] The buggy address belongs to the object at ffff88811d228440
> > >                 which belongs to the cache kmalloc-8 of size 8
> > > [  166.341129] The buggy address is located 0 bytes inside of
> > >                 8-byte region [ffff88811d228440, ffff88811d228448)
> > > [  166.341134] The buggy address belongs to the page:
> > > [  166.341140] page:ffffea0004748a00 count:1 mapcount:0 mapping:ffff88815a80c340 index:0xffff88811d228f80 compound_mapcount: 0
> > > [  166.341146] flags: 0x200000000010200(slab|head)
> > > [  166.341153] raw: 0200000000010200 ffffea000564b288 ffffea00049ef708 ffff88815a80c340
> > > [  166.341159] raw: ffff88811d228f80 0000000000160013 00000001ffffffff 0000000000000000
> > > [  166.341163] page dumped because: kasan: bad access detected
> > >
> > > [  166.341169] Memory state around the buggy address:
> > > [  166.341174]  ffff88811d228300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > > [  166.341179]  ffff88811d228380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > > [  166.341184] >ffff88811d228400: fc fc fc fc fc fc fc fc fb fc fc fc fc fc fc fc
> > > [  166.341188]                                            ^
> > > [  166.341192]  ffff88811d228480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > > [  166.341197]  ffff88811d228500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > > [  166.341201] ==================================================================
> > >
> > > > On Tuesday, 11 December 2018 16:20:43 EET Laurent Pinchart wrote:
> > > > > On Tuesday, 11 December 2018 15:43:53 EET Laurent Pinchart wrote:
> > > > > > On Tuesday, 11 December 2018 15:34:49 EET Laurent Pinchart wrote:
> > > > > >> On Wednesday, 5 December 2018 02:30:46 EET Mani, Rajmohan wrote:
> > > > > >>
> > > > > >> [snip]
> > > > > >>
> > > > > >>> I can see a couple of steps missing in the script below.
> > > > > >>> (https://lists.libcamera.org/pipermail/libcamera-devel/2018-November/0
> > > > > >>> 00040.html)
> > > > > >>>
> > > > > >>> From patch 02 of this v7 series "doc-rst: Add Intel IPU3
> > > > > >>> documentation",
> > > > > >>> under section "Configuring ImgU V4L2 subdev for image processing"...
> > > > > >>>
> > > > > >>> 1. The pipe mode needs to be configured for the V4L2 subdev.
> > > > > >>>
> > > > > >>> Also the pipe mode of the corresponding V4L2 subdev should be set as
> > > > > >>> desired (e.g 0 for video mode or 1 for still mode) through the control
> > > > > >>> id 0x009819a1 as below.
> > > > > >>>
> > > > > >>> e.g v4l2n -d /dev/v4l-subdev7 --ctrl=0x009819A1=1
> > > > > >>
> > > > > >> I assume the control takes a valid default value ? It's better to set
> > > > > >> it
> > > > > >> explicitly anyway, so I'll do so.
> > > > > >>
> > > > > >>> 2. ImgU pipeline needs to be configured for image processing as below.
> > > > > >>>
> > > > > >>> RAW bayer frames go through the following ISP pipeline HW blocks to
> > > > > >>> have the processed image output to the DDR memory.
> > > > > >>>
> > > > > >>> RAW bayer frame -> Input Feeder -> Bayer Down Scaling (BDS) ->
> > > > > >>> Geometric Distortion Correction (GDC) -> DDR
> > > > > >>>
> > > > > >>> The ImgU V4L2 subdev has to be configured with the supported
> > > > > >>> resolutions in all the above HW blocks, for a given input resolution.
> > > > > >>>
> > > > > >>> For a given supported resolution for an input frame, the Input Feeder,
> > > > > >>> Bayer Down Scaling and GDC blocks should be configured with the
> > > > > >>> supported resolutions. This information can be obtained by looking at
> > > > > >>> the following IPU3 ISP configuration table for ov5670 sensor.
> > > > > >>>
> > > > > >>> https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+
> > > > > >>> /master/baseboard-poppy/media-libs/cros-camera-hal-configs-poppy/files
> > > > > >>> /
> > > > > >>> gcss/graph_settings_ov5670.xml
> > > > > >>>
> > > > > >>> For the ov5670 example, for an input frame with a resolution of
> > > > > >>> 2592x1944 (which is input to the ImgU subdev pad 0), the corresponding
> > > > > >>> resolutions for input feeder, BDS and GDC are 2592x1944, 2592x1944 and
> > > > > >>> 2560x1920 respectively.
> > > > > >>
> > > > > >> How is the GDC output resolution computed from the input resolution ?
> > > > > >> Does the GDC always consume 32 columns and 22 lines ?
> > > > > >>
> > > > > >>> The following steps prepare the ImgU ISP pipeline for the image
> > > > > >>> processing.
> > > > > >>>
> > > > > >>> 1. The ImgU V4L2 subdev data format should be set by using the
> > > > > >>> VIDIOC_SUBDEV_S_FMT on pad 0, using the GDC width and height obtained
> > > > > >>> above.
> > > > > >>
> > > > > >> If I understand things correctly, the GDC resolution is the pipeline
> > > > > >> output resolution. Why is it configured on pad 0 ?
> > > > > >>
> > > > > >>> 2. The ImgU V4L2 subdev cropping should be set by using the
> > > > > >>> VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_CROP as the
> > > > > >>> target, using the input feeder height and width.
> > > > > >>>
> > > > > >>> 3. The ImgU V4L2 subdev composing should be set by using the
> > > > > >>> VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_COMPOSE as the
> > > > > >>> target, using the BDS height and width.
> > > > > >>>
> > > > > >>> Once these 2 steps are done, the raw bayer frames can be input to the
> > > > > >>> ImgU V4L2 subdev for processing.
> > > > > >>
> > > > > >> Do I need to capture from both the output and viewfinder nodes ? How
> > > > > >> are
> > > > > >> they related to the IF -> BDS -> GDC pipeline, are they both fed from
> > > > > >> the GDC output ? If so, how does the viewfinder scaler fit in that
> > > > > >> picture ?
> > > > > >>
> > > > > >> I have tried the above configuration with the IPU3 v8 driver, and while
> > > > > >> the kernel doesn't crash, no images get processed. The userspace
> > > > > >> processes wait forever for buffers to be ready. I then configured pad 2
> > > > > >> to 2560x1920 and pad 3 to 1920x1080, and managed to capture images \o/
> > > > > >>
> > > > > >> There's one problem though: during capture, or very soon after it, the
> > > > > >> machine locks up completely. I suspect a memory corruption, as when it
> > > > > >> doesn't log immediately commands such as dmesg will not produce any
> > > > > >> output and just block, until the system freezes soon after (especially
> > > > > >> when moving the mouse).
> > > > > >>
> > > > > >> I would still call this an improvement to some extent, but there's
> > > > > >> definitely room for more improvements :-)
> > > > > >>
> > > > > >> To reproduce the issue, you can run the ipu3-process.sh script
> > > > > >> (attached
> > > > > >> to this e-mail) with the following arguments:
> > > > > >>
> > > > > >> $ ipu3-process.sh --out 2560x1920 frame-2592x1944.cio2
> > > > >
> > > > > This should have read
> > > > >
> > > > > $ ipu3-process.sh --out 2560x1920 --vf 1920x1080 frame-2592x1944.cio2
> > > > >
> > > > > Without the --vf argument no images are processed.
> > > > >
> > > > > It seems that the Intel mail server blocked the mail that contained the
> > > > > script. You can find a copy at http://paste.debian.net/hidden/fd5bb8df/.
> > > > >
> > > > > >> frame-2592x1944.cio2 is a binary file containing a 2592x1944 images in
> > > > > >> the IPU3-specific Bayer format (for a total of 6469632 bytes).
> > > > > >
> > > > > > I managed to get the dmesg output, and it doesn't look pretty.
> > > > > >
> > > > > > [  571.217192] WARNING: CPU: 3 PID: 1303 at /home/laurent/src/iob/oss/
> > > > > > libcamera/linux/drivers/staging/media/ipu3/ipu3-dmamap.c:172
> > > > > > ipu3_dmamap_unmap+0x30/0x75 [ipu3_imgu]
> > > > > > [  571.217196] Modules linked in: asix usbnet mii zram arc4 iwlmvm
> > > > > > mac80211
> > > > > > iwlwifi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp
> > > > > > cfg80211
> > > > > > 8250_dw hid_multitouch ipu3_cio2 ipu3_imgu(C) videobuf2_dma_sg
> > > > > > videobuf2_memops videobuf2_v4l2 videobuf2_common
> > > > > > processor_thermal_device
> > > > > > intel_soc_dts_iosf ov13858 dw9714 ov5670 v4l2_fwnode v4l2_common
> > > > > > videodev
> > > > > > at24 media int3403_thermal int340x_thermal_zone cros_ec_lpcs
> > > > > > cros_ec_core
> > > > > > int3400_thermal chromeos_pstore mac_hid acpi_thermal_rel autofs4 usbhid
> > > > > > mmc_block hid_generic i915 video i2c_algo_bit drm_kms_helper syscopyarea
> > > > > > sysfillrect sdhci_pci sysimgblt fb_sys_fops cqhci sdhci drm
> > > > > > drm_panel_orientation_quirks i2c_hid hid
> > > > > > [  571.217254] CPU: 3 PID: 1303 Comm: yavta Tainted: G         C
> > > > > > 4.20.0-rc6+ #2
> > > > > > [  571.217256] Hardware name: HP Soraka/Soraka, BIOS  08/30/2018
> > > > > > [  571.217267] RIP: 0010:ipu3_dmamap_unmap+0x30/0x75 [ipu3_imgu]
> > > > > > [  571.217271] Code: 54 55 48 8d af d0 6e 00 00 53 48 8b 76 10 49 89 fc
> > > > > > f3
> > > > > > 48 0f bc 8f f0 6e 00 00 48 89 ef 48 d3 ee e8 e6 73 d9 e6 48 85 c0 75 07
> > > > > > <0f> 0b 5b 5d 41 5c c3 48 8b 70 20 48 89 c3 48 8b 40 18 49 8b bc 24
> > > > > > [  571.217274] RSP: 0018:ffffb675021c7b38 EFLAGS: 00010246
> > > > > > [  571.217278] RAX: 0000000000000000 RBX: ffff8f5cf58f8448 RCX:
> > > > > > 000000000000000c
> > > > > > [  571.217280] RDX: 0000000000000000 RSI: 0000000000000202 RDI:
> > > > > > 00000000ffffffff
> > > > > > [  571.217283] RBP: ffff8f5cf58f6ef8 R08: 00000000000006c5 R09:
> > > > > > ffff8f5cfaba16f0
> > > > > > [  571.217286] R10: ffff8f5cbf508f98 R11: 000000e03da27aba R12:
> > > > > > ffff8f5cf58f0028
> > > > > > [  571.217289] R13: ffff8f5cf58f0028 R14: 0000000000000000 R15:
> > > > > > ffff8f5cf58f04e8
> > > > > > [  571.217293] FS:  00007f85d009c700(0000) GS:ffff8f5cfab80000(0000)
> > > > > > knlGS:
> > > > > > 0000000000000000
> > > > > > [  571.217296] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > > [  571.217299] CR2: 00007f3440fce4b0 CR3: 000000014abf2001 CR4:
> > > > > > 00000000003606e0
> > > > > > [  571.217301] Call Trace:
> > > > > > [  571.217316]  ipu3_dmamap_free+0x5b/0x8f [ipu3_imgu]
> > > > > > [  571.217326]  ipu3_css_pool_cleanup+0x25/0x2f [ipu3_imgu]
> > > > > > [  571.217338]  ipu3_css_pipeline_cleanup+0x59/0x8f [ipu3_imgu]
> > > > > > [  571.217348]  ipu3_css_stop_streaming+0x15b/0x20f [ipu3_imgu]
> > > > > > [  571.217360]  imgu_s_stream+0x5a/0x30a [ipu3_imgu]
> > > > > > [  571.217371]  ? ipu3_all_nodes_streaming+0x14f/0x16b [ipu3_imgu]
> > > > > > [  571.217382]  ipu3_vb2_stop_streaming+0xe4/0x10f [ipu3_imgu]
> > > > > > [  571.217392]  __vb2_queue_cancel+0x2b/0x1b8 [videobuf2_common]
> > > > > > [  571.217402]  vb2_core_streamoff+0x30/0x71 [videobuf2_common]
> > > > > > [  571.217418]  __video_do_ioctl+0x258/0x38e [videodev]
> > > > > > [  571.217438]  video_usercopy+0x25f/0x4e5 [videodev]
> > > > > > [  571.217453]  ? copy_overflow+0x14/0x14 [videodev]
> > > > > > [  571.217471]  v4l2_ioctl+0x4d/0x58 [videodev]
> > > > > > [  571.217480]  vfs_ioctl+0x1e/0x2b
> > > > > > [  571.217486]  do_vfs_ioctl+0x531/0x559
> > > > > > [  571.217494]  ? vfs_write+0xd1/0xdf
> > > > > > [  571.217500]  ksys_ioctl+0x50/0x70
> > > > > > [  571.217506]  __x64_sys_ioctl+0x16/0x19
> > > > > > [  571.217512]  do_syscall_64+0x53/0x60
> > > > > > [  571.217519]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > > > > [  571.217524] RIP: 0033:0x7f85cf9b9f47
> > > > > > [  571.217528] Code: 00 00 00 48 8b 05 51 6f 2c 00 64 c7 00 26 00 00 00
> > > > > > 48
> > > > > > c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05
> > > > > > <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 21 6f 2c 00 f7 d8 64 89 01 48
> > > > > > [  571.217531] RSP: 002b:00007ffc59056b78 EFLAGS: 00000246 ORIG_RAX:
> > > > > > 0000000000000010
> > > > > > [  571.217535] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
> > > > > > 00007f85cf9b9f47
> > > > > > [  571.217537] RDX: 00007ffc59056b84 RSI: 0000000040045613 RDI:
> > > > > > 0000000000000003
> > > > > > [  571.217540] RBP: 000055f4c4dc0af8 R08: 00007f85cd7c4000 R09:
> > > > > > 00007f85d009c700
> > > > > > [  571.217542] R10: 0000000000000020 R11: 0000000000000246 R12:
> > > > > > 000055f4c4dc0b06
> > > > > > [  571.217545] R13: 0000000000000004 R14: 00007ffc59056d50 R15:
> > > > > > 00007ffc59057825
> > > > > > [  571.217553] ---[ end trace 4b42bd84953eff53 ]---
> > > > > > [  571.318645] ipu3-imgu 0000:00:05.0: wait cio gate idle timeout
> > > > >
> > > > > And after fixing another issue in the capture script (which was setting
> > > > > the
> > > > > format on the ImgU subdev pad 3 to 2560x1920 but capture in 1920x1080), I
> > > > > now get plenty of the following messages:
> > > > >
> > > > > [  221.366131] BUG: Bad page state in process yavta  pfn:14a4ff
> > > > > [  221.366134] page:ffffde5d45293fc0 count:-1 mapcount:0 mapping:
> > > > > 0000000000000000 index:0x0
> > > > > [  221.366137] flags: 0x200000000000000()
> > > > > [  221.366140] raw: 0200000000000000 dead000000000100 dead000000000200
> > > > > 0000000000000000
> > > > > [  221.366143] raw: 0000000000000000 0000000000000000 ffffffffffffffff
> > > > > 0000000000000000
> > > > > [  221.366145] page dumped because: nonzero _refcount
> > > > > [  221.366147] Modules linked in: asix usbnet mii zram arc4 iwlmvm
> > > > > intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp mac80211 iwlwifi
> > > > > cfg80211 hid_multitouch 8250_dw ipu3_cio2 ipu3_imgu(C) videobuf2_dma_sg
> > > > > videobuf2_memops videobuf2_v4l2 processor_thermal_device videobuf2_common
> > > > > intel_soc_dts_iosf ov13858 ov5670 dw9714 v4l2_fwnode v4l2_common videodev
> > > > > media at24 cros_ec_lpcs cros_ec_core int3403_thermal int340x_thermal_zone
> > > > > chromeos_pstore mac_hid int3400_thermal acpi_thermal_rel autofs4 usbhid
> > > > > mmc_block hid_generic i915 video i2c_algo_bit drm_kms_helper syscopyarea
> > > > > sysfillrect sysimgblt fb_sys_fops sdhci_pci cqhci sdhci drm
> > > > > drm_panel_orientation_quirks i2c_hid hid
> > > > > [  221.366172] CPU: 3 PID: 1022 Comm: yavta Tainted: G    B   WC
> > > > > 4.20.0-rc6+ #2
> > > > > [  221.366173] Hardware name: HP Soraka/Soraka, BIOS  08/30/2018
> > > > > [  221.366173] Call Trace:
> > > > > [  221.366176]  dump_stack+0x46/0x59
> > > > > [  221.366179]  bad_page+0xf2/0x10c
> > > > > [  221.366182]  free_pages_check+0x78/0x81
> > > > > [  221.366186]  free_pcppages_bulk+0xa6/0x236
> > > > > [  221.366190]  free_unref_page+0x4b/0x53
> > > > > [  221.366193]  vb2_dma_sg_put+0x95/0xb5 [videobuf2_dma_sg]
> > > > > [  221.366197]  __vb2_buf_mem_free+0x3a/0x6e [videobuf2_common]
> > > > > [  221.366202]  __vb2_queue_free+0xe3/0x1be [videobuf2_common]
> > > > > [  221.366207]  vb2_core_reqbufs+0xe9/0x2cc [videobuf2_common]
> > > > > [  221.366212]  vb2_ioctl_reqbufs+0x78/0x9e [videobuf2_v4l2]
> > > > > [  221.366220]  __video_do_ioctl+0x258/0x38e [videodev]
> > > > > [  221.366229]  video_usercopy+0x25f/0x4e5 [videodev]
> > > > > [  221.366237]  ? copy_overflow+0x14/0x14 [videodev]
> > > > > [  221.366240]  ? unmap_region+0xe0/0x10a
> > > > > [  221.366250]  v4l2_ioctl+0x4d/0x58 [videodev]
> > > > > [  221.366253]  vfs_ioctl+0x1e/0x2b
> > > > > [  221.366255]  do_vfs_ioctl+0x531/0x559
> > > > > [  221.366260]  ksys_ioctl+0x50/0x70
> > > > > [  221.366263]  __x64_sys_ioctl+0x16/0x19
> > > > > [  221.366266]  do_syscall_64+0x53/0x60
> > > > > [  221.366269]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > > > [  221.366270] RIP: 0033:0x7fbe39f6af47
> > > > > [  221.366272] Code: 00 00 00 48 8b 05 51 6f 2c 00 64 c7 00 26 00 00 00 48
> > > > > c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05
> > > > > <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 21 6f 2c 00 f7 d8 64 89 01 48
> > > > > [  221.366273] RSP: 002b:00007fff05638e68 EFLAGS: 00000246 ORIG_RAX:
> > > > > 0000000000000010
> > > > > [  221.366275] RAX: ffffffffffffffda RBX: 0000000000000007 RCX:
> > > > > 00007fbe39f6af47
> > > > > [  221.366279] RDX: 00007fff05638f90 RSI: 00000000c0145608 RDI:
> > > > > 0000000000000003
> > > > > [  221.366283] RBP: 0000000000000004 R08: 0000000000000000 R09:
> > > > > 0000000000000045
> > > > > [  221.366287] R10: 0000000000000557 R11: 0000000000000246 R12:
> > > > > 000055c83bd76750
> > > > > [  221.366290] R13: 000055c83b6b26a0 R14: 0000000000000001 R15:
> > > > > 00007fff0563a825
> > >
> > > --
> > > Regards,
> > >
> > > Laurent Pinchart
> > >
> > >
> > >

--45ord6jdbxrcktt5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlw2JAUACgkQcjQGjxah
VjyYThAAhg41Q5lIxjVSniXOUpj2aFD87Qj77U9IUOc6hRLqb1cGgFLbf5lFtOnx
Yh5wxGkEaKbrMxOZ5y0bBapmGDZBohPq/5onBBWdmi0Z1kxuSux7lO0Hgy+BCl/a
5CcueRsXLjmlEivZw24G7+V8hJJxnPP7VZFwvPdDZF1qjZQIypoeuVKTVT0RjUGc
aAC5z5kdcubZ/S0F9rwyYhgEhtpt2gGmtehWpBOg8pXegpOok895gFtV8avlkMFA
NrUnpM8xhTmoG5ZozWEFdTW9eE4IO53SlG5kA1lDFeB5YBj+Yq9Vw34SgTzbg/4j
FlURcUPmtxddPtZIbq38whdIUFj9B9bHIMZg/ZaXu6+PK/3562A755jrvgrDaKq1
GLl8qPCv2soxWK5gFEeecuWGnGrWFUTrnUVUrOEupohTJTHZAxrsfmZyP2YwfdWg
AHIDvHKJbeu93gC3IMfz1zmFH//Q63vf+HbcmcTSYlOwKb9ZGIyH8U+aGrAP/cTC
twETdz2P9eVP4255SixjjxxK9RY2K37ggmcBHjfqka5KxQCV3qBakOwf3GBVbXFk
lqolhBgqk/sJAnA6l6+KMoCnR9VxXuc5k77GOJqdLPw0ihpuFI63909IVlqwYZAQ
4LjNk84NS5QHrwcPfX/aEXCAUQHE74RVoik0ZUrH4x5Slh7curA=
=P68A
-----END PGP SIGNATURE-----

--45ord6jdbxrcktt5--
