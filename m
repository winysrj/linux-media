Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48158 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791AbZBPIdM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 03:33:12 -0500
Message-ID: <499925C7.2090604@redhat.com>
Date: Mon, 16 Feb 2009 09:37:27 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	kilgota@banach.math.auburn.edu,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>
Subject: Re: Adding a control for Sensor Orientation
References: <200902142048.51863.linux@baker-net.org.uk> <20090215232637.46732912@pedra.chehab.org> <Pine.LNX.4.58.0902151956510.24268@shell2.speakeasy.net> <200902160844.26368.hverkuil@xs4all.nl>
In-Reply-To: <200902160844.26368.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hans Verkuil wrote:
> On Monday 16 February 2009 05:04:40 Trent Piepho wrote:
>> On Sun, 15 Feb 2009, Mauro Carvalho Chehab wrote:
>>> On Sun, 15 Feb 2009 10:29:03 +0100
>>>
>>> Hans de Goede <hdegoede@redhat.com> wrote:
>>>>> I think we should also be able to detect 90 and 270 degree
>>>>> rotations. Or at the very least prepare for it. It's a safe bet to
>>>>> assume that webcams will arrive that can detect portrait vs
>>>>> landscape orientation.
>>>> Handling those (esp on the fly) will be rather hard as width and
>>>> height then get swapped. So lets worry about those when we need to.
>>>> We will need an additional flag for those cases anyways.
>>> The camera rotation is something that is already needed, at least on
>>> some embedded devices, like those cellular phones whose display changes
>>> when you rotate the device.
>>>
>>> By looking at the v4l2_buffer struct, we currently have 4 reserved
>>> bytes. It has also one flags field, with several bits not used. I can
>>> see 2 possibilities to extend the API:
>>>
>>> 1) adding V4L2_BUF_FLAG_HFLIP and V4L2_BUF_FLAG_VFLIP flags. This would
>>> work for 90, 180 and 270 rotation;
>> HFLIP and VFLIP are only good for 0 and 180 degrees.  90 and 270 isn't
>> the same as flipping.
>>
>> The problem I'm seeing here is that as people are using v4l2 for digital
>> cameras instead of tv capture there is more and more meta-data available.
>> Things like shutter speed, aperture, focus distance, and so on.  Just
>> look at all the EXIF data a digital camera provides.  Four bytes and two
>> flags are going to run out very quickly at this rate.
>>
>> It's a shame there are not 8 bytes left, as then they could be used for a
>> pointer to an extended meta-data structure.
> 
> I think we have to distinguish between two separate types of data: fixed 
> ('the sensor is mounted upside-down', or 'the sensor always requires a 
> hflip/vflip') and dynamic ('the user pivoted the camera 270 degrees').
> 
> The first is static data and I think we can just reuse the existing 
> HFLIP/VFLIP controls: just make them READONLY to tell libv4l that libv4l 
> needs to do the flipping.
> 
> The second is dynamic data and should be passed through v4l2_buffer since 
> this can change on a per-frame basis. In this case add two bits to the 
> v4l2_buffer's flags field:
> 
> V4L2_BUF_FLAG_ROTATION_MSK	0x0c00
> V4L2_BUF_FLAG_ROTATION_0	0x0000
> V4L2_BUF_FLAG_ROTATION_90	0x0400
> V4L2_BUF_FLAG_ROTATION_180	0x0800
> V4L2_BUF_FLAG_ROTATION_270	0x0c00
> 
> No need to use the reserved field.
> 
> This makes a lot more sense to me: static (or rarely changing) data does not 
> belong to v4l2_buffer, that's what controls are for. And something dynamic 
> like pivoting belongs to v4l2_buffer. This seems like a much cleaner API to 
> me.

I agree that we have static and dynamic camera properties, and that we may want 
  to have 2 API's for them. I disagree the control API is the proper API to 
expose static properties, many existing applications will not handle this well.

More over in the case we are discussing now, we have one type of data (sensor 
orientation) which can be both static or dynamic depending on the camera having 
2 API's for this is just plain silly. Thus unnecessarily complicates things if 
some camera property can be static in some cases and dynamic in others then we 
should just always treat it as dynamic. This way we will only have one code 
path to deal with instead of two (with very interesting interactions also, what 
if both API's sat rotate 180 degrees, should we then not rotate at all?). This 
way lies madness.

My conclusion:
1) Since rotation can be dynamic store it in the buffer flags
2) In the future we will most likely need an API to be able to query camera
    properties

Regards,

Hans
