Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:48206 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759686AbbA3Pz0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2015 10:55:26 -0500
MIME-Version: 1.0
In-Reply-To: <1418997124-28426-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1418997124-28426-1-git-send-email-prabhakar.csengg@gmail.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Fri, 30 Jan 2015 15:54:55 +0000
Message-ID: <CA+V-a8uGcVnVCJ6bD9kC0n0JpVh=QR-r7SD5Eu9vwAWk0RvHDg@mail.gmail.com>
Subject: Re: [PATCH v2] media: ti-vpe: Use mem-to-mem ioctl helpers
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans/Kamil,

On Fri, Dec 19, 2014 at 1:52 PM, Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
> 1: Simplify the vpe mem-to-mem driver by using the m2m ioctl
>    and vb2 helpers.
> 2: Align and arranged the v4l2_ioctl_ops.
> 3: Fixes a typo.
> 4: Use of_match_ptr() instead of explicitly defining the macro
>    to NULL in case CONFIG_OF is not defined.
>
Can you please review and queue this patch for v3.20 ?

Cheers,
--Prabhakar Lad
