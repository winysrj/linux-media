Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,UPPERCASE_50_75,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C7EC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 17:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1578E214C6
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 17:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfAIRZ5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 12:25:57 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:57675 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfAIRZ5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 12:25:57 -0500
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id D6237100006;
        Wed,  9 Jan 2019 17:25:46 +0000 (UTC)
Date:   Wed, 9 Jan 2019 18:25:53 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     "Mani, Rajmohan" <rajmohan.mani@intel.com>
Cc:     Tomasz Figa <tfiga@chromium.org>, "Zhi, Yong" <yong.zhi@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Message-ID: <20190109172553.lrnwxuy3x4drk6af@uno.localdomain>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1819843.KIqgResAvh@avalon>
 <2135468.G1bK1392oW@avalon>
 <3475971.piroVKfGO7@avalon>
 <CAAFQd5CN3dhTviSnFbzSOjkMTQqUyOajYv+CVxSLLAih522CgQ@mail.gmail.com>
 <CAAFQd5AWLi=UD+LtuiQdc5QD8v5B1WX0Jcoe6=QUy+392FSeng@mail.gmail.com>
 <20190109164037.yvtluixvua7cm2tl@uno.localdomain>
 <6F87890CF0F5204F892DEA1EF0D77A599B321599@fmsmsx122.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="24f5qynqznqmgshh"
Content-Disposition: inline
In-Reply-To: <6F87890CF0F5204F892DEA1EF0D77A599B321599@fmsmsx122.amr.corp.intel.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--24f5qynqznqmgshh
Content-Type: multipart/mixed; boundary="eysapepcergda33h"
Content-Disposition: inline


--eysapepcergda33h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello Raj,

On Wed, Jan 09, 2019 at 05:00:21PM +0000, Mani, Rajmohan wrote:
> Hi Laurent, Tomasz, Jacopo,
>
> > -----Original Message-----
> > From: Jacopo Mondi [mailto:jacopo@jmondi.org]
> > Sent: Wednesday, January 09, 2019 8:41 AM
> > To: Tomasz Figa <tfiga@chromium.org>
> > Cc: Zhi, Yong <yong.zhi@intel.com>; Mani, Rajmohan
> > <rajmohan.mani@intel.com>; Qiu, Tian Shu <tian.shu.qiu@intel.com>; Cao,
> > Bingbu <bingbu.cao@intel.com>; Laurent Pinchart
> > <laurent.pinchart@ideasonboard.com>; Linux Media Mailing List <linux-
> > media@vger.kernel.org>; Sakari Ailus <sakari.ailus@linux.intel.com>; Mauro
> > Carvalho Chehab <mchehab@kernel.org>; Hans Verkuil
> > <hans.verkuil@cisco.com>; Hu, Jerry W <jerry.w.hu@intel.com>; Toivonen,
> > Tuukka <tuukka.toivonen@intel.com>
> > Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
> >
> > Hello,
> >
> > On Tue, Jan 08, 2019 at 03:54:34PM +0900, Tomasz Figa wrote:
> > > Hi Raj, Yong, Bingbu, Tianshu,
> > >
> > > On Fri, Dec 21, 2018 at 12:04 PM Tomasz Figa <tfiga@chromium.org> wrote:
> > > >
> > > > On Fri, Dec 21, 2018 at 7:24 AM Laurent Pinchart
> > > > <laurent.pinchart@ideasonboard.com> wrote:
> > > > >
> > > > > Hellon
> > > > >
> > > > > On Sunday, 16 December 2018 09:26:18 EET Laurent Pinchart wrote:
> > > > > > Hello Yong,
> > > > > >
> > > > > > Could you please have a look at the crash reported below ?
> > > > >
> > > > > A bit more information to help you debugging this. I've enabled
> > > > > KASAN in the kernel configuration, and get the following use-after-free
> > reports.
> >
> > I tested as well using the ipu-process.sh script shared by Laurent, with the
> > following command line:
> > ./ipu3-process.sh --out 2560x1920 --vf 1920x1080 frame-2592x1944.cio2
> >
> > and I got a very similar trace available at:
> > https://paste.debian.net/hidden/5855e15a/
> >
> > Please note I have been able to process a set of images (with KASAN enabled
> > the machine does not freeze) but the kernel log gets flooded and it is not
> > possible to process any other frame after this.
> >
> > The issue is currently quite annoying and it's a blocker for libcamera
> > development on IPU3. Please let me know if I can support with more testing.
> >
> > Thanks
> >    j
> >
> > > > >
> > > > > [  166.332920]
> > > > >
> > ================================================================
> > ==
> > > > > [  166.332937] BUG: KASAN: use-after-free in
> > > > > __cached_rbnode_delete_update+0x36/0x202
> > > > > [  166.332944] Read of size 8 at addr ffff888133823718 by task
> > > > > yavta/1305
> > > > >
> > > > > [  166.332955] CPU: 3 PID: 1305 Comm: yavta Tainted: G         C        4.20.0-
> > rc6+ #3
> > > > > [  166.332958] Hardware name: HP Soraka/Soraka, BIOS  08/30/2018 [
> > > > > 166.332959] Call Trace:
> > > > > [  166.332967]  dump_stack+0x5b/0x81 [  166.332974]
> > > > > print_address_description+0x65/0x227
> > > > > [  166.332979]  ? __cached_rbnode_delete_update+0x36/0x202
> > > > > [  166.332983]  kasan_report+0x247/0x285 [  166.332989]
> > > > > __cached_rbnode_delete_update+0x36/0x202
> > > > > [  166.332995]  private_free_iova+0x57/0x6d [  166.332999]
> > > > > __free_iova+0x23/0x31 [  166.333011]  ipu3_dmamap_free+0x118/0x1d6
> > > > > [ipu3_imgu]
> > > >
> > > > Thanks Laurent, I think this is a very good hint. It looks like
> > > > we're basically freeing and already freed IOVA and corrupting some
> > > > allocator state?
> > >
> > > Did you have any luck in reproducing and fixing this double free issue?
> > >
>
> This issue is either hard to reproduce or comes with different signatures with
> the updated yavta (that now supports meta output) with the 4.4 kernel that
> I have been using.
> I am switching to 4.20-rc6 for better reproducibility.
> Enabling KASAN also results in storage space issues on my Chrome device.
> Will enable this just for ImgU to get ahead and get back with more updates.
>

