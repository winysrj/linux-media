Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2325 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab1FCIGQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2011 04:06:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [RFCv1 PATCH 4/5] DocBook: document autoclusters.
Date: Fri, 3 Jun 2011 10:06:11 +0200
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <1306508275-9228-1-git-send-email-hverkuil@xs4all.nl> <078067fab856b8b055f1e0e5442489ffa4bebd8b.1306507763.git.hans.verkuil@cisco.com>
In-Reply-To: <078067fab856b8b055f1e0e5442489ffa4bebd8b.1306507763.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106031006.11520.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, May 27, 2011 16:57:54 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/video4linux/v4l2-controls.txt |   56 +++++++++++++++++++++++++++
>  1 files changed, 56 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
> index 65d4652..6e277fe 100644
> --- a/Documentation/video4linux/v4l2-controls.txt
> +++ b/Documentation/video4linux/v4l2-controls.txt
> @@ -452,6 +452,25 @@ In the example above the following are equivalent for the VOLUME case:
>  	ctrl == ctrl->cluster[AUDIO_CL_VOLUME] == state->audio_cluster[AUDIO_CL_VOLUME]
>  	ctrl->cluster[AUDIO_CL_MUTE] == state->audio_cluster[AUDIO_CL_MUTE]
>  
> +In practice using cluster arrays like this becomes very tiresome. So instead
> +the following equivalent method is used:
> +
> +	struct {
> +		/* audio cluster */
> +		struct v4l2_ctrl *volume;
> +		struct v4l2_ctrl *mute;
> +	};
> +
> +The anonymous struct is used to clearly 'cluster' these two control pointers,
> +but it serves no other purpose. The effect is the same as creating an
> +array with two control pointers. So you can just do:
> +
> +	state->volume = v4l2_ctrl_new_std(&state->ctrl_handler, ...);
> +	state->mute = v4l2_ctrl_new_std(&state->ctrl_handler, ...);
> +	v4l2_ctrl_cluster(2, &state->volume);
> +
> +And in foo_s_ctrl you can use these pointers directly: state->mute->val.
> +
>  Note that controls in a cluster may be NULL. For example, if for some
>  reason mute was never added (because the hardware doesn't support that
>  particular feature), then mute will be NULL. So in that case we have a
> @@ -474,6 +493,43 @@ controls, then the 'is_new' flag would be 1 for both controls.
>  The 'is_new' flag is always 1 when called from v4l2_ctrl_handler_setup().
>  
>  
> +Handling autogain/gain-type Controls with Auto Clusters
> +=======================================================
> +
> +A common type of control cluster is one that handles 'auto-foo/foo'-type
> +controls. Typical examples are autogain/gain, autoexposure/exposure,
> +autowhitebalance/red balance/blue balance. In all cases you have one controls
> +that determines whether another control is handled automatically by the hardware,
> +or whether it is under manual control from the user.
> +
> +If the cluster is in automatic mode, then the manual controls should be
> +marked read-only if they are volatile and inactive if they are non-volatile.

I have slept on this some more and I really don't like the idea of marking
controls as read-only in this case. While this is fine in theory, in practice
it leads to awkward situations.

One problem with this is that when you set e.g. autogain and gain together using
VIDIOC_S_EXT_CTRLS you would have to return -EACCES if you set autogain to 1.
After all, if autogain is 1, then gain would be marked read-only and so setting
it should return -EACCES. But before the call to S_EXT_CTRLS the gain control is
marked writable (assuming autogain was 0). That's really unexpected behavior,
even though it is correct in theory.

Another problem is that there is no application currently that assumes that the
read-only flag can change on the fly. So control panels and such will not work
correctly. So making this change will most likely break existing applications.

I propose instead to change the behavior to set the INACTIVE flag instead.
So setting the gain control will always work, except that the manual gain
value won't be used (activated) until autogain is set to 0.

Reading the gain value will either return the manual gain that you set (if
gain is a non-volatile control) or the gain value as calculated by the autogain
hardware (if autogain is 1 and the gain control was marked volatile).

This will also simplify the patches (an additional bonus).

I will prepare an RFCv2 for this.

Regards,

	Hans

> +When the volatile controls are read the g_volatile_ctrl operation should return
> +the value that the hardware's automatic mode set up automatically.
> +
> +If the cluster is put in manual mode, then the manual controls should become
> +writable/active again and the is_volatile flag should be ignored (so
> +g_volatile_ctrl is no longer called while in manual mode).
> +
> +Finally the V4L2_CTRL_FLAG_UPDATE should be set for the auto control since
> +changing that control affects the control flags of the manual controls.
> +
> +In order to simplify this a special variation of v4l2_ctrl_cluster was
> +introduced:
> +
> +void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
> +			u8 manual_val, bool set_volatile);
> +
> +The first two arguments are identical to v4l2_ctrl_cluster. The third argument
> +tells the framework which value switches the cluster into manual mode. The
> +last argument will optionally set is_volatile flag for the non-auto controls.
> +
> +The first control of the cluster is assumed to be the 'auto' control.
> +
> +Using this function will ensure that you don't need to handle all the complex
> +flag and volatile handling.
> +
> +
>  VIDIOC_LOG_STATUS Support
>  =========================
>  
> 
