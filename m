Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5PIrx8k025605
	for <video4linux-list@redhat.com>; Wed, 25 Jun 2008 14:54:00 -0400
Received: from mail-in-01.arcor-online.net (mail-in-01.arcor-online.net
	[151.189.21.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5PIrhav026568
	for <video4linux-list@redhat.com>; Wed, 25 Jun 2008 14:53:43 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Frederic CAND <frederic.cand@anevia.com>
In-Reply-To: <4862351E.7040103@anevia.com>
References: <485FA5A8.9000103@anevia.com>
	<1214259929.6208.26.camel@pc10.localdom.local>
	<4860AE9F.80104@anevia.com>
	<1214343023.2636.53.camel@pc10.localdom.local>
	<4862351E.7040103@anevia.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 25 Jun 2008 20:51:22 +0200
Message-Id: <1214419882.3168.59.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [HVR 1300] secam bg
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


Am Mittwoch, den 25.06.2008, 14:07 +0200 schrieb Frederic CAND:
> hermann pitton a écrit :
> > Hi,
> > 
> > Am Dienstag, den 24.06.2008, 10:21 +0200 schrieb Frederic CAND:
> >> hermann pitton a écrit :
> >>> Hi Frederic,
> >>>
> >>> Am Montag, den 23.06.2008, 15:31 +0200 schrieb Frederic CAND:
> >>>> dear all
> >>>> I could not make secam b/g work on my hvr 1300
> >>>> ioctl returns -1, error "Invalid argument"
> >>>> I know my card is able to handle this tv norm since it's working fine
> >>>> (video and sound are ok) under windows
> >>>> anyone could confirm it isn't working ? any idea why, and how to make it 
> >>>> work ?
> >>> since without reply, I don't claim to have seriously looked at it, but
> >>> at least have one question myself.
> >>>
> >>> In cx88-core is no define for SECAM B or G.
> >>>
> >>> Do you use a signal generator?
> >> Indeed, I do.
> >> It's a Promax GV-198.
> >> http://www.promaxprolink.com/gv198.htm
> >>
> >>> Hartmut asked once on the saa7134 driver, if there are any known
> >>> remaining SECAM_BG users currently and we remained, that it is hard to
> >>> get really up to date global analog lists for current broadcasts and I
> >>> only could contribute that there was no single request for it during all
> >>> these last years.
> >>>
> >>> You know countries still using it?
> >>  From what I've found on the internet, Cyprus, Greece, Saudi Arabia and 
> >> some others. Plus people using a signal modulator (e.g: professionnal use).
> >>
> >>> Thanks,
> >>> Hermann
> >>>
> >>>
> >> Actually, tda9887 Secam BG was broken in (more or less) recent versions 
> >> of v4l-dvb (I noticed that thanks to the signal modulator and my knc tv 
> >> station saa7134 based). I came up with a "roll back" patch. I guess it 
> >> can't be applied directly on the current tree but it can be done 
> >> manually before being comited to the tree.
> >>
> >> diff -pur1 a/linux/drivers/media/video/tda9887.c 
> >> b/linux/drivers/media/video/tda9887.c
> >> --- a/linux/drivers/media/video/tda9887.c      2007-07-02 
> >> 20:39:57.000000000 +0200
> >> +++ b/linux/drivers/media/video/tda9887.c      2008-06-19 
> >> 12:21:50.000000000 +0200
> >> @@ -172,7 +172,6 @@ static struct tvnorm tvnorms[] = {
> >>                  .name  = "SECAM-BGH",
> >> -               .b     = ( cPositiveAmTV  |
> >> +               .b     = ( cNegativeFmTV  |
> >>                             cQSS           ),
> >>                  .c     = ( cTopDefault),
> >> -               .e     = ( cGating_36     |
> >> -                          cAudioIF_5_5   |
> >> +               .e     = ( cAudioIF_5_5   |
> >>                             cVideoIF_38_90 ),
> >>
> >>
> >>
> >> For the Hauppauge HVR 1300, I found that adding mentions of SECAM B/G/H 
> >> in cx88.h and cx88-core.c helped making it work. Same goes for this one, 
> >> I guess it can't be applied on the current tree but it can easily be 
> >> manually applied.
> >>
> >> diff -pur1 a/linux/drivers/media/video/cx88/cx88-core.c 
> >> b/linux/drivers/media/video/cx88/cx88-core.c
> >> --- a/linux/drivers/media/video/cx88/cx88-core.c       2007-07-02 
> >> 20:39:57.000000000 +0200
> >> +++ b/linux/drivers/media/video/cx88/cx88-core.c       2008-06-23 
> >> 18:48:21.000000000 +0200
> >> @@ -890,2 +890,5 @@ static int set_tvaudio(struct cx88_core
> >>
> >> +    } else if ((V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H) 
> >> & norm) {
> >> +        core->tvaudio = WW_BG;
> >> +
> >>          } else if (V4L2_STD_SECAM_DK & norm) {
> >> @@ -979,3 +982,6 @@ int cx88_set_tvnorm(struct cx88_core *co
> >>                  cxiformat, cx_read(MO_INPUT_FORMAT) & 0x0f);
> >> -       cx_andor(MO_INPUT_FORMAT, 0xf, cxiformat);
> >> +    /* Chroma AGC must be disabled if SECAM is used, we enable it
> >> +        by default on PAL and NTSC */
> >> +    cx_andor(MO_INPUT_FORMAT, 0x40f,
> >> +            norm & V4L2_STD_SECAM ? cxiformat : cxiformat | 0x400);
> >>
> >>
> >>
> >> diff -pur1 a/linux/drivers/media/video/cx88/cx88.h 
> >> b/linux/drivers/media/video/cx88/cx88.h
> >> --- a/linux/drivers/media/video/cx88/cx88.h    2008-05-13 
> >> 10:21:01.000000000 +0200
> >> +++ b/linux/drivers/media/video/cx88/cx88.h    2008-06-23 
> >> 17:48:41.000000000 +0200
> >> @@ -62,3 +62,4 @@
> >>          V4L2_STD_PAL_M |  V4L2_STD_PAL_N    |  V4L2_STD_PAL_Nc   | \
> >> -       V4L2_STD_PAL_60|  V4L2_STD_SECAM_L  |  V4L2_STD_SECAM_DK )
> >> +       V4L2_STD_PAL_60|  V4L2_STD_SECAM_L  |  V4L2_STD_SECAM_DK | \
> >> +    V4L2_STD_SECAM_B| V4L2_STD_SECAM_G  |  V4L2_STD_SECAM_H )
> >>
> > 
> > Secam BG was a weapon during cold war.
> > 
> > It was the composite of the wall on the ground for radio waves in the
> > air. It is the most vanishing TV standard in the world.
> > 
> > For what I seem to know, there is nothing left like such in Europe these
> > days. Also old broadcasting equipment in Irak and Afghanistan doesn't
> > exist anymore and Saudi Arabia at least has Pal BG too.
> > 
> > For other parts of the world the same might count, but we fore sure
> > can't trust on ITU stuff as far back than 2004.
> > The fee is unexpectedly moderate, sorry for the noise Daniel. 
> > 
> > Most of the other potentially remaining candidates are states with huge
> > deserts using usually DVB-S.
> > 
> > Since we likely have no easy means to make totally sure it is not used
> > anymore or should be still available for professional purposes, I
> > suggest to prepare your patches in such a way Mauro can pick them up.
> > 
> > Cheers,
> > Hermann
> >  
> > 
> > 
> > 
> > 
> would you like me to prepare the patches against latest snapshot ? could 
> you please remind me of a tiny "howto" ?
> cheers


Yes, latest v4l-dvb and separate patches for the tda9887 correction and
Secam BGH addition to cx88.

There are various ways to generate patches.
I'll try to give some basic hints to something that should work for you.

"yum install mercurial" or what you distribution uses.
"hg clone http://linuxtv.org/hg/v4l-dvb"

Try README.patches there.

We need a

Signed-off-by: your name <your.e-mail.address>

line from you above your patches.


Fix the tda9887.
"hg diff" has your changes.
"make checkpatch" searches for errors and coding style stuff.

If OK,
"hg diff > tda9887_fix_SECAM-BGH_demodulation.patch"

"make commit"

Do the cx88 changes and same procedure resulting in your second patch.

(In your case, since the patches are not interdependent concerning the
modified code and the order in which they have to be applied, you could
even avoid the "make commit" remove your tda9887 fix with "patch -R -p1
< tda9887*.patch" and create the cx88 patchset with "hg diff" from here
too or use a second copy of v4l-dvb.)

This is usually enough to send them per mail as patch 1/2 and 2/2 with
something like "[PATCH 1/2] tda9887: fix SECAM-BGH demodulation"
               "[PATCH 2/2] cx88: add support for SECAM-BGH"
in the subject. You might add a small description and don't forget your
signed-off-by line. Send also a copy directly to Mauro.

Mail applications often break patches. If you are not sure about yours,
send to yourself at first and check or add the patch also as an
attachment.

"hg export changeset-number" is useful in case you start working with
"make commit" to get them out for mailing, "hg log > hg.log" to get the
changeset numbers if you like to review something.

Thanks,
Hermann



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
