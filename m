Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58399 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbcISPAj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 11:00:39 -0400
Date: Mon, 19 Sep 2016 12:00:30 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-doc@vger.kernel.org Mailing List" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] doc-rst:c-domain: fix some issues in the
 c-domain
Message-ID: <20160919120030.4e390e9a@vento.lan>
In-Reply-To: <1089B8C0-6296-4CC4-84B9-A1F62FA565AD@darmarit.de>
References: <1473232378-11869-1-git-send-email-markus.heiser@darmarit.de>
        <20160909090832.35c2d982@vento.lan>
        <73B0403A-272C-4058-A0D9-493C685EE332@darmarit.de>
        <1089B8C0-6296-4CC4-84B9-A1F62FA565AD@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 19 Sep 2016 13:36:55 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Hi Mauro, 
> 
> sorry for my late reply (so much work to do) ..
> 
> Am 09.09.2016 um 14:25 schrieb Markus Heiser <markus.heiser@darmarIT.de>:
> 
> >> Using either this approach or my kernel-doc patch, I'm now getting
> >> only two warnings:
> >> 
> >> 1) at media-entity.h, even without nitpick mode:
> >> 
> >> ./include/media/media-entity.h:1053: warning: No description found for parameter '...'  
> 
> FYI: This message comes from the kernel-doc parser.
> 
> >> This is caused by this kernel-doc tag and the corresponding macro:
> >> 
> >> 	/**
> >> 	 * media_entity_call - Calls a struct media_entity_operations operation on
> >> 	 *	an entity
> >> 	 *
> >> 	 * @entity: entity where the @operation will be called
> >> 	 * @operation: type of the operation. Should be the name of a member of
> >> 	 *	struct &media_entity_operations.
> >> 	 *
> >> 	 * This helper function will check if @operation is not %NULL. On such case,
> >> 	 * it will issue a call to @operation\(@entity, @args\).
> >> 	 */
> >> 
> >> 	#define media_entity_call(entity, operation, args...)			\
> >> 		(((entity)->ops && (entity)->ops->operation) ?			\
> >> 		 (entity)->ops->operation((entity) , ##args) : -ENOIOCTLCMD)
> >> 
> >> 
> >> Basically, the Sphinx C domain seems to be expecting a description for
> >> "...". I didn't find any way to get rid of that.  
> 
> This is a bug in the kernel-doc parser.	The parser generates:
> 
>   .. c:function:: media_entity_call ( entity,  operation,  ...)
> 
> correct is:
> 
>   .. c:function::  media_entity_call( entity,  operation,  args...)
> 
> So both, the message and the wrong parse result comes from kernel-doc.

Ok, I'll try to address it by fixing kernel-doc script.

> 
> >> 
> >> 2) a nitpick warning at v4l2-mem2mem.h:
> >> 
> >> ./include/media/v4l2-mem2mem.h:339: WARNING: c:type reference target not found: queue_init  
> 
> FYI: this message comes from sphinx c-domain.
> 
> >> 	/**
> >> 	 * v4l2_m2m_ctx_init() - allocate and initialize a m2m context
> >> 	 *
> >> 	 * @m2m_dev: opaque pointer to the internal data to handle M2M context
> >> 	 * @drv_priv: driver's instance private data
> >> 	 * @queue_init: a callback for queue type-specific initialization function
> >> 	 * 	to be used for initializing videobuf_queues
> >> 	 *
> >> 	 * Usually called from driver's ``open()`` function.
> >> 	 */
> >> 	struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
> >> 			void *drv_priv,
> >> 			int (*queue_init)(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq));
> >> 
> >> I checked the output of kernel-doc, and it looked ok. Yet, it expects
> >> "queue_init" to be defined somehow. I suspect that this is an error at
> >> Sphinx C domain parser.  
> 
> Hmm, as far as I see, the output is not correct ... The output of
> functions with a function pointer argument are missing the 
> leading parenthesis in the function definition:
> 
>   .. c:function:: struct v4l2_m2m_ctx * v4l2_m2m_ctx_init (struct v4l2_m2m_dev * m2m_dev, void * drv_priv, int (*queue_init) (void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
> 
> The missing parenthesis cause the error message. 


Ah, OK! I'll kernel-doc and see what's happening here.

> 
> The output of the parameter description is:
> 
>   ``int (*)(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq) queue_init``
>     a callback for queue type-specific initialization function
>     to be used for initializing videobuf_queues
> 
> Correct (and IMO better to read) is:
> 
>   .. c:function:: struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev, void *drv_priv, int (*queue_init)(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq))
> 
> and the parameter description should be something like ...
> 
>    :param int (\*queue_init)(void \*priv, struct vb2_queue \*src_vq, struct vb2_queue \*dst_vq):
>         a callback for queue type-specific initialization function
>         to be used for initializing videobuf_queues

I guess the better would be to strip the parameter type and output
it as:
	queue_init
		a callback for queue type-specific initialization function
		to be used for initializing videobuf_queues

As I pointed before, the point is that such argument can easily have
more than 80 columns, with would cause troubles with LaTeX output,
as LaTeX doesn't break long verbatim text on multiple lines.

I submitted one patch fixing it. Not sure if it got merged by Jon
or not.

> 
> I tested this with my linuxdoc tools (parser) with I get no
> error messages from the sphinx c-domain.
> 
> BTW: 
> 
> The parser of my linuxdoc project is more strict and spit out some 
> warnings, which are not detected by the kernel-doc parser from the
> kernel source tree.
> 
> For your rework on kernel-doc comments, it might be helpful to see
> those messages, so I recommend to install the linuxdoc package and
> do some lint.
> 
> install: https://return42.github.io/linuxdoc/install.html
> lint:    https://return42.github.io/linuxdoc/cmd-line.html#kernel-lintdoc

Interesting! Yeah, it caught a lot more errors ;)

If I understood it right, I could do something like:

diff --git a/Documentation/media/conf_nitpick.py b/Documentation/media/conf_nitpick.py
index 480d548af670..2de603871536 100644
--- a/Documentation/media/conf_nitpick.py
+++ b/Documentation/media/conf_nitpick.py
@@ -107,3 +107,9 @@ nitpick_ignore = [
 
     ("c:type", "v4l2_m2m_dev"),
 ]
+
+
+extensions.append("linuxdoc.rstKernelDoc")
+extensions.append("linuxdoc.rstFlatTable")
+extensions.append("linuxdoc.kernel_include")
+extensions.append("linuxdoc.manKernelDoc")

Right? It would be good to do some sort of logic on the
above for it to automatically include it, if linuxdoc is
present, otherwise print a warning and do "just" the normal
Sphinx tests.

> 
> E.g. if you want to lint your whole include/media tree type:
> 
>   kernel-lintdoc [--sloppy] include/media

Yeah, running it manually is another way, although I prefer to have
it done via a Makefile target, and doing only for the files that
are currently inside a Sphinx rst file (at least on a first moment).

Thanks,
Mauro
