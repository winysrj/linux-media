Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1251 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1HZI0g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 04:26:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC PATCH] Modify volatile auto cluster handling as per earlier discussions
Date: Fri, 26 Aug 2011 10:26:25 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201108091840.09884.hverkuil@xs4all.nl> <4E56AF04.2020705@redhat.com>
In-Reply-To: <4E56AF04.2020705@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108261026.26021.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, August 25, 2011 22:22:28 Hans de Goede wrote:
> Hi,
> 
> First of all thanks for doing this! Overall it looks good,
> see below for several (small) remarks which I have.


Thanks for the review!

> On 08/09/2011 06:40 PM, Hans Verkuil wrote:
> > This patch modifies the way autoclusters work when the 'foo' controls are
> > volatile if autofoo is on.
> >
> > E.g.: if autogain is true, then gain returns the gain set by the autogain
> > circuitry.
> >
> > This patch makes the following changes:
> >
> > 1) The V4L2_CTRL_FLAG_VOLATILE flag is added to let userspace know that a certain
> >     control is volatile. Currently this is internal information only.
> >
> > 2) If v4l2_ctrl_auto_cluster() is called with the last 'set_volatile' argument set
> >     to true, then the cluster has the following behavior:
> >
> >     - when in manual mode you can set the manual values normally.
> >     - when in auto mode any new manual values will be ignored. When you
> >       read the manual values you will get those as determined by the auto mode.
> >     - when switching from auto to manual mode the manual values from the auto
> >       mode are obtained through g_volatile_ctrl first. Any manual values explicitly
> >       set by the application will replace those obtained from the automode and the
> >       final set of values is sent to the driver with s_ctrl.
> >     - when in auto mode the V4L2_CTRL_FLAG_VOLATILE and INACTIVE flags are set for
> >       the 'foo' controls. These flags are cleared when in manual mode.
> >
> > This patch modifies existing users of is_volatile and simplifies the pwc driver
> > that required this behavior.
> >
> > The only thing missing is the documentation update and some code comments.
> >
> > I have to admit that it works quite well.
> >
> > Hans, can you verify that this does what you wanted it to do?
> >
> > Regards,
> >
> > 	Hans
> >
> 
> <snip>
> 
> > diff --git a/drivers/media/video/pwc/pwc-v4l.c b/drivers/media/video/pwc/pwc-v4l.c
> > index e9a0e94..4ce00bf 100644
> > --- a/drivers/media/video/pwc/pwc-v4l.c
> > +++ b/drivers/media/video/pwc/pwc-v4l.c
> 
> <snip>
> 
> > @@ -632,52 +634,28 @@ static int pwc_set_awb(struct pwc_device *pdev)
> >   {
> >   	int ret = 0;
> >
> > -	if (pdev->auto_white_balance->is_new) {
> > +	if (pdev->auto_white_balance->is_new)
> >   		ret = pwc_set_u8_ctrl(pdev, SET_CHROM_CTL,
> > -				      WB_MODE_FORMATTER,
> > -				      pdev->auto_white_balance->val);
> > -		if (ret)
> > -			return ret;
> > +			WB_MODE_FORMATTER,
> > +			pdev->auto_white_balance->val);
> > +	if (ret)
> > +		return ret;
> >
> > -		/* Update val when coming from auto or going to a preset */
> > -		if (pdev->red_balance->is_volatile ||
> > -		    pdev->auto_white_balance->val == awb_indoor ||
> > -		    pdev->auto_white_balance->val == awb_outdoor ||
> > -		    pdev->auto_white_balance->val == awb_fl) {
> > -			if (!pdev->red_balance->is_new)
> > -				pwc_get_u8_ctrl(pdev, GET_STATUS_CTL,
> > -					READ_RED_GAIN_FORMATTER,
> > -					&pdev->red_balance->val);
> > -			if (!pdev->blue_balance->is_new)
> > -				pwc_get_u8_ctrl(pdev, GET_STATUS_CTL,
> > -					READ_BLUE_GAIN_FORMATTER,
> > -					&pdev->blue_balance->val);
> > -		}
> > -		if (pdev->auto_white_balance->val == awb_auto) {
> > -			pdev->red_balance->is_volatile = true;
> > -			pdev->blue_balance->is_volatile = true;
> > -			pdev->color_bal_valid = false; /* Force cache update */
> > -		} else {
> > -			pdev->red_balance->is_volatile = false;
> > -			pdev->blue_balance->is_volatile = false;
> > -		}
> > +	if (pdev->auto_white_balance->val != awb_manual) {
> > +		pdev->color_bal_valid = false; /* Force cache update */
> > +		return 0;
> >   	}
> >
> 
> The setting of pdev->color_bal_valid = false should happen inside
> the "if (pdev->auto_white_balance->is_new)" block (under the same
> pdev->auto_white_balance->val != awb_manual condition), the way it
> is now if someone tries to say write blue bal while in awb mode, not
> only will the write get ignored (good), but this will also invalidate
> the cached values (bad).

True. 

> > -	if (ret == 0&&  pdev->red_balance->is_new) {
> > -		if (pdev->auto_white_balance->val != awb_manual)
> > -			return -EBUSY;
> > +	if (pdev->red_balance->is_new)
> >   		ret = pwc_set_u8_ctrl(pdev, SET_CHROM_CTL,
> > -				      PRESET_MANUAL_RED_GAIN_FORMATTER,
> > -				      pdev->red_balance->val);
> > -	}
> > -
> > -	if (ret == 0&&  pdev->blue_balance->is_new) {
> > -		if (pdev->auto_white_balance->val != awb_manual)
> > -			return -EBUSY;
> > +			PRESET_MANUAL_RED_GAIN_FORMATTER,
> > +			pdev->red_balance->val);
> > +	if (ret)
> > +		return ret;
> > +	if (pdev->blue_balance->is_new)
> >   		ret = pwc_set_u8_ctrl(pdev, SET_CHROM_CTL,
> > -				      PRESET_MANUAL_BLUE_GAIN_FORMATTER,
> > -				      pdev->blue_balance->val);
> > -	}
> > +			PRESET_MANUAL_BLUE_GAIN_FORMATTER,
> > +			pdev->blue_balance->val);
> >   	return ret;
> >   }
> >
> 
> Nitpick: I'm also not happy with moving the error return checks outside
> of the is_new blocks, I know the end result is the same, but it just
> feels a bit wrong to me, because it makes less clear what the actual
> intend of the check is (to check the pwc_set_u8_ctrl result).

