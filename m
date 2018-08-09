Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60716 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbeHIVJr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 17:09:47 -0400
Date: Thu, 9 Aug 2018 15:43:37 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv17 04/34] media: doc: Add media-request.h header to
 documentation build
Message-ID: <20180809154337.5feeb1b6@coco.lan>
In-Reply-To: <20180804124526.46206-5-hverkuil@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
        <20180804124526.46206-5-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat,  4 Aug 2018 14:44:56 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> media-request.h has been recently added; add it to the documentation build
> as well.

Looks good. Please add my reviewed-by:

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

(from now on, if I find a patch without anything to comment in this series,
I'll add my reviewed by - please remove it if you do changes that aren't
simply trivial rebase conflict solving).


> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/media/kapi/mc-core.rst | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
> index 0c05503eaf1f..69362b3135c2 100644
> --- a/Documentation/media/kapi/mc-core.rst
> +++ b/Documentation/media/kapi/mc-core.rst
> @@ -262,3 +262,5 @@ in the end provide a way to use driver-specific callbacks.
>  .. kernel-doc:: include/media/media-devnode.h
>  
>  .. kernel-doc:: include/media/media-entity.h
> +
> +.. kernel-doc:: include/media/media-request.h



Thanks,
Mauro
