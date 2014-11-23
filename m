Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:41358 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaKWKgn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 05:36:43 -0500
Received: by mail-la0-f46.google.com with SMTP id gd6so6388456lab.33
        for <linux-media@vger.kernel.org>; Sun, 23 Nov 2014 02:36:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1416315068-22936-6-git-send-email-hverkuil@xs4all.nl>
References: <1416315068-22936-1-git-send-email-hverkuil@xs4all.nl> <1416315068-22936-6-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Sun, 23 Nov 2014 19:36:01 +0900
Message-ID: <CAMm-=zBybAq4t_RBC9-4V3fdA0UTb3=uF_=8KqTDfUJQ+7WRhA@mail.gmail.com>
Subject: Re: [REVIEWv7 PATCH 05/12] vb2-dma-sg: add allocation context to dma-sg
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 18, 2014 at 9:51 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Require that dma-sg also uses an allocation context. This is in preparation
> for adding prepare/finish memops to sync the memory between DMA and CPU.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

-- 
Best regards,
Pawel Osciak
