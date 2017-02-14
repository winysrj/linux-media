Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41423
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753598AbdBNTqF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 14:46:05 -0500
Date: Tue, 14 Feb 2017 17:45:57 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] siano: make it work again with CONFIG_VMAP_STACK
Message-ID: <20170214174557.4d7b2100@vento.lan>
In-Reply-To: <20170214194146.GA28566@kroah.com>
References: <08f1b470a156163cc3394f73bcbaea3925b6f376.1487100723.git.mchehab@s-opensource.com>
        <20170214194146.GA28566@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 14 Feb 2017 11:41:46 -0800
Greg KH <gregkh@linuxfoundation.org> escreveu:

> On Tue, Feb 14, 2017 at 05:32:11PM -0200, Mauro Carvalho Chehab wrote:
> > Reported as a Kaffeine bug:
> > 	https://bugs.kde.org/show_bug.cgi?id=375811
> > 
> > The USB control messages require DMA to work. We cannot pass
> > a stack-allocated buffer, as it is not warranted that the
> > stack would be into a DMA enabled area.
> > 
> > On Kernel 4.9, the default is to not accept DMA on stack anymore.
> > 
> > Tested with USB ID 2040:5510: Hauppauge Windham
> > 
> > Cc: stable@vger.kernel.org # For 4.9+  
> 
> Unless there is some major reason, this should go into _all_ stable
> releases, as the driver would be broken on them all for platforms that
> can't handle USB data that is not DMA-able.  This has been a requirement
> for USB drivers since the 2.2 days.

Good point! No, there's no particular reason why not backporting it
to older Kernel releases. I suspect that this particular part of
the driver hasn't changed for a while. So, it can very likely be
backported to all stable releases.

I'll fix the C/C message when submitting it upstream.

Thanks,
Mauro
