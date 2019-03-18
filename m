Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC1EC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B064D20850
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552920371;
	bh=VXk8044aIkjiTgThvreUga7BIzyES16fRQvBqz8niiw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=h9e3/n7/fTnzzantPfaw1nMo0sMsVUY4Goum7ZT9HQtgvZVeElyND9I74Ew2PL4uV
	 qMncU1YbDskflyToEpZ6wk01BBIJfrB/J3T9cC7fSgugTxsaI7dwT7UF9rsLLdcNUV
	 QYhdrZ0eW8h+CKADrZGv/E289c5GSm/mZWAs4HOg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfCROqL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 10:46:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:59684 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfCROqL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 10:46:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=H6KQyXCX2TKmJEsScIsdqKMxRrKJbYRNrXBwGwNR+R0=; b=Nat3z8TBeg+cwkbtMhqxIT/sLC
        XyqkeLzeOzlHdodhCQ0C+gq2jc01QAa7qCZ5XcThsBf1E12Ex4+3g7zLt9pXbT9WexMctdpA2CE/8
        LzDhgl1ibzIOQSS773YPmbnHMl9iPjO8W69bm+vauNU+/5tmhUe61YE1phKUCLT/JSrkwIwzDnqaa
        7UpTPlQ/yDJneXAnxIVca9N40oOMm6CH9wYOSTXyO6OLaYiFq3RLVsujNfHluzEVqyTkWt3LAiPxy
        KN9/YvoFzjHiUT41MVtu6uHcUpPwU7CqB5IRHsMgsO26avf6uFkSOjuEptFjLtXo8rZ294rVhqxLp
        A/Zfmvhw==;
Received: from [191.250.43.186] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h5tWg-0006K6-DN; Mon, 18 Mar 2019 14:46:07 +0000
Date:   Mon, 18 Mar 2019 11:46:01 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc:     dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v7 00/18] R-Car DU display writeback support
Message-ID: <20190318114601.455984b2@coco.lan>
In-Reply-To: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Mon, 18 Mar 2019 16:31:03 +0200
Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> escreveu:

> Hello everybody,
> 
> This is the latest and greatest version of the patch series that
> implements display writeback support for the R-Car Gen3 platforms in the
> VSP1 and DU drivers. All patches have been reviewed, all comments
> incorporated, and the result rebased on top ov v5.1-rc1.
> 
> Patches 01/18 to 11/18 prepare the VSP1 driver for writeback support
> with all the necessary plumbing, including extensions of the API between
> the VSP1 and DU drivers.
> 
> The most significant change compared to v6 is the rebase on top of
> v5.1-rc1. This was done to ease merging, as the VSP and DU parts would
> normally go through different trees. I usually ask Mauro or Dave their
> permission to merge the whole series through a single tree, and doing
> the same this time I would select the DRM tree given that I hope to get
> more DU patches merged in this development cycle. There is no foreseen
> conflicting patch for the VSP in v5.2, but if a need arises, I will
> them on top of the 11 first patches of this series and send a pull
> request to Mauro to avoid conflicts.
> 
> Mauro, I plan to send a pull request to Dave by the end of this week, so
> if you'd like to have a look at the VSP patches, now would be a good
> time :-) It's only driver changes, and they have been reviewed already,
> so I don't expect any problem.
> 
> Compared to v5 the major change is the usage of chained display lists in
> the VSP to disable writeback after one frame, instead of patching the
> active display list in memory. This should solve the potential DMA to
> released buffer issue that could occur when the frame start interrupt
> was delayed after frame end. Patch 06/18 and 07/18 are new in this
> version to support usage of chained display pipelines.
> 
> Compared to v4 the major change is the move from V4L2 to DRM writeback
> connectors for the userspace API. This has caused a few issues with
> writeback support to be uncovered, and they are addressed by patches
> 12/18 to 14/18.
> 
> Patches 15/18 to 17/18 then perform refactoring of the DU driver, to
> finally add writeback support in patch 18/18.
> 
> The writeback pixel format is restricted to RGB, due to the VSP1
> outputting RGB to the display and lacking a separate colour space
> conversion unit for writeback. The writeback framebuffer size must match
> the active mode, writeback scaling is not supported by the hardware.
> 
> Writeback requests being part of atomic commits, they're queued to the
> hardware when they are received, become active at the next vblank, and
> complete on the following vblank. The display list chaining mechanism
> ensures that writeback will be enabled for a single frame only, unless
> the next atomic commit contains a separate writeback request.
> 
> For convenience patches can be found at
> 
> 	git://linuxtv.org/pinchartl/media.git drm/du/writeback
> 
> Kieran Bingham (1):
>   Revert "[media] v4l: vsp1: Supply frames to the DU continuously"
> 
> Laurent Pinchart (17):
>   media: vsp1: wpf: Fix partition configuration for display pipelines
>   media: vsp1: Replace leftover occurrence of fragment with body
>   media: vsp1: Fix addresses of display-related registers for VSP-DL
>   media: vsp1: Replace the display list internal flag with a flags field
>   media: vsp1: Add vsp1_dl_list argument to .configure_stream()
>     operation
>   media: vsp1: dl: Allow chained display lists for display pipelines
>   media: vsp1: wpf: Add writeback support
>   media: vsp1: drm: Split RPF format setting to separate function
>   media: vsp1: drm: Extend frame completion API to the DU driver
>   media: vsp1: drm: Implement writeback support

