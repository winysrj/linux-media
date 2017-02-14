Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44926 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752366AbdBNTlr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 14:41:47 -0500
Date: Tue, 14 Feb 2017 11:41:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        stable@vger.kernel.org, #@smtp.w2.samsung.com,
        For@smtp.w2.samsung.com, 4.9+@smtp.w2.samsung.com
Subject: Re: [PATCH] siano: make it work again with CONFIG_VMAP_STACK
Message-ID: <20170214194146.GA28566@kroah.com>
References: <08f1b470a156163cc3394f73bcbaea3925b6f376.1487100723.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08f1b470a156163cc3394f73bcbaea3925b6f376.1487100723.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 14, 2017 at 05:32:11PM -0200, Mauro Carvalho Chehab wrote:
> Reported as a Kaffeine bug:
> 	https://bugs.kde.org/show_bug.cgi?id=375811
> 
> The USB control messages require DMA to work. We cannot pass
> a stack-allocated buffer, as it is not warranted that the
> stack would be into a DMA enabled area.
> 
> On Kernel 4.9, the default is to not accept DMA on stack anymore.
> 
> Tested with USB ID 2040:5510: Hauppauge Windham
> 
> Cc: stable@vger.kernel.org # For 4.9+

Unless there is some major reason, this should go into _all_ stable
releases, as the driver would be broken on them all for platforms that
can't handle USB data that is not DMA-able.  This has been a requirement
for USB drivers since the 2.2 days.

thanks,

greg k-h
