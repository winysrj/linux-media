Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:55599 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab2LNOLQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 09:11:16 -0500
Received: by mail-yh0-f52.google.com with SMTP id o22so757186yho.11
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2012 06:11:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50CB1442.50002@gmail.com>
References: <1355477817-5750-1-git-send-email-sumit.semwal@ti.com>
	<50CB1442.50002@gmail.com>
Date: Fri, 14 Dec 2012 08:11:14 -0600
Message-ID: <CAF6AEGskmd+ZGCvcocUzjiKDGsexfhDhJNbV8feVHN7OeG4Jjg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: Add debugfs support
From: Rob Clark <robdclark@gmail.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Sumit Semwal <sumit.semwal@ti.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 14, 2012 at 5:57 AM, Maarten Lankhorst
<m.b.lankhorst@gmail.com> wrote:
> Op 14-12-12 10:36, sumit.semwal@ti.com schreef:
>> From: Sumit Semwal <sumit.semwal@linaro.org>
>>
>> Add debugfs support to make it easier to print debug information
>> about the dma-buf buffers.
>>
> I like the idea, I don't know if it could be done in a free manner, but for bonus points
> could we also have the dma-buf fd be obtainable that way from a debugfs entry?
>
> Doing so would allow me to 'steal' a dma-buf from an existing mapping easily, and test against that.
>
> Also I think the name of the device and process that exported the dma-buf would be useful
> to have as well, even if in case of the device that would mean changing the api slightly to record it.
>
> I was thinking of having a directory structure like this:
>
> /sys/kernel/debug/dma_buf/stats
>
> and then for each dma-buf:
>
> /sys/kernel/debug/dma-buf/exporting_file.c/<number>-fd
> /sys/kernel/debug/dma-buf/exporting_file.c/<number>-attachments
> /sys/kernel/debug/dma-buf/exporting_file.c/<number>-info
>
> Opening the fd file would give you back the original fd, or fail with -EIO if refcount was dropped to 0.
>
> Would something like this be doable? I don't know debugfs that well, but I don't see why it wouldn't be,

yeah.. but sort of back-door's the security benefits of an anonymous fd..

BR,
-R

> ~Maarten
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
