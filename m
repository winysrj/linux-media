Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50286 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab2KSF3b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 00:29:31 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so4494669oag.19
        for <linux-media@vger.kernel.org>; Sun, 18 Nov 2012 21:29:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353081787-7010-1-git-send-email-hverkuil@xs4all.nl>
References: <1353081787-7010-1-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 19 Nov 2012 10:59:07 +0530
Message-ID: <CA+V-a8vosXzByUVBe4vM2z2Pagxs81tmHMY1shF9DDOh0c8_rQ@mail.gmail.com>
Subject: Re: [RFCv1 PATCH 0/2] Two vpif fixes protecting the dma_queue by a lock
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patches.

On Fri, Nov 16, 2012 at 9:33 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Prabhakar,
>
> These two patches add protection to the dma_queue. We discovered that not
> locking caused race conditions, which caused the display DMA to jam. After
> adding the lock we never saw this again.
>
> It makes sense as well since the interrupt routine and normal code both
> manipulated the same list.
>
> It's fixed for both capture and display.
>
Acked-by: Prabhakar Lad <prabhakar.lad@ti.com>

I'll queue these patches for 3.8.

Regards,
--Prabhakar Lad

> Regards,
>
>         Hans
>
