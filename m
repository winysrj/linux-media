Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47121
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbcGTNAd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 09:00:33 -0400
Date: Wed, 20 Jul 2016 10:00:27 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Kees Cook <keescook@chromium.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] [media] doc-rst: Fix some Sphinx warnings
Message-ID: <20160720100027.440796a4@recife.lan>
In-Reply-To: <d612024e7d2acd7ec82c75b5fed271fd61673386.1469017917.git.mchehab@s-opensource.com>
References: <d612024e7d2acd7ec82c75b5fed271fd61673386.1469017917.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 20 Jul 2016 09:32:15 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Fix all remaining media warnings with ReST that are fixable
> without changing at the Sphinx code.
> 

> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 83877719bef4..3d885d97d149 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -180,8 +180,10 @@ struct media_pad {
>   *			view. The media_entity_pipeline_start() function
>   *			validates all links by calling this operation. Optional.
>   *
> - * .. note:: Those these callbacks are called with struct media_device.@graph_mutex
> - * mutex held.
> + * .. note::
> + *
> + *    Those these callbacks are called with struct media_device.@graph_mutex
> + *    mutex held.
>   */

The kernel-doc script did something wrong here... something bad
happened with "@graph_mutex". While it is showing the note box
properly, the message inside is:

	"Note

	 Those these callbacks are called with struct media_device.**graph_mutex** mutex held."


E. g. it converted @ to "**graph_mutex**" and some code seemed to
change it to: "\*\*graph_mutex\*\*", as this message is not showing
with a bold font, but, instead, with the double asterisks.

No idea how to fix it.

Thanks,
Mauro
