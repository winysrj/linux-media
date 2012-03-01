Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44609 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab2CAO4U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2012 09:56:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 32/33] smiapp: Add driver.
Date: Thu, 01 Mar 2012 15:56:35 +0100
Message-ID: <2004080.2hxX8IoNUT@avalon>
In-Reply-To: <4F4F8143.8000909@iki.fi>
References: <20120220015605.GI7784@valkosipuli.localdomain> <3598400.2MKjxpiZx5@avalon> <4F4F8143.8000909@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 01 March 2012 16:01:39 Sakari Ailus wrote:
> Laurent Pinchart wrote:

[snip]

> >>>> +		return sensor->pixel_array->ctrl_handler.error;
> >>>> +	}
> >>>> +
> >>>> +	sensor->pixel_array->sd.ctrl_handler =
> >>>> +		&sensor->pixel_array->ctrl_handler;
> >>>> +
> >>>> +	v4l2_ctrl_cluster(2, &sensor->hflip);
> >>> 
> >>> Shouldn't you move this before the control handler check ?
> >> 
> >> Why? It can't fail.
> > 
> > I thought it could fail. You could then leave it here, but it would be
> > easier from a maintenance point of view to check the error code after
> > completing all control-related initialization, as it would avoid
> > introducing a bug if for some reason the v4l2_ctrl_cluster() function
> > needs to return an error later.
> Then every other driver must also take that into account. And as
> Sylwester said, there are things to check before that as well.
> 
> So I could also re-check the control handler error status after the
> function but currently it doesn't look like it would make sense.

Sylwester made a very good point. Let's leave the code as-is.

[snip]

> >> The lvalues are module parameters whereas the rvalues are sensor
> >> parameters.>> 
> >>>> +	if (!minfo->manufacturer_id && !minfo->model_id) {
> >>>> +		minfo->manufacturer_id = minfo->sensor_manufacturer_id;
> >>>> +		minfo->model_id = minfo->sensor_model_id;
> >>>> +		minfo->revision_number_major = minfo->sensor_revision_number;
> >>>> +	}
> >>>> +
> >>>> +	for (i = 0; i < ARRAY_SIZE(smiapp_module_idents); i++) {
> >>>> +		if (smiapp_module_idents[i].manufacturer_id
> >>>> +		    != minfo->manufacturer_id)
> >>>> +			continue;
> >>>> +		if (smiapp_module_idents[i].model_id != minfo->model_id)
> >>>> +			continue;
> >>>> +		if (smiapp_module_idents[i].flags
> >>>> +		    & SMIAPP_MODULE_IDENT_FLAG_REV_LE) {
> >>>> +			if (smiapp_module_idents[i].revision_number_major
> >>>> +			    < minfo->revision_number_major)
> >>>> +				continue;
> >>>> +		} else {
> >>>> +			if (smiapp_module_idents[i].revision_number_major
> >>>> +			    != minfo->revision_number_major)
> >>>> +				continue;
> >>>> +		}
> >>>> +
> >>>> +		minfo->name = smiapp_module_idents[i].name;
> >>>> +		minfo->quirk = smiapp_module_idents[i].quirk;
> >>>> +		break;
> >>>> +	}
> >>>> +
> >>>> +	if (i >= ARRAY_SIZE(smiapp_module_idents))
> >>>> +		dev_warn(&client->dev, "no quirks for this module\n");
> >>> 
> >>> Maybe a message such as "unknown SMIA++ module - trying generic support"
> >>> would be better ? Many of the known modules have no quirks.
> >> 
> >> I'd like to think it as a positive message of the conformance of the
> >> sensor
> >> --- still it may inform that the quirks are actually missing. What do you
> >> think?
> > 
> > In that case I think something similar to my message is better :-) I agree
> > about the meaning the message should convey.
> 
> I understand from your message that the sensor should have quirks and
> the fact they're missing is a fall-back solution. :-)

Just use any message you want that says that the sensor model isn't known to 
the driver, but should still work as it's supposed to be standard-compliant 
:-)

[snip]

> >>>> +	}
> >>>> +
> >>>> +	if (ssd != ssd->sensor->pixel_array) {
> >>>> +		sel.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> >>>> +		sel.pad = SMIAPP_PAD_SINK;
> >>>> +		sel.target = V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE;
> >>>> +		__smiapp_get_selection(sd, fh, &sel);
> >>>> +		try_sel = v4l2_subdev_get_try_compose(fh, SMIAPP_PAD_SINK);
> >>>> +		*try_sel = sel.r;
> >>>> +	}
> >>>> +
> >>>> +	rval = smiapp_set_power(sd, 1);
> >>>> +
> >>>> +	mutex_unlock(&ssd->sensor->mutex);
> >>>> +
> >>>> +	if (rval < 0)
> >>>> +		goto out;
> >>>> +
> >>>> +	/* Was the sensor already powered on? */
> >>>> +	if (ssd->sensor->power_count > 1)
> >>> 
> >>> power_count is accessed in smiapp_set_power without taking the
> >>> power_mutex lock. Are two locks really needed ?
> >> 
> >> Well, now that you mention it, control handler setup function that
> >> wouldn't take the locks would resolve the issue, I think. Should I create
> >> one?
> > 
> > I'd ask Hans about that.
> > 
> > [snip]
> 
> I agree. I think I'll postpone the change so we can have time for
> discussion. Would you be ok with that?

OK.

-- 
Regards,

Laurent Pinchart
