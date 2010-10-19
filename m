Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:17599 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab0JSHeb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 03:34:31 -0400
Subject: Re: [PATCH v13 1/1] Documentation: v4l: Add hw_seek spacing and  
 two TUNER_RDS_CAP flags.
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
In-Reply-To: <ec5341251875e33faaea9cc94c160978.squirrel@webmail.xs4all.nl>
References: <1287406657-18859-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1287406657-18859-2-git-send-email-matti.j.aaltonen@nokia.com>
	 <9c6327556dad0b210e353c11126e2ceb.squirrel@webmail.xs4all.nl>
	 <4CBC4E73.70601@redhat.com>
	 <ec5341251875e33faaea9cc94c160978.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 10:34:15 +0300
Message-ID: <1287473655.7176.41.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi.

On Mon, 2010-10-18 at 15:57 +0200, ext Hans Verkuil wrote:
> > Em 18-10-2010 11:17, Hans Verkuil escreveu:
> >> Just a few very small comments:
> >
> >>> +For future use the
> >>> +flag <constant>V4L2_TUNER_SUB_RDS_CONTROLS</constant> has also been
> >>> +defined. However, a driver for a radio tuner with this capability does
> >>> +not yet exist, so if you are planning to write such a driver the best
> >>> +way to start would probably be by opening a discussion about it on
> >>> +the linux-media mailing list: &v4l-ml;. </para>
> >>
> >> Change to:
> >>
> >> not yet exist, so if you are planning to write such a driver you
> >> should discuss this on the linux-media mailing list: &v4l-ml;.</para>
> >
> > No, please. Don't add any API capabilities at the DocBook without having a
> > driver
> > using it. At the time a driver start needing it, we can just add the API
> > bits
> > and doing the needed discussions as you've proposed. This is already
> > implicit.
> 
> These caps are shared between tuner and modulator. And for the modulator
> both caps *are* used in Matti's driver. But while RDS_CONTROLS is
> available for modulators, it is not yet applicable to tuners and for that
> we need to make this note in the spec.
> 
> So this is an exception to the rule, I'm afraid.

So it's ACK... or NACK?

Cheers,
Matti

> Regards,
> 
>         Hans
> 


