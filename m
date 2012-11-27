Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63387 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933031Ab2K0JZb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 04:25:31 -0500
MIME-Version: 1.0
In-Reply-To: <50B4711D.3060702@samsung.com>
References: <1353995979-28792-1-git-send-email-prabhakar.lad@ti.com>
 <50B46A83.8020703@samsung.com> <CA+V-a8tLvO2dywNNS8ykpsiCMiuSuVNF2QPCk+CrevVtDxxxsg@mail.gmail.com>
 <50B4711D.3060702@samsung.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 27 Nov 2012 14:55:10 +0530
Message-ID: <CA+V-a8v+PkvPSo-kO=s0ZZRCf6WHUfo3bicRC+Svr1XVu0XSVQ@mail.gmail.com>
Subject: Re: [PATCH] media: fix a typo CONFIG_HAVE_GENERIC_DMA_COHERENT in videobuf2-dma-contig.c
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, Nov 27, 2012 at 1:21 PM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hello,
>
>
> On 11/27/2012 8:39 AM, Prabhakar Lad wrote:
>>
>> Hi Marek,
>>
>> On Tue, Nov 27, 2012 at 12:53 PM, Marek Szyprowski
>> <m.szyprowski@samsung.com> wrote:
>> > Hello,
>> >
>> >
>> > On 11/27/2012 6:59 AM, Prabhakar Lad wrote:
>> >>
>> >> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>> >>
>> >> from commit 93049b9368a2e257ace66252ab2cc066f3399cad, which adds
>> >> a check HAVE_GENERIC_DMA_COHERENT for dma ops, the check was wrongly
>> >> made it should have been HAVE_GENERIC_DMA_COHERENT but it was
>> >> CONFIG_HAVE_GENERIC_DMA_COHERENT.
>> >> This patch fixes the typo, which was causing following build error:
>> >>
>> >> videobuf2-dma-contig.c:743: error: 'vb2_dc_get_dmabuf' undeclared here
>> >> (not in a function)
>> >> make[3]: *** [drivers/media/v4l2-core/videobuf2-dma-contig.o] Error 1
>> >>
>> >> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> >> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>> >
>> >
>> > The CONFIG_HAVE_GENERIC_DMA_COHERENT based patch was a quick workaround
>> > for the build problem in linux-next and should be reverted now. The
>> > correct patch has been posted for drivers/base/dma-mapping.c to LKML,
>> > see http://www.spinics.net/lists/linux-next/msg22890.html
>>
>> I was referring to this patch from Mauro,
>>
>> http://git.linuxtv.org/media_tree.git/commitdiff/93049b9368a2e257ace66252ab2cc066f3399cad
>> which introduced this build error.
>
>
> I know, with my patch the workaround introduced by Mauro is not needed at
> all.
>
Thanks for clarifying I'll drop this patch,  I hope Mauro will revert
his changes.

Regards,
--Prabhakar

>
> Best regards
> --
> Marek Szyprowski
> Samsung Poland R&D Center
>
>
