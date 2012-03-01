Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:41286 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966220Ab2CAOBw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Mar 2012 09:01:52 -0500
Message-ID: <4F4F8143.8000909@iki.fi>
Date: Thu, 01 Mar 2012 16:01:39 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 32/33] smiapp: Add driver.
References: <20120220015605.GI7784@valkosipuli.localdomain> <2925645.UTNbXqr535@avalon> <20120229054149.GB14920@valkosipuli.localdomain> <3598400.2MKjxpiZx5@avalon>
In-Reply-To: <3598400.2MKjxpiZx5@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
...
>>>> +	case V4L2_CID_VBLANK:
>>>> +		exposure = sensor->exposure->val;
>>>> +
>>>> +		__smiapp_update_exposure_limits(sensor);
>>>> +
>>>> +		if (exposure > sensor->exposure->maximum) {
>>>> +			sensor->exposure->val =
>>>> +				sensor->exposure->maximum;
>>>> +			rval = smiapp_set_ctrl(
>>>> +				sensor->exposure);
>>>
>>> Shouldn't you call the V4L2 control API here instead ? Otherwise no
>>> control change event will be generated for the exposure time. Will this
>>> work as expected if the user sets the exposure time in the same
>>> VIDIOC_S_EXT_CTRLS call ?
>>
>> Good question. I'm holding the ctrl handler lock here and so can't use the
>> regular functions to perform the change. Perhaps time to implement
>> __v4l2_subdev_s_ext_ctrls() and use that?
> 
> Do you mean __v4l2_ctrl_s_ctrl() ? I think it would make sense, yes.

Something to discuss with Hans, I guess.

>>>> +	if (sensor->pixel_array->ctrl_handler.error) {
>>>> +		dev_err(&client->dev,
>>>> +			"pixel array controls initialization failed (%d)\n",
>>>> +			sensor->pixel_array->ctrl_handler.error);
>>>
>>> Shouldn't you call v4l2_ctrl_handler_free() here ?
>>
>> Yes. Fixed.
>>
>>>> +		return sensor->pixel_array->ctrl_handler.error;
>>>> +	}
>>>> +
>>>> +	sensor->pixel_array->sd.ctrl_handler =
>>>> +		&sensor->pixel_array->ctrl_handler;
>>>> +
>>>> +	v4l2_ctrl_cluster(2, &sensor->hflip);
>>>
>>> Shouldn't you move this before the control handler check ?
>>
>> Why? It can't fail.
> 
> I thought it could fail. You could then leave it here, but it would be easier 
> from a maintenance point of view to check the error code after completing all 
> control-related initialization, as it would avoid introducing a bug if for 
> some reason the v4l2_ctrl_cluster() function needs to return an error later.

Then every other driver must also take that into account. And as
Sylwester said, there are things to check before that as well.

So I could also re-check the control handler error status after the
function but currently it doesn't look like it would make sense.

> [snip]
> 
>>>> +static int smiapp_update_mode(struct smiapp_sensor *sensor)
>>>> +{
>>>
>>> This function isn't protected by the sensor mutex when called from
>>> s_power, but it changes controls. The other call paths seem OK, but you
>>> might want to double-check them.
>>
>> It's actually not an issue. When s_power is being called there are no other
>> users and the power_lock serialises it.
> 
> Are you sure about that? s_power can be called from both the subdev video node 
> open() handlers (assuming the sensor is in the pipe).

Good point... That certainly needs to be taken into account. I move the
lock to set_power directly.

>>>> +		minfo->manufacturer_id, minfo->model_id);
>>>> +
>>>> +	dev_dbg(&client->dev,
>>>> +		"module revision 0x%2.2x-0x%2.2x date %2.2d-%2.2d-%2.2d\n",
>>>> +		minfo->revision_number_major, minfo->revision_number_minor,
>>>> +		minfo->module_year, minfo->module_month, minfo->module_day);
>>>> +
>>>> +	dev_dbg(&client->dev, "sensor 0x%2.2x-0x%4.4x\n",
>>>> +		minfo->sensor_manufacturer_id, minfo->sensor_model_id);
>>>> +
>>>> +	dev_dbg(&client->dev,
>>>> +		"sensor revision 0x%2.2x firmware version 0x%2.2x\n",
>>>> +		minfo->sensor_revision_number, minfo->sensor_firmware_version);
>>>> +
>>>> +	dev_dbg(&client->dev, "smia version %2.2d smiapp version %2.2d\n",
>>>> +		minfo->smia_version, minfo->smiapp_version);
>>>> +
>>>
>>> Could you please add a short comment to explain why this is needed ?
>>
>> The one below?
> 
> Yes, the lines below, sorry.
> 
>> Some devices just have bad data in these variables. Hopefully the other
>> variables have better stuff.
> 
> I knew why this was needed, but other readers might not :-) That's why a 
> comment would be good.

