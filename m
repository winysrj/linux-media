Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:35643 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751996AbdHHM1G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 08:27:06 -0400
Message-ID: <1502195141.4561.1.camel@linux.intel.com>
Subject: Re: [PATCH] staging: media: atomisp: use kvmalloc/kvzalloc
From: Alan Cox <alan@linux.intel.com>
To: Geliang Tang <geliangtang@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <6718b1734dc8f657d91b37c7c59f3b709719670c.1502090593.git.geliangtang@gmail.com>
References: <5f901760510d0dc6e6e971d4136c8d2d4e0a13fd.1502103408.git.geliangtang@gmail.com>
         <6718b1734dc8f657d91b37c7c59f3b709719670c.1502090593.git.geliangtang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Aug 2017 13:25:41 +0100
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-08-07 at 21:44 +0800, Geliang Tang wrote:
> Use kvmalloc()/kvzalloc() instead of atomisp_kernel_malloc()
> /atomisp_kernel_zalloc().
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Definitely better now we have kvmalloc/kvzalloc.

Thanks

Alan
