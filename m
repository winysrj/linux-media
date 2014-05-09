Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50231 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750702AbaEINq0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 9 May 2014 09:46:26 -0400
Date: Fri, 9 May 2014 16:46:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: V4L control units
Message-ID: <20140509134622.GK8753@valkosipuli.retiisi.org.uk>
References: <536A2DA7.7050803@iki.fi>
 <20140508090446.GG8753@valkosipuli.retiisi.org.uk>
 <536CD0A9.4020904@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536CD0A9.4020904@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, May 09, 2014 at 02:57:13PM +0200, Hans Verkuil wrote:
> On 05/08/2014 11:04 AM, Sakari Ailus wrote:
> > Heippa!
> > 
> > On Wed, May 07, 2014 at 03:57:11PM +0300, Antti Palosaari wrote:
> >> What is preferred way implement controls that could have some known
> >> unit or unknown unit? For example for gain controls, I would like to
> >> offer gain in unit of dB (decibel) and also some unknown driver
> >> specific unit. Should I two controls, one for each unit?
> >>
> >> Like that
> >>
> >> V4L2_CID_RF_TUNER_LNA_GAIN_AUTO
> >> V4L2_CID_RF_TUNER_LNA_GAIN
> >> V4L2_CID_RF_TUNER_LNA_GAIN_dB
> > 
> > I suppose that on any single device there would be a single unit to control
> > a given... control. Some existing controls do document the unit as well but
> > I don't think that's scalable nor preferrable. This way we'd have many
> > different controls to control the same thing but just using a different
> > unit. The auto control is naturally different. Hans did have a patch to add
> > the unit to queryctrl (in the form of QUERY_EXT_CTRL).
> 
> Well, that's going to be dropped again. There were too many comments about
> that during the mini-summit and it was not critical for me.

Ok. Thanks for the information.

> > <URL:http://www.spinics.net/lists/linux-media/msg73136.html>
> > 
> > I wish we can get these in relatively soon.
> 
> Sakari, I think you will have to push this if you want this done.

Ack. I think I proposed something like this already a few years ago so I'm
fine picking it up. :-) Now it's a good time to add the required space in
the struct as we're going to have a new IOCTL anyway.

> One interesting thing to look at: the AVB IEEE 1722.1 standard has extensive
> support for all sorts of units. I don't know if you have access to the standard
> document, but it might be interesting to look at what they do there.

I have access to it but I don't see this would be that interesting in
regards to what we're doing. In any case, we should document the units so
that different drivers end up using exactly the same string to signal a
particular unit.

I prefer to have a prefix as well: a lot of hardware devices use binary
fractions so that even if we provide an integer control to the user the
actual control value may well be divided by e.g. 256. That is a somewhat
separate topic still.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