I'm fine with either approach.

> This how I would like pwc_set_awb to look after this patch:
> 
> {
>   	int ret;
> 
> 	if (pdev->auto_white_balance->is_new)
>   		ret = pwc_set_u8_ctrl(pdev, SET_CHROM_CTL,
> 				      WB_MODE_FORMATTER,
> 				      pdev->auto_white_balance->val);
> 		if (ret)
> 			return ret;
> 
> 		if (pdev->auto_white_balance->val != awb_manual)
> 			pdev->color_bal_valid = false; /* Force cache update */
> 	}
> 
> 	if (pdev->auto_white_balance->val != awb_manual)
> 		return 0;
> 
> 	if (pdev->red_balance->is_new) {
>   		ret = pwc_set_u8_ctrl(pdev, SET_CHROM_CTL,
> 			PRESET_MANUAL_RED_GAIN_FORMATTER,
> 			pdev->red_balance->val);
> 		if (ret)
> 			return ret;
> 	}
> 
> 	if (pdev->blue_balance->is_new) {
>   		ret = pwc_set_u8_ctrl(pdev, SET_CHROM_CTL,
> 			PRESET_MANUAL_BLUE_GAIN_FORMATTER,
> 			pdev->blue_balance->val);
> 		if (ret)
> 			return ret;
> 	}
> 
>   	return 0;
> }
> 
> 
> > @@ -686,26 +664,18 @@ static int pwc_set_autogain(struct pwc_device *pdev)
> >   {
> >   	int ret = 0;
> >
> > -	if (pdev->autogain->is_new) {
> > +	if (pdev->autogain->is_new)
> >   		ret = pwc_set_u8_ctrl(pdev, SET_LUM_CTL,
> > -				      AGC_MODE_FORMATTER,
> > -				      pdev->autogain->val ? 0 : 0xff);
> > -		if (ret)
> > -			return ret;
> > -		if (pdev->autogain->val)
> > -			pdev->gain_valid = false; /* Force cache update */
> > -		else if (!pdev->gain->is_new)
> > -			pwc_get_u8_ctrl(pdev, GET_STATUS_CTL,
> > -					READ_AGC_FORMATTER,
> > -					&pdev->gain->val);
> > -	}
> > -	if (ret == 0&&  pdev->gain->is_new) {
> > -		if (pdev->autogain->val)
> > -			return -EBUSY;
> > +			AGC_MODE_FORMATTER,
> > +			pdev->autogain->val ? 0 : 0xff);
> > +	if (ret)
> > +		return ret;
> > +	if (pdev->autogain->val)
> > +		pdev->gain_valid = false; /* Force cache update */
> > +	else if (pdev->gain->is_new)
> >   		ret = pwc_set_u8_ctrl(pdev, SET_LUM_CTL,
> >   				      PRESET_AGC_FORMATTER,
> >   				      pdev->gain->val);
> > -	}
> >   	return ret;
> >   }
> 
> Same old, same old, invalidation of the cache should be inside
> the is_new block. Move error checks into is_new blocks, ie:
> 
> {
>     	int ret;
> 
> 	if (pdev->autogain->is_new) {
>     		ret = pwc_set_u8_ctrl(pdev, SET_LUM_CTL,
> 				      AGC_MODE_FORMATTER,
> -				      pdev->autogain->val ? 0 : 0xff);
> 		if (ret)
> 			return ret;
> 		if (pdev->autogain->val)
> 			pdev->gain_valid = false; /* Force cache update */
> 	}
> 
> 	if (pdev->autogain->val)
> 		return 0;
> 
> 	if (pdev->gain->is_new) {
>    		ret = pwc_set_u8_ctrl(pdev, SET_LUM_CTL,
>    				      PRESET_AGC_FORMATTER,
>    				      pdev->gain->val);
> 		if (ret)
> 			return ret;
> 	}
> 
> 	return 0;
> }
> 
> 
> 
> >
> > @@ -715,26 +685,18 @@ static int pwc_set_exposure_auto(struct pwc_device *pdev)
> >   	int ret = 0;
> >   	int is_auto = pdev->exposure_auto->val == V4L2_EXPOSURE_AUTO;
> >
> > -	if (pdev->exposure_auto->is_new) {
> > +	if (pdev->exposure_auto->is_new)
> >   		ret = pwc_set_u8_ctrl(pdev, SET_LUM_CTL,
> > -				      SHUTTER_MODE_FORMATTER,
> > -				      is_auto ? 0 : 0xff);
> > -		if (ret)
> > -			return ret;
> > -		if (is_auto)
> > -			pdev->exposure_valid = false; /* Force cache update */
> > -		else if (!pdev->exposure->is_new)
> > -			pwc_get_u16_ctrl(pdev, GET_STATUS_CTL,
> > -					 READ_SHUTTER_FORMATTER,
> > -					&pdev->exposure->val);
> > -	}
> > -	if (ret == 0&&  pdev->exposure->is_new) {
> > -		if (is_auto)
> > -			return -EBUSY;
> > +			SHUTTER_MODE_FORMATTER,
> > +			is_auto ? 0 : 0xff);
> > +	if (ret)
> > +		return ret;
> > +	if (is_auto)
> > +		pdev->exposure_valid = false; /* Force cache update */
> > +	else if (pdev->exposure->is_new)
> >   		ret = pwc_set_u16_ctrl(pdev, SET_LUM_CTL,
> >   				       PRESET_SHUTTER_FORMATTER,
> >   				       pdev->exposure->val);
> > -	}
> >   	return ret;
> >   }
> >
> 
> Idem.
> 
> > @@ -743,39 +705,26 @@ static int pwc_set_autogain_expo(struct pwc_device *pdev)
> >   {
> >   	int ret = 0;
> >
> > -	if (pdev->autogain->is_new) {
> > +	if (pdev->autogain->is_new)
> >   		ret = pwc_set_u8_ctrl(pdev, SET_LUM_CTL,
> >   				      AGC_MODE_FORMATTER,
> >   				      pdev->autogain->val ? 0 : 0xff);
> > +	if (ret)
> > +		return ret;
> > +	if (pdev->autogain->val) {
> > +		pdev->gain_valid     = false; /* Force cache update */
> > +		pdev->exposure_valid = false; /* Force cache update */
> > +	} else {
> > +		if (pdev->gain->is_new)
> > +			ret = pwc_set_u8_ctrl(pdev, SET_LUM_CTL,
> > +					PRESET_AGC_FORMATTER,
> > +					pdev->gain->val);
> >   		if (ret)
> >   			return ret;
> > -		if (pdev->autogain->val) {
> > -			pdev->gain_valid     = false; /* Force cache update */
> > -			pdev->exposure_valid = false; /* Force cache update */
> > -		} else {
> > -			if (!pdev->gain->is_new)
> > -				pwc_get_u8_ctrl(pdev, GET_STATUS_CTL,
> > -						READ_AGC_FORMATTER,
> > -						&pdev->gain->val);
> > -			if (!pdev->exposure->is_new)
> > -				pwc_get_u16_ctrl(pdev, GET_STATUS_CTL,
> > -						 READ_SHUTTER_FORMATTER,
> > -						&pdev->exposure->val);
> > -		}
> > -	}
> > -	if (ret == 0&&  pdev->gain->is_new) {
> > -		if (pdev->autogain->val)
> > -			return -EBUSY;
> > -		ret = pwc_set_u8_ctrl(pdev, SET_LUM_CTL,
> > -				      PRESET_AGC_FORMATTER,
> > -				      pdev->gain->val);
> > -	}
> > -	if (ret == 0&&  pdev->exposure->is_new) {
> > -		if (pdev->autogain->val)
> > -			return -EBUSY;
> > -		ret = pwc_set_u16_ctrl(pdev, SET_LUM_CTL,
> > -				       PRESET_SHUTTER_FORMATTER,
> > -				       pdev->exposure->val);
> > +		if (pdev->exposure->is_new)
> > +			ret = pwc_set_u16_ctrl(pdev, SET_LUM_CTL,
> > +					PRESET_SHUTTER_FORMATTER,
> > +					pdev->exposure->val);
> >   	}
> >   	return ret;
> >   }
> 
> Idem
> 
> > @@ -872,20 +821,13 @@ static int pwc_s_ctrl(struct v4l2_ctrl *ctrl)
> >   				      ctrl->val ? 0 : 0xff);
> >   		break;
> >   	case PWC_CID_CUSTOM(autocontour):
> > -		if (pdev->autocontour->is_new) {
> > -			ret = pwc_set_u8_ctrl(pdev, SET_LUM_CTL,
> > -					AUTO_CONTOUR_FORMATTER,
> > -					pdev->autocontour->val ? 0 : 0xff);
> > -		}
> > -		if (ret == 0&&  pdev->contour->is_new) {
> > -			if (pdev->autocontour->val) {
> > -				ret = -EBUSY;
> > -				break;
> > -			}
> > +		ret = pwc_set_u8_ctrl(pdev, SET_LUM_CTL,
> > +				AUTO_CONTOUR_FORMATTER,
> > +				pdev->autocontour->val ? 0 : 0xff);
> > +		if (ret == 0&&  pdev->autocontour->val)
> >   			ret = pwc_set_u8_ctrl(pdev, SET_LUM_CTL,
> >   					      PRESET_CONTOUR_FORMATTER,
> >   					      pdev->contour->val);
> > -		}
> >   		break;
> >   	case V4L2_CID_BACKLIGHT_COMPENSATION:
> >   		ret = pwc_set_u8_ctrl(pdev, SET_LUM_CTL,
> 
> 2 things:
> 1) Why not use is_new before setting ?

