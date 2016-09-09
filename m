Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54152 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753028AbcIIMIm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2016 08:08:42 -0400
Date: Fri, 9 Sep 2016 09:08:32 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 0/3] doc-rst:c-domain: fix some issues in the
 c-domain
Message-ID: <20160909090832.35c2d982@vento.lan>
In-Reply-To: <1473232378-11869-1-git-send-email-markus.heiser@darmarit.de>
References: <1473232378-11869-1-git-send-email-markus.heiser@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed,  7 Sep 2016 09:12:55 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> From: Markus Heiser <markus.heiser@darmarIT.de>
> 
> Hi Jon,
> 
> according to your remarks I fixed the first and second patch. The third patch is
> resend unchanged;
> 
> > Am 06.09.2016 um 14:28 schrieb Jonathan Corbet <corbet@lwn.net>:
> >
> > As others have pointed out, we generally want to hide the difference
> > between functions and macros, so this is probably one change we don't
> > want.  
> 
> I read "probably", so there might be a chance to persuade you ;)
> 
> I'm not a friend of *information hiding* and since the index is sorted
> alphabetical it does no matter if the entry is 'FOO (C function)' or 'FOO (C
> macro)'. The last one has the right information e.g. for someone how is looking
> for a macro. FOO is a function-like macro and not a function, if the author
> describes the macro he might use the word "macro FOO" but in the index it is
> tagged as C function.
> 
> Macros and functions are totally different even if their notation looks
> similarly. So where is the benefit of entries like 'FOO (C function)', which is
> IMHO ambiguous.
> 
> I tagged the 'function-like macros index entry' patch with 'RFC' and resend it
> within this series. If you and/or others have a different opinion, feel free to
> drop it.
> 
> Thanks for review.
> 
> -- Markus --
> 
> 
> Markus Heiser (3):
>   doc-rst:c-domain: fix sphinx version incompatibility
>   doc-rst:c-domain: function-like macros arguments
>   doc-rst:c-domain: function-like macros index entry
> 
>  Documentation/sphinx/cdomain.py | 79 +++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 76 insertions(+), 3 deletions(-)
> 

Those patches indeed fix the issues. The arguments are now
processed properly.

Tested-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

---

Using either this approach or my kernel-doc patch, I'm now getting
only two warnings:

1) at media-entity.h, even without nitpick mode:

./include/media/media-entity.h:1053: warning: No description found for parameter '...'

This is caused by this kernel-doc tag and the corresponding macro:

	/**
	 * media_entity_call - Calls a struct media_entity_operations operation on
	 *	an entity
	 *
	 * @entity: entity where the @operation will be called
	 * @operation: type of the operation. Should be the name of a member of
	 *	struct &media_entity_operations.
	 *
	 * This helper function will check if @operation is not %NULL. On such case,
	 * it will issue a call to @operation\(@entity, @args\).
	 */

	#define media_entity_call(entity, operation, args...)			\
		(((entity)->ops && (entity)->ops->operation) ?			\
		 (entity)->ops->operation((entity) , ##args) : -ENOIOCTLCMD)


Basically, the Sphinx C domain seems to be expecting a description for
"...". I didn't find any way to get rid of that.

2) a nitpick warning at v4l2-mem2mem.h:

./include/media/v4l2-mem2mem.h:339: WARNING: c:type reference target not found: queue_init


	/**
	 * v4l2_m2m_ctx_init() - allocate and initialize a m2m context
	 *
	 * @m2m_dev: opaque pointer to the internal data to handle M2M context
	 * @drv_priv: driver's instance private data
	 * @queue_init: a callback for queue type-specific initialization function
	 * 	to be used for initializing videobuf_queues
	 *
	 * Usually called from driver's ``open()`` function.
	 */
	struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
			void *drv_priv,
			int (*queue_init)(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq));

I checked the output of kernel-doc, and it looked ok. Yet, it expects
"queue_init" to be defined somehow. I suspect that this is an error at
Sphinx C domain parser.

Markus,

Could you please take a look on those?

Thanks,
Mauro
