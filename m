Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:50944 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2LNOf1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 09:35:27 -0500
Message-ID: <50CB392C.7080407@canonical.com>
Date: Fri, 14 Dec 2012 15:35:24 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
MIME-Version: 1.0
To: Rob Clark <robdclark@gmail.com>
CC: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: Add debugfs support
References: <1355477817-5750-1-git-send-email-sumit.semwal@ti.com> <50CB1442.50002@gmail.com> <CAF6AEGskmd+ZGCvcocUzjiKDGsexfhDhJNbV8feVHN7OeG4Jjg@mail.gmail.com>
In-Reply-To: <CAF6AEGskmd+ZGCvcocUzjiKDGsexfhDhJNbV8feVHN7OeG4Jjg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op 14-12-12 15:11, Rob Clark schreef:
> On Fri, Dec 14, 2012 at 5:57 AM, Maarten Lankhorst
> <m.b.lankhorst@gmail.com> wrote:
>> Op 14-12-12 10:36, sumit.semwal@ti.com schreef:
>>> From: Sumit Semwal <sumit.semwal@linaro.org>
>>>
>>> Add debugfs support to make it easier to print debug information
>>> about the dma-buf buffers.
>>>
>> I like the idea, I don't know if it could be done in a free manner, but for bonus points
>> could we also have the dma-buf fd be obtainable that way from a debugfs entry?
>>
>> Doing so would allow me to 'steal' a dma-buf from an existing mapping easily, and test against that.
>>
>> Also I think the name of the device and process that exported the dma-buf would be useful
>> to have as well, even if in case of the device that would mean changing the api slightly to record it.
>>
>> I was thinking of having a directory structure like this:
>>
>> /sys/kernel/debug/dma_buf/stats
>>
>> and then for each dma-buf:
>>
>> /sys/kernel/debug/dma-buf/exporting_file.c/<number>-fd
>> /sys/kernel/debug/dma-buf/exporting_file.c/<number>-attachments
>> /sys/kernel/debug/dma-buf/exporting_file.c/<number>-info
>>
>> Opening the fd file would give you back the original fd, or fail with -EIO if refcount was dropped to 0.
>>
>> Would something like this be doable? I don't know debugfs that well, but I don't see why it wouldn't be,
> yeah.. but sort of back-door's the security benefits of an anonymous fd..
>
> BR,
> -R
If you have access to debugfs you're root, so what stops you from stealing it through a ptrace?

~Maarten
