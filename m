Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3279 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbZFNQ7P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 12:59:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCHv7 2/9] v4l2: video device: Add V4L2_CTRL_CLASS_FM_TX  controls
Date: Sun, 14 Jun 2009 18:59:13 +0200
Cc: Eduardo Valentin <edubezval@gmail.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1244827840-886-1-git-send-email-eduardo.valentin@nokia.com> <a0580c510906140350o532a106dm1e2f876ebc60b3d0@mail.gmail.com> <Pine.LNX.4.58.0906140919110.32713@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0906140919110.32713@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906141859.13982.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 14 June 2009 18:23:41 Trent Piepho wrote:
> On Sun, 14 Jun 2009, Eduardo Valentin wrote:
> > >> +/* FM Modulator class control IDs */
> > >> +#define V4L2_CID_FM_TX_CLASS_BASE      (V4L2_CTRL_CLASS_FM_TX | 0x900)
> > >> +#define V4L2_CID_FM_TX_CLASS                 (V4L2_CTRL_CLASS_FM_TX | 1)
> > >> +
> > >> +#define V4L2_CID_RDS_ENABLED                 (V4L2_CID_FM_TX_CLASS_BASE + 1)
> > >> +#define V4L2_CID_RDS_PI                              (V4L2_CID_FM_TX_CLASS_BASE + 2)
> > >> +#define V4L2_CID_RDS_PTY                     (V4L2_CID_FM_TX_CLASS_BASE + 3)
> > >> +#define V4L2_CID_RDS_PS_NAME                 (V4L2_CID_FM_TX_CLASS_BASE + 4)
> > >> +#define V4L2_CID_RDS_RADIO_TEXT                      (V4L2_CID_FM_TX_CLASS_BASE + 5)
> > >
> > > I think these RDS controls should be renamed to V4L2_CID_RDS_TX_. This makes
> > > it clear that these controls relate to the RDS transmitter instead of a
> > > receiver. I would not be surprised to see similar controls appear for an RDS
> > > receiver in the future.
> 
> So there should there be different controls to set the same thing, one set
> for tx and another for rx?

Sure. Say some RDS decoder stores the PI in a register. I can imagine that
we add a V4L2_CID_RDS_RX_PI control for that. Whereas a V4L2_CID_RDS_TX_PI
control will return the PI sent out by the encoder.

Currently no such controls exist (or are needed) for an RDS decoder, but I
wouldn't be surprised at all if we need them at some point in the future.

> 
> > >> +#define V4L2_CID_PREEMPHASIS                 (V4L2_CID_FM_TX_CLASS_BASE + 17)
> > >> +enum v4l2_fm_tx_preemphasis {
> > >> +     V4L2_FM_TX_PREEMPHASIS_DISABLED         = 0,
> > >> +     V4L2_FM_TX_PREEMPHASIS_50_uS            = 1,
> > >> +     V4L2_FM_TX_PREEMPHASIS_75_uS            = 2,
> > >> +};
> > >
> > > I suggest renaming this to V4L2_CID_FM_TX_PREEMPHASIS. There is already a
> > > similar V4L2_CID_MPEG_EMPHASIS control and others might well appear in the
> > > future, so I think this name should be more specific to the FM_TX API.
> 
> The cx88 driver could get support for setting the fm preemphasis via a
> control.  I added support via a module option, but a control would be
> better.  You're saying it shouldn't use this fm preemphasis control?

Correct. This set the pre-emphasis when transmitting. For receiving you want
a separate control. Although the enum should be made generic. So FM_TX can be
removed from the enum.

Why should we have one rx and one tx control for this? Because you can have
both receivers and transmitters in one device and you want independent control
of the two.

It is my believe that the other fm_tx controls are unambiguously transmitter
related, so I don't think they need a TX prefix. It doesn't hurt if someone
can double check that, though.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
