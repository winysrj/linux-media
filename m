Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3870 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab0I1MLk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 08:11:40 -0400
Message-ID: <3c895d38527af5e6b5acdd783ff8dacb.squirrel@webmail.xs4all.nl>
In-Reply-To: <201009281350.23233.laurent.pinchart@ideasonboard.com>
References: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com>
    <1285517612-20230-8-git-send-email-laurent.pinchart@ideasonboard.com>
    <201009262025.20852.hverkuil@xs4all.nl>
    <201009281350.23233.laurent.pinchart@ideasonboard.com>
Date: Tue, 28 Sep 2010 14:11:28 +0200
Subject: Re: [RFC/PATCH 7/9] v4l: v4l2_subdev userspace format API
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, g.liakhovetski@gmx.de
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> Hi Hans,
>
> Thanks for the review.
>
> On Sunday 26 September 2010 20:25:20 Hans Verkuil wrote:
>> On Sunday, September 26, 2010 18:13:30 Laurent Pinchart wrote:

<snip>

>> > diff --git a/Documentation/DocBook/v4l/vidioc-streamon.xml
>> > b/Documentation/DocBook/v4l/vidioc-streamon.xml index e42bff1..75ed39b
>> > 100644
>> > --- a/Documentation/DocBook/v4l/vidioc-streamon.xml
>> > +++ b/Documentation/DocBook/v4l/vidioc-streamon.xml
>> > @@ -93,6 +93,15 @@ synchronize with other events.</para>
>> >
>> >  been allocated (memory mapping) or enqueued (output) yet.</para>
>> >
>> >  	</listitem>
>> >
>> >        </varlistentry>
>> >
>> > +      <varlistentry>
>> > +	<term><errorcode>EPIPE</errorcode></term>
>> > +	<listitem>
>> > +	  <para>The driver implements <link
>> > +	  linkend="pad-level-formats">pad-level format configuration</link>
>> and
>> > +	  the pipeline configuration is invalid.
>>
>> This raises a question with me: how do I know that pad-level format
>> configuration is possible? Is there a capability or some test that I can
>> perform to check this?
>
> What about VIDIOC_SUBDEV_G_FMT on a pad ?

That will work. Probably a good idea to document this.

>
> [snip]
>
>> > diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
>> > new file mode 100644
>> > index 0000000..623d063
>> > --- /dev/null
>> > +++ b/include/linux/v4l2-subdev.h
>
> [snip]
>
>> > +/**
>> > + * struct v4l2_subdev_frame_size_enum - Media bus format enumeration
>> > + * @pad: pad number, as reported by the media API
>> > + * @index: format index during enumeration
>> > + * @code: format code (from enum v4l2_mbus_pixelcode)
>> > + */
>> > +struct v4l2_subdev_frame_size_enum {
>> > +	__u32 index;
>> > +	__u32 pad;
>> > +	__u32 code;
>> > +	__u32 min_width;
>> > +	__u32 max_width;
>> > +	__u32 min_height;
>> > +	__u32 max_height;
>> > +	__u32 reserved[9];
>> > +};
>>
>> Is there a reason why struct v4l2_frmsize_discrete and
>> v4l2_frmsize_stepwise are not reused here? Given the absence of
>> step_width/height fields in the struct can I assume a step of 1?

Didn't see a comment from you on this one...

>> > +
>> > +#define VIDIOC_SUBDEV_G_FMT	_IOWR('V',  4, struct v4l2_subdev_format)
>> > +#define VIDIOC_SUBDEV_S_FMT	_IOWR('V',  5, struct v4l2_subdev_format)
>> > +#define VIDIOC_SUBDEV_ENUM_MBUS_CODE \
>> > +			_IOWR('V',  2, struct v4l2_subdev_mbus_code_enum)
>> > +#define VIDIOC_SUBDEV_ENUM_FRAME_SIZE \
>> > +			_IOWR('V', 74, struct v4l2_subdev_frame_size_enum)
>>
>> The ioctl numbering is a bit scary. We want to be able to reuse V4L2
>> ioctls
>> with subdevs where appropriate. But then we need to enumerate the subdev
>> ioctls using a different character to avoid potential conflicts. E.g.
>> 'S'
>> instead of 'V'.
>
> There's little chance the ioctl values will conflict, as they encode the
> structure size. However, it could still happen. That's why I've reused the
> VIDIOC_G_FMT, VIDIOC_S_FMT, VIDIOC_ENUM_FMT and VIDIOC_ENUM_FRAMESIZES
> ioctl
> numbers for those new ioctls, as they replace the V4L2 ioctls for
> sub-devices.
> We can also use another prefix, but there's a limited supply of them.

Hmm, perhaps we can use 'v'. That's currently in use by V4L1, but that's
on the way out. I'm not sure what is wisdom here. Mauro should take a look
at this, I think.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

