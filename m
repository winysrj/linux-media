Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33076 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbbFKIAv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 04:00:51 -0400
Received: by padev16 with SMTP id ev16so49111199pad.0
        for <linux-media@vger.kernel.org>; Thu, 11 Jun 2015 01:00:51 -0700 (PDT)
Date: Thu, 11 Jun 2015 17:01:15 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
	Cyrill Gorcunov <gorcunov@openvz.org>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Paul Cassella <cassella@cray.com>,
	Steve Capper <steve.capper@linaro.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/9] mm: Provide new get_vaddr_frames() helper
Message-ID: <20150611080115.GB515@swordfish>
References: <cover.1433927458.git.mchehab@osg.samsung.com>
 <f8d212d88c005564f3faedf1c7d6f089fcb3126d.1433927458.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8d212d88c005564f3faedf1c7d6f089fcb3126d.1433927458.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On (06/10/15 06:20), Mauro Carvalho Chehab wrote:
[..]
> +
> +/**
> + * frame_vector_destroy() - free memory allocated to carry frame vector
> + * @vec:	Frame vector to free
> + *
> + * Free structure allocated by frame_vector_create() to carry frames.
> + */
> +void frame_vector_destroy(struct frame_vector *vec)
> +{
> +	/* Make sure put_vaddr_frames() got called properly... */
> +	VM_BUG_ON(vec->nr_frames > 0);
> +	if (!is_vmalloc_addr(vec))
> +		kfree(vec);
> +	else
> +		vfree(vec);

minor:  kvfree(vec);

	-ss
