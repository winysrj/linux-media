Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbbEFKqo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 06:46:44 -0400
Message-ID: <5549F112.1000405@suse.cz>
Date: Wed, 06 May 2015 12:46:42 +0200
From: Vlastimil Babka <vbabka@suse.cz>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, linux-mm@kvack.org
CC: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	dri-devel@lists.freedesktop.org, Pawel Osciak <pawel@osciak.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	mgorman@suse.de, Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 3/9] media: omap_vout: Convert omap_vout_uservirt_to_phys()
 to use get_vaddr_pfns()
References: <1430897296-5469-1-git-send-email-jack@suse.cz> <1430897296-5469-4-git-send-email-jack@suse.cz>
In-Reply-To: <1430897296-5469-4-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/06/2015 09:28 AM, Jan Kara wrote:
> Convert omap_vout_uservirt_to_phys() to use get_vaddr_pfns() instead of
> hand made mapping of virtual address to physical address. Also the
> function leaked page reference from get_user_pages() so fix that by
> properly release the reference when omap_vout_buffer_release() is
> called.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>   drivers/media/platform/omap/omap_vout.c | 67 +++++++++++++++------------------
>   1 file changed, 31 insertions(+), 36 deletions(-)
>

...

> +	vec = frame_vector_create(1);
> +	if (!vec)
> +		return -ENOMEM;
>
> -		if (res == nr_pages) {
> -			physp =  __pa(page_address(&pages[0]) +
> -					(virtp & ~PAGE_MASK));
> -		} else {
> -			printk(KERN_WARNING VOUT_NAME
> -					"get_user_pages failed\n");
> -			return 0;
> -		}
> +	ret = get_vaddr_frames(virtp, 1, 1, 0, vec);

Use true/false where appropriate.
