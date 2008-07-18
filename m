Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6IN20R3030637
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 19:02:00 -0400
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net
	[151.189.21.53])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6IN1l2g027957
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 19:01:48 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Simon Arlott <simon@fire.lp0.eu>, video4linux-list@redhat.com,
	v4l-dvb list <v4l-dvb-maintainer@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <38354.simon.1216381906@5ec7c279.invalid>
References: <6dd519ae0807180428k30abd15eo60fd2856f7a43821@mail.gmail.com>
	<38354.simon.1216381906@5ec7c279.invalid>
Content-Type: text/plain
Date: Sat, 19 Jul 2008 00:56:39 +0200
Message-Id: <1216421799.2666.23.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: linux-dvb@linuxtv.org, Brian Marete <bgmarete@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-dvb] [PATCH] V4L: Link tuner before saa7134
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

Hi,

Am Freitag, den 18.07.2008, 12:51 +0100 schrieb Simon Arlott:
> On Fri, July 18, 2008 12:28, Brian Marete wrote:
> > On Jul 14, 6:00 am, hermann pitton <hermann-pit...@arcor.de> wrote:
> >>
> >> #1 users can't set thetunertype anymore,
> >>    but the few cases oftunerdetection from eeprom we have should
> >>    work again for that price.
> >
> > Hello,
> >
> > Any patch yet for above issue? It seems to have made it into 2.6.26.
> >
> > I use saa7134 with everything, including the tuner modules, compiled
> > as a module. My card is detected as a flyvideo2000. The default tuner
> > for that card (#37) allows me to tune into TV but not to FM Radio. I
> > can access both functions (TV and FM Radio) if I override with
> > tuner=69, which is what I usually do. That override does not work on
> > 2.6.26.
> >
> > Any suggestions?
> 
> Modify saa7134_board_init2 so that the manual tuner type setting isn't
> ignored. The first thing it does is to overwrite the current value
> (set earlier from module parameter) with the static values... even
> before trying to autodetect it.
> 
> In saa7134-core.c saa7134_initdev:
>  dev->tuner_type   = saa7134_boards[dev->board].tuner_type;
> +dev->tuner_addr   = saa7134_boards[dev->board].tuner_addr;
> 
> In saa7134-cards.c saa7134_board_init2:
> -dev->tuner_type   = saa7134_boards[dev->board].tuner_type;
> -dev->tuner_addr   = saa7134_boards[dev->board].tuner_addr;
> 
> I think that will fix it.
> 

this restores tuner behavior on the saa7134 driver.

I can't test XCeive tuners, which load different firmware dynamically.
Mauro was on them.

Please send the patch to Mauro and/or provide your signed-off-by.

This must go to the stable team ASAP as well.

Reviewed-by: Hermann Pitton <hermann-pitton@arcor.de>

Many thanks!

Cheers,
Hermann

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
