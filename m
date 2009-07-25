Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4115 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZGYOj1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 10:39:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: eduardo.valentin@nokia.com
Subject: Re: [PATCHv10 6/8] FMTx: si4713: Add files to handle si4713 i2c device
Date: Sat, 25 Jul 2009 16:39:18 +0200
Cc: "Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"dougsland@gmail.com" <dougsland@gmail.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1248453448-1668-1-git-send-email-eduardo.valentin@nokia.com> <200907251533.55361.hverkuil@xs4all.nl> <20090725132521.GE10561@esdhcp037198.research.nokia.com>
In-Reply-To: <20090725132521.GE10561@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907251639.18441.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 25 July 2009 15:25:21 Eduardo Valentin wrote:
> On Sat, Jul 25, 2009 at 03:33:55PM +0200, ext Hans Verkuil wrote:
> > On Saturday 25 July 2009 15:29:38 ext-Eero.Nurkkala@nokia.com wrote:
> > > 
> > > > I'm surprised at these MAX string lengths. Looking at the RDS standard it
> > > > seems that the max length for the PS_NAME is 8 and for RADIO_TEXT it is
> > > > either 32 (2A group) or 64 (2B group). I don't know which group the si4713
> > > > uses.
> > > > 
> > > > Can you clarify how this is used?
> > > > 
> > > > Regards,
> > > > 
> > > >         Hans
> > > 
> > > Well, PS_NAME can be 8 x n, but only 8 bytes are shown at once...
> > > so it keeps 'scrolling', or changes periodically. There's even commercial
> > > radio stations that do so.
> > 
> > And I'm assuming that the same is true for radio text. However, this behavior
> > contradicts the control description in the spec, so that should be clarified.
> 
> Yes, I'll add a comment explaining this for those defines.

Another question: what happens if I give a string that's e.g. 10 characters
long? What will happen then?

If the string must be exactly 8 x n long, then I think that it is a good idea
to start using the 'step' value of v4l2_queryctrl: this can be used to tell
the application that string lengths should be a multiple of the step value.
I've toyed with that idea before but I couldn't think of a good use case,
but this might be it.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
