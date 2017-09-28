Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34358
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752520AbdI1BM0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 21:12:26 -0400
Date: Wed, 27 Sep 2017 22:12:17 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH v2 07/13] docs: kernel-doc.rst: add documentation about
 man pages
Message-ID: <20170927221217.31b6b184@vento.lan>
In-Reply-To: <6ef754d0-4c7f-0547-e7e9-8afb87b28506@infradead.org>
References: <cover.1506546492.git.mchehab@s-opensource.com>
        <d728e50a675aad84310e1418c2d4ec9495322982.1506546492.git.mchehab@s-opensource.com>
        <6ef754d0-4c7f-0547-e7e9-8afb87b28506@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 27 Sep 2017 14:20:03 -0700
Randy Dunlap <rdunlap@infradead.org> escreveu:

> On 09/27/17 14:10, Mauro Carvalho Chehab wrote:
> > kernel-doc-nano-HOWTO.txt has a chapter about man pages  
> 
>   kernel-doc.rst has a chapter (or section)

I actually meant to say that kernel-doc-nano-HOWTO.txt has a chapter
about man pages, but such chapter is missing at kernel-doc.rst.

I'll make it clearer at the patch's description.

Thanks!
Mauro

> 
> > production. While we don't have a working  "make manpages"
> > target, add it.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  Documentation/doc-guide/kernel-doc.rst | 34 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> > 
> > diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation/doc-guide/kernel-doc.rst
> > index 0923c8bd5769..96012f9e314d 100644
> > --- a/Documentation/doc-guide/kernel-doc.rst
> > +++ b/Documentation/doc-guide/kernel-doc.rst  
> 
> 



Thanks,
Mauro
