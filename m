Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:52345 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbZFPSGx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 14:06:53 -0400
Date: Tue, 16 Jun 2009 11:06:55 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
cc: ext Hans Verkuil <hverkuil@xs4all.nl>,
	Eduardo Valentin <edubezval@gmail.com>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PATCHv7 2/9] v4l2: video device: Add V4L2_CTRL_CLASS_FM_TX
 controls
In-Reply-To: <20090616105234.GB16092@esdhcp037198.research.nokia.com>
Message-ID: <Pine.LNX.4.58.0906161104260.32713@shell2.speakeasy.net>
References: <1244827840-886-1-git-send-email-eduardo.valentin@nokia.com>
 <a0580c510906140350o532a106dm1e2f876ebc60b3d0@mail.gmail.com>
 <Pine.LNX.4.58.0906140919110.32713@shell2.speakeasy.net>
 <200906141859.13982.hverkuil@xs4all.nl> <20090616105234.GB16092@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 16 Jun 2009, Eduardo Valentin wrote:
> On Sun, Jun 14, 2009 at 06:59:13PM +0200, ext Hans Verkuil wrote:
> > On Sunday 14 June 2009 18:23:41 Trent Piepho wrote:
> > > > > similar V4L2_CID_MPEG_EMPHASIS control and others might well appear in the
> > > > > future, so I think this name should be more specific to the FM_TX API.
> > >
> > > The cx88 driver could get support for setting the fm preemphasis via a
> > > control.  I added support via a module option, but a control would be
> > > better.  You're saying it shouldn't use this fm preemphasis control?
> >
> > Correct. This set the pre-emphasis when transmitting. For receiving you want
> > a separate control. Although the enum should be made generic. So FM_TX can be
> > removed from the enum.
> >
> > Why should we have one rx and one tx control for this? Because you can have
> > both receivers and transmitters in one device and you want independent control
> > of the two.
>
> Yes, agreed here. There is the possibility to have receiver and transmitter
> both in the same device. So, I think it is better to have separated controls.

Is both a receiver and transmitter in the same device different than having
two receivers or two transmitters?  In which case, since controls are not
assigned to a specific input, how does one handle that?
