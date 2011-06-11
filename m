Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4972 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757665Ab1FKNxl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 09:53:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv1 PATCH 3/7] tuner-core: fix g_frequency support.
Date: Sat, 11 Jun 2011 15:53:35 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl> <0d7f8cae6d252df04dbbcc6515507a9f7e00b895.1307798213.git.hans.verkuil@cisco.com> <4DF3714B.70507@redhat.com>
In-Reply-To: <4DF3714B.70507@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106111553.35384.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, June 11, 2011 15:44:43 Mauro Carvalho Chehab wrote:
> Em 11-06-2011 10:34, Hans Verkuil escreveu:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > VIDIOC_G_FREQUENCY should not check the tuner type, instead that is
> > something the driver fill in.
> > 
> > Since apps will often leave the type at 0, the 'supported_mode' call
> > will return false and the frequency never gets filled in.
> > 
> > Remove this check.
> 
> This patch is wrong, as it breaks support for devices with multiple
> tuners (e. g. a tea5767 for radio and another tuner for TV).

Thanks for catching this, I had it right in an earlier version, but it
got lost somewhere along the way.

What should happen is that this should be added at the beginning:

if (t->standby)
	return 0;

Ditto for g_tuner. If the current mode is not supported, standby is set to
true.

Regards,

	Hans

> 
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/video/tuner-core.c |    2 --
> >  1 files changed, 0 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
> > index ee43e0a..4d8dcea 100644
> > --- a/drivers/media/video/tuner-core.c
> > +++ b/drivers/media/video/tuner-core.c
> > @@ -1132,8 +1132,6 @@ static int tuner_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
> >  	struct tuner *t = to_tuner(sd);
> >  	struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
> >  
> > -	if (!supported_mode(t, f->type))
> > -		return 0;
> >  	f->type = t->mode;
> >  	if (fe_tuner_ops->get_frequency && !t->standby) {
> >  		u32 abs_freq;
> 
> 
