Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:45637 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761101AbZAPQcj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2009 11:32:39 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1637947rvb.1
        for <linux-media@vger.kernel.org>; Fri, 16 Jan 2009 08:32:38 -0800 (PST)
From: Andreas <linuxdreas@dslextreme.com>
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] mxl5005s tuner analog support
Date: Fri, 16 Jan 2009 08:32:35 -0800
References: <412bdbff0812261348h35b28437m5c87f43a3e6a5e33@mail.gmail.com> <1230333055.3125.6.camel@palomino.walls.org> <412bdbff0812261908l262ef8f1h8362910a88e846f6@mail.gmail.com>
In-Reply-To: <412bdbff0812261908l262ef8f1h8362910a88e846f6@mail.gmail.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901160832.35850.linuxdreas@dslextreme.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, 26. Dezember 2008 19:08:29 schrieb Devin Heitmueller:
> On Fri, Dec 26, 2008 at 6:10 PM, Andy Walls <awalls@radix.net> wrote:
> > On Fri, 2008-12-26 at 16:48 -0500, Devin Heitmueller wrote:
> >> Hello,
> >>
> >> I working on the analog support for the Pinnacle Ultimate 880e
> >> support, and that device includes an mxl5005s tuner.
> >>
> >> I went to do the normal changes to em28xx to support another
> >> tuner, which prompted me to wonder:
> >>
> >> Is the analog support known to to work in Linux for this tuner for
> >> any other device?
> >>
> >> The reason I ask is because I hit an oops and when I looked at the
> >> source I found some suspicious things:
> >>
> >> * No entry in tuner.h
> >> * No attach command in tuner-core.c
> >> * No definition of set_analog_params() callback in mxl5005s.c
> >
> > The mxl5005s support was added to the v4l-dvb repo by Steven Toth
> > for the HVR-1600 which uses it exclusively for ATSC (QAM and
> > 8-VSB).
> >
> > The source of Steve's driver is from RealTek.  More comments on
> > origin can be found in the mxl5005s.[ch] files.
> >
> > There is some history in the list archives between Steve and Manu
> > (and me indirectly) on the use of the mxl500x source module.
> >
> >> I wonder if perhaps the driver was ported from some other source
> >> and nobody ever got around to getting the analog support working? 
> >> If that's the case then that is fine (I'll make it work), but I
> >> want to know if I am just missing something obvious here....
> >
> > I'd like to get the driver working a little better myself.  Steve
> > said the QAM suffers a 3 dB hit compared to Manu's version (IIRC). 
> > I'd like a decent signal strength readout.   If I had a data sheet
> > from MaxLinear maybe I could do something.  It still looks like
> > details of external tracking filter hardware need to be known and
> > tested for each particular board though.
> >
> > Regards,
> > Andy
>
> Thanks for the feedback.  I just wanted a sanity check that I wasn't
> missing something obvious.  I'll take a look at the code, as well as
> the original RealTek code and see if I can get the analog side
> working.
>
> I'll send some emails and see if I can get the datasheet - I didn't
> ask for it when I started the work since I was under the impression
> that the driver was mature.
>
> Devin

I seem to be affected by that 3db loss between the old mxl500x and the 
mxl5005s driver. Did you ever get the datasheets and is anyone perhaps 
even working on squeezing a little more out of the driver?

-- 
Gruﬂ
Andreas
