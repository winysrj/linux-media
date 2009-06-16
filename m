Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:31600 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZFPLNm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 07:13:42 -0400
Date: Tue, 16 Jun 2009 14:07:55 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PATCHv7 0/9] FM Transmitter (si4713) and another changes
Message-ID: <20090616110755.GD16092@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1244827840-886-1-git-send-email-eduardo.valentin@nokia.com> <200906141337.20665.hverkuil@xs4all.nl> <20090616104714.GA16092@esdhcp037198.research.nokia.com> <200906161301.51543.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906161301.51543.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 16, 2009 at 01:01:51PM +0200, ext Hans Verkuil wrote:
> On Tuesday 16 June 2009 12:47:14 Eduardo Valentin wrote:
> > Hi Hans,
> >
> > On Sun, Jun 14, 2009 at 01:37:20PM +0200, ext Hans Verkuil wrote:
> 
> <snip>
> 
> > > I think the refactoring should be done first. I don't believe it is
> > > that much work and experience shows that it is better to do this right
> > > away while you are still motivated :-)
> >
> > hehehe.. Yes, that's what I was expecting :-). No problem. I've started
> > it. I will resend the series once I've completed the re-factoring and I
> > 've made some testing after that. I hope tomorrow or so.
> >
> > > The string control support should not go into 2.6.31. I would like to
> > > do that only in the v4l-dvb tree (so it will appear in 2.6.32) since I
> > > want to give that a bit more time to mature. I implemented it very
> > > quickly and I do not feel comfortable queueing this for 2.6.31.
> >
> > Right. Yes, better to test the stuff a bit more.
> >
> > > In addition it is still unclear if Mauro will merge my v4l-dvb-subdev2
> > > tree for 2.6.31. I hope so, since otherwise it will hamper the
> > > development of this and other embedded platforms.
> >
> > Ok.
> >
> > > I also need to add a new V4L2_CAP_MODULATOR (which needs a review as
> > > well).
> > >
> > > And finally I realized that we need to add some v4l2_modulator
> > > capabilities for the RDS encoder similar to the upcoming v4l2_tuner RDS
> > > capabilities as is described in this RFC:
> > >
> > > http://www.mail-archive.com/linux-media%40vger.kernel.org/msg02498.html
> > >
> > > I haven't had time to implement this RFC and I know that is not going
> > > to make 2.6.31. It's now almost at the top of my TODO list, so it
> > > should go in soon (pending unforeseen circumstances).
> >
> > Ok. I'll take a look at it.
> 
> I've worked on this yesterday. You can take a look at my v4l-dvb-rds tree. 
> Both the API and the documentation of it in the v4l2-spec is in there. I 
> started work on updating the few RDS decoders that we have, but that is not 
> yet in that tree.
> 
> > > As a result of rereading this RFC I also started to wonder about
> > > whether the si4713 supports the MMBS functionality. Do you know
> > > anything about that?
> >
> > No. Not that I know. Can you point some link?
> 
> http://www.rds.org.uk/rdsfrdsrbds.html
> 
> But I've just read here:
> 
> http://www.rds.org.uk/rds98/pdf/rdsForum_standards_090414_8.pdf
> 
> that MMBS is discontinued. I'll need to investigate this further, but if 
> this is indeed true then this can be removed completely from our RDS 
> decoder and encoder APIs.

Yes, better to double check. At least with si4713, I haven't heard anything about this.

> 
> Regards,
> 
> 	Hans
> 
> 
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

-- 
Eduardo Valentin
