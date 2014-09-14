Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:61414 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaINDkq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Sep 2014 23:40:46 -0400
Received: by mail-la0-f51.google.com with SMTP id gi9so2973761lab.10
        for <linux-media@vger.kernel.org>; Sat, 13 Sep 2014 20:40:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1410526803-25887-4-git-send-email-hverkuil@xs4all.nl>
References: <1410526803-25887-1-git-send-email-hverkuil@xs4all.nl> <1410526803-25887-4-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Sun, 14 Sep 2014 11:40:04 +0800
Message-ID: <CAMm-=zBR0vzB1x0rK_=oq4t+FqQOon32EShnxuZOzsZj5pOWdg@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 03/14] vb2-dma-sg: add prepare/finish memops
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Thank you for working on this.

On Fri, Sep 12, 2014 at 8:59 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This moves dma_(un)map_sg to the prepare/finish memops of videobuf2-dma-sg.c.

I agree with Laurent. dma_map and unmap should be done when we alloc
(or get) and put a buffer, while prepare and finish should only sync.

-- 
Best regards,
Pawel Osciak
