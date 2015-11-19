Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44157 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933866AbbKSKUR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 05:20:17 -0500
Date: Thu, 19 Nov 2015 12:19:43 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] DocBook: only copy stuff to media_api if media xml is
 generated
Message-ID: <20151119101943.GB17128@valkosipuli.retiisi.org.uk>
References: <e99ac34ef0b822ac3007b00a499a67eb1af36d9a.1447926299.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e99ac34ef0b822ac3007b00a499a67eb1af36d9a.1447926299.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thu, Nov 19, 2015 at 07:45:13AM -0200, Mauro Carvalho Chehab wrote:
> It is possible to use:
> 	make DOCBOOKS=device-drivers.xml htmldocs
> 
> To produce just a few docbooks. In such case, the media docs
> won't be built, causing the makefile target to return an error.
> 
> While this is ok for human eyes, if the above is used on an script,
> it would cause troubles.
> 
> Fix it by only creating/filling the media_api directory if the
> media_api.xml is found at DOCBOOKS.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  Documentation/DocBook/media/Makefile | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
> index 02848146fc3a..2840ff483d5a 100644
> --- a/Documentation/DocBook/media/Makefile
> +++ b/Documentation/DocBook/media/Makefile
> @@ -199,8 +199,10 @@ DVB_DOCUMENTED = \
>  #
>  
>  install_media_images = \
> -	$(Q)-mkdir -p $(MEDIA_OBJ_DIR)/media_api; \
> -	cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/*.svg $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api
> +	$(Q)if [ "x$(findstring media_api.xml,$(DOCBOOKS))" != "x" ]; then \
> +		mkdir -p $(MEDIA_OBJ_DIR)/media_api; \
> +		cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/*.svg $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api; \
> +	fi
>  
>  $(MEDIA_OBJ_DIR)/%: $(MEDIA_SRC_DIR)/%.b64
>  	$(Q)base64 -d $< >$@

I'd still copy the files even if the directory was there. It's entirely
possible that new files appeared between the make runs, or that the existing
files changed. cp will just overwrite the targets in that case.

Albeit one still has to issue "make cleandocs" to get the DocBook rebuilt.
Oh well... One thing at a time? :-)

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
