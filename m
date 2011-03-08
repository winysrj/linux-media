Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41324 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab1CHLFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 06:05:43 -0500
Received: by wwa36 with SMTP id 36so949195wwa.1
        for <linux-media@vger.kernel.org>; Tue, 08 Mar 2011 03:05:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201103080913.59231.hverkuil@xs4all.nl>
References: <201103080913.59231.hverkuil@xs4all.nl>
Date: Tue, 8 Mar 2011 20:05:41 +0900
Message-ID: <AANLkTinu8qGRUZfbO7FENmH58o_7dE60qbVWSqVWJRrr@mail.gmail.com>
Subject: Re: Yet another memory provider: can linaro organize a meeting?
From: Kyungmin Park <kmpark@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linaro-dev@lists.linaro.org, linux-media@vger.kernel.org,
	Jonghun Han <jonghun.han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dear Jonghun,

It's also helpful to explain what's the original purpose of UMP (for
GPU, MALI) and what's the goal of UMP usage for multimedia stack.
Especially, what's the final goal of UMP from LSI.

Also consider the previous GPU memory management program, e.g., SGX.

Thank you,
Kyungmin Park

On Tue, Mar 8, 2011 at 5:13 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi all,
>
> We had a discussion yesterday regarding ways in which linaro can assist
> V4L2 development. One topic was that of sorting out memory providers like
> GEM and HWMEM.
>
> Today I learned of yet another one: UMP from ARM.
>
> http://blogs.arm.com/multimedia/249-making-the-mali-gpu-device-driver-open-source/page__cid__133__show__newcomment/
>
> This is getting out of hand. I think that organizing a meeting to solve this
> mess should be on the top of the list. Companies keep on solving the same
> problem time and again and since none of it enters the mainline kernel any
> driver using it is also impossible to upstream.
>
> All these memory-related modules have the same purpose: make it possible to
> allocate/reserve large amounts of memory and share it between different
> subsystems (primarily framebuffer, GPU and V4L).
>
> It really shouldn't be that hard to get everyone involved together and settle
> on a single solution (either based on an existing proposal or create a 'the
> best of' vendor-neutral solution).
>
> I am currently aware of the following solutions floating around the net
> that all solve different parts of the problem:
>
> In the kernel: GEM and TTM.
> Out-of-tree: HWMEM, UMP, CMA, VCM, CMEM, PMEM.
>
> I'm sure that last list is incomplete.
>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by Cisco
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
