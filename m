Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n23EG2v9004466
	for <video4linux-list@redhat.com>; Tue, 3 Mar 2009 09:16:02 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n23EFjCi022971
	for <video4linux-list@redhat.com>; Tue, 3 Mar 2009 09:15:45 -0500
Date: Tue, 3 Mar 2009 11:15:19 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Vitaly Wool <vital@embeddedalley.com>
Message-ID: <20090303111519.2af25876@pedra.chehab.org>
In-Reply-To: <49AD2F59.8070505@embeddedalley.com>
References: <49ABF405.9090005@embeddedalley.com>
	<20090302225509.4603d580@pedra.chehab.org>
	<49AD2F59.8070505@embeddedalley.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] em28xx: enable Compro VideoMate ForYou sound
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Tue, 03 Mar 2009 16:23:37 +0300
Vitaly Wool <vital@embeddedalley.com> wrote:

> 
> --- linux-next.orig/drivers/media/video/em28xx/em28xx-core.c	2009-03-02 18:08:10.000000000 +0300
> +++ linux-next/drivers/media/video/em28xx/em28xx-core.c	2009-03-03 10:33:35.000000000 +0300
> @@ -353,6 +353,7 @@
>  {
>  	int ret;
>  	u8 input;
> +	int do_mute = 0;
>  
>  	if (dev->board.is_em2800) {
>  		if (dev->ctl_ainput == EM28XX_AMUX_VIDEO)
> @@ -378,6 +379,14 @@
>  		}
>  	}
>  
> +	if (dev->mute || input != EM28XX_AUDIO_SRC_TUNER)
> +		do_mute = 1;


Do you really need the above line? This will reduce a lot the value of a mute
callback, since it will not work for EM28XX_AUDIO_SRC_TUNER.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
