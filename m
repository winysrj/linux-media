Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:59766 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730395AbeG0QGS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 12:06:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham@ideasonboard.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: Re: rcar-du/vsp1: possible recursive locking detected
Date: Fri, 27 Jul 2018 17:44:36 +0300
Message-ID: <1610058.cAHTnblAmQ@avalon>
In-Reply-To: <97d625f6-9eb5-d08a-0222-f1cb244f5089@ideasonboard.com>
References: <97d625f6-9eb5-d08a-0222-f1cb244f5089@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Friday, 13 July 2018 19:01:55 EEST Kieran Bingham wrote:
> Observing this on linux-media/master branch, while running a simple
> kmstest with dual outputs (HDMI, VGA)
> 
> 
> Just reporting for the moment. We'll have to look at bisecting to see if
> it was introduced recently.

I haven't bisected it, but I'm pretty sure the faulty commit is

commit f81f9adc4ee1e94a38a9059f6291feea74f184e5
Author: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Date:   Thu Feb 22 14:26:21 2018 -0500

    media: v4l: vsp1: Assign BRU and BRS to pipelines dynamically

I ran into the same issue today, and I'm now debugging it.

> [   31.644076] ============================================
> [   31.649412] WARNING: possible recursive locking detected
> [   31.654752] 4.18.0-rc2-arm64-renesas-12862-g666e994aa227 #25 Not tainted
> [   31.661483] --------------------------------------------
> [   31.666818] kmstest/986 is trying to acquire lock:
> [   31.671631] 000000008bb5ef8e (&vsp1->drm->lock){+.+.}, at:
> vsp1_du_setup_lif+0x90/0x438
> [   31.679693]
> [   31.679693] but task is already holding lock:
> [   31.685551] 00000000ef2edc5c (&vsp1->drm->lock){+.+.}, at:
> vsp1_du_atomic_begin+0x1c/0x28
> [   31.693775]
> [   31.693775] other info that might help us debug this:
> [   31.700331]  Possible unsafe locking scenario:
> [   31.700331]
> [   31.706276]        CPU0
> [   31.708731]        ----
> [   31.711185]   lock(&vsp1->drm->lock);
> [   31.714864]   lock(&vsp1->drm->lock);
> [   31.718543]
> [   31.718543]  *** DEADLOCK ***
> [   31.718543]
> [   31.724489]  May be due to missing lock nesting notation
> [   31.724489]
> [   31.731308] 3 locks held by kmstest/986:
> [   31.735246]  #0: 0000000073af26f9 (crtc_ww_class_acquire){+.+.}, at:
> drm_mode_atomic_ioctl+0xa0/0xa50
> [   31.744523]  #1: 000000007a933c3a (crtc_ww_class_mutex){+.+.}, at:
> drm_modeset_lock+0x64/0x118
> [   31.753184]  #2: 00000000ef2edc5c (&vsp1->drm->lock){+.+.}, at:
> vsp1_du_atomic_begin+0x1c/0x28
> [   31.761844]
> [   31.761844] stack backtrace:
> [   31.766223] CPU: 1 PID: 986 Comm: kmstest Not tainted
> 4.18.0-rc2-arm64-renesas-12862-g666e994aa227 #25
> [   31.775571] Hardware name: Renesas Salvator-X 2nd version board based
> on r8a7795 ES2.0+ (DT)
> [   31.784047] Call trace:
> [   31.786509]  dump_backtrace+0x0/0x1c8
> [   31.790187]  show_stack+0x14/0x20
> [   31.793521]  dump_stack+0xbc/0xf4
> [   31.796853]  __lock_acquire+0x964/0x1888
> [   31.800792]  lock_acquire+0x48/0x64
> [   31.804297]  __mutex_lock+0x70/0x838
> [   31.807887]  mutex_lock_nested+0x1c/0x28
> [   31.811826]  vsp1_du_setup_lif+0x90/0x438
> [   31.815856]  rcar_du_vsp_enable+0x108/0x138
> [   31.820057]  rcar_du_crtc_setup+0x3d8/0x548
> [   31.824258]  rcar_du_crtc_atomic_begin+0x5c/0x70
> [   31.828899]  drm_atomic_helper_commit_planes+0x70/0x208
> [   31.834147]  rcar_du_atomic_commit_tail+0x30/0x68
> [   31.838871]  commit_tail+0x44/0x78
> [   31.842287]  drm_atomic_helper_commit+0xe8/0x160
> [   31.846925]  drm_atomic_commit+0x48/0x58
> [   31.850865]  drm_mode_atomic_ioctl+0x850/0xa50
> [   31.855328]  drm_ioctl_kernel+0x88/0x108
> [   31.859267]  drm_ioctl+0x1b8/0x400
> [   31.862686]  do_vfs_ioctl+0xb8/0xa20
> [   31.866276]  ksys_ioctl+0x44/0x90
> [   31.869605]  sys_ioctl+0xc/0x18
> [   31.872759]  el0_svc_naked+0x30/0x34


-- 
Regards,

Laurent Pinchart
