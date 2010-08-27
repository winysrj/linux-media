Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:57208 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab0H0O5U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Aug 2010 10:57:20 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id o7REvJGu027956
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 27 Aug 2010 09:57:19 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id o7REvJFi019027
	for <linux-media@vger.kernel.org>; Fri, 27 Aug 2010 09:57:19 -0500 (CDT)
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id o7REvJZP004116
	for <linux-media@vger.kernel.org>; Fri, 27 Aug 2010 09:57:19 -0500 (CDT)
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Warren, Christina" <cawarren@ti.com>,
	"Boateng, Akwasi" <akwasi.boateng@ti.com>
Date: Fri, 27 Aug 2010 09:57:17 -0500
Subject: [Query][videobuf-dma-sg] Pages in Highmem handling
Message-ID: <A24693684029E5489D1D202277BE8944719829DB@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

I see that in current videobuf library, for DMA SG code, these functions fail when
Detecting a page in Highmem region:

- videobuf_pages_to_sg
- videobuf_vmalloc_to_sg

Now, what's the real reason to not allow handling of Highmem pages?
Is it an assumption that _always_ HighMem is not reachable by DMA?

I guess my point is, OMAP platform (and maybe other platforms) can handle
Highmem pages without any problem. I commented these validations:

65 static struct scatterlist *videobuf_vmalloc_to_sg(unsigned char *virt,
66                                                   int nr_pages)
67 {

...

77         for (i = 0; i < nr_pages; i++, virt += PAGE_SIZE) {
78                 pg = vmalloc_to_page(virt);
79                 if (NULL == pg)
80                         goto err;
81                 /* BUG_ON(PageHighMem(pg)); */

...

96 static struct scatterlist *videobuf_pages_to_sg(struct page **pages,
97                                                 int nr_pages, int offset)
98 {

...

109         /* if (PageHighMem(pages[0])) */
110                 /* DMA to highmem pages might not work */
111                 /* goto highmem; */
112         sg_set_page(&sglist[0], pages[0], PAGE_SIZE - offset, offset);
113         for (i = 1; i < nr_pages; i++) {
114                 if (NULL == pages[i])
115                         goto nopage;
116                 /* if (PageHighMem(pages[i]))
117                         goto highmem; */
118                 sg_set_page(&sglist[i], pages[i], PAGE_SIZE, 0);
119         }

Can somebody shed any light on this?

Regards,
Sergio
