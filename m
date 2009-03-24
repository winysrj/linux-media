Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3399 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758141AbZCXKYX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 06:24:23 -0400
Message-ID: <15803.62.70.2.252.1237890249.squirrel@webmail.xs4all.nl>
Date: Tue, 24 Mar 2009 11:24:09 +0100 (CET)
Subject: Re: [question] about open/release and
     vidioc_g_input/vidioc_s_input functions
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>
Cc: "Alexey Klimov" <klimov.linux@gmail.com>,
	linux-media@vger.kernel.org,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Douglas Schilling Landgraf" <dougsland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Tuesday 24 March 2009 08:06:39 Hans Verkuil wrote:
>> On Tuesday 24 March 2009 00:14:07 Alexey Klimov wrote:
>> > Hello, all
>> >
>> > After last convertion of radio drivers to use v4l2_device we have such
>> > code in many radio drivers:
>> > (it's radio-terratec.c for example)
>> >
>> > ...
>> >  static int terratec_open(struct file *file)
>> > {
>> >         return 0;
>> > }
>> >
>> > static int terratec_release(struct file *file)
>> > {
>> >         return 0;
>> > }
>> > ...
>> >
>> > and
>> >
>> > ...
>> > static int vidioc_g_input(struct file *filp, void *priv, unsigned int
>> > *i)
>> > {
>> >         *i = 0;
>> >         return 0;
>> > }
>> >
>> > static int vidioc_s_input(struct file *filp, void *priv, unsigned int
>> i)
>> > {
>> >         return i ? -EINVAL : 0;
>> > }
>> > ...
>> >
>> > Such code used in many radio-drivers as i understand.
>> >
>> > Is it good to place this empty and almost empty functions in:
>> > (here i see two variants)
>> >
>> > 1) In header file that be in linux/drivers/media/radio/ directory.
>> > Later, we can move some generic/or repeating code in this header.
>> >
>> > 2) In any v4l header. What header may contain this ?
>> >
>> > ?
>> >
>> > For what ? Well, as i understand we can decrease amount of lines and
>> > provide this simple generic functions. It's like
>> > video_device_release_empty function behaviour. Maybe not only radio
>> > drivers can use such vidioc_g_input and vidioc_s_input.
>> >
>> > Is it worth ?
>>
>> I don't think it is worth doing this for g/s_input. I think it is useful
>> to
>> have them here: it makes it very clear that there is just a single input
>> and the overhead in both lines and actual bytes is minimal.
>
> What about making that the default NULL g_input/s_input callbacks handling
> in
> video_ioctl2 ? Devices with a single input wouldn't need to define
> g_input/s_input callbacks at all.

If you leave s/g_input NULL then you have a device without an input at
all. That's perfectly valid for output-only devices.

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