Thanks for testing this.

For your informations I'm using the following branch, from Sakari's
tree: git://linuxtv.org/sailus/media_tree.git ipu3

Although it appears that the media tree master branch has everything
that is there, with a few additional patches on top. I should move to
use media tree master as well...

I have here attached 2 configuration files for v4.20-rc5 I am using on
Soraka, in case they might help you. One has KASAN enabled with an
increased kernel log size, the other one is the one we use for daily
development.

Also, please make sure to use (the most) recent media-ctl and yavta
utilities, as the ones provided by most distros are usually not recent
enough to work with IPU3, but I'm sure you know that already ;)

Thanks
  j

> > > Best regards,
> > > Tomasz
> > >
> > > >
> > > > > [  166.333022]  ipu3_css_pool_cleanup+0x25/0x2f [ipu3_imgu] [
> > > > > 166.333032]  ipu3_css_pipeline_cleanup+0x79/0xcf [ipu3_imgu] [
> > > > > 166.333043]  ipu3_css_stop_streaming+0x2fe/0x4dc [ipu3_imgu] [
> > > > > 166.333056]  imgu_s_stream+0xc0/0x6c0 [ipu3_imgu] [  166.333067]
> > > > > ? ipu3_all_nodes_streaming+0x1ee/0x20d [ipu3_imgu] [  166.333079]
> > > > > ipu3_vb2_stop_streaming+0x27c/0x2d2 [ipu3_imgu] [  166.333088]
> > > > > __vb2_queue_cancel+0xa8/0x705 [videobuf2_common] [  166.333096]  ?
> > > > > __mutex_lock_interruptible_slowpath+0xf/0xf
> > > > > [  166.333104]  vb2_core_streamoff+0x68/0xf8 [videobuf2_common] [
> > > > > 166.333123]  __video_do_ioctl+0x625/0x887 [videodev] [
> > > > > 166.333142]  ? copy_overflow+0x14/0x14 [videodev] [  166.333147]
> > > > > ? slab_free_freelist_hook+0x46/0x94 [  166.333151]  ?
> > > > > kfree+0x107/0x1a0 [  166.333169]  video_usercopy+0x3a3/0x8ae
> > > > > [videodev] [  166.333187]  ? copy_overflow+0x14/0x14 [videodev] [
> > > > > 166.333203]  ? v4l_enumstd+0x49/0x49 [videodev] [  166.333207]  ?
> > > > > __wake_up_common+0x342/0x342 [  166.333215]  ?
> > > > > atomic_long_add_return+0x15/0x24 [  166.333219]  ?
> > > > > ldsem_up_read+0x15/0x29 [  166.333223]  ? tty_write+0x4c6/0x4d8 [
> > > > > 166.333227]  ? n_tty_receive_char_special+0x1152/0x1152
> > > > > [  166.333244]  ? video_usercopy+0x8ae/0x8ae [videodev] [
> > > > > 166.333260]  v4l2_ioctl+0xb7/0xc5 [videodev] [  166.333266]
> > > > > vfs_ioctl+0x76/0x89 [  166.333271]  do_vfs_ioctl+0xb33/0xb7e [
> > > > > 166.333275]  ? __switch_to_asm+0x40/0x70 [  166.333279]  ?
> > > > > __switch_to_asm+0x40/0x70 [  166.333282]  ?
> > > > > __switch_to_asm+0x34/0x70 [  166.333286]  ?
> > > > > __switch_to_asm+0x40/0x70 [  166.333290]  ?
> > > > > ioctl_preallocate+0x174/0x174 [  166.333294]  ?
> > > > > __switch_to+0x71c/0xb00 [  166.333299]  ?
> > > > > compat_start_thread+0x6b/0x6b [  166.333302]  ?
> > > > > __switch_to_asm+0x34/0x70 [  166.333305]  ?
> > > > > __switch_to_asm+0x40/0x70 [  166.333309]  ? mmdrop+0x12/0x23 [
> > > > > 166.333313]  ? finish_task_switch+0x34d/0x3de [  166.333319]  ?
> > > > > __schedule+0x1004/0x1045 [  166.333325]  ?
> > > > > firmware_map_remove+0x119/0x119 [  166.333330]
> > > > > ksys_ioctl+0x50/0x70 [  166.333335]  __x64_sys_ioctl+0x82/0x89 [
> > > > > 166.333340]  do_syscall_64+0xa0/0xd2 [  166.333345]
> > > > > entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > > > [  166.333349] RIP: 0033:0x7f2481541f47 [  166.333354] Code: 00 00
> > > > > 00 48 8b 05 51 6f 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff
> > > > > c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01
> > > > > f0 ff ff 73 01 c3 48 8b 0d 21 6f 2c 00 f7 d8 64 89 01 48 [
> > > > > 166.333357] RSP: 002b:00007fffd6aff9b8 EFLAGS: 00000246 ORIG_RAX:
> > > > > 0000000000000010 [  166.333362] RAX: ffffffffffffffda RBX:
> > > > > 0000000000000000 RCX: 00007f2481541f47 [  166.333364] RDX:
> > > > > 00007fffd6aff9c4 RSI: 0000000040045613 RDI: 0000000000000003 [
> > > > > 166.333367] RBP: 0000555f1c494af8 R08: 00007f247f34c000 R09:
> > > > > 00007f2481c24700 [  166.333369] R10: 0000000000000020 R11:
> > > > > 0000000000000246 R12: 0000555f1c494b06 [  166.333372] R13:
> > > > > 0000000000000004 R14: 00007fffd6affb90 R15: 00007fffd6b00825
> > > > >
> > > > > [  166.333383] Allocated by task 1305:
> > > > > [  166.333389]  kasan_kmalloc+0x8a/0x98 [  166.333392]
> > > > > slab_post_alloc_hook+0x31/0x51 [  166.333396]
> > > > > kmem_cache_alloc+0xd7/0x174 [  166.333399]  alloc_iova+0x24/0x2ea
> > > > > [  166.333407]  ipu3_dmamap_alloc+0x193/0x83f [ipu3_imgu] [
> > > > > 166.333415]  ipu3_css_pool_init+0x80/0xdf [ipu3_imgu] [
> > > > > 166.333424]  ipu3_css_start_streaming+0x58df/0x5ddc [ipu3_imgu] [
> > > > > 166.333433]  imgu_s_stream+0x2dd/0x6c0 [ipu3_imgu] [  166.333442]
> > > > > ipu3_vb2_start_streaming+0x35f/0x3de [ipu3_imgu] [  166.333449]
> > > > > vb2_start_streaming+0x164/0x33b [videobuf2_common] [  166.333455]
> > > > > vb2_core_streamon+0x1a1/0x208 [videobuf2_common] [  166.333471]
> > > > > __video_do_ioctl+0x625/0x887 [videodev] [  166.333487]
> > > > > video_usercopy+0x3a3/0x8ae [videodev] [  166.333501]
> > > > > v4l2_ioctl+0xb7/0xc5 [videodev] [  166.333505]
> > > > > vfs_ioctl+0x76/0x89 [  166.333508]  do_vfs_ioctl+0xb33/0xb7e [
> > > > > 166.333511]  ksys_ioctl+0x50/0x70 [  166.333514]
> > > > > __x64_sys_ioctl+0x82/0x89 [  166.333518]  do_syscall_64+0xa0/0xd2
> > > > > [  166.333521]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > > >
> > > > > [  166.333526] Freed by task 1301:
> > > > > [  166.333532]  __kasan_slab_free+0xfa/0x11c [  166.333535]
> > > > > slab_free_freelist_hook+0x46/0x94 [  166.333538]
> > > > > kmem_cache_free+0x7b/0x172 [  166.333542]  __free_iova+0x23/0x31 [
> > > > > 166.333550]  ipu3_dmamap_free+0x118/0x1d6 [ipu3_imgu] [
> > > > > 166.333557]  ipu3_css_pool_cleanup+0x25/0x2f [ipu3_imgu] [
> > > > > 166.333566]  ipu3_css_pipeline_cleanup+0x79/0xcf [ipu3_imgu] [
> > > > > 166.333574]  ipu3_css_stop_streaming+0x2fe/0x4dc [ipu3_imgu] [
> > > > > 166.333584]  imgu_s_stream+0xc0/0x6c0 [ipu3_imgu] [  166.333593]
> > > > > ipu3_vb2_stop_streaming+0x27c/0x2d2 [ipu3_imgu] [  166.333599]
> > > > > __vb2_queue_cancel+0xa8/0x705 [videobuf2_common] [  166.333606]
> > > > > vb2_core_streamoff+0x68/0xf8 [videobuf2_common] [  166.333621]
> > > > > __video_do_ioctl+0x625/0x887 [videodev] [  166.333637]
> > > > > video_usercopy+0x3a3/0x8ae [videodev] [  166.333652]
> > > > > v4l2_ioctl+0xb7/0xc5 [videodev] [  166.333655]
> > > > > vfs_ioctl+0x76/0x89 [  166.333658]  do_vfs_ioctl+0xb33/0xb7e [
> > > > > 166.333662]  ksys_ioctl+0x50/0x70 [  166.333665]
> > > > > __x64_sys_ioctl+0x82/0x89 [  166.333668]  do_syscall_64+0xa0/0xd2
> > > > > [  166.333671]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > > >
> > > > > [  166.333678] The buggy address belongs to the object at
> > ffff888133823700
> > > > >                 which belongs to the cache iommu_iova of size 40 [
> > > > > 166.333685] The buggy address is located 24 bytes inside of
> > > > >                 40-byte region [ffff888133823700,
> > > > > ffff888133823728) [  166.333690] The buggy address belongs to the page:
> > > > > [  166.333696] page:ffffea0004ce0880 count:1 mapcount:0
> > > > > mapping:ffff8881519e8640 index:0x0 compound_mapcount: 0 [
> > > > > 166.333703] flags: 0x200000000010200(slab|head) [  166.333710]
> > > > > raw: 0200000000010200 ffffea0004dfc488 ffff88814bfbde70
> > > > > ffff8881519e8640 [  166.333717] raw: 0000000000000000
> > > > > 0000000000120012 00000001ffffffff 0000000000000000 [  166.333720]
> > > > > page dumped because: kasan: bad access detected
> > > > >
> > > > > [  166.333726] Memory state around the buggy address:
> > > > > [  166.333732]  ffff888133823600: fc fc fc fc fc fc fc fc fc fc fc
> > > > > fc fc fc fc fc [  166.333737]  ffff888133823680: fc fc fc fc fc fc
> > > > > fc fc fc fc fc fc fc fc fc fc [  166.333742] >ffff888133823700: fb fb fb fb fb fc fc
> > fc fc fc fc fc fc fc fc fc
> > > > > [  166.333745]                             ^
> > > > > [  166.333750]  ffff888133823780: fc fc fc fc fc fc fc fc fc fc fc
> > > > > fc fc fc fc fc [  166.333755]  ffff888133823800: fc fc fc fc fc fc
> > > > > fc fc fc fc fc fc fc fc fc fc [  166.333759]
> > > > >
> > ================================================================
> > ==
> > > > > [  166.333762] Disabling lock debugging due to kernel taint [
> > > > > 166.333764]
> > > > >
> > ================================================================
> > ==
> > > > > [  166.333770] BUG: KASAN: double-free or invalid-free in
> > > > > kmem_cache_free+0x7b/0x172
> > > > >
> > > > > [  166.333780] CPU: 3 PID: 1305 Comm: yavta Tainted: G    B    C        4.20.0-
> > rc6+ #3
> > > > > [  166.333782] Hardware name: HP Soraka/Soraka, BIOS  08/30/2018 [
> > > > > 166.333783] Call Trace:
> > > > > [  166.333789]  dump_stack+0x5b/0x81 [  166.333795]
> > > > > print_address_description+0x65/0x227
> > > > > [  166.333799]  ? kmem_cache_free+0x7b/0x172 [  166.333803]
> > > > > kasan_report_invalid_free+0x67/0xa0
> > > > > [  166.333807]  ? kmem_cache_free+0x7b/0x172 [  166.333812]
> > > > > __kasan_slab_free+0x86/0x11c [  166.333817]
> > > > > slab_free_freelist_hook+0x46/0x94 [  166.333822]
> > > > > kmem_cache_free+0x7b/0x172 [  166.333826]  ? __free_iova+0x23/0x31
> > > > > [  166.333831]  __free_iova+0x23/0x31 [  166.333840]
> > > > > ipu3_dmamap_free+0x118/0x1d6 [ipu3_imgu] [  166.333851]
> > > > > ipu3_css_pool_cleanup+0x25/0x2f [ipu3_imgu] [  166.333861]
> > > > > ipu3_css_pipeline_cleanup+0x79/0xcf [ipu3_imgu] [  166.333872]
> > > > > ipu3_css_stop_streaming+0x2fe/0x4dc [ipu3_imgu] [  166.333885]
> > > > > imgu_s_stream+0xc0/0x6c0 [ipu3_imgu] [  166.333896]  ?
> > > > > ipu3_all_nodes_streaming+0x1ee/0x20d [ipu3_imgu] [  166.333908]
> > > > > ipu3_vb2_stop_streaming+0x27c/0x2d2 [ipu3_imgu] [  166.333917]
> > > > > __vb2_queue_cancel+0xa8/0x705 [videobuf2_common] [  166.333923]  ?
> > > > > __mutex_lock_interruptible_slowpath+0xf/0xf
> > > > > [  166.333932]  vb2_core_streamoff+0x68/0xf8 [videobuf2_common] [
> > > > > 166.333950]  __video_do_ioctl+0x625/0x887 [videodev] [
> > > > > 166.333970]  ? copy_overflow+0x14/0x14 [videodev] [  166.333974]
> > > > > ? slab_free_freelist_hook+0x46/0x94 [  166.333979]  ?
> > > > > kfree+0x107/0x1a0 [  166.333997]  video_usercopy+0x3a3/0x8ae
> > > > > [videodev] [  166.334015]  ? copy_overflow+0x14/0x14 [videodev] [
> > > > > 166.334031]  ? v4l_enumstd+0x49/0x49 [videodev] [  166.334035]  ?
> > > > > __wake_up_common+0x342/0x342 [  166.334042]  ?
> > > > > atomic_long_add_return+0x15/0x24 [  166.334046]  ?
> > > > > ldsem_up_read+0x15/0x29 [  166.334050]  ? tty_write+0x4c6/0x4d8 [
> > > > > 166.334054]  ? n_tty_receive_char_special+0x1152/0x1152
> > > > > [  166.334071]  ? video_usercopy+0x8ae/0x8ae [videodev] [
> > > > > 166.334087]  v4l2_ioctl+0xb7/0xc5 [videodev] [  166.334092]
> > > > > vfs_ioctl+0x76/0x89 [  166.334097]  do_vfs_ioctl+0xb33/0xb7e [
> > > > > 166.334101]  ? __switch_to_asm+0x40/0x70 [  166.334105]  ?
> > > > > __switch_to_asm+0x40/0x70 [  166.334108]  ?
> > > > > __switch_to_asm+0x34/0x70 [  166.334111]  ?
> > > > > __switch_to_asm+0x40/0x70 [  166.334116]  ?
> > > > > ioctl_preallocate+0x174/0x174 [  166.334120]  ?
> > > > > __switch_to+0x71c/0xb00 [  166.334124]  ?
> > > > > compat_start_thread+0x6b/0x6b [  166.334127]  ?
> > > > > __switch_to_asm+0x34/0x70 [  166.334130]  ?
> > > > > __switch_to_asm+0x40/0x70 [  166.334134]  ? mmdrop+0x12/0x23 [
> > > > > 166.334137]  ? finish_task_switch+0x34d/0x3de [  166.334143]  ?
> > > > > __schedule+0x1004/0x1045 [  166.334148]  ?
> > > > > firmware_map_remove+0x119/0x119 [  166.334153]
> > > > > ksys_ioctl+0x50/0x70 [  166.334158]  __x64_sys_ioctl+0x82/0x89 [
> > > > > 166.334163]  do_syscall_64+0xa0/0xd2 [  166.334167]
> > > > > entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > > > [  166.334171] RIP: 0033:0x7f2481541f47 [  166.334175] Code: 00 00
> > > > > 00 48 8b 05 51 6f 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff
> > > > > c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01
> > > > > f0 ff ff 73 01 c3 48 8b 0d 21 6f 2c 00 f7 d8 64 89 01 48 [
> > > > > 166.334177] RSP: 002b:00007fffd6aff9b8 EFLAGS: 00000246 ORIG_RAX:
> > > > > 0000000000000010 [  166.334181] RAX: ffffffffffffffda RBX:
> > > > > 0000000000000000 RCX: 00007f2481541f47 [  166.334184] RDX:
> > > > > 00007fffd6aff9c4 RSI: 0000000040045613 RDI: 0000000000000003 [
> > > > > 166.334186] RBP: 0000555f1c494af8 R08: 00007f247f34c000 R09:
> > > > > 00007f2481c24700 [  166.334189] R10: 0000000000000020 R11:
> > > > > 0000000000000246 R12: 0000555f1c494b06 [  166.334191] R13:
> > > > > 0000000000000004 R14: 00007fffd6affb90 R15: 00007fffd6b00825
> > > > >
>
> [snip]

