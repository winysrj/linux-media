Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:54671 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646AbcFTQXd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 12:23:33 -0400
Subject: Re: [PATCH v4 8/9] Input: atmel_mxt_ts - add support for reference
 data
To: Nick Dyer <nick.dyer@itdev.co.uk>
References: <1466172988-3698-1-git-send-email-nick.dyer@itdev.co.uk>
 <1466172988-3698-9-git-send-email-nick.dyer@itdev.co.uk>
 <5768152E.7070905@xs4all.nl>
 <d5a7f130-ef12-2e1d-c842-eef62899a31a@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57681853.9020703@xs4all.nl>
Date: Mon, 20 Jun 2016 18:22:43 +0200
MIME-Version: 1.0
In-Reply-To: <d5a7f130-ef12-2e1d-c842-eef62899a31a@itdev.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/20/2016 06:18 PM, Nick Dyer wrote:
> On 20/06/2016 17:09, Hans Verkuil wrote:
>> On 06/17/2016 04:16 PM, Nick Dyer wrote:
>>> @@ -2325,11 +2344,20 @@ static int mxt_vidioc_querycap(struct file *file, void *priv,
>>>  static int mxt_vidioc_enum_input(struct file *file, void *priv,
>>>  				   struct v4l2_input *i)
>>>  {
>>> -	if (i->index > 0)
>>> +	if (i->index >= MXT_V4L_INPUT_MAX)
>>>  		return -EINVAL;
>>>  
>>>  	i->type = V4L2_INPUT_TYPE_TOUCH_SENSOR;
>>> -	strlcpy(i->name, "Mutual References", sizeof(i->name));
>>> +
>>> +	switch (i->index) {
>>> +	case MXT_V4L_INPUT_REFS:
>>> +		strlcpy(i->name, "Mutual References", sizeof(i->name));
>>> +		break;
>>> +	case MXT_V4L_INPUT_DELTAS:
>>> +		strlcpy(i->name, "Mutual Deltas", sizeof(i->name));
>>
>> I don't think this name is very clear. I have no idea how to interpret "Mutual"
>> in this context.
> 
> "Mutual" is a touch domain specific term, it means the delta value is for
> the capacitance between the horizontal and vertical lines at a particular
> "node" on the touchscreen matrix, see
> https://en.wikipedia.org/wiki/Touchscreen#Mutual_capacitance
> 
> I'll put in a comment.

As I mentioned in an earlier review, we need a v4l-touch interface description anyway.
I think it might be useful to describe some of these touch-specific terms there.
That way that could be a useful reference for end-users.

Nobody reads comments, but people do read the spec (well, I do).

Regards,

	Hans

> 
>>
>>> +		break;
>>> +	}
>>> +
>>>  	return 0;
>>>  }
>>>  
>>> @@ -2337,12 +2365,16 @@ static int mxt_set_input(struct mxt_data *data, unsigned int i)
>>>  {
>>>  	struct v4l2_pix_format *f = &data->dbg.format;
>>>  
>>> -	if (i > 0)
>>> +	if (i >= MXT_V4L_INPUT_MAX)
>>>  		return -EINVAL;
>>>  
>>> +	if (i == MXT_V4L_INPUT_DELTAS)
>>> +		f->pixelformat = V4L2_PIX_FMT_YS16;
>>> +	else
>>> +		f->pixelformat = V4L2_PIX_FMT_Y16;
>>
>> You probably need a V4L2_TOUCH_FMT_U16 or something for this as well. It certainly
>> needs to be documented.
> 
> OK, will change this.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
