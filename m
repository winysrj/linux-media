Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1144 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab1F1GLU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 02:11:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv3 PATCH 08/18] v4l2-ctrls: add v4l2_ctrl_auto_cluster to simplify autogain/gain scenarios
Date: Tue, 28 Jun 2011 08:11:07 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl> <79b139274f67e1e17b56ab49ece643e9cb106e99.1307458245.git.hans.verkuil@cisco.com> <4E08F1D9.6080903@redhat.com>
In-Reply-To: <4E08F1D9.6080903@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106280811.07289.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, June 27, 2011 23:10:49 Mauro Carvalho Chehab wrote:
> Em 07-06-2011 12:05, Hans Verkuil escreveu:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > It is a bit tricky to handle autogain/gain type scenerios correctly. Such
> > controls need to be clustered and the V4L2_CTRL_FLAG_UPDATE should be set on
> > the autofoo controls. In addition, the manual controls should be marked
> > inactive when the automatic mode is on, and active when the manual mode is on.
> > This also requires specialized volatile handling.
> > 
> > The chances of drivers doing all these things correctly are pretty remote.
> > So a new v4l2_ctrl_auto_cluster function was added that takes care of these
> > issues.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/video/v4l2-ctrls.c |   69 +++++++++++++++++++++++++++++++------
> >  include/media/v4l2-ctrls.h       |   45 ++++++++++++++++++++++++
> >  2 files changed, 102 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> > index a46d5c1..c39ab0c 100644
> > --- a/drivers/media/video/v4l2-ctrls.c
> > +++ b/drivers/media/video/v4l2-ctrls.c
> > @@ -39,6 +39,20 @@ struct ctrl_helper {
> >  	bool handled;
> >  };
> >  
> > +/* Small helper function to determine if the autocluster is set to manual
> > +   mode. In that case the is_volatile flag should be ignored. */
> > +static bool is_cur_manual(const struct v4l2_ctrl *master)
> > +{
> > +	return master->is_auto && master->cur.val == master->manual_mode_value;
> > +}
> > +
> > +/* Same as above, but this checks the against the new value instead of the
> > +   current value. */
> > +static bool is_new_manual(const struct v4l2_ctrl *master)
> > +{
> > +	return master->is_auto && master->val == master->manual_mode_value;
> > +}
> > +
> >  /* Returns NULL or a character pointer array containing the menu for
> >     the given control ID. The pointer array ends with a NULL pointer.
> >     An empty string signifies a menu entry that is invalid. This allows
> > @@ -643,7 +657,7 @@ static int ctrl_is_volatile(struct v4l2_ext_control *c,
> >  }
> >  
> >  /* Copy the new value to the current value. */
> > -static void new_to_cur(struct v4l2_ctrl *ctrl)
> > +static void new_to_cur(struct v4l2_ctrl *ctrl, bool update_inactive)
> >  {
> >  	if (ctrl == NULL)
> >  		return;
> > @@ -659,6 +673,11 @@ static void new_to_cur(struct v4l2_ctrl *ctrl)
> >  		ctrl->cur.val = ctrl->val;
> >  		break;
> >  	}
> > +	if (update_inactive) {
> > +		ctrl->flags &= ~V4L2_CTRL_FLAG_INACTIVE;
> > +		if (!is_cur_manual(ctrl->cluster[0]))
> > +			ctrl->flags |= V4L2_CTRL_FLAG_INACTIVE;
> > +	}
> >  }
> >  
> >  /* Copy the current value to the new value */
> > @@ -1166,7 +1185,7 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
> >  	int i;
> >  
> >  	/* The first control is the master control and it must not be NULL */
> > -	BUG_ON(controls[0] == NULL);
> > +	BUG_ON(ncontrols == 0 || controls[0] == NULL);
> >  
> >  	for (i = 0; i < ncontrols; i++) {
> >  		if (controls[i]) {
> > @@ -1177,6 +1196,28 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
> >  }
> >  EXPORT_SYMBOL(v4l2_ctrl_cluster);
> >  
> > +void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
> > +			    u8 manual_val, bool set_volatile)
> > +{
> > +	struct v4l2_ctrl *master = controls[0];
> > +	u32 flag;
> > +	int i;
> > +
> > +	v4l2_ctrl_cluster(ncontrols, controls);
> > +	WARN_ON(ncontrols <= 1);
> > +	master->is_auto = true;
> > +	master->manual_mode_value = manual_val;
> > +	master->flags |= V4L2_CTRL_FLAG_UPDATE;
> > +	flag = is_cur_manual(master) ? 0 : V4L2_CTRL_FLAG_INACTIVE;
> > +
> > +	for (i = 1; i < ncontrols; i++)
> 
> Hmm... the first control _should_ be the autogain one. This is documented at the ABI
> description, but it would be good to have a comment about there at the *.h file.

Huh? It's there already:

  * @controls:  The cluster control array of size @ncontrols. The first control
  *             must be the 'auto' control (e.g. autogain, autoexposure, etc.)

Regards,

	Hans
