Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:46621 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbbA3QDc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2015 11:03:32 -0500
Message-ID: <54CBAB4E.3040805@xs4all.nl>
Date: Fri, 30 Jan 2015 17:03:26 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>
CC: LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] media: ti-vpe: Use mem-to-mem ioctl helpers
References: <1418997124-28426-1-git-send-email-prabhakar.csengg@gmail.com> <CA+V-a8uGcVnVCJ6bD9kC0n0JpVh=QR-r7SD5Eu9vwAWk0RvHDg@mail.gmail.com>
In-Reply-To: <CA+V-a8uGcVnVCJ6bD9kC0n0JpVh=QR-r7SD5Eu9vwAWk0RvHDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

I might have time on Monday, but that is almost certainly too late
for 3.20. It's a bit busy at the moment.

Sorry,

	Hans

On 01/30/2015 04:54 PM, Lad, Prabhakar wrote:
> Hello Hans/Kamil,
> 
> On Fri, Dec 19, 2014 at 1:52 PM, Lad, Prabhakar
> <prabhakar.csengg@gmail.com> wrote:
>> 1: Simplify the vpe mem-to-mem driver by using the m2m ioctl
>>    and vb2 helpers.
>> 2: Align and arranged the v4l2_ioctl_ops.
>> 3: Fixes a typo.
>> 4: Use of_match_ptr() instead of explicitly defining the macro
>>    to NULL in case CONFIG_OF is not defined.
>>
> Can you please review and queue this patch for v3.20 ?
> 
> Cheers,
> --Prabhakar Lad
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
