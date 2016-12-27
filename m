Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45744 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752694AbcL0LvR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Dec 2016 06:51:17 -0500
Date: Tue, 27 Dec 2016 13:51:11 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jan Kara <jack@suse.cz>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH 0/8] [media] v4l2-core: Fine-tuning for some function
 implementations
Message-ID: <20161227115111.GN16630@valkosipuli.retiisi.org.uk>
References: <9268b60d-08ba-c64e-1848-f84679d64f80@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9268b60d-08ba-c64e-1848-f84679d64f80@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

On Mon, Dec 26, 2016 at 09:41:19PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 26 Dec 2016 21:30:12 +0100
> 
> Some update suggestions were taken into account
> from static source code analysis.
> 
> Markus Elfring (8):
>   v4l2-async: Use kmalloc_array() in v4l2_async_notifier_unregister()
>   v4l2-async: Delete an error message for a failed memory allocation in v4l2_async_notifier_unregister()
>   videobuf-dma-sg: Use kmalloc_array() in videobuf_dma_init_user_locked()
>   videobuf-dma-sg: Adjust 24 checks for null values
>   videobuf-dma-sg: Move two assignments for error codes in __videobuf_mmap_mapper()
>   videobuf-dma-sg: Improve a size determination in __videobuf_mmap_mapper()
>   videobuf-dma-sg: Delete an unnecessary return statement in videobuf_vm_close()
>   videobuf-dma-sg: Add some spaces for better code readability in videobuf_dma_init_user_locked()

I don't really disagree with the videobuf changes as such --- the original
code sure seems quite odd, but I wonder whether we want to do this kind of
cleanups in videobuf. Videobuf will be removed likely in not too distant
future; when exactly, Hans can guesstimate better than me. Cc him.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
