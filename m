Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab2IWTva (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 15:51:30 -0400
Message-ID: <505F6834.6040806@redhat.com>
Date: Sun, 23 Sep 2012 16:51:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] tlg2300: fix missing check for audio creation
References: <20120904144319.25311.50526.stgit@localhost.localdomain>
In-Reply-To: <20120904144319.25311.50526.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

Em 04-09-2012 11:43, Alan Cox escreveu:
> From: Alan Cox <alan@linux.intel.com>
> 
> If we fail to set up the capture device we go through negative indexes and
> badness happens. Add the missing test.
> 
> Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=44551
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/media/usb/tlg2300/pd-alsa.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/usb/tlg2300/pd-alsa.c b/drivers/media/usb/tlg2300/pd-alsa.c
> index 9f8b7da..0c77869 100644
> --- a/drivers/media/usb/tlg2300/pd-alsa.c
> +++ b/drivers/media/usb/tlg2300/pd-alsa.c
> @@ -305,6 +305,10 @@ int poseidon_audio_init(struct poseidon *p)
>  		return ret;
>  
>  	ret = snd_pcm_new(card, "poseidon audio", 0, 0, 1, &pcm);
> +	if (ret < 0) {
> +		snd_free_card(card);

That patch broke compilation:

  CC      drivers/media/usb/tlg2300/pd-alsa.o
drivers/media/usb/tlg2300/pd-alsa.c: In function 'poseidon_audio_init':
drivers/media/usb/tlg2300/pd-alsa.c:309:3: error: implicit declaration of function 'snd_free_card' [-Werror=implicit-function-declaration]

This change fixed it:
-		snd_free_card(card);
+		snd_card_free(card);

Not sure if this is a typo, or if it is due to some function rename
that might be happening at alsa subsystem and you might be noticed
at -next. In any case, I had to apply a patch on my tree fixing it.

PS: I noticed the compilation breakage too late to merge the fix together
with your patch - my background compilation process was supposed to
not only print a warning message in red, but also to bug me at the 
speakers - due to Murphy laws, everything got wrong: the screen
was overlapped by another one; my speakers were muted).

Still, I can swap the patch order for the patches I didn't sent
upstream yet, in order to put the fixup patch just after yours.

Regards,
Mauro

