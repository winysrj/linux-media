Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45966
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932275AbdC3KNP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 06:13:15 -0400
Date: Thu, 30 Mar 2017 07:12:58 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Takashi Iwai <tiwai@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Oliver Neukum <oneukum@suse.com>,
        Martyn Welch <martyn.welch@collabora.co.uk>,
        Alexander Dahl <post@lespocky.de>,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 02/22] docs-rst: convert usb docbooks to ReST
Message-ID: <20170330071258.0ca47e4c@vento.lan>
In-Reply-To: <D5D8BF1C-755B-4D56-B744-6A155C5B2313@darmarit.de>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
        <327dcce56a725c7f91f542f2ff97995504d26526.1490813422.git.mchehab@s-opensource.com>
        <7D76BCB2-53F5-4BD4-8205-5A4852164C91@darmarit.de>
        <87y3vn2mzk.fsf@intel.com>
        <D5D8BF1C-755B-4D56-B744-6A155C5B2313@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 30 Mar 2017 11:20:14 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 30.03.2017 um 10:21 schrieb Jani Nikula <jani.nikula@intel.com>:
> 
> > On Thu, 30 Mar 2017, Markus Heiser <markus.heiser@darmarit.de> wrote:  
> >> Hi Mauro,
> >> 
> >> Am 29.03.2017 um 20:54 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> >>   
> >>> As we're moving out of DocBook, let's convert the remaining
> >>> USB docbooks to ReST.
> >>> 
> >>> The transformation itself on this patch is a no-brainer
> >>> conversion using pandoc.  
> >> 
> >> right, its a no-brainer ;-) I'am not very happy with this
> >> conversions, some examples see below.
> >> 
> >> I recommend to use a more elaborate conversion as starting point,
> >> e.g. from my sphkerneldoc project:
> >> 
> >> * https://github.com/return42/sphkerneldoc/tree/master/Documentation/books_migrated/gadget
> >> * https://github.com/return42/sphkerneldoc/tree/master/Documentation/books_migrated/writing_musb_glue_layer
> >> * https://github.com/return42/sphkerneldoc/tree/master/Documentation/books_migrated/writing_usb_driver
> >> 
> >> Since these DocBooks hasn't been changed in the last month, the linked reST
> >> should be up to date.  
> > 
> > Markus, I know you've done a lot of work on your conversions, and you
> > like to advocate them, but AFAICT you have never posted the conversions
> > as patches to the list. Your project isn't a clone of the kernel
> > tree. It's a pile of .rst files that nobody knows how to produce from
> > current upstream DocBook .tmpl files. I'm sorry, but this just doesn't
> > work that way.  
> 
> The conversion is done with the dbxml2rst tool:
> 
>   https://github.com/return42/dbxml2rst
> 
> But you are right, the links I send are decoupled from kernel. It is
> a 5 month old snapshot of a DocBook to reST conversion (now updated,
> with no affect to the linked files, since they have not been patched
> in the meantime) ...
> 
> > At this point I'd just go with what Mauro has. It's here now, as
> > patches. We've seen from the GPU documentation that polishing the
> > one-time initial conversion is, after a point, wasted effort. Having the
> > documentation in rst attracts more attention and contributions, and any
> > remaining issues will get ironed out in rst.  
> 
> I totally agree with you (I have never said something different)
> 
> > This is also one reason I'm in favor of just bulk converting the rest of
> > the .tmpl files using Documentation/sphinx/tmplcvt, get rid of DocBook
> > and be done with it, and have the crowds focus on rst.  
> 
> I also agree with that. The tmplcvt script is good enough for this task,
> the dbxml2rst tool is more elaborate.

I like the idea of a bulk conversion. My personal preference here is to
use the tmplcvt for such task, at least for simple books like the ones
I converted from USB.

The advantage is that it places everything on a single rst file, with,
IMHO, works best for books that aren't too complex.

Of course, it doesn't hurt to compare the end result with dbxml2rst
and see if something could be improved.

> 
> If Jonathan also likes to have a bulk conversion of the rest DocBooks,
> we can use tmplcvt or even dbxml2rst for this task. Everything under
> 
>   https://github.com/return42/sphkerneldoc/tree/master/Documentation/books_migrated
> 
> is just a "make dbxm2rst", I can update every time and if a bulk conversion
> is the way ... I can send such patches or you send a tmplcvt conversion.
> 
> @Jon: what do you think about a bulk conversion?
> 
>  -- Markus --
>   


Thanks,
Mauro
