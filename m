Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2002 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400Ab0EBWYO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 May 2010 18:24:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 08/15] [RFC] cx25840/ivtv: replace ugly priv control with s_config
Date: Mon, 3 May 2010 00:25:14 +0200
Cc: linux-media@vger.kernel.org
References: <cover.1272267136.git.hverkuil@xs4all.nl> <726d8aa69a6dac2fb3226b13ad6b6be8c3a5544d.1272267137.git.hverkuil@xs4all.nl> <201005022241.29562.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201005022241.29562.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005030025.14477.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 02 May 2010 22:41:29 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 26 April 2010 09:33:54 Hans Verkuil wrote:
> > The cx25840 used a private control CX25840_CID_ENABLE_PVR150_WORKAROUND
> > to be told whether to enable a workaround for certain pvr150 cards.
> > 
> > This is really config data that it needs to get at load time.
> > 
> > Implemented this in cx25840 and ivtv.
> > 
> > Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> > ---
> >  drivers/media/video/cx25840/cx25840-core.c |   23 +++++++++++++++--------
> >  drivers/media/video/cx25840/cx25840-core.h |    8 --------
> >  drivers/media/video/ivtv/ivtv-driver.c     |    9 +--------
> >  drivers/media/video/ivtv/ivtv-i2c.c        |    7 +++++++
> >  include/media/cx25840.h                    |   11 +++++++++++
> >  5 files changed, 34 insertions(+), 24 deletions(-)
> > 
> > diff --git a/drivers/media/video/cx25840/cx25840-core.c
> > b/drivers/media/video/cx25840/cx25840-core.c index f2461cd..b8aa5d2 100644
> > --- a/drivers/media/video/cx25840/cx25840-core.c
> > +++ b/drivers/media/video/cx25840/cx25840-core.c
> 
> [snip]
> 
> > @@ -1601,10 +1593,25 @@ static int cx25840_log_status(struct v4l2_subdev
> > *sd) return 0;
> >  }
> > 
> > +static int cx25840_s_config(struct v4l2_subdev *sd, int irq, void
> > *platform_data) +{
> > +	struct cx25840_state *state = to_state(sd);
> > +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +
> > +	if (platform_data) {
> > +		struct cx25840_platform_data *pdata = platform_data;
> > +
> > +		state->pvr150_workaround = pdata->pvr150_workaround;
> > +		set_input(client, state->vid_input, state->aud_input);
> > +	}
> > +	return 0;
> > +}
> > +
> 
> You've told me that s_config was only meant for I2C devices in pre-2.6.26 
> kernels. Shouldn't this be done in the probe function instead ?

s_config is only meant for i2c drivers that have to support pre-2.6.26
kernels (only applicable for the hg tree, of course). And that is definitely
the case for cx25840.

As a side note: we could decide to ditch that backwards compatibility support
in the git tree of course, but I don't know how problematic that may turn out
to be for the hg tree maintenance. Anyway, I have too much to do already :-)

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
