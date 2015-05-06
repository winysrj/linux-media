Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42823 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbbEFPBy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 11:01:54 -0400
Date: Wed, 6 May 2015 17:01:49 +0200
From: Jan Kara <jack@suse.cz>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	dri-devel@lists.freedesktop.org, Pawel Osciak <pawel@osciak.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	mgorman@suse.de, Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 3/9] media: omap_vout: Convert
 omap_vout_uservirt_to_phys() to use get_vaddr_pfns()
Message-ID: <20150506150149.GB27648@quack.suse.cz>
References: <1430897296-5469-1-git-send-email-jack@suse.cz>
 <1430897296-5469-4-git-send-email-jack@suse.cz>
 <5549F112.1000405@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5549F112.1000405@suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 06-05-15 12:46:42, Vlastimil Babka wrote:
> On 05/06/2015 09:28 AM, Jan Kara wrote:
> >Convert omap_vout_uservirt_to_phys() to use get_vaddr_pfns() instead of
> >hand made mapping of virtual address to physical address. Also the
> >function leaked page reference from get_user_pages() so fix that by
> >properly release the reference when omap_vout_buffer_release() is
> >called.
> >
> >Signed-off-by: Jan Kara <jack@suse.cz>
> >---
> >  drivers/media/platform/omap/omap_vout.c | 67 +++++++++++++++------------------
> >  1 file changed, 31 insertions(+), 36 deletions(-)
> >
> 
> ...
> 
> >+	vec = frame_vector_create(1);
> >+	if (!vec)
> >+		return -ENOMEM;
> >
> >-		if (res == nr_pages) {
> >-			physp =  __pa(page_address(&pages[0]) +
> >-					(virtp & ~PAGE_MASK));
> >-		} else {
> >-			printk(KERN_WARNING VOUT_NAME
> >-					"get_user_pages failed\n");
> >-			return 0;
> >-		}
> >+	ret = get_vaddr_frames(virtp, 1, 1, 0, vec);
> 
> Use true/false where appropriate.
  Right. Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
