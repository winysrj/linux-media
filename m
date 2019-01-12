Return-Path: <SRS0=PrKG=PU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9AF1C43387
	for <linux-media@archiver.kernel.org>; Sat, 12 Jan 2019 15:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B18792084E
	for <linux-media@archiver.kernel.org>; Sat, 12 Jan 2019 15:09:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="AU51X6yh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbfALPJF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 12 Jan 2019 10:09:05 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:46354 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbfALPJE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Jan 2019 10:09:04 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id A43B2513;
        Sat, 12 Jan 2019 16:09:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547305742;
        bh=PKagmk4kTEGTfwTIdaavjPc31ySoi+Y5OD43Fovmu9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AU51X6yhlpLc3mG7Mms+nsYCZSgghcIerZUxjrfxja9ATnqyrk1zWakMTb1OzbFQt
         r7LUV6AxYXV+J/00+AuN6fLFnaBj2l/8HT8JK1e9bviu33rDoIJ7bXPnyNI8fCYOA1
         l/6RWKe/gdZLe5mc0t6Sh3ZOqybVA9lt/KgeWtI0=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     "Mani, Rajmohan" <rajmohan.mani@intel.com>
Cc:     Jacopo Mondi <jacopo@jmondi.org>, Tomasz Figa <tfiga@chromium.org>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Date:   Sat, 12 Jan 2019 17:10:14 +0200
Message-ID: <2718150.slhGTuRzHq@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <6F87890CF0F5204F892DEA1EF0D77A599B322D80@fmsmsx122.amr.corp.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com> <20190109182028.l6dopz5k75w3u3t4@uno.localdomain> <6F87890CF0F5204F892DEA1EF0D77A599B322D80@fmsmsx122.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello Raj,

On Saturday, 12 January 2019 04:30:49 EET Mani, Rajmohan wrote:

[snip]

> I finally managed to reproduce the issue with 4.20-rc6, with KASAN enabled
> and with CONFIG_SLUB_DEBUG_ON with SLAB_STORE_USER.

Nice ! Thank you for your work.

> The following line indicates the crash happens when yavta PID 10289 tries to
> free the memory.
> 
> [  452.437844] BUG: KASAN: use-after-free in ipu3_dmamap_free+0x50/0x9c
> [ipu3_imgu]
> [  452.446123] Read of size 8 at addr ffff8881503481a0 by task yavta/10289 
> 
> The above looks to be normal, since it's the same task that allocated this
> memory.
> [  452.685731] Allocated by task 10289:
> 
> Before the above happened, yavta/10187 came in and freed this memory per
> KASAN.
> [  452.787656] Freed by task 10187:
> 
> Is this (one instance of yavta freeing the memory allocated by another
> instance of yavta) expected? Or does it indicate that mmap giving the same
> address across these 2 instances of yavta? I need to debug / confirm the
> latter case.

KASAN prints the task name (and process ID) to help you debugging the problem, 
but this doesn't mean that yavta is freeing the memory. yavta exercises the 
V4L2 API exposed by the driver, and internally, down the call stack, 
ipu3_dmamap_free() is called by the driver. According to the backtraces you 
posted, this is in response to a VIDIOC_STREAMOFF call from yavta. I would 
expect VIDIOC_STREAMOFF to free DMA mappings created for the buffers on the 
corresponding video nodes, and thus allocated by the same task. The fact that 
memory is allocated in one task and freed in another seems weird to me in this 
case.

My guess is that when using multiple instances of yavta the calls to 
VIDIOC_STREAMOFF on the different video nodes are asynchronous and happen in a 
way that the driver does not expect. Regardless of how the API is exercised by 
applications, in a good or bad way, the IPU3 driver must not crash. It needs 
to be prepared for all V4L2 ioctls to be called at any time, and an 
application could call VIDIOC_STREAMOFF on any video node while the IPU3 is 
busy processing images.

> With the help of local application that operates these pipes in a serial
> fashion, I do not see this issue.

[snip]

-- 
Regards,

Laurent Pinchart



