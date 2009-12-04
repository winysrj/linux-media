Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:61510 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756AbZLDLFi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2009 06:05:38 -0500
Received: by ywh12 with SMTP id 12so2442634ywh.21
        for <linux-media@vger.kernel.org>; Fri, 04 Dec 2009 03:05:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155B76E2F@dlee06.ent.ti.com>
References: <1259681414-30246-1-git-send-email-m-karicheri2@ti.com>
	 <aec7e5c30912011904o285ff2d8w25ad6868a352a1b5@mail.gmail.com>
	 <A69FA2915331DC488A831521EAE36FE40155B76E2F@dlee06.ent.ti.com>
Date: Fri, 4 Dec 2009 20:05:44 +0900
Message-ID: <aec7e5c30912040305j5ca179b3u7156c15050a0dc8b@mail.gmail.com>
Subject: Re: [PATCH] V4L - Fix videobuf_dma_contig_user_get() getting page
	aligned physical address
From: Magnus Damm <magnus.damm@gmail.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi again Murali,

Thanks for your work on this.

On Thu, Dec 3, 2009 at 12:48 AM, Karicheri, Muralidharan
<m-karicheri2@ti.com> wrote:
> Magnus,
>
>>Thanks for the patch. For non-page aligned user space pointers I agree
>>that a fix is needed. Don't you think the while loop in
>>videobuf_dma_contig_user_get() also needs to be adjusted to include
>>the last page? I think the while loop checks one page too little in
>>the non-aligned case today.
>
> Thanks for reviewing my patch. It had worked for non-aligned address in
> my testing. If I understand this code correctly, the physical address of
> the user page start is determined in the first loop (pages_done == 0)
> and additional loops are run to make sure the memory is physically
> contiguous. Initially the mem->size is set to number of pages aligned to
> page size.
>
> Assume we pass 4097 bytes as size.
>
> mem->size = PAGE_ALIGN(vb->size); => 2
>
> Inside the loop, iteration is done for 0 to pages-1.
>
> pages_done < (mem->size >> 12) => pages_done < 2 => iterate 2 times
>
> For size of 4096, we iterate once.
> For size of 4095, we iterate once.
>
> So IMO the loop is already iterate one more time when we pass non-aligned address since size is aligned to include the last page. So based on this
> could you ack my patch so that we could ask Mauro to merge it with priority?

I think your observations are correct, but I also think there is one
more hidden issue. In the case where the offset within the page is
other than 0 then we should loop once more to also check the final
page. Right now no one is checking if the last page is contiguous or
not in the case on non-page-aligned offset..

So in your case with a 4096 or 4095 size, but if the offset withing
the page is non-zero then we should loop twice to make sure the pages
really are physically contiguous. Today we only loop once based on the
size. We should also include the offset in the calculation of number
of pages to check.

If you can include that fix in your patch that would be great. If not
then i'll fix it up myself.

Thanks!

/ magnus
