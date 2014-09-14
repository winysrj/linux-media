Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:64419 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbaINHD0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Sep 2014 03:03:26 -0400
Received: by mail-lb0-f172.google.com with SMTP id w7so2931838lbi.3
        for <linux-media@vger.kernel.org>; Sun, 14 Sep 2014 00:03:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1410526803-25887-11-git-send-email-hverkuil@xs4all.nl>
References: <1410526803-25887-1-git-send-email-hverkuil@xs4all.nl> <1410526803-25887-11-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Sun, 14 Sep 2014 15:02:44 +0800
Message-ID: <CAMm-=zDKpTsOh5n-VD_zyS5XD39Nqud1MSoptj4j1B+h58WG9w@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 10/14] vb2: add 'new_cookies' flag
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Sep 12, 2014 at 8:59 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This flag helps drivers that need to reprogram their DMA engine whenever
> a plane cookie (== DMA address or DMA scatter-gather list) changes.
>
> Otherwise they would have to reprogram the DMA engine for every frame.
>
> Note that it is not possible to do this in buf_init() since dma_map_sg has
> to be done first, which happens just before buf_prepare() in the prepare()
> memop. It is dma_map_sg that sets up the dma addresses that are needed to
> configure the DMA engine.

Perhaps I'm missing something, but couldn't we just dma_map_sg on
allocation/get in dma-sg and unmap on put?

-- 
Best regards,
Pawel Osciak