For the media patches:

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

If those are the only changes at media side, feel free to push it
via DRM tree.

>   drm: writeback: Cleanup job ownership handling when queuing job
>   drm: writeback: Fix leak of writeback job
>   drm: writeback: Add job prepare and cleanup operations
>   drm: rcar-du: Fix rcar_du_crtc structure documentation
>   drm: rcar-du: Store V4L2 fourcc in rcar_du_format_info structure
>   drm: rcar-du: vsp: Extract framebuffer (un)mapping to separate
>     functions
>   drm: rcar-du: Add writeback support for R-Car Gen3
> 
>  drivers/gpu/drm/arm/malidp_mw.c             |   3 +-
>  drivers/gpu/drm/drm_atomic_helper.c         |  11 +
>  drivers/gpu/drm/drm_atomic_state_helper.c   |   4 +
>  drivers/gpu/drm/drm_atomic_uapi.c           |  31 +--
>  drivers/gpu/drm/drm_writeback.c             |  73 +++++-
>  drivers/gpu/drm/rcar-du/Kconfig             |   4 +
>  drivers/gpu/drm/rcar-du/Makefile            |   3 +-
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c      |   7 +-
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.h      |   9 +-
>  drivers/gpu/drm/rcar-du/rcar_du_kms.c       |  37 +++
>  drivers/gpu/drm/rcar-du/rcar_du_kms.h       |   1 +
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c       | 122 +++++-----
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.h       |  17 ++
>  drivers/gpu/drm/rcar-du/rcar_du_writeback.c | 243 ++++++++++++++++++++
>  drivers/gpu/drm/rcar-du/rcar_du_writeback.h |  39 ++++
>  drivers/gpu/drm/vc4/vc4_txp.c               |   2 +-
>  drivers/media/platform/vsp1/vsp1_brx.c      |   1 +
>  drivers/media/platform/vsp1/vsp1_clu.c      |   1 +
>  drivers/media/platform/vsp1/vsp1_dl.c       |  84 ++++---
>  drivers/media/platform/vsp1/vsp1_dl.h       |   6 +-
>  drivers/media/platform/vsp1/vsp1_drm.c      |  94 +++++---
>  drivers/media/platform/vsp1/vsp1_drm.h      |   2 +-
>  drivers/media/platform/vsp1/vsp1_entity.c   |   3 +-
>  drivers/media/platform/vsp1/vsp1_entity.h   |   7 +-
>  drivers/media/platform/vsp1/vsp1_hgo.c      |   1 +
>  drivers/media/platform/vsp1/vsp1_hgt.c      |   1 +
>  drivers/media/platform/vsp1/vsp1_hsit.c     |   1 +
>  drivers/media/platform/vsp1/vsp1_lif.c      |   1 +
>  drivers/media/platform/vsp1/vsp1_lut.c      |   1 +
>  drivers/media/platform/vsp1/vsp1_regs.h     |   6 +-
>  drivers/media/platform/vsp1/vsp1_rpf.c      |   1 +
>  drivers/media/platform/vsp1/vsp1_rwpf.h     |   1 +
>  drivers/media/platform/vsp1/vsp1_sru.c      |   1 +
>  drivers/media/platform/vsp1/vsp1_uds.c      |   1 +
>  drivers/media/platform/vsp1/vsp1_uif.c      |   1 +
>  drivers/media/platform/vsp1/vsp1_video.c    |  16 +-
>  drivers/media/platform/vsp1/vsp1_wpf.c      |  83 +++++--
>  include/drm/drm_modeset_helper_vtables.h    |   7 +
>  include/drm/drm_writeback.h                 |  30 ++-
>  include/media/vsp1.h                        |  19 +-
>  40 files changed, 775 insertions(+), 200 deletions(-)
>  create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_writeback.c
>  create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_writeback.h
> 



Thanks,
Mauro
