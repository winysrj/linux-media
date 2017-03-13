Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29699 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751058AbdCMLwT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 07:52:19 -0400
Date: Mon, 13 Mar 2017 14:51:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: mchehab@kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, alan@linux.intel.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: atomisp: use k{v}zalloc instead of k{v}alloc
 and memset
Message-ID: <20170313115129.GC4136@mwanda>
References: <20170313105421.GA32342@SEL-JYOUN-D1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170313105421.GA32342@SEL-JYOUN-D1>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 13, 2017 at 07:54:21PM +0900, Daeseok Youn wrote:
> If the atomisp_kernel_zalloc() has "true" as a second parameter, it
> tries to allocate zeroing memory from kmalloc(vmalloc) and memset.
> But using kzalloc is rather than kmalloc followed by memset with 0.
> (vzalloc is for same reason with kzalloc)
> 
> And also atomisp_kernel_malloc() can be used with
> atomisp_kernel_zalloc(<size>, false);
> 

We should just change all the callers to kvmalloc() and kvzmalloc().

regards,
dan carpenter
