Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37649 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751165AbdGMM0A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 08:26:00 -0400
Subject: Re: [PATCH v2 00/14] Renesas R-Car VSP: Add H3 ES2.0 support
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
Message-ID: <83249582-3ad4-91f1-7afa-e951af15cfc9@ideasonboard.com>
Date: Thu, 13 Jul 2017 13:25:55 +0100
MIME-Version: 1.0
In-Reply-To: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thankyou for these patches, bringing life to the outputs of my ES2.0 target board.

I have tested them on my board, and including the VSP unit test suite, and
kmscube utilities.

Feel free to add a Tested-by: Kieran Bingham
<kieran.bingham+renesas@ideasonboard.com> to all of the patches if you desire,
and I'm working through the individual reviews.

Oh - except now I've just said that - I did some extra testing with both HDMI
and VGA output connected and ran
   kmstest --flip --sync

This was soon followed by a kernel error trace [0] shown below.

However replicating this is possibly more complicated than just running kmstest
--flip --sync ... I've had to do various iterations of running with/without
{flip, sync} but I have reproduced 'issues' about 3 times now.

I think the key thing is in the VGA connection or regarding trying to output to
both.

Interestingly, I haven't been able to make this happen on the ES1.0 platform as
yet... though --flip --sync is quicker to fail with 'Flip Commit failed: -16"
there...

For reference this was tested on your pinchartl-media/drm/next/h3-es2/merged,
branch which I don't believe has the recent work on not needing to wait for a
final vblank on shutdown. So it is quite possible that the issue I am seeing is
simply a symptom of that separately repaired issue.

On that basis I've left my comment regarding my Tested-by: tag above as I
suspect that this issue I've hit could likely be separate and already resolved.

I'll try to add those patches to this tree to see if the issue resolves itself...

Regardless of that, this series conflicts with my current developments,
therefore I will likely rebase my work on top of this series. I don't need an
immutable branch, but please do let me know if this series changes :-)

--
Regards

Kieran.






[0] : Kernel log snippet posted below:

