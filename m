Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53130 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1CUNjP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 09:39:15 -0400
Received: by wya21 with SMTP id 21so5765251wya.19
        for <linux-media@vger.kernel.org>; Mon, 21 Mar 2011 06:39:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1103211139560.21013@axis700.grange>
References: <1300109904-3991-1-git-send-email-pawel@osciak.com>
 <1300109904-3991-2-git-send-email-pawel@osciak.com> <Pine.LNX.4.64.1103211139560.21013@axis700.grange>
From: Pawel Osciak <pawel@osciak.com>
Date: Mon, 21 Mar 2011 06:38:53 -0700
Message-ID: <AANLkTin+dsWGOMh+yTfZx_Bp=G0sEO+5-yMzPMmBsgU=@mail.gmail.com>
Subject: Re: [PATCH 2/2] [media] videobuf2-dma-contig: make cookie() return a
 pointer to dma_addr_t
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	hverkuil@xs4all.nl
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Mon, Mar 21, 2011 at 03:47, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Mon, 14 Mar 2011, Pawel Osciak wrote:
>
>> dma_addr_t may not fit into void* on some architectures. To be safe, make
>> vb2_dma_contig_cookie() return a pointer to dma_addr_t and dereference it
>> in vb2_dma_contig_plane_paddr() back to dma_addr_t.
>>
>> Signed-off-by: Pawel Osciak <pawel@osciak.com>
>> Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
>
> Right, it is correct, that this patch is submitted as "2/2" with
> "sh_mobile_ceu_camera: Do not call vb2's mem_ops directly" being "1/2."
> The only slight difficulty is, that this patch should go directly to
> Mauro or via some vb2 tree, if one exists, whereas "1/2" I would normally
> take via my tree. Hence the question: should I take them both via my tree,
> or should I only take "1/2" and we take care to merge this one after it?
> Assuming, there are no objections against this one.

I attached 2/2 for reference, please take 1/2 and I will take care to
ask Mauro to pull 2/2, unless you prefer to pull both.

Thanks,
-- 
Pawel Osciak
