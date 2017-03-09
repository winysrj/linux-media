Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43486 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754730AbdCIRK7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 12:10:59 -0500
Date: Thu, 9 Mar 2017 17:46:35 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: simran singhal <singhalsimran0@gmail.com>
Cc: mchehab@kernel.org, devel@driverdev.osuosl.org,
        outreachy-kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: media: Remove parentheses from return arguments
Message-ID: <20170309164635.GC12365@kroah.com>
References: <20170303170139.GA9887@singhal-Inspiron-5558>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170303170139.GA9887@singhal-Inspiron-5558>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 03, 2017 at 10:31:39PM +0530, simran singhal wrote:
> The sematic patch used for this is:
> @@
> identifier i;
> constant c;
> @@
> return
> - (
>     \(i\|-i\|i(...)\|c\)
> - )
>   ;
> 
> Signed-off-by: simran singhal <singhalsimran0@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
>  .../media/atomisp/pci/atomisp2/css2400/sh_css.c      | 20 ++++++++++----------
>  .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c   |  2 +-
>  2 files changed, 11 insertions(+), 11 deletions(-)

Again, one patch per driver.
