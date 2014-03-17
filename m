Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2296 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbaCQUxf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 16:53:35 -0400
Message-ID: <532760CF.10704@intel.com>
Date: Mon, 17 Mar 2014 13:53:35 -0700
From: Dave Hansen <dave.hansen@intel.com>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, linux-mm@kvack.org
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/9] mm: Provide new get_vaddr_pfns() helper
References: <1395085776-8626-1-git-send-email-jack@suse.cz> <1395085776-8626-2-git-send-email-jack@suse.cz>
In-Reply-To: <1395085776-8626-2-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/17/2014 12:49 PM, Jan Kara wrote:
> +int get_vaddr_pfns(unsigned long start, int nr_pfns, int write, int force,
> +		   struct pinned_pfns *pfns)
> +{
...
> +	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
> +		pfns->got_ref = 1;
> +		pfns->is_pages = 1;
> +		ret = get_user_pages(current, mm, start, nr_pfns, write, force,
> +				     pfns_vector_pages(pfns), NULL);
> +		goto out;
> +	}

Have you given any thought to how this should deal with VM_MIXEDMAP
vmas?  get_user_pages() will freak when it hits the !vm_normal_page()
test on the pfnmapped ones, and jump out.  Shouldn't get_vaddr_pfns() be
able to handle those too?
