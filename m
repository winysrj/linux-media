Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46160
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbcGHNeZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:34:25 -0400
Date: Fri, 8 Jul 2016 10:34:20 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: LMML <linux-media@vger.kernel.org>,
	Linux Doc <linux-doc@vger.kernel.org>
Subject: [ANN] Media documentation converted to ReST markup language
Message-ID: <20160708103420.27453f0d@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As commented on the patch series I just submitted, we finished the conversion
of the Media uAPI book from DocBook to ReST.

For now, I'm placing the new documentation, after parsed by Sphinx, at this
place:
	https://mchehab.fedorapeople.org/media_API_book/

There are some instructions there about how to use Sphinx too, with can be
useful for the ones writing patches. Those are part of the docs-next that
will be sent to Kernel 4.8, thanks to Jani Nikula an Jonathan Corbet.

The media docbook itself is located at:
	https://mchehab.fedorapeople.org/media_API_book/linux_tv/index.html

And the patches are already at the media tree, under the "docs-next"
branch:
	https://git.linuxtv.org/media_tree.git/log/?h=docs-next

If you find anything inconsistent, wrong or incomplete, feel free to
submit patches to it. My plan is to merge this branch on Kernel 4.8-rc1
and then remove the Documentation/DocBook/media stuff from the Kernel.

PS.: I'll soon be adding one extra patch there renaming the media
directory. "linux_tv" is not the best name for the media contents,
but, on the other hand, having a "media/media" directory also doesn't
make sense. So, I need to think for a better name before doing the
change. Pehaps I'll go for:
	Documentation/media - for all media documentation, were we
		should also store things that are now under 
		/video4linux and under /dvb;

and:
	Documentation/media/uapi - for the above book that were just
		converted from DocBook.

Enjoy!

Thanks,
Mauro
