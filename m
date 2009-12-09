Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:35468 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbZLIPeY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 10:34:24 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Magnus Damm <magnus.damm@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"mchehab@infradead.org" <mchehab@infradead.org>
Date: Wed, 9 Dec 2009 09:34:06 -0600
Subject: RE: [PATCH - v1] V4L-Fix videobuf_dma_contig_user_get() for
 	non-aligned offsets
Message-ID: <A69FA2915331DC488A831521EAE36FE40155C80479@dlee06.ent.ti.com>
References: <1260308217-22871-1-git-send-email-m-karicheri2@ti.com>
 <aec7e5c30912090459q1854c483hdfbe370a73ea94a8@mail.gmail.com>
In-Reply-To: <aec7e5c30912090459q1854c483hdfbe370a73ea94a8@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Magnus,

Thanks for testing and approving the patch.

Mauro,

Could you merge this bug fix?

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Magnus Damm [mailto:magnus.damm@gmail.com]
>Sent: Wednesday, December 09, 2009 8:00 AM
>To: Karicheri, Muralidharan
>Cc: linux-media@vger.kernel.org
>Subject: Re: [PATCH - v1] V4L-Fix videobuf_dma_contig_user_get() for non-
>aligned offsets
>
>On Wed, Dec 9, 2009 at 6:36 AM,  <m-karicheri2@ti.com> wrote:
>> From: Muralidharan Karicheri <m-karicheri2@ti.com>
>>
>> If a USERPTR address that is not aligned to page boundary is passed to
>the
>> videobuf_dma_contig_user_get() function, it saves a page aligned address
>to
>> the dma_handle. This is not correct. This issue is observed when using
>USERPTR
>> IO machism for buffer exchange.
>>
>> Updates from last version:-
>>
>> Adding offset for size calculation as per comment from Magnus Damm. This
>> ensures the last page is also included for checking if memory is
>> contiguous.
>>
>> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
>
>Hi Murali,
>
>I've spent some time testing this patch with the SuperH CEU driver in
>USERPTR mode. My test case is based on capture.c with places a bunch
>of QVGA frames directly after each other. The size of each QVGA frame
>is not an even multiple of 4k page size, so some of the frames will
>use a non-aligned start addresses. Currently the CEU driver page
>aligns the size of each frame, but I'll fix that in an upcoming patch.
>Thank you!
>
>Acked-by: Magnus Damm <damm@opensource.se>