No idea :-)

I think this may have been a left-over from an earlier attempt.

> 2) contour is not volatile, you can set it to $random value while
>     auto is on, and then when you turn auto off, it will "jump"
>     to $random setting you last did, so there should be no
>     pdev->autocontour->val check (and if there should be it should be
>     inverted.
> 
> I've attached a revised version of the patch addrressing all
> my concerns / code style request wrt the pwc driver.

Thanks! I'll use that for my pull request.

> 
> > @@ -1099,6 +1041,14 @@ static int pwc_enum_frameintervals(struct file *file, void *fh,
> >   	return 0;
> >   }
> >
> > +static int pwc_log_status(struct file *file, void *priv)
> > +{
> > +	struct pwc_device *pdev = video_drvdata(file);
> > +
> > +	v4l2_ctrl_handler_log_status(&pdev->ctrl_handler, PWC_NAME);
> > +	return 0;
> > +}
> > +
> >   static long pwc_default(struct file *file, void *fh, bool valid_prio,
> >   			int cmd, void *arg)
> >   {
> > @@ -1122,6 +1072,7 @@ const struct v4l2_ioctl_ops pwc_ioctl_ops = {
> >   	.vidioc_dqbuf			    = pwc_dqbuf,
> >   	.vidioc_streamon		    = pwc_streamon,
> >   	.vidioc_streamoff		    = pwc_streamoff,
> > +	.vidioc_log_status		    = pwc_log_status,
> >   	.vidioc_enum_framesizes		    = pwc_enum_framesizes,
> >   	.vidioc_enum_frameintervals	    = pwc_enum_frameintervals,
> >   	.vidioc_default		    = pwc_default,
> 
> <snip>
> 
> > diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> > index 06b6014..b29f3d8 100644
> > --- a/drivers/media/video/v4l2-ctrls.c
> > +++ b/drivers/media/video/v4l2-ctrls.c
> > @@ -43,7 +43,7 @@ struct v4l2_ctrl_helper {
> >   };
> >
> >   /* Small helper function to determine if the autocluster is set to manual
> > -   mode. In that case the is_volatile flag should be ignored. */
> > +   mode. */
> >   static bool is_cur_manual(const struct v4l2_ctrl *master)
> >   {
> >   	return master->is_auto&&  master->cur.val == master->manual_mode_value;
> > @@ -937,9 +937,13 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
> >   		break;
> >   	}
> >   	if (update_inactive) {
> > -		ctrl->flags&= ~V4L2_CTRL_FLAG_INACTIVE;
> > -		if (!is_cur_manual(ctrl->cluster[0]))
> > +		ctrl->flags&=
> > +			~(V4L2_CTRL_FLAG_INACTIVE | V4L2_CTRL_FLAG_VOLATILE);
> > +		if (!is_cur_manual(ctrl->cluster[0])) {
> >   			ctrl->flags |= V4L2_CTRL_FLAG_INACTIVE;
> > +			if (ctrl->cluster[0]->is_auto_volatile)
> > +				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
> > +		}
> >   	}
> >   	if (changed || update_inactive) {
> >   		/* If a control was changed that was not one of the controls
> > @@ -1394,10 +1398,8 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
> >   			type, min, max,
> >   			is_menu ? cfg->menu_skip_mask : step,
> >   			def, flags, qmenu, priv);
> > -	if (ctrl) {
> > +	if (ctrl)
> >   		ctrl->is_private = cfg->is_private;
> > -		ctrl->is_volatile = cfg->is_volatile;
> > -	}
> >   	return ctrl;
> >   }
> >   EXPORT_SYMBOL(v4l2_ctrl_new_custom);
> > @@ -1491,6 +1493,7 @@ EXPORT_SYMBOL(v4l2_ctrl_add_handler);
> >   /* Cluster controls */
> >   void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
> >   {
> > +	bool is_auto_volatile = false;
> >   	int i;
> >
> >   	/* The first control is the master control and it must not be NULL */
> > @@ -1500,8 +1503,11 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
> >   		if (controls[i]) {
> >   			controls[i]->cluster = controls;
> >   			controls[i]->ncontrols = ncontrols;
> > +			if (controls[i]->flags&  V4L2_CTRL_FLAG_VOLATILE)
> > +				is_auto_volatile = true;
> >   		}
> >   	}
> > +	controls[0]->is_auto_volatile = is_auto_volatile;
> >   }
> >   EXPORT_SYMBOL(v4l2_ctrl_cluster);
> >
> 
> I see that you are setting is_auto_volatile for regular (non auto
> clusters) here. First of all given its name that seems weird.
> 
> I can see that this then gets used in v4l2_g_ext_ctrls
> to call g_volatile_ctrl in the case were the master is
> not volatile, but some other controls in the cluster are.
> 
> However it also leads to calling update_from_auto_cluster
> from try_set_ext_ctrls and set_ctrl in the same case, which I
> personally consider an undesirable side-effect, but maybe
> you see things differently?

I agree, this can be improved. I'll work on this.

> > @@ -1509,22 +1515,25 @@ void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
> >   			    u8 manual_val, bool set_volatile)
> >   {
> >   	struct v4l2_ctrl *master = controls[0];
> > -	u32 flag;
> > +	u32 flag = 0;
> >   	int i;
> >
> >   	v4l2_ctrl_cluster(ncontrols, controls);
> >   	WARN_ON(ncontrols<= 1);
> >   	WARN_ON(manual_val<  master->minimum || manual_val>  master->maximum);
> > +	WARN_ON(set_volatile&&  !has_op(master, g_volatile_ctrl));
> >   	master->is_auto = true;
> > +	master->is_auto_volatile = set_volatile;
> >   	master->manual_mode_value = manual_val;
> >   	master->flags |= V4L2_CTRL_FLAG_UPDATE;
> > -	flag = is_cur_manual(master) ? 0 : V4L2_CTRL_FLAG_INACTIVE;
> > +
> > +	if (!is_cur_manual(master))
> > +		flag = V4L2_CTRL_FLAG_INACTIVE |
> > +			(set_volatile ? V4L2_CTRL_FLAG_VOLATILE : 0);
> >
> >   	for (i = 1; i<  ncontrols; i++)
> > -		if (controls[i]) {
> > -			controls[i]->is_volatile = set_volatile;
> > +		if (controls[i])
> >   			controls[i]->flags |= flag;
> > -		}
> >   }
> >   EXPORT_SYMBOL(v4l2_ctrl_auto_cluster);
> >
> > @@ -1579,9 +1588,6 @@ EXPORT_SYMBOL(v4l2_ctrl_grab);
> >   static void log_ctrl(const struct v4l2_ctrl *ctrl,
> >   		     const char *prefix, const char *colon)
> >   {
> > -	int fl_inact = ctrl->flags&  V4L2_CTRL_FLAG_INACTIVE;
> > -	int fl_grabbed = ctrl->flags&  V4L2_CTRL_FLAG_GRABBED;
> > -
> >   	if (ctrl->flags&  (V4L2_CTRL_FLAG_DISABLED | V4L2_CTRL_FLAG_WRITE_ONLY))
> >   		return;
> >   	if (ctrl->type == V4L2_CTRL_TYPE_CTRL_CLASS)
> > @@ -1612,14 +1618,17 @@ static void log_ctrl(const struct v4l2_ctrl *ctrl,
> >   		printk(KERN_CONT "unknown type %d", ctrl->type);
> >   		break;
> >   	}
> > -	if (fl_inact&&  fl_grabbed)
> > -		printk(KERN_CONT " (inactive, grabbed)\n");
> > -	else if (fl_inact)
> > -		printk(KERN_CONT " (inactive)\n");
> > -	else if (fl_grabbed)
> > -		printk(KERN_CONT " (grabbed)\n");
> > -	else
> > -		printk(KERN_CONT "\n");
> > +	if (ctrl->flags&  (V4L2_CTRL_FLAG_INACTIVE |
> > +			   V4L2_CTRL_FLAG_GRABBED |
> > +			   V4L2_CTRL_FLAG_VOLATILE)) {
> > +		if (ctrl->flags&  V4L2_CTRL_FLAG_INACTIVE)
> > +			printk(KERN_CONT " inactive");
> > +		if (ctrl->flags&  V4L2_CTRL_FLAG_GRABBED)
> > +			printk(KERN_CONT " grabbed");
> > +		if (ctrl->flags&  V4L2_CTRL_FLAG_VOLATILE)
> > +			printk(KERN_CONT " volatile");
> > +	}
> > +	printk(KERN_CONT "\n");
> >   }
> >
> >   /* Log all controls owned by the handler */
> > @@ -1959,7 +1968,8 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
> >   		v4l2_ctrl_lock(master);
> >
> >   		/* g_volatile_ctrl will update the new control values */
> > -		if (has_op(master, g_volatile_ctrl)&&  !is_cur_manual(master)) {
> > +		if ((master->flags&  V4L2_CTRL_FLAG_VOLATILE) ||
> > +			(master->is_auto_volatile&&  !is_cur_manual(master))) {
> >   			for (j = 0; j<  master->ncontrols; j++)
> >   				cur_to_new(master->cluster[j]);
> >   			ret = call_op(master, g_volatile_ctrl);
> > @@ -2004,7 +2014,7 @@ static int get_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
> >
> >   	v4l2_ctrl_lock(master);
> >   	/* g_volatile_ctrl will update the current control values */
> > -	if (ctrl->is_volatile&&  !is_cur_manual(master)) {
> > +	if (ctrl->flags&  V4L2_CTRL_FLAG_VOLATILE) {
> >   		for (i = 0; i<  master->ncontrols; i++)
> >   			cur_to_new(master->cluster[i]);
> >   		ret = call_op(master, g_volatile_ctrl);
> > @@ -2120,6 +2130,18 @@ static int validate_ctrls(struct v4l2_ext_controls *cs,
> >   	return 0;
> >   }
> >
> > +static void update_from_auto_cluster(struct v4l2_ctrl *master)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i<  master->ncontrols; i++)
> > +		cur_to_new(master->cluster[i]);
> > +	if (!call_op(master, g_volatile_ctrl))
> > +		for (i = 1; i<  master->ncontrols; i++)
> > +			if (master->cluster[i])
> > +				master->cluster[i]->is_new = 1;
> > +}
> > +
> >   /* Try or try-and-set controls */
> >   static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
> >   			     struct v4l2_ext_controls *cs,
> > @@ -2165,6 +2187,9 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
> >   			if (master->cluster[j])
> >   				master->cluster[j]->is_new = 0;
> >
> > +		if (master->is_auto_volatile&&  !is_cur_manual(master))
> > +			update_from_auto_cluster(master);
> > +
> >   		/* Copy the new caller-supplied control values.
> >   		   user_to_new() sets 'is_new' to 1. */
> >   		do {
> > @@ -2235,6 +2260,8 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, s32 *val)
> >   		if (master->cluster[i])
> >   			master->cluster[i]->is_new = 0;
> >
> > +	if (master->is_auto_volatile&&  !is_cur_manual(master))
> > +		update_from_auto_cluster(master);
> >   	ctrl->val = *val;
> >   	ctrl->is_new = 1;
> >   	ret = try_or_set_cluster(fh, master, true);
> 
> <snip>
> 
> > diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> > index 13fe4d7..d1a77cd 100644
> > --- a/include/media/v4l2-ctrls.h
> > +++ b/include/media/v4l2-ctrls.h
> > @@ -118,8 +118,8 @@ struct v4l2_ctrl {
> >
> >   	unsigned int is_new:1;
> >   	unsigned int is_private:1;
> > -	unsigned int is_volatile:1;
> >   	unsigned int is_auto:1;
> > +	unsigned int is_auto_volatile:1;
> >   	unsigned int manual_mode_value:8;
> >
> >   	const struct v4l2_ctrl_ops *ops;
> > @@ -208,9 +208,9 @@ struct v4l2_ctrl_handler {
> >     *		must be NULL.
> >     * @is_private: If set, then this control is private to its handler and it
> >     *		will not be added to any other handlers.
> > -  * @is_volatile: If set, then this control is volatile. This means that the
> > -  *		control's current value cannot be cached and needs to be
> > -  *		retrieved through the g_volatile_ctrl op.
> > +  * @is_volatile: If set, then this autocluster control is volatile. This means
> > +  *		that the control's current value cannot be cached and needs to
> > +  *		be retrieved through the g_volatile_ctrl op.
> >     */
> >   struct v4l2_ctrl_config {
> >   	const struct v4l2_ctrl_ops *ops;
> 
> Typo: adds docstring for is_volatile, should be is_auto_volatile

Actually, it should be removed altogether. is_volatile is now marked by the
VOLATILE flag.

> 
> > @@ -225,7 +225,6 @@ struct v4l2_ctrl_config {
> >   	u32 menu_skip_mask;
> >   	const char * const *qmenu;
> >   	unsigned int is_private:1;
> > -	unsigned int is_volatile:1;
> >   };
> >
> >   /** v4l2_ctrl_fill() - Fill in the control fields based on the control ID.
> 
> Regards,
> 
> Hans
> 

Thanks!

	Hans
