Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52033 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2LNL57 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 06:57:59 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so2730168lbb.19
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2012 03:57:57 -0800 (PST)
Message-ID: <50CB1442.50002@gmail.com>
Date: Fri, 14 Dec 2012 12:57:54 +0100
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
MIME-Version: 1.0
To: sumit.semwal@ti.com
CC: sumit.semwal@linaro.org, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: Add debugfs support
References: <1355477817-5750-1-git-send-email-sumit.semwal@ti.com>
In-Reply-To: <1355477817-5750-1-git-send-email-sumit.semwal@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op 14-12-12 10:36, sumit.semwal@ti.com schreef:
> From: Sumit Semwal <sumit.semwal@linaro.org>
>
> Add debugfs support to make it easier to print debug information
> about the dma-buf buffers.
>
I like the idea, I don't know if it could be done in a free manner, but for bonus points
could we also have the dma-buf fd be obtainable that way from a debugfs entry?

Doing so would allow me to 'steal' a dma-buf from an existing mapping easily, and test against that.

Also I think the name of the device and process that exported the dma-buf would be useful
to have as well, even if in case of the device that would mean changing the api slightly to record it.

I was thinking of having a directory structure like this:

/sys/kernel/debug/dma_buf/stats

and then for each dma-buf:

/sys/kernel/debug/dma-buf/exporting_file.c/<number>-fd
/sys/kernel/debug/dma-buf/exporting_file.c/<number>-attachments
/sys/kernel/debug/dma-buf/exporting_file.c/<number>-info

Opening the fd file would give you back the original fd, or fail with -EIO if refcount was dropped to 0.

Would something like this be doable? I don't know debugfs that well, but I don't see why it wouldn't be,

~Maarten

