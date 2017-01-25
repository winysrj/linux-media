Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f180.google.com ([209.85.213.180]:36246 "EHLO
        mail-yb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751360AbdAYJNK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jan 2017 04:13:10 -0500
Received: by mail-yb0-f180.google.com with SMTP id 123so4368318ybe.3
        for <linux-media@vger.kernel.org>; Wed, 25 Jan 2017 01:13:10 -0800 (PST)
Subject: Re: [RFC simple allocator v1 0/2] Simple allocator
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linaro-kernel@lists.linaro.org, arnd@arndb.de,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        robdclark@gmail.com, broonie@kernel.org,
        Sumit Semwal <sumit.semwal@linaro.org>
References: <1484926351-30185-1-git-send-email-benjamin.gaignard@linaro.org>
 <20170123083545.6l2jxlkdtmebxy5b@phenom.ffwll.local>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <87889ec2-e005-9071-e45f-049503c866ef@redhat.com>
Date: Wed, 25 Jan 2017 10:13:05 +0100
MIME-Version: 1.0
In-Reply-To: <20170123083545.6l2jxlkdtmebxy5b@phenom.ffwll.local>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/23/2017 09:35 AM, Daniel Vetter wrote:
> On Fri, Jan 20, 2017 at 04:32:29PM +0100, Benjamin Gaignard wrote:
>> The goal of this RFC is to understand if a common ioctl for specific memory
>> regions allocations is needed/welcome.
>>
>> Obviously it will not replace allocation done in linux kernel frameworks like
>> v4l2, drm/kms or others, but offer an alternative when you don't want/need to
>> use them for buffer allocation.
>> To keep a compatibility with what already exist allocated buffers are exported
>> in userland as dmabuf file descriptor (like ION is doing).
>>
>> "Unix Device Memory Allocator" project [1] wants to create a userland library
>> which may allow to select, depending of the devices constraint, the best
>> back-end for allocation. With this RFC I would to propose to have common ioctl
>> for a maximum of allocators to avoid to duplicated back-ends for this library.
>>
>> One of the issues that lead me to propose this RFC it is that since the beginning
>> it is a problem to allocate contiguous memory (CMA) without using v4l2 or
>> drm/kms so the first allocator available in this RFC use CMA memory.
>>
>> An other question is: do we have others memory regions that could be interested
>> by this new framework ? I have in mind that some title memory regions could use
>> it or replace ION heaps (system, carveout, etc...).
>> Maybe it only solve CMA allocation issue, in this case there is no need to create
>> a new framework but only a dedicated ioctl.
>>
>> Maybe the first thing to do is to change the name and the location of this
>> module, suggestions are welcome.
>>
>> I have testing this code with the following program:
>
> I'm still maintaining that we should just destage ION (with the todo items
> fixed), since that is already an uabi to do this (afaiui at least), and
> it's used on a few devices ... Please chat with Laura Abott.
> -Daniel
>

(I thought I sent this before but apparently it didn't go through.
Apologies if this ends up as a repeat for anyone)

I've been reviewing this as well. Even if Ion is used on a number of
devices, the model is still a bit clunky. I was hoping to see if it
could be re-written from scratch in a framework like this and then
either add a shim layer or just coax all devices out there to actually
convert to the new framework.

I supposed another option is to destage as you suggested and work on
an improved version in parallel.

Thanks,
Laura


