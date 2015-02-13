Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:46804 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbbBMPr6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 10:47:58 -0500
MIME-Version: 1.0
In-Reply-To: <54DE192B.5060402@xs4all.nl>
References: <1423650827-16232-1-git-send-email-ricardo.ribalda@gmail.com>
 <54DE11FA.6050702@xs4all.nl> <CAPybu_0wpNU0m2jjmbff+-mcoU-dkKjpHoW8Hr-GPyWH4oGcgQ@mail.gmail.com>
 <54DE192B.5060402@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 13 Feb 2015 16:47:36 +0100
Message-ID: <CAPybu_1fw6qEmeXPrJVsTAoiY5=athE6FaakXznnbzd7fE7shw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] media/videobuf2-dma-sg: Fix handling of sg_table structure
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	martin.petersen@oracle.com, hch@lst.de, tonyb@cybernetics.com,
	axboe@fb.com, Stephen Rothwell <sfr@canb.auug.org.au>,
	lauraa@codeaurora.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	webbnh@hp.com, hare@suse.de,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all

On Fri, Feb 13, 2015 at 4:32 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Yes please. And if Ricardo is correct, then someone (janitor job?) should do
> a review of dma_unmap_sg in particular.

Perhaps a code snippet inside scatterlist.h will clarify even more.

Would any of the maintainers accept a patch to include a comment like:

struct sg_table *sgt;

sgt = kzalloc(sizeof(*sgt);
if (!sgt){
return -ENOMEM;
}

ret = sg_alloc_table(sgt, N_NENTS, GPF_KERNEL);
if (ret){
  kfree(sgt);
  return ret;
}

//Fill sgt using orig_nents or nents  as index

sgt->nents = dma_map_sg(dev, sgt->sgl, sgt->orig_nents, DIR);
if (!sgt->nents){
  sg_free_table(sgt);
  kfree(sgt);
  return -EIO;
}

//Use nent  as index

dma_unmap_sg(dev, sgt->sgl, sgt->orig_nents, DIR);
sg_free_table(sgt);
kfree(sgt);
return 0



Thanks!


-- 
Ricardo Ribalda
