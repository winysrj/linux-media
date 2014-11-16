Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:34938 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbaKPMsI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Nov 2014 07:48:08 -0500
Received: by mail-la0-f44.google.com with SMTP id hz20so6964256lab.17
        for <linux-media@vger.kernel.org>; Sun, 16 Nov 2014 04:48:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415623771-29634-4-git-send-email-hverkuil@xs4all.nl>
References: <1415623771-29634-1-git-send-email-hverkuil@xs4all.nl> <1415623771-29634-4-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Sun, 16 Nov 2014 20:47:26 +0800
Message-ID: <CAMm-=zCTMOjGsuUZ0vz0aM1gKQVo8xRKx9e8HCwehtBv5EmYXQ@mail.gmail.com>
Subject: Re: [RFCv6 PATCH 03/16] vb2: add dma_dir to the alloc memop.
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 10, 2014 at 8:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This is needed for the next patch where the dma-sg alloc memop needs
> to know the dma_dir.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

-- 
Best regards,
Pawel Osciak
