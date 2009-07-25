Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1188 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbZGYNbp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 09:31:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: eduardo.valentin@nokia.com
Subject: Re: [PATCHv10 6/8] FMTx: si4713: Add files to handle si4713 i2c device
Date: Sat, 25 Jul 2009 15:31:29 +0200
Cc: ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1248453448-1668-1-git-send-email-eduardo.valentin@nokia.com> <200907251520.53119.hverkuil@xs4all.nl> <20090725131524.GB10561@esdhcp037198.research.nokia.com>
In-Reply-To: <20090725131524.GB10561@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907251531.29726.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 25 July 2009 15:15:24 Eduardo Valentin wrote:
> On Sat, Jul 25, 2009 at 03:20:53PM +0200, ext Hans Verkuil wrote:
> > > +     switch (control->id) {
> > > +     case V4L2_CID_RDS_TX_PS_NAME:
> > > +             if (strlen(sdev->rds_info.ps_name) + 1 > control->length) {
> > > +                     control->length = strlen(sdev->rds_info.ps_name) + 1;
> > 
> > I recommend setting length to the actual maximum MAX_RDS_PS_NAME+1.
> > 
> > > +                     rval = -ENOSPC;
> > > +                     goto exit;
> > > +             }
> > > +             rval = copy_to_user(control->string, sdev->rds_info.ps_name,
> > > +                                     strlen(sdev->rds_info.ps_name) + 1);
> > > +             break;
> > > +
> > > +     case V4L2_CID_RDS_TX_RADIO_TEXT:
> > > +             if (strlen(sdev->rds_info.radio_text) + 1 > control->length) {
> > > +                     control->length = strlen(sdev->rds_info.radio_text) + 1;
> > 
> > Ditto.
> 
> Right, I think doing the way you are proposing is to avoid changes that may generate
> failures in the following reads.
> 
> I 'll change this in the v11 as well.

OK.

> > > +struct rds_info {
> > > +     u32 pi;
> > > +#define MAX_RDS_PTY                  31
> > > +     u32 pty;
> > > +#define MAX_RDS_DEVIATION            90000
> > > +     u32 deviation;
> > > +#define MAX_RDS_PS_NAME                      96
> > > +     u8 ps_name[MAX_RDS_PS_NAME + 1];
> > > +#define MAX_RDS_RADIO_TEXT           384
> > 
> > I'm surprised at these MAX string lengths. Looking at the RDS standard it
> > seems that the max length for the PS_NAME is 8 and for RADIO_TEXT it is
> > either 32 (2A group) or 64 (2B group). I don't know which group the si4713
> > uses.
> > 
> > Can you clarify how this is used?

Did you see this comment as well? I'm quite interested in this.

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
