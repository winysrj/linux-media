Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1PNf7t8010698
	for <video4linux-list@redhat.com>; Wed, 25 Feb 2009 18:41:07 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1PNepg2026356
	for <video4linux-list@redhat.com>; Wed, 25 Feb 2009 18:40:52 -0500
Date: Wed, 25 Feb 2009 20:40:23 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Vitaly Wool <vital@embeddedalley.com>
Message-ID: <20090225204023.16b96fe5@pedra.chehab.org>
In-Reply-To: <49A59B31.9080407@embeddedalley.com>
References: <49A3A61F.30509@embeddedalley.com>
	<20090224234205.7a5ca4ca@pedra.chehab.org>
	<49A53CB9.1040109@embeddedalley.com>
	<20090225090728.7f2b0673@caramujo.chehab.org>
	<49A567D9.80805@embeddedalley.com>
	<20090225101812.212fabbe@caramujo.chehab.org>
	<49A57BD4.6040209@embeddedalley.com>
	<20090225153323.66778ad2@caramujo.chehab.org>
	<49A59B31.9080407@embeddedalley.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, em28xx@mcentral.de
Subject: Re: em28xx: Compro VideoMate For You sound problems
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

On Wed, 25 Feb 2009 22:25:37 +0300
Vitaly Wool <vital@embeddedalley.com> wrote:

> Mauro,
> 
> Mauro Carvalho Chehab wrote:
> >   
> >> diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
> >> index 100f90a..f300e74 100644
> >> --- a/drivers/media/video/em28xx/em28xx-cards.c
> >> +++ b/drivers/media/video/em28xx/em28xx-cards.c
> >> @@ -1245,14 +1245,17 @@ struct em28xx_board em28xx_boards[] = {
> >>  		.tda9887_conf = TDA9887_PRESENT,
> >>  		.decoder      = EM28XX_TVP5150,
> >>  		.adecoder     = EM28XX_TVAUDIO,
> >> +		.tuner_gpio   = default_tuner_gpio,
> >>     
> >
> > You don't need a tuner gpio. This is used basically by xc3028 based devices, in
> > order to reset it during software upload.
> >
> > Instead, we should add another gpio here, for mute. This should be called in a
> > place where we can remove the unwanted noise (e. g. at the beginning of the
> > device setup logic), and when mute is selected by the audio functions.
> >   
> I'm not quite sure I understood. Do I need to add another field to the 
> board structure and use it where appropriate?

Yes, that's what I'm meaning.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
