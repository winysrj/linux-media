Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:35792 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZFNQXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 12:23:39 -0400
Date: Sun, 14 Jun 2009 09:23:41 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Eduardo Valentin <edubezval@gmail.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PATCHv7 2/9] v4l2: video device: Add V4L2_CTRL_CLASS_FM_TX
 controls
In-Reply-To: <a0580c510906140350o532a106dm1e2f876ebc60b3d0@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0906140919110.32713@shell2.speakeasy.net>
References: <1244827840-886-1-git-send-email-eduardo.valentin@nokia.com>
 <1244827840-886-2-git-send-email-eduardo.valentin@nokia.com>
 <1244827840-886-3-git-send-email-eduardo.valentin@nokia.com>
 <200906141246.02884.hverkuil@xs4all.nl> <a0580c510906140350o532a106dm1e2f876ebc60b3d0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 14 Jun 2009, Eduardo Valentin wrote:
> >> +/* FM Modulator class control IDs */
> >> +#define V4L2_CID_FM_TX_CLASS_BASE      (V4L2_CTRL_CLASS_FM_TX | 0x900)
> >> +#define V4L2_CID_FM_TX_CLASS                 (V4L2_CTRL_CLASS_FM_TX | 1)
> >> +
> >> +#define V4L2_CID_RDS_ENABLED                 (V4L2_CID_FM_TX_CLASS_BASE + 1)
> >> +#define V4L2_CID_RDS_PI                              (V4L2_CID_FM_TX_CLASS_BASE + 2)
> >> +#define V4L2_CID_RDS_PTY                     (V4L2_CID_FM_TX_CLASS_BASE + 3)
> >> +#define V4L2_CID_RDS_PS_NAME                 (V4L2_CID_FM_TX_CLASS_BASE + 4)
> >> +#define V4L2_CID_RDS_RADIO_TEXT                      (V4L2_CID_FM_TX_CLASS_BASE + 5)
> >
> > I think these RDS controls should be renamed to V4L2_CID_RDS_TX_. This makes
> > it clear that these controls relate to the RDS transmitter instead of a
> > receiver. I would not be surprised to see similar controls appear for an RDS
> > receiver in the future.

So there should there be different controls to set the same thing, one set
for tx and another for rx?

> >> +#define V4L2_CID_PREEMPHASIS                 (V4L2_CID_FM_TX_CLASS_BASE + 17)
> >> +enum v4l2_fm_tx_preemphasis {
> >> +     V4L2_FM_TX_PREEMPHASIS_DISABLED         = 0,
> >> +     V4L2_FM_TX_PREEMPHASIS_50_uS            = 1,
> >> +     V4L2_FM_TX_PREEMPHASIS_75_uS            = 2,
> >> +};
> >
> > I suggest renaming this to V4L2_CID_FM_TX_PREEMPHASIS. There is already a
> > similar V4L2_CID_MPEG_EMPHASIS control and others might well appear in the
> > future, so I think this name should be more specific to the FM_TX API.

The cx88 driver could get support for setting the fm preemphasis via a
control.  I added support via a module option, but a control would be
better.  You're saying it shouldn't use this fm preemphasis control?
