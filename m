Return-path: <linux-media-owner@vger.kernel.org>
Received: from zencphosting06.zen.co.uk ([82.71.204.9]:57566 "EHLO
	zencphosting06.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbcFUWRH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2016 18:17:07 -0400
Subject: Re: [PATCH v4 9/9] Input: synaptics-rmi4 - add support for F54
 diagnostics
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <1466172988-3698-1-git-send-email-nick.dyer@itdev.co.uk>
 <1466172988-3698-10-git-send-email-nick.dyer@itdev.co.uk>
 <576817C3.1090806@xs4all.nl>
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
From: Nick Dyer <nick.dyer@itdev.co.uk>
Message-ID: <35cae2f6-7c5c-ba7d-1bf4-28f83f19e6a5@itdev.co.uk>
Date: Tue, 21 Jun 2016 23:16:56 +0100
MIME-Version: 1.0
In-Reply-To: <576817C3.1090806@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20/06/2016 17:20, Hans Verkuil wrote:
> On 06/17/2016 04:16 PM, Nick Dyer wrote:
>> +static int rmi_f54_vidioc_enum_input(struct file *file, void *priv,
>> +				     struct v4l2_input *i)
>> +{
>> +	struct f54_data *f54 = video_drvdata(file);
>> +	enum f54_report_type reptype;
>> +
>> +	reptype = rmi_f54_get_reptype(f54, i->index);
>> +	if (reptype == F54_REPORT_NONE)
>> +		return -EINVAL;
>> +
>> +	i->type = V4L2_INPUT_TYPE_TOUCH_SENSOR;
>> +	strlcpy(i->name, rmi_f54_reptype_str(reptype), sizeof(i->name));
> 
> Hmm, this doesn't feel right, but I don't have enough knowledge to decide if
> using inputs for this is the right approach.
> 
> One thing that strikes me as odd is that both F54_8BIT_IMAGE and F54_16BIT_IMAGE
> both seem to return signed 16 bit samples. I would expect this to result in
> different pixel formats.

Yes, you're right. I've had a look at this area now and fixed it up. I've
added pixel formats for the various types of touch data so we will never
emit anything that's not under V4L2_TCH_FMT.

I've also worked on adding the DocBook documentation that was missing,
cribbing from SDR as you suggested. I think I've found all the places it
was needed now.

> I have no idea what all these inputs mean. Are they all actually needed?
> Would this perhaps be better implemented through a menu control?

These are the various types of tuning or fault finding data that users
expect to be able to access via the RMI4 F54 diagnostics function. Although
I would have to do some digging to give an detailed use case for each one.
Due to the way that F54 is implemented, only one data source can be
selected at once. So it seemed fairly reasonable to me to map it to inputs.

> I generally go by the philosophy that if I can't understand it, then it is
> likely that others won't either :-)

No problem.
