Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39576 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752443AbdCWNht (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Mar 2017 09:37:49 -0400
Date: Thu, 23 Mar 2017 14:37:33 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geliang Tang <geliangtang@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Alan Cox <alan@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        simran singhal <singhalsimran0@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: media: atomisp: use kvmalloc and kvfree
Message-ID: <20170323133733.GA16056@kroah.com>
References: <328d0eb3da461aaaa6140b1409ee7550bcec87bb.1490261279.git.geliangtang@gmail.com>
 <7ac949fbedccaa86c27db0dd045f10be97ec74b1.1490261637.git.geliangtang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ac949fbedccaa86c27db0dd045f10be97ec74b1.1490261637.git.geliangtang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 23, 2017 at 09:12:39PM +0800, Geliang Tang wrote:
> Use kvmalloc() and kvfree() instead of open-coding.

These functions are not in Linus's tree, so I can't apply this patch
without breaking things :(

thanks,

greg k-h
