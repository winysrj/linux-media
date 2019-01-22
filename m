Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAFE8C282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 07:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7E4F20870
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 07:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfAVHe4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 02:34:56 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:34243 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726423AbfAVHe4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 02:34:56 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lqaAgkG8wBDyIlqaEgSdHZ; Tue, 22 Jan 2019 08:34:54 +0100
Subject: Re: [PATCH v4 0/3] media: imx: Stop stream before disabling IDMA
 channels
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Gael PORTAY <gael.portay@collabora.com>,
        Peter Seiderer <ps.report@gmx.net>
References: <20190121233552.20001-1-slongerbeam@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cfa25b62-0e2e-07df-11d2-811993682246@xs4all.nl>
Date:   Tue, 22 Jan 2019 08:34:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190121233552.20001-1-slongerbeam@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGNsc09NztkRzwj/JnJNeiPIug6Sw9MrqEjn5WOOyvsRb3DA5/Yru/M+3SKEgA0a2bhnGwfuczhqi9p8EUhiv0d0b8WV/nORG4LidG/VDI5gLf7S+iXu
 JdyncyAk2ukyTWhMW10giu5VcNnX8sjG97kcMNlYvP++VKQJtIwFbrgm1d0lH1AdGMxUWXtbw83540qtSgozrSo2iKtvDfqdtMzrh/2Tbm6xJMd/VqEpC5HY
 sgo3zqMulYmzp+L2LT19T7lxMUmtoPDDDMq8NtWEGnk=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Steve,

On 01/22/2019 12:35 AM, Steve Longerbeam wrote:
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

Please let me know when you are satisfied with this patch series and I
can make a pull request for this.

Thanks!

	Hans

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

