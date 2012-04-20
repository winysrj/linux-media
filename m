Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:38839 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753597Ab2DTU5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 16:57:36 -0400
Subject: Re: [PATCH] TDA9887 PAL-Nc fix
From: Andy Walls <awalls@md.metrocast.net>
To: "Gonzalo A. de la Vega" <gadelavega@gmail.com>
Cc: linux-media@vger.kernel.org
Date: Fri, 20 Apr 2012 16:57:30 -0400
In-Reply-To: <CADbd7mHbP0YVQSBo4TgF0ZKqEU5VydWOoHZp__owh2b4k8aZsw@mail.gmail.com>
References: <4F8EB1F1.1030801@gmail.com>
	 <1334879437.14608.22.camel@palomino.walls.org>
	 <CADbd7mHbP0YVQSBo4TgF0ZKqEU5VydWOoHZp__owh2b4k8aZsw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1334955453.2544.21.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2012-04-20 at 11:01 -0300, Gonzalo A. de la Vega wrote:
> On Thu, Apr 19, 2012 at 8:50 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> > On Wed, 2012-04-18 at 09:22 -0300, Gonzalo de la Vega wrote:
> >> The tunner IF for PAL-Nc norm, which AFAIK is used only in Argentina, was being defined as equal to PAL-M but it is not. It actually uses the same video IF as PAL-BG (and unlike PAL-M) but the audio is at 4.5MHz (same as PAL-M). A separate structure member was added for PAL-Nc.
> >>
> >> Signed-off-by: Gonzalo A. de la Vega <gadelavega@gmail.com>
> >
> > Hmmm.
> >
> > The Video IF for N systems is 45.75 MHz according to this popular book
> > (see page 29 of the PDF):
> > http://www.deetc.isel.ipl.pt/Analisedesinai/sm/downloads/doc/ch08.pdf
> >
> > The Video IF is really determined by the IF SAW filter used in your
> > tuner assembly, and how the tuner data sheet says to program the
> > mixer/oscillator chip to mix down from RF to IF.
> >
> > What model analog tuner assembly are you using?  It could be that the
> > linux tuner-simple module is setting up the mixer/oscillator chip wrong.
> >
> > Regards,
> > Andy
> 
> Hi Andy,
> first of all and to clarify things: I could not tune analog TV without
> this patch, or I could barely see a BW image. With the patch applied,
> I can see image in full color and with good sound. So it works with
> the patch, it does not work without it.

I believe you.  However, I beleive your fix is in the wrong place.
Every M/N tuner datahseet that I have seen, specifies a Video IF of
45.75 MHz.

> Now, I'm not an expert on TV (I am an electronics engineer thou) so I
> am having some trouble trying to put together what I read in the
> TDA9887 datasheet and the reference you sent.

Here's a datasheet for the LG TAPE-H091F tuner (M/N using a TDA9887):
http://dl.ivtvdriver.org/datasheets/tuners/TAPE-H091F_MK3.pdf
Look at the block diagram on page 26.  This design is very typical of
analog tuner assemblies.

The IF SAW filter is fixed.  I could program the mixer/oscialltor chip
and the TDA9887 IF decoder chip so the Video IF in use was 38.90 MHz,
and probably get a viewable TV picture.  That doesn't mean using 38.90
MHz is right, if the IF SAW filter is fixed and centered at 45.75 MHz.


>  The thing with PAL-Nc is
> that it has a video bandwidth of 4.2MHz not 5.0MHz (page 51) and the
> attenuation of color difference signals for >20dB is at 3.6MHz instead
> of 4MHz (page 54). You can just search for "Argentina" inside the
> document.
> 

Yes, that's fine.

The Video IF is what I am concerned about.  Your change could break
other tuners and/or the linux tuner-simple.ko module is programming
some(?) tuners wrong for PAL-N and PAL-Nc

By the way, this document describes PAL Combination N (-Nc) as a
difference from PAL-N:
ITU-R BT.470-6
http://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.470-6-199811-S!!PDF-E.pdf


Argentine Law 21.895, October 1978, wasn't much help in describing the
technical aspects of PAL-Nc:
http://www.infojus.gov.ar/index.php?kk_seccion=documento&registro=LEYNAC&docid=LEY%2520C%2520021895%25201978%252010%252030


> So, this works... but now I'm not sure why.

Likely the tuner-simple.ko module is programming the mixer oscillator
component for the 38.90 MHz IF.  That may be right or wrong, depending
on you exact tuner model.

Again, what exact tuner assembly are you using?

>  I guess cVideoIF_38_90 is
> compensating for the bandwidth difference. I need to study this.

Nope.  It is just matching how the tuner-simple.ko module programmed the
mixer/oscillator chip.

Regards,
Andy

> Gonzalo
> 
> >
> >>
> >> diff --git a/drivers/media/common/tuners/tda9887.c b/drivers/media/common/tuners/tda9887.c
> >> index cdb645d..b560b5d 100644
> >> --- a/drivers/media/common/tuners/tda9887.c
> >> +++ b/drivers/media/common/tuners/tda9887.c
> >> @@ -168,8 +168,8 @@ static struct tvnorm tvnorms[] = {
> >>                          cAudioIF_6_5   |
> >>                          cVideoIF_38_90 ),
> >>       },{
> >> -             .std   = V4L2_STD_PAL_M | V4L2_STD_PAL_Nc,
> >> -             .name  = "PAL-M/Nc",
> >> +             .std   = V4L2_STD_PAL_M,
> >> +             .name  = "PAL-M",
> >>               .b     = ( cNegativeFmTV  |
> >>                          cQSS           ),
> >>               .c     = ( cDeemphasisON  |
> >> @@ -179,6 +179,17 @@ static struct tvnorm tvnorms[] = {
> >>                          cAudioIF_4_5   |
> >>                          cVideoIF_45_75 ),
> >>       },{
> >> +             .std   = V4L2_STD_PAL_Nc,
> >> +             .name  = "PAL-Nc",
> >> +             .b     = ( cNegativeFmTV  |
> >> +                        cQSS           ),
> >> +             .c     = ( cDeemphasisON  |
> >> +                        cDeemphasis75  |
> >> +                        cTopDefault),
> >> +             .e     = ( cGating_36     |
> >> +                        cAudioIF_4_5   |
> >> +                        cVideoIF_38_90 ),
> >> +     },{
> >>               .std   = V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H,
> >>               .name  = "SECAM-BGH",
> >>               .b     = ( cNegativeFmTV  |
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


