Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59614 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754323AbdCXNrP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 09:47:15 -0400
Date: Fri, 24 Mar 2017 14:46:58 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Cox <alan@linux.intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: media: atomisp: remove ifdef around HMM_BO_ION
Message-ID: <20170324134658.GA26415@kroah.com>
References: <20170324132127.3199892-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170324132127.3199892-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 24, 2017 at 02:20:24PM +0100, Arnd Bergmann wrote:
> The revert reintroduced a build failure without CONFIG_ION:
> 
> media/atomisp/pci/atomisp2/hmm/hmm.c:52:2: error: excess elements in array initializer [-Werror]
> media/atomisp/pci/atomisp2/hmm/hmm.c:52:2: note: (near initialization for 'hmm_bo_type_strings')
> 
> We should really be able to build in any configuration, so this tries a
> different fix to make sure the symbol is defined.
> 
> Fixes: 9ca98bd07748 ("Revert "staging: media: atomisp: fill properly hmm_bo_type_strings when ION is disabled"")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo.h | 2 --
>  1 file changed, 2 deletions(-)

Ugh, Alan, what's going on here, I thought you fixed this?

totally confused,

greg k-h
