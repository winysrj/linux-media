Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:41573 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbZLBPs4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 10:48:56 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Magnus Damm <magnus.damm@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Wed, 2 Dec 2009 09:48:55 -0600
Subject: RE: [PATCH] V4L - Fix videobuf_dma_contig_user_get() getting page
 	aligned physical address
Message-ID: <A69FA2915331DC488A831521EAE36FE40155B76E2F@dlee06.ent.ti.com>
References: <1259681414-30246-1-git-send-email-m-karicheri2@ti.com>
 <aec7e5c30912011904o285ff2d8w25ad6868a352a1b5@mail.gmail.com>
In-Reply-To: <aec7e5c30912011904o285ff2d8w25ad6868a352a1b5@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Magnus,

>Thanks for the patch. For non-page aligned user space pointers I agree
>that a fix is needed. Don't you think the while loop in
>videobuf_dma_contig_user_get() also needs to be adjusted to include
>the last page? I think the while loop checks one page too little in
>the non-aligned case today.
>
>Cheers,
>
>/ magnus

Thanks for reviewing my patch. It had worked for non-aligned address in
my testing. If I understand this code correctly, the physical address of
the user page start is determined in the first loop (pages_done == 0)
and additional loops are run to make sure the memory is physically
contiguous. Initially the mem->size is set to number of pages aligned to
page size. 

Assume we pass 4097 bytes as size.

mem->size = PAGE_ALIGN(vb->size); => 2

Inside the loop, iteration is done for 0 to pages-1.

pages_done < (mem->size >> 12) => pages_done < 2 => iterate 2 times

For size of 4096, we iterate once.
For size of 4095, we iterate once.

So IMO the loop is already iterate one more time when we pass non-aligned address since size is aligned to include the last page. So based on this
could you ack my patch so that we could ask Mauro to merge it with priority?

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com
