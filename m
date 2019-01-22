Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5720C282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 14:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A125821019
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 14:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbfAVOps (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 09:45:48 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59974 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728736AbfAVOpr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 09:45:47 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gportay)
        with ESMTPSA id BBE2426109D
Date:   Tue, 22 Jan 2019 09:45:49 -0500
From:   =?utf-8?B?R2HDq2w=?= PORTAY <gael.portay@collabora.com>
To:     Steve Longerbeam <slongerbeam@gmail.com>
Cc:     linux-media@vger.kernel.org, Peter Seiderer <ps.report@gmx.net>
Subject: Re: [PATCH v4 0/3] media: imx: Stop stream before disabling IDMA
 channels
Message-ID: <20190122144549.zznkilfwnf2gv2on@archlinux.localdomain>
References: <20190121233552.20001-1-slongerbeam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190121233552.20001-1-slongerbeam@gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Steve,

On Mon, Jan 21, 2019 at 03:35:49PM -0800, Steve Longerbeam wrote:
> Repeatedly sending a stream off immediately followed by stream on can
> eventually cause a complete system hard lockup on the SabreAuto when
> streaming from the ADV7180:
> 
> while true; do v4l2-ctl  -d4 --stream-mmap --stream-count=3; done
> 
> Eventually this either causes the system lockup or EOF timeouts at all
> subsequent stream on, until a system reset.
> 
> The lockup occurs when disabling the IDMA channels at stream off. Stopping
> the video data stream entering the IDMA channel before disabling the
> channel itself appears to be a reliable fix for the hard lockup.
> 
> In the CSI subdevice, this can be done by disabling the CSI before
> disabling the CSI IDMA channel, instead of after. In the IC-PRPENVVF
> subdevice, this can be done by stopping upstream before disabling the
> PRPENC/VF IDMA channel.
> 
> History:
> v4:
> - Disabling SMFC will have no effect if both CSI's are streaming. So
>   go back to disabling CSI before channel as in v2, but split up
>   csi_idmac_stop such that ipu_csi_disable can still be called within
>   csi_stop.
> 
> v3:
> - Switch to disabling the SMFC before the channel, instead of the CSI
>   before the channel.
> 
> v2:
> - Whitespace fixes
> - Add Fixes: and Cc: stable@vger.kernel.org
> - No functional changes.
> 
> 
> Steve Longerbeam (3):
>   media: imx: csi: Disable CSI immediately after last EOF
>   media: imx: csi: Stop upstream before disabling IDMA channel
>   media: imx: prpencvf: Stop upstream before disabling IDMA channel
> 
>  drivers/staging/media/imx/imx-ic-prpencvf.c | 26 ++++++++-----
>  drivers/staging/media/imx/imx-media-csi.c   | 42 +++++++++++++--------
>  2 files changed, 44 insertions(+), 24 deletions(-)
> 
> -- 
> 2.17.1
> 

The system is still up and running this morning after a whole night long
of tests.

You have my Tested-by.

Thanks,
Gael
