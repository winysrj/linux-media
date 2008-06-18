Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.178])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <owen.townend@gmail.com>) id 1K8nzh-000100-IC
	for linux-dvb@linuxtv.org; Wed, 18 Jun 2008 05:05:58 +0200
Received: by wa-out-1112.google.com with SMTP id n7so38863wag.13
	for <linux-dvb@linuxtv.org>; Tue, 17 Jun 2008 20:05:52 -0700 (PDT)
Message-ID: <bb72339d0806172005x2b3b4c59p80a0fe50e87daa73@mail.gmail.com>
Date: Wed, 18 Jun 2008 13:05:52 +1000
From: "Owen Townend" <owen.townend@gmail.com>
To: video4linux-list@redhat.com, linux-dvb@linuxtv.org
In-Reply-To: <4858755C.7090606@iinet.net.au>
MIME-Version: 1.0
Content-Disposition: inline
References: <1822849CB0478545ADCFB217EF4A340584E53A@sedah.startrac.com>
	<4858755C.7090606@iinet.net.au>
Subject: Re: [linux-dvb] [PATCH] Avermedia A16D composite input
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On 18/06/2008, timf <timf@iinet.net.au> wrote:
> Dan Taylor wrote:
>  > This is a patch against 78442352b885.  It adds composite support for the
>  > included Composite->S-video adapter that comes with the Avermedia A16D.
>  > The work that went into DVB support for the card made this much simpler
>  > than my earlier version.
>  >
>  >
>  >
>  > As before, it has been tested with a signal generator and an iPod.
>  >
>  >
>  >
>  > I appreciate the DVB work and hope to be testing it early next week.
>  > Does anyone have a sample mplayer config file for DVB-T?
>  >
>  >
>  >
>  > diff -upr linux-2.6.26-v4l/drivers/media/video/saa7134/saa7134-cards.c
>  > linux-2.6.26-v4lc/drivers/media/video/saa7134/saa7134-cards.c
>  > --- linux-2.6.26-v4l/drivers/media/video/saa7134/saa7134-cards.c
>  > 2008-06-15 05:33:42.000000000 -0800
>  > +++ linux-2.6.26-v4lc/drivers/media/video/saa7134/saa7134-cards.c
>  > 2008-06-17 16:19:14.000000000 -0800
>  > @@ -4269,6 +4269,10 @@ struct saa7134_board saa7134_boards[] =
>  >                   .name = name_svideo,
>  >                   .vmux = 8,
>  >                   .amux = LINE1,
>  > +           }, {
>  > +                 .name = name_comp,
>  > +                 .vmux = 0,
>  > +                 .amux = LINE1,
>  >             } },
>  >             .radio = {
>  >                   .name = name_radio,
>  >
>  >
>  >
>  >
>  >
>  >
>  >
>  >
>  >
>  > ------------------------------------------------------------------------
>  >
>  > --
>  > video4linux-list mailing list
>  > Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>  > https://www.redhat.com/mailman/listinfo/video4linux-list
>  Hi Dan,
>  Well done!
>  I just responded to alert you that you will need to send a patch to
>  Mauro direct as well.
>  You will need to run it through various checks before it will happen.
>  However, excellent, it looks like the card is complete!
>  Regards,
>  Timf
>
>  _______________________________________________
>  linux-dvb mailing list
>  linux-dvb@linuxtv.org
>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

Hey,
  I own one of these cards and have yet to use/test more than the dvb
input as yet, but want to add my thanks to any and all involved in the
hacking, coding and testing which lets it work for all of us.
Thanks again!

Cheers,
Owen.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