--eysapepcergda33h
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="linux-v4.20-rc5-ipu3.config"

# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_PREEMPT=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_CGROUPS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
CONFIG_NAMESPACES=y
CONFIG_USER_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL_SYSCALL=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_KALLSYMS_ALL=y
CONFIG_BPF_SYSCALL=y
CONFIG_EMBEDDED=y
# CONFIG_COMPAT_BRK is not set
CONFIG_PROFILING=y
CONFIG_SMP=y
CONFIG_X86_X2APIC=y
CONFIG_X86_NUMACHIP=y
CONFIG_X86_INTEL_LPSS=y
CONFIG_IOSF_MBI_DEBUG=y
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_KVM_DEBUG_FS=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_NR_CPUS=256
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_I8K=m
CONFIG_MICROCODE_AMD=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_NUMA=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_X86_PMEM_LEGACY=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
CONFIG_HZ_1000=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_KEXEC_VERIFY_SIG=y
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_LIVEPATCH=y
CONFIG_HIBERNATION=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TRACE_RTC=y
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_TPS68470_PMIC_OPREGION=y
CONFIG_SFI=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_INTEL_IDLE=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCI_MSI=y
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_IA32_EMULATION=y
CONFIG_X86_X32=y
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_DMI_SYSFS=m
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_EFI_VARS=y
CONFIG_EFI_VARS_PSTORE=m
# CONFIG_VIRTUALIZATION is not set
CONFIG_OPROFILE=m
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_BLK_DEV_THROTTLING=y
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_AIX_PARTITION=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_CMDLINE_PARTITION=y
CONFIG_IOSCHED_CFQ=m
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_IOSCHED_BFQ=y
CONFIG_BFQ_GROUP_IOSCHED=y
CONFIG_BINFMT_MISC=m
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_ZSWAP=y
CONFIG_ZBUD=y
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_NET_KEY=m
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_IPV6_SIT is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_TABLES=m
CONFIG_NFT_COUNTER=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_QUEUE=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
CONFIG_NF_SOCKET_IPV4=m
CONFIG_NF_TPROXY_IPV4=m
CONFIG_NF_DUP_IPV4=m
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_FILTER=y
CONFIG_NF_SOCKET_IPV6=m
CONFIG_NF_TPROXY_IPV6=m
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_DNS_RESOLVER=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_BPF_JIT=y
CONFIG_CFG80211=m
CONFIG_CFG80211_DEBUGFS=y
CONFIG_CFG80211_WEXT=y
CONFIG_MAC80211=m
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_MESSAGE_TRACING=y
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_GPIO=m
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
CONFIG_DEBUG_DEVRES=y
CONFIG_CONNECTOR=y
CONFIG_OF=y
# CONFIG_PNP_DEBUG_MESSAGES is not set
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_FD=m
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=m
CONFIG_ZRAM=m
CONFIG_BLK_DEV_UMEM=m
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_DRBD=m
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_SKD=m
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_SIZE=65536
CONFIG_BLK_DEV_NVME=m
CONFIG_SRAM=y
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
# CONFIG_SCSI_MQ_DEFAULT is not set
CONFIG_BLK_DEV_SD=y
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_ATA=m
CONFIG_SATA_AHCI=m
CONFIG_SATA_AHCI_PLATFORM=m
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=m
CONFIG_NETDEVICES=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
CONFIG_EQUALIZER=m
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
CONFIG_IPVLAN=m
CONFIG_VXLAN=m
CONFIG_GENEVE=m
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_TUN=y
CONFIG_VETH=m
CONFIG_NLMON=m
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_AGERE is not set
# CONFIG_NET_VENDOR_ALACRITECH is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_NET_VENDOR_AMAZON is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_AQUANTIA is not set
# CONFIG_NET_VENDOR_ARC is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_VENDOR_AURORA is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_VENDOR_CADENCE is not set
# CONFIG_NET_VENDOR_CAVIUM is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_NET_VENDOR_CORTINA is not set
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EZCHIP is not set
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_NET_VENDOR_HUAWEI is not set
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_E1000=m
CONFIG_IGBVF=m
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
# CONFIG_NET_VENDOR_MICROSEMI is not set
# CONFIG_NET_VENDOR_MYRI is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NETERION is not set
# CONFIG_NET_VENDOR_NETRONOME is not set
# CONFIG_NET_VENDOR_NI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_NET_VENDOR_PACKET_ENGINES is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_QUALCOMM is not set
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_NET_VENDOR_RENESAS is not set
# CONFIG_NET_VENDOR_ROCKER is not set
# CONFIG_NET_VENDOR_SAMSUNG is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SOLARFLARE is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_SOCIONEXT is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_SYNOPSYS is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_PHYLIB=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOE=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_USB_NET_DRIVERS=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_RNDIS_HOST=m
# CONFIG_USB_ARMLINUX is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_WLAN_VENDOR_ADMTEK is not set
# CONFIG_WLAN_VENDOR_ATH is not set
# CONFIG_WLAN_VENDOR_ATMEL is not set
# CONFIG_WLAN_VENDOR_BROADCOM is not set
# CONFIG_WLAN_VENDOR_CISCO is not set
CONFIG_IWL4965=m
CONFIG_IWL3945=m
CONFIG_IWLWIFI=m
CONFIG_IWLDVM=m
CONFIG_IWLMVM=m
CONFIG_IWLWIFI_DEBUGFS=y
# CONFIG_WLAN_VENDOR_MARVELL is not set
# CONFIG_WLAN_VENDOR_MEDIATEK is not set
# CONFIG_WLAN_VENDOR_RALINK is not set
# CONFIG_WLAN_VENDOR_REALTEK is not set
# CONFIG_WLAN_VENDOR_RSI is not set
# CONFIG_WLAN_VENDOR_ST is not set
# CONFIG_WLAN_VENDOR_TI is not set
# CONFIG_WLAN_VENDOR_ZYDAS is not set
# CONFIG_WLAN_VENDOR_QUANTENNA is not set
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=m
CONFIG_KEYBOARD_CROS_EC=m
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_ELAN=y
CONFIG_TOUCHSCREEN_MELFAS_MIP4=y
CONFIG_TOUCHSCREEN_WDT87XX_I2C=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_RM_TS=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_UINPUT=m
CONFIG_LEGACY_PTY_COUNT=0
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_NR_UARTS=48
CONFIG_SERIAL_8250_RUNTIME_UARTS=32
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DW=m
# CONFIG_SERIAL_8250_MID is not set
CONFIG_SERIAL_KGDB_NMI=y
CONFIG_TTY_PRINTK=y
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_NVRAM=y
CONFIG_R3964=m
CONFIG_APPLICOM=m
CONFIG_HPET=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TELCLOCK=m
CONFIG_I2C=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_SCMI=m
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
CONFIG_I2C_CROS_EC_TUNNEL=m
CONFIG_I2C_SLAVE=y
CONFIG_I2C_SLAVE_EEPROM=m
CONFIG_SPI=y
CONFIG_PINCTRL_BAYTRAIL=y
CONFIG_PINCTRL_CHERRYVIEW=y
CONFIG_PINCTRL_BROXTON=y
CONFIG_PINCTRL_SUNRISEPOINT=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_ICH=m
CONFIG_GPIO_LYNXPOINT=m
CONFIG_GPIO_SCH=m
CONFIG_GPIO_TPS68470=y
CONFIG_POWER_RESET=y
CONFIG_PDA_POWER=m
CONFIG_GENERIC_ADC_BATTERY=m
CONFIG_BATTERY_SBS=m
CONFIG_CHARGER_GPIO=m
CONFIG_CHARGER_MANAGER=y
CONFIG_SENSORS_I5500=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=m
CONFIG_INTEL_SOC_DTS_THERMAL=m
CONFIG_INT340X_THERMAL=m
CONFIG_MFD_CROS_EC=m
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
CONFIG_MFD_TPS68470=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
CONFIG_MEDIA_SUPPORT=m
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_MEDIA_USB_SUPPORT=y
CONFIG_USB_VIDEO_CLASS=m
# CONFIG_USB_GSPCA is not set
CONFIG_MEDIA_PCI_SUPPORT=y
CONFIG_VIDEO_IPU3_CIO2=m
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_VIDEO_DW9714=m
CONFIG_VIDEO_OV5670=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_OV13858=m
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_I915=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_TILEBLITTING=y
CONFIG_FB_INTEL=m
CONFIG_FB_SIMPLE=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_HID=m
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_MULTITOUCH=m
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m
CONFIG_I2C_HID=m
CONFIG_USB=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_STORAGE=m
CONFIG_USB_UAS=m
CONFIG_NOP_USB_XCEIV=y
CONFIG_USB_GPIO_VBUS=m
CONFIG_MMC=y
CONFIG_MMC_BLOCK=m
CONFIG_SDIO_UART=m
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
# CONFIG_MMC_RICOH_MMC is not set
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_LEDS_CLASS=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_DRV_HID_SENSOR_TIME=m
CONFIG_DMADEVICES=y
CONFIG_INTEL_IOATDMA=m
CONFIG_DW_DMAC=y
CONFIG_ASYNC_TX_DMA=y
CONFIG_AUXDISPLAY=y
# CONFIG_VIRTIO_MENU is not set
CONFIG_STAGING=y
CONFIG_STAGING_MEDIA=y
CONFIG_VIDEO_IPU3_IMGU=m
CONFIG_DCDBAS=m
CONFIG_DELL_RBU=m
CONFIG_CHROMEOS_LAPTOP=m
CONFIG_CHROMEOS_PSTORE=m
CONFIG_CROS_EC_LPC=m
CONFIG_CROS_KBD_LED_BACKLIGHT=m
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_IRQ_REMAP=y
CONFIG_MEMORY=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_RESET_CONTROLLER=y
CONFIG_GENERIC_PHY=y
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=m
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_ENCRYPTION=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=y
CONFIG_CUSE=m
CONFIG_OVERLAY_FS=m
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
CONFIG_CACHEFILES=m
CONFIG_VFAT_FS=y
CONFIG_PROC_KCORE=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_EFIVAR_FS=y
CONFIG_PSTORE_RAM=m
CONFIG_NFS_FS=m
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
CONFIG_NFS_SWAP=y
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_NFS_V4_1_MIGRATION=y
CONFIG_NFS_FSCACHE=y
CONFIG_SUNRPC_DEBUG=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_UTF8=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_INTEL_TXT=y
CONFIG_SECURITY_APPARMOR=y
# CONFIG_INTEGRITY is not set
CONFIG_CRYPTO_ECDH=m
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_CCP=y
# CONFIG_CRYPTO_DEV_CCP_DD is not set
CONFIG_LIBCRC32C=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_DDR=y
CONFIG_PRINTK_TIME=y
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_SCHEDSTATS=y
CONFIG_SCHED_STACK_END_CHECK=y
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_MMIOTRACE=y
CONFIG_MEMTEST=y
CONFIG_KGDB=y
CONFIG_KGDB_LOW_LEVEL_TRAP=y
CONFIG_KGDB_KDB=y
CONFIG_KDB_KEYBOARD=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_EFI=y
CONFIG_IO_DELAY_0XED=y
CONFIG_OPTIMIZE_INLINING=y

