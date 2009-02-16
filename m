Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3631 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbZBPJKB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 04:10:01 -0500
Message-ID: <53216.62.70.2.252.1234775259.squirrel@webmail.xs4all.nl>
Date: Mon, 16 Feb 2009 10:07:39 +0100 (CET)
Subject: Re: Adding a control for Sensor Orientation
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: "Hans de Goede" <hdegoede@redhat.com>,
	"Trent Piepho" <xyzzy@speakeasy.org>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	kilgota@banach.math.auburn.edu,
	"Adam Baker" <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	"Jean-Francois Moine" <moinejf@free.fr>,
	"Olivier Lorin" <o.lorin@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>
>>
>>
>> Hans Verkuil wrote:
>>> On Monday 16 February 2009 05:04:40 Trent Piepho wrote:
>>>> On Sun, 15 Feb 2009, Mauro Carvalho Chehab wrote:
>>>>> On Sun, 15 Feb 2009 10:29:03 +0100
>>>>>
>>>>> Hans de Goede <hdegoede@redhat.com> wrote:
>>>>>>> I think we should also be able to detect 90 and 270 degree
>>>>>>> rotations. Or at the very least prepare for it. It's a safe bet to
>>>>>>> assume that webcams will arrive that can detect portrait vs
>>>>>>> landscape orientation.
>>>>>> Handling those (esp on the fly) will be rather hard as width and
>>>>>> height then get swapped. So lets worry about those when we need to.
>>>>>> We will need an additional flag for those cases anyways.
>>>>> The camera rotation is something that is already needed, at least on
>>>>> some embedded devices, like those cellular phones whose display
>>>>> changes
>>>>> when you rotate the device.
>>>>>
>>>>> By looking at the v4l2_buffer struct, we currently have 4 reserved
>>>>> bytes. It has also one flags field, with several bits not used. I can
>>>>> see 2 possibilities to extend the API:
>>>>>
>>>>> 1) adding V4L2_BUF_FLAG_HFLIP and V4L2_BUF_FLAG_VFLIP flags. This
>>>>> would
>>>>> work for 90, 180 and 270 rotation;
>>>> HFLIP and VFLIP are only good for 0 and 180 degrees.  90 and 270 isn't
>>>> the same as flipping.
>>>>
>>>> The problem I'm seeing here is that as people are using v4l2 for
>>>> digital
>>>> cameras instead of tv capture there is more and more meta-data
>>>> available.
>>>> Things like shutter speed, aperture, focus distance, and so on.  Just
>>>> look at all the EXIF data a digital camera provides.  Four bytes and
>>>> two
>>>> flags are going to run out very quickly at this rate.
>>>>
>>>> It's a shame there are not 8 bytes left, as then they could be used
>>>> for
>>>> a
>>>> pointer to an extended meta-data structure.
>>>
>>> I think we have to distinguish between two separate types of data:
>>> fixed
>>> ('the sensor is mounted upside-down', or 'the sensor always requires a
>>> hflip/vflip') and dynamic ('the user pivoted the camera 270 degrees').
>>>
>>> The first is static data and I think we can just reuse the existing
>>> HFLIP/VFLIP controls: just make them READONLY to tell libv4l that
>>> libv4l
>>> needs to do the flipping.
>>>
>>> The second is dynamic data and should be passed through v4l2_buffer
>>> since
>>> this can change on a per-frame basis. In this case add two bits to the
>>> v4l2_buffer's flags field:
>>>
>>> V4L2_BUF_FLAG_ROTATION_MSK	0x0c00
>>> V4L2_BUF_FLAG_ROTATION_0	0x0000
>>> V4L2_BUF_FLAG_ROTATION_90	0x0400
>>> V4L2_BUF_FLAG_ROTATION_180	0x0800
>>> V4L2_BUF_FLAG_ROTATION_270	0x0c00
>>>
>>> No need to use the reserved field.
>>>
>>> This makes a lot more sense to me: static (or rarely changing) data
>>> does
>>> not
>>> belong to v4l2_buffer, that's what controls are for. And something
>>> dynamic
>>> like pivoting belongs to v4l2_buffer. This seems like a much cleaner
>>> API
>>> to
>>> me.
>>
>> I agree that we have static and dynamic camera properties, and that we
>> may
>> want
>>   to have 2 API's for them. I disagree the control API is the proper API
>> to
>> expose static properties, many existing applications will not handle
>> this
>> well.
>
> ??? And they will when exposed through v4l2_buffer? It's all new
> functionality, so that is a non-argument. The point is that libv4l has to
> be able to detect and handle oddly mounted sensors. It can do that easily
> through the already existing HFLIP/VFLIP controls. It's a one time check
> when the device is opened (does it have read-only H/VFLIP controls? If so,
> then libv4l knows it has to correct).
>
> Completely independent from that is the camera pivot: this is dynamic and
> while by default libv4l may be called upon to handle this, it should also
> be possible to disable this in libv4l by the application.
>
> You should definitely not mix pivoting information with sensor mount
> information: e.g. if you see hflip and vflip bits set, does that mean that
> the sensor is mounted upside down? Or that the camera is pivoted 180
> degrees? That's two different things.
>
>> More over in the case we are discussing now, we have one type of data
>> (sensor
>> orientation) which can be both static or dynamic depending on the camera
>> having
>> 2 API's for this is just plain silly. Thus unnecessarily complicates
>> things if
>> some camera property can be static in some cases and dynamic in others
>> then we
>> should just always treat it as dynamic. This way we will only have one
>> code
>> path to deal with instead of two (with very interesting interactions
>> also,
>> what
>> if both API's sat rotate 180 degrees, should we then not rotate at
>> all?).
>> This
>> way lies madness.
>
> I strongly disagree. Yes, if both sensor mount info and pivot info is
> handled completely inside libv4l, then indeed it doesn't have to rotate at
> all. But the application probably still wants to know that the user
> rotated the camera 180 degrees, if only to be able to report this
> situation. And this is of course even more important for the 90 and 270
> degree rotations (think handhelds).
>
>> My conclusion:
>> 1) Since rotation can be dynamic store it in the buffer flags
>
> Ack. But rotation != sensor mount position.
>
>> 2) In the future we will most likely need an API to be able to query
>> camera
>>     properties
>
> For sensor mount position we have them in the form of HFLIP/VFLIP readonly
> controls. One-time check, simple to use.
>
> I'd like some more input on this from other people as well.

An additional comment: I'm willing to consider having both hflip/vflip
bits and rotate bits in v4l2_buffer (although I think it is not the best
solution), or a separate CAM_SENSOR_MOUNT control conveying the sensor
mount information. But don't mix mount and pivot info.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

