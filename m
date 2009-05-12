Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58034 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073AbZELJxu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 05:53:50 -0400
Date: Tue, 12 May 2009 06:53:41 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: eduardo.valentin@nokia.com
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>
Subject: Re: [PATCH v2 1/7] v4l2: video device: Add V4L2_CTRL_CLASS_FMTX
 controls
Message-ID: <20090512065341.46c7c290@pedra.chehab.org>
In-Reply-To: <20090512061043.GB4639@esdhcp037198.research.nokia.com>
References: <1242034309-13448-1-git-send-email-eduardo.valentin@nokia.com>
	<1242034309-13448-2-git-send-email-eduardo.valentin@nokia.com>
	<20090511231703.17087c01@pedra.chehab.org>
	<20090512061043.GB4639@esdhcp037198.research.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 12 May 2009 09:10:43 +0300
Eduardo Valentin <eduardo.valentin@nokia.com> escreveu:

> On Tue, May 12, 2009 at 04:17:03AM +0200, ext Mauro Carvalho Chehab wrote:
> > Em Mon, 11 May 2009 12:31:43 +0300
> > Eduardo Valentin <eduardo.valentin@nokia.com> escreveu:
> > 
> > > This patch adds a new class of extended controls. This class
> > > is intended to support Radio Modulators properties such as:
> > > rds, audio limiters, audio compression, pilot tone generation,
> > > tuning power levels and region related properties.
> > > 
> > > Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> > > ---
> > >  include/linux/videodev2.h |   45 +++++++++++++++++++++++++++++++++++++++++++++
> > >  1 files changed, 45 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > > index ebb2ea6..7559299 100644
> > > --- a/include/linux/videodev2.h
> > > +++ b/include/linux/videodev2.h
> > > @@ -803,6 +803,7 @@ struct v4l2_ext_controls {
> > >  #define V4L2_CTRL_CLASS_USER 0x00980000	/* Old-style 'user' controls */
> > >  #define V4L2_CTRL_CLASS_MPEG 0x00990000	/* MPEG-compression controls */
> > >  #define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class controls */
> > > +#define V4L2_CTRL_CLASS_FMTX 0x009b0000	/* FM Radio Modulator class controls */
> > >  
> > >  #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
> > >  #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
> > > @@ -1141,6 +1142,50 @@ enum  v4l2_exposure_auto_type {
> > >  
> > >  #define V4L2_CID_PRIVACY			(V4L2_CID_CAMERA_CLASS_BASE+16)
> > >  
> > > +/* FM Radio Modulator class control IDs */
> > > +#define V4L2_CID_FMTX_CLASS_BASE		(V4L2_CTRL_CLASS_FMTX | 0x900)
> > > +#define V4L2_CID_FMTX_CLASS			(V4L2_CTRL_CLASS_FMTX | 1)
> > > +
> > > +#define V4L2_CID_RDS_ENABLED			(V4L2_CID_FMTX_CLASS_BASE + 1)
> > > +#define V4L2_CID_RDS_PI				(V4L2_CID_FMTX_CLASS_BASE + 2)
> > > +#define V4L2_CID_RDS_PTY			(V4L2_CID_FMTX_CLASS_BASE + 3)
> > > +#define V4L2_CID_RDS_PS_NAME			(V4L2_CID_FMTX_CLASS_BASE + 4)
> > > +#define V4L2_CID_RDS_RADIO_TEXT			(V4L2_CID_FMTX_CLASS_BASE + 5)
> > > +
> > > +#define V4L2_CID_AUDIO_LIMITER_ENABLED		(V4L2_CID_FMTX_CLASS_BASE + 6)
> > > +#define V4L2_CID_AUDIO_LIMITER_RELEASE_TIME	(V4L2_CID_FMTX_CLASS_BASE + 7)
> > > +#define V4L2_CID_AUDIO_LIMITER_DEVIATION	(V4L2_CID_FMTX_CLASS_BASE + 8)
> > > +
> > > +#define V4L2_CID_AUDIO_COMPRESSION_ENABLED	(V4L2_CID_FMTX_CLASS_BASE + 9)
> > > +#define V4L2_CID_AUDIO_COMPRESSION_GAIN		(V4L2_CID_FMTX_CLASS_BASE + 10)
> > > +#define V4L2_CID_AUDIO_COMPRESSION_THRESHOLD	(V4L2_CID_FMTX_CLASS_BASE + 11)
> > > +#define V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME	(V4L2_CID_FMTX_CLASS_BASE + 12)
> > > +#define V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME	(V4L2_CID_FMTX_CLASS_BASE + 13)
> > > +
> > > +#define V4L2_CID_PILOT_TONE_ENABLED		(V4L2_CID_FMTX_CLASS_BASE + 14)
> > > +#define V4L2_CID_PILOT_TONE_DEVIATION		(V4L2_CID_FMTX_CLASS_BASE + 15)
> > > +#define V4L2_CID_PILOT_TONE_FREQUENCY		(V4L2_CID_FMTX_CLASS_BASE + 16)
> > > +
> > > +#define V4L2_CID_REGION				(V4L2_CID_FMTX_CLASS_BASE + 17)
> > > +enum v4l2_fmtx_region {
> > > +	V4L2_FMTX_REGION_USA			= 0,
> > > +	V4L2_FMTX_REGION_AUSTRALIA		= 1,
> > > +	V4L2_FMTX_REGION_EUROPE			= 2,
> > > +	V4L2_FMTX_REGION_JAPAN			= 3,
> > > +	V4L2_FMTX_REGION_JAPAN_WIDE_BAND	= 4,
> > > +};
> > 
> > Hmm... the region is not just a derived parameter, based on
> > preemphasis/frequencies, and channel stepping? What this parameter controls?
> 
> Hi Mauro, I thought in the opposite way. The other parameters are derived
> from the region parameter. So, you just set the region, then it will affect
> the frequency range, channel stepping and preemphasis.
> 
> However, there was some resistance to have this inside kernel
> (in previous discussion). One suggested to use database in user land
> (or similar thing). In that case, driver(s) would
> report its constraints based on device values, not in region settings.
> But, this patch set is proposing to have it inside the kernel as you can see.

The point is that the region and the other parameters are interrelated. So,
you're specifying the same thing twice. In order to follow the V4L2 spirit,
where video standards aren't determined by a Country based table, but, instead,
by their technical differences, IMO, we should remove this. Also, I don't doubt
that some countries would come with new settings as they deploy some digital radio
broadcast standard.

> I'd like to hear more opinions though.

Yes, it would be nice to have more opinions about the API changes.

Cheers,
Mauro




Cheers,
Mauro
