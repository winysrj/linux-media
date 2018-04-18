Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43782 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750981AbeDRSgP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 14:36:15 -0400
Date: Wed, 18 Apr 2018 11:36:07 -0700
From: Matthew Wilcox <willy@infradead.org>
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: sakari.ailus@iki.fi, mchehab@kernel.org, jack@suse.cz,
        dan.j.williams@intel.com, akpm@linux-foundation.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] media: v4l2-core: videobuf-dma-sg: Change return type
 to vm_fault_t
Message-ID: <20180418183607.GB30953@bombadil.infradead.org>
References: <20180418181919.GA25052@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418181919.GA25052@jordon-HP-15-Notebook-PC>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 18, 2018 at 11:49:19PM +0530, Souptick Joarder wrote:
> Use new return type vm_fault_t for fault handler. For
> now, this is just documenting that the function returns
> a VM_FAULT value rather than an errno. Once all instances
> are converted, vm_fault_t will become a distinct type.
> 
> Reference id -> 1c8f422059ae ("mm: change return type to
> vm_fault_t")
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> v2: Updated patch subject

I'm pretty sure what Sakari meant was:

videobuf: Change return type to vm_fault_t