--eysapepcergda33h
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="linux-v4.20-rc5-ipu3-kasan-kernel-log.config"

# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_PREEMPT=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=17
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=17
CONFIG_CGROUPS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
CONFIG_NAMESPACES=y
CONFIG_USER_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL_SYSCALL=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_KALLSYMS_ALL=y
CONFIG_BPF_SYSCALL=y
CONFIG_EMBEDDED=y
# CONFIG_COMPAT_BRK is not set
CONFIG_PROFILING=y
CONFIG_SMP=y
CONFIG_X86_X2APIC=y
CONFIG_X86_NUMACHIP=y
CONFIG_X86_INTEL_LPSS=y
CONFIG_IOSF_MBI_DEBUG=y
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_KVM_DEBUG_FS=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_NR_CPUS=256
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_I8K=m
CONFIG_MICROCODE_AMD=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_NUMA=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_X86_PMEM_LEGACY=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
CONFIG_HZ_1000=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_KEXEC_VERIFY_SIG=y
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_LIVEPATCH=y
CONFIG_HIBERNATION=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TRACE_RTC=y
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_TPS68470_PMIC_OPREGION=y
CONFIG_SFI=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_INTEL_IDLE=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCI_MSI=y
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_IA32_EMULATION=y
CONFIG_X86_X32=y
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_DMI_SYSFS=m
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_EFI_VARS=y
CONFIG_EFI_VARS_PSTORE=m
# CONFIG_VIRTUALIZATION is not set
CONFIG_OPROFILE=m
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_BLK_DEV_THROTTLING=y
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_AIX_PARTITION=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_CMDLINE_PARTITION=y
CONFIG_IOSCHED_CFQ=m
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_IOSCHED_BFQ=y
CONFIG_BFQ_GROUP_IOSCHED=y
CONFIG_BINFMT_MISC=m
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_ZSWAP=y
CONFIG_ZBUD=y
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_NET_KEY=m
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_IPV6_SIT is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_TABLES=m
CONFIG_NFT_COUNTER=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_QUEUE=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
CONFIG_NF_SOCKET_IPV4=m
CONFIG_NF_TPROXY_IPV4=m
CONFIG_NF_DUP_IPV4=m
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_FILTER=y
CONFIG_NF_SOCKET_IPV6=m
CONFIG_NF_TPROXY_IPV6=m
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_DNS_RESOLVER=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_BPF_JIT=y
CONFIG_CFG80211=m
CONFIG_CFG80211_DEBUGFS=y
CONFIG_CFG80211_WEXT=y
CONFIG_MAC80211=m
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_MESSAGE_TRACING=y
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_GPIO=m
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
CONFIG_DEBUG_DEVRES=y
CONFIG_CONNECTOR=y
CONFIG_OF=y
# CONFIG_PNP_DEBUG_MESSAGES is not set
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_FD=m
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=m
CONFIG_ZRAM=m
CONFIG_BLK_DEV_UMEM=m
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_DRBD=m
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_SKD=m
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_SIZE=65536
CONFIG_BLK_DEV_NVME=m
CONFIG_SRAM=y
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
# CONFIG_SCSI_MQ_DEFAULT is not set
CONFIG_BLK_DEV_SD=y
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_ATA=m
CONFIG_SATA_AHCI=m
CONFIG_SATA_AHCI_PLATFORM=m
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=m
CONFIG_NETDEVICES=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
CONFIG_EQUALIZER=m
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
CONFIG_IPVLAN=m
CONFIG_VXLAN=m
CONFIG_GENEVE=m
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_TUN=y
CONFIG_VETH=m
CONFIG_NLMON=m
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_AGERE is not set
# CONFIG_NET_VENDOR_ALACRITECH is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_NET_VENDOR_AMAZON is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_AQUANTIA is not set
# CONFIG_NET_VENDOR_ARC is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_VENDOR_AURORA is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_VENDOR_CADENCE is not set
# CONFIG_NET_VENDOR_CAVIUM is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_NET_VENDOR_CORTINA is not set
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EZCHIP is not set
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_NET_VENDOR_HUAWEI is not set
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_E1000=m
CONFIG_IGBVF=m
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
# CONFIG_NET_VENDOR_MICROSEMI is not set
# CONFIG_NET_VENDOR_MYRI is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NETERION is not set
# CONFIG_NET_VENDOR_NETRONOME is not set
# CONFIG_NET_VENDOR_NI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_NET_VENDOR_PACKET_ENGINES is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_QUALCOMM is not set
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_NET_VENDOR_RENESAS is not set
# CONFIG_NET_VENDOR_ROCKER is not set
# CONFIG_NET_VENDOR_SAMSUNG is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SOLARFLARE is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_SOCIONEXT is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_SYNOPSYS is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_PHYLIB=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOE=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_USB_NET_DRIVERS=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_RNDIS_HOST=m
# CONFIG_USB_ARMLINUX is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_WLAN_VENDOR_ADMTEK is not set
# CONFIG_WLAN_VENDOR_ATH is not set
# CONFIG_WLAN_VENDOR_ATMEL is not set
# CONFIG_WLAN_VENDOR_BROADCOM is not set
# CONFIG_WLAN_VENDOR_CISCO is not set
CONFIG_IWL4965=m
CONFIG_IWL3945=m
CONFIG_IWLWIFI=m
CONFIG_IWLDVM=m
CONFIG_IWLMVM=m
CONFIG_IWLWIFI_DEBUGFS=y
# CONFIG_WLAN_VENDOR_MARVELL is not set
# CONFIG_WLAN_VENDOR_MEDIATEK is not set
# CONFIG_WLAN_VENDOR_RALINK is not set
# CONFIG_WLAN_VENDOR_REALTEK is not set
# CONFIG_WLAN_VENDOR_RSI is not set
# CONFIG_WLAN_VENDOR_ST is not set
# CONFIG_WLAN_VENDOR_TI is not set
# CONFIG_WLAN_VENDOR_ZYDAS is not set
# CONFIG_WLAN_VENDOR_QUANTENNA is not set
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=m
CONFIG_KEYBOARD_CROS_EC=m
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_ELAN=y
CONFIG_TOUCHSCREEN_MELFAS_MIP4=y
CONFIG_TOUCHSCREEN_WDT87XX_I2C=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_RM_TS=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_UINPUT=m
CONFIG_LEGACY_PTY_COUNT=0
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_NR_UARTS=48
CONFIG_SERIAL_8250_RUNTIME_UARTS=32
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DW=m
# CONFIG_SERIAL_8250_MID is not set
CONFIG_SERIAL_KGDB_NMI=y
CONFIG_TTY_PRINTK=y
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_NVRAM=y
CONFIG_R3964=m
CONFIG_APPLICOM=m
CONFIG_HPET=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TELCLOCK=m
CONFIG_I2C=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_SCMI=m
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
CONFIG_I2C_CROS_EC_TUNNEL=m
CONFIG_I2C_SLAVE=y
CONFIG_I2C_SLAVE_EEPROM=m
CONFIG_SPI=y
CONFIG_PINCTRL_BAYTRAIL=y
CONFIG_PINCTRL_CHERRYVIEW=y
CONFIG_PINCTRL_BROXTON=y
CONFIG_PINCTRL_SUNRISEPOINT=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_ICH=m
CONFIG_GPIO_LYNXPOINT=m
CONFIG_GPIO_SCH=m
CONFIG_GPIO_TPS68470=y
CONFIG_POWER_RESET=y
CONFIG_PDA_POWER=m
CONFIG_GENERIC_ADC_BATTERY=m
CONFIG_BATTERY_SBS=m
CONFIG_CHARGER_GPIO=m
CONFIG_CHARGER_MANAGER=y
CONFIG_SENSORS_I5500=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=m
CONFIG_INTEL_SOC_DTS_THERMAL=m
CONFIG_INT340X_THERMAL=m
CONFIG_MFD_CROS_EC=m
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
CONFIG_MFD_TPS68470=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
CONFIG_MEDIA_SUPPORT=m
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_MEDIA_USB_SUPPORT=y
CONFIG_USB_VIDEO_CLASS=m
# CONFIG_USB_GSPCA is not set
CONFIG_MEDIA_PCI_SUPPORT=y
CONFIG_VIDEO_IPU3_CIO2=m
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_VIDEO_DW9714=m
CONFIG_VIDEO_OV5670=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_OV13858=m
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_I915=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_TILEBLITTING=y
CONFIG_FB_INTEL=m
CONFIG_FB_SIMPLE=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_HID=m
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_MULTITOUCH=m
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m
CONFIG_I2C_HID=m
CONFIG_USB=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_STORAGE=m
CONFIG_USB_UAS=m
CONFIG_NOP_USB_XCEIV=y
CONFIG_USB_GPIO_VBUS=m
CONFIG_MMC=y
CONFIG_MMC_BLOCK=m
CONFIG_SDIO_UART=m
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
# CONFIG_MMC_RICOH_MMC is not set
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_LEDS_CLASS=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_DRV_HID_SENSOR_TIME=m
CONFIG_DMADEVICES=y
CONFIG_INTEL_IOATDMA=m
CONFIG_DW_DMAC=y
CONFIG_ASYNC_TX_DMA=y
CONFIG_AUXDISPLAY=y
# CONFIG_VIRTIO_MENU is not set
CONFIG_STAGING=y
CONFIG_STAGING_MEDIA=y
CONFIG_VIDEO_IPU3_IMGU=m
CONFIG_DCDBAS=m
CONFIG_DELL_RBU=m
CONFIG_CHROMEOS_LAPTOP=m
CONFIG_CHROMEOS_PSTORE=m
CONFIG_CROS_EC_LPC=m
CONFIG_CROS_KBD_LED_BACKLIGHT=m
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_IRQ_REMAP=y
CONFIG_MEMORY=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_RESET_CONTROLLER=y
CONFIG_GENERIC_PHY=y
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=m
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_ENCRYPTION=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=y
CONFIG_CUSE=m
CONFIG_OVERLAY_FS=m
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
CONFIG_CACHEFILES=m
CONFIG_VFAT_FS=y
CONFIG_PROC_KCORE=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_EFIVAR_FS=y
CONFIG_PSTORE_RAM=m
CONFIG_NFS_FS=m
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
CONFIG_NFS_SWAP=y
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_NFS_V4_1_MIGRATION=y
CONFIG_NFS_FSCACHE=y
CONFIG_SUNRPC_DEBUG=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_UTF8=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_INTEL_TXT=y
CONFIG_SECURITY_APPARMOR=y
# CONFIG_INTEGRITY is not set
CONFIG_CRYPTO_ECDH=m
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_CCP=y
# CONFIG_CRYPTO_DEV_CCP_DD is not set
CONFIG_LIBCRC32C=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_DDR=y
CONFIG_PRINTK_TIME=y
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
CONFIG_KASAN=y
CONFIG_KASAN_EXTRA=y
CONFIG_KASAN_INLINE=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_SCHEDSTATS=y
CONFIG_SCHED_STACK_END_CHECK=y
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_MMIOTRACE=y
CONFIG_MEMTEST=y
CONFIG_KGDB=y
CONFIG_KGDB_LOW_LEVEL_TRAP=y
CONFIG_KGDB_KDB=y
CONFIG_KDB_KEYBOARD=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_EFI=y
CONFIG_IO_DELAY_0XED=y
CONFIG_OPTIMIZE_INLINING=y

