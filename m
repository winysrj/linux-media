Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47133
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbcGTOEU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 10:04:20 -0400
Date: Wed, 20 Jul 2016 11:04:13 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Kees Cook <keescook@chromium.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] [media] doc-rst: Fix some Sphinx warnings
Message-ID: <20160720110413.68334513@recife.lan>
In-Reply-To: <250A8BC9-A965-4162-BF63-6FFFBCD42D89@darmarit.de>
References: <d612024e7d2acd7ec82c75b5fed271fd61673386.1469017917.git.mchehab@s-opensource.com>
	<20160720100027.440796a4@recife.lan>
	<250A8BC9-A965-4162-BF63-6FFFBCD42D89@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 20 Jul 2016 15:14:27 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 20.07.2016 um 15:00 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
> > Em Wed, 20 Jul 2016 09:32:15 -0300
> > Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:
> >   
> >> Fix all remaining media warnings with ReST that are fixable
> >> without changing at the Sphinx code.
> >>   
> >   
> >> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> >> index 83877719bef4..3d885d97d149 100644
> >> --- a/include/media/media-entity.h
> >> +++ b/include/media/media-entity.h
> >> @@ -180,8 +180,10 @@ struct media_pad {
> >> *			view. The media_entity_pipeline_start() function
> >> *			validates all links by calling this operation. Optional.
> >> *
> >> - * .. note:: Those these callbacks are called with struct media_device.@graph_mutex
> >> - * mutex held.
> >> + * .. note::
> >> + *
> >> + *    Those these callbacks are called with struct media_device.@graph_mutex
> >> + *    mutex held.
> >> */  
> > 
> > The kernel-doc script did something wrong here... something bad
> > happened with "@graph_mutex". While it is showing the note box
> > properly, the message inside is:
> > 
> > 	"Note
> > 
> > 	 Those these callbacks are called with struct media_device.**graph_mutex** mutex held."
> > 
> > 
> > E. g. it converted @ to "**graph_mutex**" and some code seemed to
> > change it to: "\*\*graph_mutex\*\*", as this message is not showing
> > with a bold font, but, instead, with the double asterisks.
> > 
> > No idea how to fix it.  
> 
> Thanks for reporting ..
> I guess it is the kernel-doc parser, currently I'am trying to eliminate
> some base fails of the kernel-doc parser (e.g. you mailed handling of 
> c functions) .. for this I test with your media_tree/doc-next ..
> if you commit this to your doc-next I have an example (or where could I get it)

It is on my development tree:
	https://git.linuxtv.org//mchehab/experimental.git/log/?h=docs-next

I'll push it to the media_tree later today.

Btw, I'm also getting this warning:

/devel/v4l/patchwork/Documentation/media/kapi/mc-core.rst:1252: WARNING: Could not lex literal_block as "C". Highlighting skipped.                                                   

With invalid line numbers. I was unable to discover why, and your
patch didn't help solving it.

---

A completely unrelated question: it seems that Sphinx is using just
one CPU to do its builds:

%Cpu0  :  3,0 us,  7,6 sy,  0,0 ni, 89,4 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
%Cpu1  :100,0 us,  0,0 sy,  0,0 ni,  0,0 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
%Cpu2  :  1,3 us,  2,7 sy,  0,0 ni, 95,7 id,  0,3 wa,  0,0 hi,  0,0 si,  0,0 st
%Cpu3  :  1,0 us,  3,3 sy,  0,0 ni, 95,7 id,  0,0 wa,  0,0 hi,  0,0 si,  0,0 st
KiB Mem : 15861876 total,  5809820 free,  1750528 used,  8301528 buff/cache
KiB Swap:  8200188 total,  8200188 free,        0 used. 13382964 avail Mem 

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND     
 5660 mchehab   20   0  325256  89776   8300 R  99,7  0,6   0:22.25 sphinx-bui+ 

Are there any way to speed it up and make it use all available CPUs?


> I will take a look about this also .. .. give me some time ;-)
> 
> -- Markus --
> 
> > 
> > Thanks,
> > Mauro
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html  
> 



Thanks,
Mauro
