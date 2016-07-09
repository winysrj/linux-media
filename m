Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46258
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbcGIOgl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jul 2016 10:36:41 -0400
Date: Sat, 9 Jul 2016 11:36:35 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Linux Doc <linux-doc@vger.kernel.org>
Subject: Re: [ANN] Media documentation converted to ReST markup language
Message-ID: <20160709113635.3e8b1695@recife.lan>
In-Reply-To: <92ae3535-a294-8564-5a69-fce04eb93565@xs4all.nl>
References: <20160708103420.27453f0d@recife.lan>
	<92ae3535-a294-8564-5a69-fce04eb93565@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 8 Jul 2016 15:45:52 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 07/08/2016 03:34 PM, Mauro Carvalho Chehab wrote:
> > As commented on the patch series I just submitted, we finished the conversion
> > of the Media uAPI book from DocBook to ReST.
> > 
> > For now, I'm placing the new documentation, after parsed by Sphinx, at this
> > place:
> > 	https://mchehab.fedorapeople.org/media_API_book/
> > 
> > There are some instructions there about how to use Sphinx too, with can be
> > useful for the ones writing patches. Those are part of the docs-next that
> > will be sent to Kernel 4.8, thanks to Jani Nikula an Jonathan Corbet.
> > 
> > The media docbook itself is located at:
> > 	https://mchehab.fedorapeople.org/media_API_book/linux_tv/index.html
> > 
> > And the patches are already at the media tree, under the "docs-next"
> > branch:
> > 	https://git.linuxtv.org/media_tree.git/log/?h=docs-next
> > 
> > If you find anything inconsistent, wrong or incomplete, feel free to
> > submit patches to it. My plan is to merge this branch on Kernel 4.8-rc1
> > and then remove the Documentation/DocBook/media stuff from the Kernel.
> > 
> > PS.: I'll soon be adding one extra patch there renaming the media
> > directory. "linux_tv" is not the best name for the media contents,
> > but, on the other hand, having a "media/media" directory also doesn't
> > make sense. So, I need to think for a better name before doing the
> > change. Pehaps I'll go for:
> > 	Documentation/media - for all media documentation, were we
> > 		should also store things that are now under 
> > 		/video4linux and under /dvb;
> > 
> > and:
> > 	Documentation/media/uapi - for the above book that were just
> > 		converted from DocBook.  
> 
> Sounds good to me!

I'm placing the ReST version of the document under:
	https://linuxtv.org/downloads/v4l-dvb-apis-new/media/media_uapi.html

For now, I'm updating it manually, as, currently, there's no way to
tell the Kernel build system to build just the media uAPI book.

Thanks,
Mauro