Comment added.

>> The lvalues are module parameters whereas the rvalues are sensor parameters.
>>
>>>> +	if (!minfo->manufacturer_id && !minfo->model_id) {
>>>> +		minfo->manufacturer_id = minfo->sensor_manufacturer_id;
>>>> +		minfo->model_id = minfo->sensor_model_id;
>>>> +		minfo->revision_number_major = minfo->sensor_revision_number;
>>>> +	}
>>>> +
>>>> +	for (i = 0; i < ARRAY_SIZE(smiapp_module_idents); i++) {
>>>> +		if (smiapp_module_idents[i].manufacturer_id
>>>> +		    != minfo->manufacturer_id)
>>>> +			continue;
>>>> +		if (smiapp_module_idents[i].model_id != minfo->model_id)
>>>> +			continue;
>>>> +		if (smiapp_module_idents[i].flags
>>>> +		    & SMIAPP_MODULE_IDENT_FLAG_REV_LE) {
>>>> +			if (smiapp_module_idents[i].revision_number_major
>>>> +			    < minfo->revision_number_major)
>>>> +				continue;
>>>> +		} else {
>>>> +			if (smiapp_module_idents[i].revision_number_major
>>>> +			    != minfo->revision_number_major)
>>>> +				continue;
>>>> +		}
>>>> +
>>>> +		minfo->name = smiapp_module_idents[i].name;
>>>> +		minfo->quirk = smiapp_module_idents[i].quirk;
>>>> +		break;
>>>> +	}
>>>> +
>>>> +	if (i >= ARRAY_SIZE(smiapp_module_idents))
>>>> +		dev_warn(&client->dev, "no quirks for this module\n");
>>>
>>> Maybe a message such as "unknown SMIA++ module - trying generic support"
>>> would be better ? Many of the known modules have no quirks.
>>
>> I'd like to think it as a positive message of the conformance of the sensor
>> --- still it may inform that the quirks are actually missing. What do you
>> think?
> 
> In that case I think something similar to my message is better :-) I agree 
> about the meaning the message should convey.

I understand from your message that the sensor should have quirks and
the fact they're missing is a fall-back solution. :-)

