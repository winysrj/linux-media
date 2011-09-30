Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp02.uk.clara.net ([195.8.89.35]:45699 "EHLO
	claranet-outbound-smtp02.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302Ab1I3LLq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 07:11:46 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Problems tuning PAL-D with a Hauppauge HVR-1110 (TDA18271 tuner) - workaround hack included
Date: Fri, 30 Sep 2011 12:11:41 +0100
Cc: LMML <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>,
	devin heitmueller <dheitmueller@kernellabs.com>
References: <201109281350.52099.simon.farnsworth@onelan.com> <4E859E74.7080900@infradead.org>
In-Reply-To: <4E859E74.7080900@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201109301211.41984.simon.farnsworth@onelan.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 30 September 2011, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> Em 28-09-2011 09:50, Simon Farnsworth escreveu:
> > (note - the CC list is everyone over 50% certainty from get_maintainer.pl)
> > 
> > I'm having problems getting a Hauppauge HVR-1110 card to successfully
> > tune PAL-D at 85.250 MHz vision frequency; by experimentation, I've
> > determined that the tda18271 is tuning to a frequency 1.25 MHz lower
> > than the vision frequency I've requested, so the following workaround
> > "fixes" it for me.
> > 
> > diff --git a/drivers/media/common/tuners/tda18271-fe.c 
> > b/drivers/media/common/tuners/tda18271-fe.c
> > index 63cc400..1a94e1a 100644
> > --- a/drivers/media/common/tuners/tda18271-fe.c
> > +++ b/drivers/media/common/tuners/tda18271-fe.c
> > @@ -1031,6 +1031,7 @@ static int tda18271_set_analog_params(struct 
> > dvb_frontend *fe,
> >  		mode = "I";
> >  	} else if (params->std & V4L2_STD_DK) {
> >  		map = &std_map->atv_dk;
> > +                freq += 1250000;
> >  		mode = "DK";
> >  	} else if (params->std & V4L2_STD_SECAM_L) {
> >  		map = &std_map->atv_l;
> 
> If I am to fix this bug, instead of a hack like that, it seems to be better
> to split the .atv_dk line at the struct tda18271_std_map maps on
> drivers/media/common/tuners/tda18271-maps.c.
> 
> Looking at the datasheet, on page 43, available at:
> 	http://www.nxp.com/documents/data_sheet/TDA18271HD.pdf
> 
> The offset values for IF seem ok, but maybe your device is using some variant
> of this chip that requires a different maps table.
>
How would I identify that?

I definitely need the hack on multiple different HVR1110 cards, in different
motherboards, so if it's a new variant needing a new maps table, it should
be possible to distinguish it from the other devices somehow - but I have no
idea how.
-- 
Simon Farnsworth
Software Engineer
ONELAN Limited
http://www.onelan.com/