[  597.471369] [drm:drm_atomic_helper_commit_cleanup_done] *ERROR*
[CRTC:57:crtc-3] flip_done timed out
[  607.711346] [drm:drm_atomic_helper_wait_for_dependencies] *ERROR*
[CRTC:57:crtc-3] flip_done timed out
[  607.711354] [drm:drm_atomic_helper_commit_cleanup_done] *ERROR*
[CRTC:57:crtc-3] flip_done timed out
[  607.749585] vsp1 fea20000.vsp: failed to reset wpf.1
[  617.951311] [drm:drm_atomic_helper_commit_cleanup_done] *ERROR*
[CRTC:57:crtc-3] flip_done timed out
[  618.055358] vsp1 fea20000.vsp: failed to reset wpf.1
[  618.060498] vsp1 fea20000.vsp: DRM pipeline stop timeout
[  628.831762] vsp1 fea20000.vsp: failed to reset wpf.1
[  638.943315] [drm:drm_atomic_helper_commit_cleanup_done] *ERROR*
[CRTC:57:crtc-3] flip_done timed out
[  649.183313] [drm:drm_atomic_helper_commit_cleanup_done] *ERROR*
[CRTC:57:crtc-3] flip_done timed out
[  677.753465] vsp1 fea20000.vsp: failed to reset wpf.1
[  687.839322] [drm:drm_atomic_helper_commit_cleanup_done] *ERROR*
[CRTC:57:crtc-3] flip_done timed out
[  687.935288] vsp1 fea20000.vsp: failed to reset wpf.1
[  687.940360] vsp1 fea20000.vsp: DRM pipeline stop timeout
[  687.945939] Unable to handle kernel NULL pointer dereference at virtual
address 00000000
[  687.954206] pgd = ffffff8009a0a000
[  687.957680] [00000000] *pgd=000000073fffe003, *pud=000000073fffe003,
*pmd=0000000000000000
[  687.966068] Internal error: Oops: 96000006 [#1] PREEMPT SMP
[  687.971690] Modules linked in:
[  687.974777] CPU: 0 PID: 10426 Comm: kmstest Not tainted
4.12.0-rc5-01343-g1bc824acf27c #5
[  687.983019] Hardware name: Renesas Salvator-X 2nd version board based on
r8a7795 ES2.0+ (DT)
[  687.991525] task: ffffffc6f97b4080 task.stack: ffffffc6f51dc000
[  687.997502] PC is at __media_pipeline_stop+0x24/0xd0
[  688.002507] LR is at media_pipeline_stop+0x34/0x48
[  688.007336] pc : [<ffffff8008583b44>] lr : [<ffffff8008583c24>] pstate: 60000145
[  688.014790] sp : ffffffc6f51df780
[  688.018129] x29: ffffffc6f51df780 x28: 0000000000000000
[  688.023490] x27: 0000000000000038 x26: ffffff8008960088
[  688.028850] x25: ffffffc6f98bcb10 x24: ffffffc6f98b8818
[  688.034210] x23: 0000000000000001 x22: ffffffc6f9ff1998
[  688.039570] x21: ffffffc6f98bc080 x20: 0000000000000000
[  688.044929] x19: 0000000000000008 x18: 0000000000000010
[  688.050288] x17: 0000007f9bc9e1c8 x16: ffffff8008165bb8
[  688.055648] x15: ffffff80899bb63f x14: 0000000000000006
[  688.061007] x13: ffffffc6faac6750 x12: ffffff80087bd078
[  688.066366] x11: 0000000000000000 x10: ffffff80097bb000
[  688.071725] x9 : ffffff8008afd000 x8 : 0000000000000000
[  688.077085] x7 : ffffff8008583c1c x6 : ffffff8008da75c8
[  688.082443] x5 : ffffff8009585d00 x4 : 000000002d28ca88
[  688.087803] x3 : 0000000089277f76 x2 : 0000000000000000
[  688.093162] x1 : ffffffc6f97b4080 x0 : ffffff8008583c24
[  688.098523] Process kmstest (pid: 10426, stack limit = 0xffffffc6f51dc000)
[  688.105453] Stack: (0xffffffc6f51df780 to 0xffffffc6f51e0000)
[  688.111245] f780: ffffffc6f51df7b0 ffffff8008583c24 ffffffc6f98b8ae8
ffffffc6f98bc080
[  688.119138] f7a0: ffffffc6f98bc818 ffffff8009d18000 ffffffc6f51df7e0
ffffff80085aa688
[  688.127031] f7c0: ffffffc6f9878c18 0000000000000001 ffffffc6f9ff0018
0000000000001f31
[  688.134923] f7e0: ffffffc6f51df8b0 ffffff800851a4b4 ffffffc6f9ff1390
ffffffc6f9ff1390
[  688.142815] f800: 0000000000000000 ffffffc6f9ff1998 ffffffc6f9ff0018
ffffff800894a478
[  688.150708] f820: ffffffc6f9557400 ffffffc6f9553400 0000000000000038
ffffff80087cf878

<huge stack trimmed>


[  688.721560] Call trace:
[  688.725502] Exception stack(0xffffffc6f51df5b0 to 0xffffffc6f51df6e0)
[  688.733473] f5a0:                                   0000000000000008
0000008000000000
[  688.742857] f5c0: ffffffc6f51df780 ffffff8008583b44 0000000000000038
ffffff800814e980
[  688.752244] f5e0: ffffff8008afd000 ffffff80097bb000 ffffffc6f51df6f0
00000000ffffffd8
[  688.761636] f600: 4554535953425553 6f6674616c703d4d 4349564544006d72
6674616c702b3d45
[  688.771035] f620: 326165663a6d726f 7073762e30303030 ffffffc6f51df650
ffffff8008124834
[  688.780447] f640: ffffffc600000000 ffffffc600000000 ffffff8008583c24
ffffffc6f97b4080
[  688.789865] f660: 0000000000000000 0000000089277f76 000000002d28ca88
ffffff8009585d00
[  688.799290] f680: ffffff8008da75c8 ffffff8008583c1c 0000000000000000
ffffff8008afd000
[  688.808727] f6a0: ffffff80097bb000 0000000000000000 ffffff80087bd078
ffffffc6faac6750
[  688.818165] f6c0: 0000000000000006 ffffff80899bb63f ffffff8008165bb8
0000007f9bc9e1c8
[  688.827617] [<ffffff8008583b44>] __media_pipeline_stop+0x24/0xd0
[  688.835247] [<ffffff8008583c24>] media_pipeline_stop+0x34/0x48
[  688.842712] [<ffffff80085aa688>] vsp1_du_setup_lif+0x5a8/0x700
[  688.850177] [<ffffff800851a4b4>] rcar_du_vsp_disable+0x2c/0x38
[  688.857632] [<ffffff80085162e0>] rcar_du_crtc_stop+0x198/0x1e8
[  688.865067] [<ffffff8008516350>] rcar_du_crtc_disable+0x20/0x70
[  688.872595] [<ffffff80084e34b4>]
drm_atomic_helper_commit_modeset_disables+0x1ac/0x3d0
[  688.882154] [<ffffff8008517718>] rcar_du_atomic_commit_tail+0x28/0x70
[  688.890233] [<ffffff80084e3a5c>] commit_tail+0x4c/0x80
[  688.897006] [<ffffff80084e3b9c>] drm_atomic_helper_commit+0xdc/0x148
[  688.905000] [<ffffff800850294c>] drm_atomic_commit+0x5c/0x68
[  688.912288] [<ffffff80084e63bc>] restore_fbdev_mode+0x15c/0x2e0
[  688.919837] [<ffffff80084e926c>]
drm_fb_helper_restore_fbdev_mode_unlocked+0x3c/0x98
[  688.929231] [<ffffff80084e9f64>] drm_fbdev_cma_restore_mode+0x24/0x30
[  688.937321] [<ffffff800851695c>] rcar_du_lastclose+0x24/0x30
[  688.944633] [<ffffff80084ee300>] drm_lastclose+0x48/0xe8
[  688.951595] [<ffffff80084ee6c0>] drm_release+0x320/0x358
[  688.958554] [<ffffff8008268ccc>] __fput+0x94/0x1d8
[  688.964977] [<ffffff8008268e88>] ____fput+0x20/0x30
[  688.971482] [<ffffff80080f4c70>] task_work_run+0xc8/0xe8
[  688.978417] [<ffffff80080d5820>] do_exit+0x310/0xb80
[  688.984997] [<ffffff80080d611c>] do_group_exit+0x3c/0xa0
[  688.991919] [<ffffff80080e3d00>] get_signal+0x558/0x8a8
[  688.998764] [<ffffff80080897f8>] do_signal+0xd0/0x560
[  689.005427] [<ffffff8008089ee0>] do_notify_resume+0xb0/0xd8
[  689.012610] [<ffffff8008083668>] work_pending+0x8/0x14
[  689.019359] Code: aa1e03e0 d503201f f9403ab4 91002293 (b9400280)
[  689.027391] ---[ end trace c94d490e101a5ed3 ]---
[  689.033758] Fixing recursive fault but reboot is needed!








On 26/06/17 19:12, Laurent Pinchart wrote:
> Hello,
> 
> This patch series implements support for the R-Car H3 ES2.0 SoC in the VSP
> and DU drivers.
>  
> Compared to the H3 ES1.1, the H3 ES2.0 has a new VSP2-DL instance that
> includes two blending units, a BRU and a BRS. The BRS is similar to the BRU
> but has two inputs only, and is used to service a second DU channel from the
> same VSP through a second LIF instances connected to WPF.1.
> 
> The patch series starts with a small fixes and cleanups in patches 01/14 to
> 05/14. Patch 06/14 prepares the VSP driver for multiple DU channels support by
> extending the DU-VSP API with an additional argument. Patches 07/14 to 10/14
> gradually build H3 ES2.0 support on top of that by implementing all needed
> features in the VSP driver.
> 
> So far the VSP driver always used headerless display lists when operating in
> connection with the DU. This mode of operation is only available on WPF.0, so
> support for regular display lists with headers when operating with the DU is
> added in patch 11/14.
> 
> The remaining patches finally implement H3 ES2.0 support in the DU driver,
> with support for VSP sharing implemented in patch 12/14, for H3 ES2.0 PLL in
> patch 13/14 (by restricting the ES1.x workaround to ES1.x SoCs) and for RGB
> output routing in patch 14/14.
> 
> Compared to v1, the series has gone under considerable changes. Testing
> locally on H3 ES2.0 uncovered multiple issues in the previous partially tested
> version, which have been fixed in additional patches. The following changes
> can be noted in particular.
> 
> - New small cleanups in patches 02/14 to 05/14
> - Pass the pipe index to vsp1_du_atomic_update() explicitly
> - Rebase on top of the VSP-DU flicker fixes, resulting in a major rework of
>   "v4l: vsp1: Add support for header display lists in continuous mode"
> - New patches 09/14, 10/14 and 12/14 to support the previously untested VGA
>   output
> 
> The series is based on top of Dave's latest drm-next branch as it depends on
> patches merged by Dave for v4.13. It depends, for testing, on
> 
> - the sh-pfc-for-v4.13 branch from Geert's renesas-drivers tree
> - the "[PATCH v2 0/2] R-Car H3 ES2.0 Salvator-X: Enable DU support in DT"
>   patch series
> 
> For convenience, a branch merging this series with all dependencies is
> available from
> 
> 	git://linuxtv.org/pinchartl/media.git drm/next/h3-es2/merged
> 
> with the DT and driver series split in two branches respectively tagged
> drm-h3-es2-dt-20170626 and drm-h3-es2-vsp-du-20170626.
> 
> The patches have been tested on the Lager, Salvator-X H3 ES1.x, Salvator-X
> M3-W and Salvator-XS boards. All outputs have been tested using modetest
> without any noticeable regression.
> 
> Laurent Pinchart (14):
>   v4l: vsp1: Fill display list headers without holding dlm spinlock
>   v4l: vsp1: Don't recycle active list at display start
>   v4l: vsp1: Don't set WPF sink pointer
>   v4l: vsp1: Store source and sink pointers as vsp1_entity
>   v4l: vsp1: Don't create links for DRM pipeline
>   v4l: vsp1: Add pipe index argument to the VSP-DU API
>   v4l: vsp1: Add support for the BRS entity
>   v4l: vsp1: Add support for new VSP2-BS, VSP2-DL and VSP2-D instances
>   v4l: vsp1: Add support for multiple LIF instances
>   v4l: vsp1: Add support for multiple DRM pipelines
>   v4l: vsp1: Add support for header display lists in continuous mode
>   drm: rcar-du: Support multiple sources from the same VSP
>   drm: rcar-du: Restrict DPLL duty cycle workaround to H3 ES1.x
>   drm: rcar-du: Configure DPAD0 routing through last group on Gen3
> 
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c    |  39 ++--
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.h    |   3 +
>  drivers/gpu/drm/rcar-du/rcar_du_group.c   |  21 ++-
>  drivers/gpu/drm/rcar-du/rcar_du_kms.c     |  91 ++++++++--
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c     |  37 ++--
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.h     |  10 +-
>  drivers/media/platform/vsp1/vsp1.h        |   7 +-
>  drivers/media/platform/vsp1/vsp1_bru.c    |  45 +++--
>  drivers/media/platform/vsp1/vsp1_bru.h    |   4 +-
>  drivers/media/platform/vsp1/vsp1_dl.c     | 205 +++++++++++++---------
>  drivers/media/platform/vsp1/vsp1_dl.h     |   1 -
>  drivers/media/platform/vsp1/vsp1_drm.c    | 283 +++++++++++++++---------------
>  drivers/media/platform/vsp1/vsp1_drm.h    |  38 ++--
>  drivers/media/platform/vsp1/vsp1_drv.c    | 115 ++++++++----
>  drivers/media/platform/vsp1/vsp1_entity.c |  40 +++--
>  drivers/media/platform/vsp1/vsp1_entity.h |   5 +-
>  drivers/media/platform/vsp1/vsp1_lif.c    |   5 +-
>  drivers/media/platform/vsp1/vsp1_lif.h    |   2 +-
>  drivers/media/platform/vsp1/vsp1_pipe.c   |   7 +-
>  drivers/media/platform/vsp1/vsp1_regs.h   |  46 +++--
>  drivers/media/platform/vsp1/vsp1_video.c  |  63 ++++---
>  drivers/media/platform/vsp1/vsp1_wpf.c    |   4 +-
>  include/media/vsp1.h                      |  10 +-
>  23 files changed, 676 insertions(+), 405 deletions(-)
> 
