Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42326 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933524AbeBWTBo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 14:01:44 -0500
Date: Fri, 23 Feb 2018 16:01:37 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] media: ttpci/ttusb: add extra parameter to filter
 callbacks
Message-ID: <20180223160137.36c8cd9a@vento.lan>
In-Reply-To: <2237441.eTbS4787IK@avalon>
References: <06bf50688ac75f5ee7af2cd2a9ae0d292f3002b9.1519404222.git.mchehab@s-opensource.com>
        <2237441.eTbS4787IK@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 23 Feb 2018 19:52:48 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Friday, 23 February 2018 18:43:48 EET Mauro Carvalho Chehab wrote:
> > The filter callbaks now have an optional extra argument,
> > meant to allow reporting statistics to userspace via mmap.
> > 
> > Set those to NULL, in order to avoid those build errors:
> >   + drivers/media/pci/ttpci/av7110.c: error: too few arguments to function
> > 'dvbdmxfilter->feed->cb.sec':  => 325:10 +
> > drivers/media/pci/ttpci/av7110.c: error: too few arguments to function
> > 'dvbdmxfilter->feed->cb.ts':  => 332:11 +
> > drivers/media/pci/ttpci/av7110_av.c: error: too few arguments to function
> > 'feed->cb.ts':  => 817:3
> >   
> 
> I think this misses a Fixes: line. Apart from that it looks good to me.
> 
> With the Fixes: line,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks for review.

While not too late, I actually decided in favor of merging it with the
original patch, in order to avoid git bisect issues, as the other patch
was applied today on my fixes branch.

Regards,
Mauro
