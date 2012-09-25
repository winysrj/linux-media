Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:36186 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab2IYNpZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 09:45:25 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv1 API PATCH 4/4] tuner-core: map audmode to STEREO for radio devices.
Date: Tue, 25 Sep 2012 15:45:00 +0200
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
References: <1347621336-14108-1-git-send-email-hans.verkuil@cisco.com> <97c2130954d0c14e16e0e7b08b29405e48a9687e.1347620872.git.hans.verkuil@cisco.com> <20120925103340.76a5db3c@redhat.com>
In-Reply-To: <20120925103340.76a5db3c@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209251545.00414.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 25 September 2012 15:33:40 Mauro Carvalho Chehab wrote:
> Em Fri, 14 Sep 2012 13:15:36 +0200
> Hans Verkuil <hans.verkuil@cisco.com> escreveu:
> 
> > Fixes a v4l2-compliance error: setting audmode to a value other than mono
> > or stereo for a radio device should map to MODE_STEREO.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/v4l2-core/tuner-core.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
> > index b5a819a..ea71371 100644
> > --- a/drivers/media/v4l2-core/tuner-core.c
> > +++ b/drivers/media/v4l2-core/tuner-core.c
> > @@ -1235,8 +1235,11 @@ static int tuner_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
> >  	if (set_mode(t, vt->type))
> >  		return 0;
> >  
> > -	if (t->mode == V4L2_TUNER_RADIO)
> > +	if (t->mode == V4L2_TUNER_RADIO) {
> >  		t->audmode = vt->audmode;
> > +		if (t->audmode > V4L2_TUNER_MODE_STEREO)
> > +			t->audmode = V4L2_TUNER_MODE_STEREO;
> 
> NACK. It is not a core's task to fix driver's bugs. It would be ok to have here a
> WARN_ON(), but, if a driver is reporting a wrong radio audmode, the fix should be
> there at the drivers, and not here at the core.

tuner-core *is* the driver. A bridge driver just passes v4l2_tuner on to the
subdev driver(s), and it is the subdev driver such as tuner-core that needs to
process the audmode as specified by the user. Which in this case means mapping
audmodes that are invalid when in radio mode to something that is valid as per
the spec.

So this is a real tuner-core bug, not a bridge driver bug since they don't
generally touch the audmode field, they just pass it along. And the vt->audmode
value comes straight from userspace, not from the bridge driver.

Regards,

	Hans