--eysapepcergda33h--

--24f5qynqznqmgshh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlw2LqEACgkQcjQGjxah
Vjw9Hg/9GfwS5p+Lun/KQHHhWnvq7vtN5PaHIU9s/AspEHnt8bawbXe+Wqi6HAKW
UwDMyG6xbvoIh+6bzWJ6cKwfKUedOPJoy6T7RvGdvxMA17GtsUS3V2KhssAzAHnu
9rtFt4rGKPD5ELJMCpO5/CtyLEeoT+TyCxG/yuoYIdLIQ6SIi9UjgW6i5u9BTVxY
BZ1I2jBNZcjzqw1ehsg1Lu+PDwpCTIQ/5tXMUzTZ4ajzGScYL7TWR58D2GAwu+my
xXSRMadJgoRN/Q9cxQctmjlJtuUr0F3F7aX2VRPnD+LL2c8mETe/zYlwpScIRFLx
jOb196SJ7X/DYwmRLOVpANGqv+n+IdSIRiFjBha981/oDaVD80OQb2PbbA+VHaD2
JiWSQRbsw1QZZLUt2MH9cnhNRzQXWl0nc2D9CVwiOTYqbU5eswzCbHMQSozlM57T
RCdyHLBMGjmQM963443okMEw6dfY+V0d/frveXlFoRCPvk7yNpdeAFVaoapJFXke
YxxTHGc3v69C3oq0Of2vdrbhAFtzSRv8ihlKe2DVBiteyZBIxl2E1y2/M2a7lK/V
gmDLcKhXLdbVWYd8uDutpOTNSB2JKqgeQrRe8rxfHaMusJ6R7wMV+1ryMTIAEUkv
7vtlVoHx43MVHWfvGSJL1qqOW30ys6UheGduCP3drIeDfWeLQT8=
=e1Ar
-----END PGP SIGNATURE-----

--24f5qynqznqmgshh--
