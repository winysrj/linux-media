Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:19177 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373AbaJUQrI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 12:47:08 -0400
Date: Tue, 21 Oct 2014 14:47:01 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] DocBook: Reduce noise from make cleandocs
Message-id: <20141021144701.042d9452.m.chehab@samsung.com>
In-reply-to: <1413908292-26560-1-git-send-email-tiwai@suse.de>
References: <1413908292-26560-1-git-send-email-tiwai@suse.de>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 21 Oct 2014 18:18:12 +0200
Takashi Iwai <tiwai@suse.de> escreveu:

> I've got a harmless warning when running make cleandocs on an already
> cleaned tree:
>   Documentation/DocBook/media/Makefile:28: recipe for target 'cleanmediadocs' failed
>   make[1]: [cleanmediadocs] Error 1 (ignored)
> 
> Suppress this by passing -f to rm.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Assuming that this one would go via linux-doc tree:

Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

> ---
>  Documentation/DocBook/media/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
> index df2962d9e11e..8bf7c6191296 100644
> --- a/Documentation/DocBook/media/Makefile
> +++ b/Documentation/DocBook/media/Makefile
> @@ -25,7 +25,7 @@ GENFILES := $(addprefix $(MEDIA_OBJ_DIR)/, $(MEDIA_TEMP))
>  PHONY += cleanmediadocs
>  
>  cleanmediadocs:
> -	-@rm `find $(MEDIA_OBJ_DIR) -type l` $(GENFILES) $(OBJIMGFILES) 2>/dev/null
> +	-@rm -f `find $(MEDIA_OBJ_DIR) -type l` $(GENFILES) $(OBJIMGFILES) 2>/dev/null
>  
>  $(obj)/media_api.xml: $(GENFILES) FORCE
>  
