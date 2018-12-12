Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8824CC65BAF
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 17:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B440208E7
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 17:27:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="vxqEYLTI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B440208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbeLLR1p (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 12:27:45 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:43782 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727681AbeLLR1p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 12:27:45 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id AC3F955A;
        Wed, 12 Dec 2018 18:27:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544635662;
        bh=L+EMb2GpdOR48ndi933TaF4mYJe40vgPJUbgAw3OU0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vxqEYLTIoKKhIWHvXkuVK2ZZjuEx8dXa56MtwLERsgA2x+5hfULC0ZX4eBkPSUndP
         QegynBGxYct6I0VVoPi4a2TAdVkWSEPn5ifGUNHa0h1mrbkMcq2A4Pl5nJ0DzgN98U
         +E3m0vRwhpskzAv8Ss4aevI5IJncw/izA4pxyoX0=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     "Matwey V. Kornilov" <matwey@sai.msu.ru>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        matwey.kornilov@gmail.com, tfiga@chromium.org,
        stern@rowland.harvard.edu, ezequiel@collabora.com,
        hdegoede@redhat.com, hverkuil@xs4all.nl, mchehab@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, isely@pobox.com,
        bhumirks@gmail.com, colin.king@canonical.com,
        kieran.bingham@ideasonboard.com, keiichiw@chromium.org
Subject: Re: [PATCH v6 0/2] media: usb: pwc: Don't use coherent DMA buffers for ISO transfer
Date:   Wed, 12 Dec 2018 19:28:27 +0200
Message-ID: <3390244.qRE0ngbmrs@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20181109190327.23606-1-matwey@sai.msu.ru>
References: <20181109190327.23606-1-matwey@sai.msu.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Matwey,

Thank you for the patches.

For the whole series,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

On Friday, 9 November 2018 21:03:25 EET Matwey V. Kornilov wrote:
> DMA cocherency slows the transfer down on systems without hardware coherent
> DMA. In order to demontrate this we introduce performance measurement
> facilities in patch 1 and fix the performance issue in patch 2 in order to
> obtain 3.3 times speedup.
> 
> Changes since v5:
>  * add dma_sync_single_for_device() as required by Laurent Pinchart
> 
> Changes since v4:
>  * fix fields order in trace events
>  * minor style fixes
> 
> Changes since v3:
>  * fix scripts/checkpatch.pl errors
>  * use __string to store name in trace events
> 
> Changes since v2:
>  * use dma_sync_single_for_cpu() to achive better performance
>  * remeasured performance
> 
> Changes since v1:
>  * trace_pwc_handler_exit() call moved to proper place
>  * detailed description added for commit 1
>  * additional output added to trace to track separate frames
> 
> Matwey V. Kornilov (2):
>   media: usb: pwc: Introduce TRACE_EVENTs for pwc_isoc_handler()
>   media: usb: pwc: Don't use coherent DMA buffers for ISO transfer
> 
>  drivers/media/usb/pwc/pwc-if.c | 69 +++++++++++++++++++++++++++++++--------
>  include/trace/events/pwc.h     | 65 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 121 insertions(+), 13 deletions(-)
>  create mode 100644 include/trace/events/pwc.h

-- 
Regards,

Laurent Pinchart



