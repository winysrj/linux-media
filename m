Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:40995 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab1CHMIm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 07:08:42 -0500
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LHQ00J64N2HN010@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 Mar 2011 21:08:41 +0900 (KST)
Received: from JONGHUNHA11 ([12.23.103.140])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LHQ00C26N2HLT@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 Mar 2011 21:08:41 +0900 (KST)
Date: Tue, 08 Mar 2011 21:08:31 +0900
From: Jonghun Han <jonghun.han@samsung.com>
Subject: RE: Yet another memory provider: can linaro organize a meeting?
In-reply-to: <AANLkTinu8qGRUZfbO7FENmH58o_7dE60qbVWSqVWJRrr@mail.gmail.com>
To: 'Kyungmin Park' <kmpark@infradead.org>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linaro-dev@lists.linaro.org, linux-media@vger.kernel.org
Message-id: <000501cbdd89$90702dc0$b1508940$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-language: ko
Content-transfer-encoding: 8BIT
References: <201103080913.59231.hverkuil@xs4all.nl>
 <AANLkTinu8qGRUZfbO7FENmH58o_7dE60qbVWSqVWJRrr@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Thanks for interesting.

As I know, the purpose of UMP is the buffer sharing especially inter-process
.
Maybe ARM can explain it more detail.

High resolution video/image processing requires zero-copy operation.
UMP allows zero-copy operation using system unique key, named SecureID.
UMP supports memory allocation. (custom memory allocator can be used.)
It gives a SecureID for each buffer during allocation.
And user virtual address for each process can be made by SecureID.
Application can access the buffer using its own virtual address made by
SecureID.
So application can share the buffer without copy operation.

For example, video playback application can share the buffer even though it
consists of multiple process.

Best regards,
Jonghun Han

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Kyungmin Park
> Sent: Tuesday, March 08, 2011 8:06 PM
> To: Hans Verkuil
> Cc: linaro-dev@lists.linaro.org; linux-media@vger.kernel.org; Jonghun Han
> Subject: Re: Yet another memory provider: can linaro organize a meeting?
> 
> Dear Jonghun,
> 
> It's also helpful to explain what's the original purpose of UMP (for GPU,
> MALI) and what's the goal of UMP usage for multimedia stack.
> Especially, what's the final goal of UMP from LSI.
> 
> Also consider the previous GPU memory management program, e.g., SGX.
> 
> Thank you,
> Kyungmin Park
> 
> On Tue, Mar 8, 2011 at 5:13 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Hi all,
> >
> > We had a discussion yesterday regarding ways in which linaro can
> > assist
> > V4L2 development. One topic was that of sorting out memory providers
> > like GEM and HWMEM.
> >
> > Today I learned of yet another one: UMP from ARM.
> >
> > http://blogs.arm.com/multimedia/249-making-the-mali-gpu-device-driver-
> > open-source/page__cid__133__show__newcomment/
> >
> > This is getting out of hand. I think that organizing a meeting to
> > solve this mess should be on the top of the list. Companies keep on
> > solving the same problem time and again and since none of it enters
> > the mainline kernel any driver using it is also impossible to upstream.
> >
> > All these memory-related modules have the same purpose: make it
> > possible to allocate/reserve large amounts of memory and share it
> > between different subsystems (primarily framebuffer, GPU and V4L).
> >
> > It really shouldn't be that hard to get everyone involved together and
> > settle on a single solution (either based on an existing proposal or
> > create a 'the best of' vendor-neutral solution).
> >
> > I am currently aware of the following solutions floating around the
> > net that all solve different parts of the problem:
> >
> > In the kernel: GEM and TTM.
> > Out-of-tree: HWMEM, UMP, CMA, VCM, CMEM, PMEM.
> >
> > I'm sure that last list is incomplete.
> >
> > Regards,
> >
> >        Hans
> >
> > --
> > Hans Verkuil - video4linux developer - sponsored by Cisco
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