>>>> +
>>>> +	dev_dbg(&client->dev, "the sensor is called %s, ident
>>>> %2.2x%4.4x%2.2x\n",
>>>> +		minfo->name, minfo->manufacturer_id, minfo->model_id,
>>>> +		minfo->revision_number_major);
>>>> +
>>>> +	strlcpy(subdev->name, sensor->minfo.name, sizeof(subdev->name));
>>>> +
>>>> +	return 0;
>>>> +}
> 
> [snip]
> 
>>>> +static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh
>>>> *fh)
>>>> +{
>>>> +	struct smiapp_subdev *ssd = to_smiapp_subdev(sd);
>>>> +	struct v4l2_subdev_selection sel;
>>>> +	struct v4l2_rect *try_sel;
>>>> +	int i;
>>>> +	int rval;
>>>> +
>>>> +	mutex_lock(&ssd->sensor->power_mutex);
>>>> +	mutex_lock(&ssd->sensor->mutex);
>>>> +
>>>> +	for (i = 0; i < ssd->npads; i++) {
>>>> +		struct v4l2_subdev_format fmt;
>>>> +		struct v4l2_mbus_framefmt *try_fmt;
>>>> +
>>>> +		fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
>>>> +		fmt.pad = i;
>>>> +		__smiapp_get_format(sd, fh, &fmt);
>>>> +		try_fmt = v4l2_subdev_get_try_format(fh, i);
>>>> +		*try_fmt = fmt.format;
>>>> +
>>>> +		sel.which = V4L2_SUBDEV_FORMAT_ACTIVE;
>>>> +		sel.pad = i;
>>>> +		sel.target = V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE;
>>>> +		__smiapp_get_selection(sd, fh, &sel);
>>>> +		try_sel = v4l2_subdev_get_try_crop(fh, i);
>>>> +		*try_sel = sel.r;
>>>
>>> Wouldn't it be better to use the default values instead of the active ones
>>> here ?
>>
>> Good question.
>>
>>>> +	}
>>>> +
>>>> +	if (ssd != ssd->sensor->pixel_array) {
>>>> +		sel.which = V4L2_SUBDEV_FORMAT_ACTIVE;
>>>> +		sel.pad = SMIAPP_PAD_SINK;
>>>> +		sel.target = V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE;
>>>> +		__smiapp_get_selection(sd, fh, &sel);
>>>> +		try_sel = v4l2_subdev_get_try_compose(fh, SMIAPP_PAD_SINK);
>>>> +		*try_sel = sel.r;
>>>> +	}
>>>> +
>>>> +	rval = smiapp_set_power(sd, 1);
>>>> +
>>>> +	mutex_unlock(&ssd->sensor->mutex);
>>>> +
>>>> +	if (rval < 0)
>>>> +		goto out;
>>>> +
>>>> +	/* Was the sensor already powered on? */
>>>> +	if (ssd->sensor->power_count > 1)
>>>
>>> power_count is accessed in smiapp_set_power without taking the power_mutex
>>> lock. Are two locks really needed ?
>>
>> Well, now that you mention it, control handler setup function that wouldn't
>> take the locks would resolve the issue, I think. Should I create one?
> 
> I'd ask Hans about that.
> 
> [snip]

I agree. I think I'll postpone the change so we can have time for
discussion. Would you be ok with that?

...
>>>> +static uint32_t float_to_u32_mul_1000000(struct i2c_client *client,
>>>> +					 uint32_t phloat)
>>>
>>> Now that's creative :-)
>>
>> I couldn't figure out a way to avoid that, unfortunately. There are a few
>> corresponding functions in math emulation libraries but it seems onethey
>> would require significant changes to be usable for this driver.
> 
> I should have been more specific, I was referring to the name 'phloat' :-)

Ah, that one. Antti wrote this part. :-)

>>>> diff --git a/drivers/media/video/smiapp/smiapp.h
>>>> b/drivers/media/video/smiapp/smiapp.h new file mode 100644
>>>> index 0000000..df514dd
>>>> --- /dev/null
>>>> +++ b/drivers/media/video/smiapp/smiapp.h
>>>
>>> [snip]
>>>
>>>> +struct smiapp_module_ident {
>>>> +	u8 manufacturer_id;
>>>> +	u16 model_id;
>>>> +	u8 revision_number_major;
>>>> +
>>>> +	u8 flags;
>>>> +
>>>> +	char *name;
>>>> +	const struct smiapp_quirk *quirk;
>>>> +} __packed;
>>>
>>> Is there really a need to pack this ? You could just move
>>> revision_number_major above model_id to save a couple of bytes and leave
>>> packing out.
>>
>> The order is there for readability, packing to save memory. I can change the
>> order, too, if you think it's a good idea.
> 
> Packing usually increases the run time (and possibly code size), as the CPU 
> will need to perform unaligned access. I don't think it's worth it in this 
> case. At second thought moving the fields around won't save any memory, so I 
> would just remove __packed.

Uh, you're right. I remove __packed.

I think this has come to be this way since I added flags later on.

>>>> +#define SMIAPP_IDENT_FQ(manufacturer, model, rev, fl, _name, _quirk)	
> \
>>>> +	{ .manufacturer_id = manufacturer,				\
>>>> +			.model_id = model,				\
>>>> +			.revision_number_major = rev,			\
>>>> +			.flags = fl,					\
>>>> +			.name = _name,					\
>>>> +			.quirk = _quirk, }
>>>
>>> Any reason for the strange indentation ?
>>
>> This is standard indentation in my Emacsitor. Hmm. I think I might be fine
>> even if it indented less. It looks like it wouldn't be indended to work that
>> way.
> 
> Maybe it's time to switch to vi ? :-D

No, no Viitor. I once tried it and that didn't go well. I can recommend
Vigor for you, though:

<URL:http://vigor.sf.net>

:-)

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
