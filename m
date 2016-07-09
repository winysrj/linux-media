Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38677 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbcGIRKa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jul 2016 13:10:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Linux Doc <linux-doc@vger.kernel.org>
Subject: Re: [ANN] Media documentation converted to ReST markup language
Date: Sat, 09 Jul 2016 20:10:21 +0300
Message-ID: <1602772.oBh27pyGSf@avalon>
In-Reply-To: <20160708103420.27453f0d@recife.lan>
References: <20160708103420.27453f0d@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Friday 08 Jul 2016 10:34:20 Mauro Carvalho Chehab wrote:
> As commented on the patch series I just submitted, we finished the
> conversion of the Media uAPI book from DocBook to ReST.
> 
> For now, I'm placing the new documentation, after parsed by Sphinx, at this
> place:
> 	https://mchehab.fedorapeople.org/media_API_book/
> 
> There are some instructions there about how to use Sphinx too, with can be
> useful for the ones writing patches. Those are part of the docs-next that
> will be sent to Kernel 4.8, thanks to Jani Nikula an Jonathan Corbet.
> 
> The media docbook itself is located at:
> 	https://mchehab.fedorapeople.org/media_API_book/linux_tv/index.html
> 
> And the patches are already at the media tree, under the "docs-next"
> branch:
> 	https://git.linuxtv.org/media_tree.git/log/?h=docs-next
> 
> If you find anything inconsistent, wrong or incomplete, feel free to
> submit patches to it. My plan is to merge this branch on Kernel 4.8-rc1
> and then remove the Documentation/DocBook/media stuff from the Kernel.
> 
> PS.: I'll soon be adding one extra patch there renaming the media
> directory. "linux_tv" is not the best name for the media contents,
> but, on the other hand, having a "media/media" directory also doesn't
> make sense. So, I need to think for a better name before doing the
> change. Pehaps I'll go for:
> 	Documentation/media - for all media documentation, were we
> 		should also store things that are now under
> 		/video4linux and under /dvb;
> 
> and:
> 	Documentation/media/uapi - for the above book that were just
> 		converted from DocBook.

The layout looks fresh and new, that's nice. I've noticed two pain points 
though. One of them is that the left-hand side navigation table requires 
Javascript. I wonder if there would be away to expand it fully, or even remove 
it, when Javascript is disabled.

The other one is related, the table of contents in the main page of each 
section 
(https://mchehab.fedorapeople.org/media_API_book/linux_tv/media/v4l/v4l2.html 
for instance) only shows the first level entries. We have a full table of 
contents now, and that's very practical to quickly search for the information 
we need without requiring many clicks (or actually any click at all). How can 
we keep that feature ?

By the way, the "Video for Linux API" section (and the other sibling sections) 
are child nodes of the "Introduction" section. That feels quite odd.

-- 
Regards,

Laurent Pinchart

