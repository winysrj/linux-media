Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35398 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1CGNFA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 08:05:00 -0500
Received: by vxi39 with SMTP id 39so3647575vxi.19
        for <linux-media@vger.kernel.org>; Mon, 07 Mar 2011 05:05:00 -0800 (PST)
Message-ID: <4D74D7F6.1000508@gmail.com>
Date: Mon, 07 Mar 2011 10:04:54 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	David Cohen <dacohen@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
References: <201102171606.58540.laurent.pinchart@ideasonboard.com> <201103061821.31705.laurent.pinchart@ideasonboard.com> <4D74C684.7090507@redhat.com> <201103071302.49323.hansverk@cisco.com> <4D74D6E4.8080501@redhat.com>
In-Reply-To: <4D74D6E4.8080501@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-03-2011 10:00, Mauro Carvalho Chehab escreveu:
> Em 07-03-2011 09:02, Hans Verkuil escreveu:
>> On Monday, March 07, 2011 12:50:28 Mauro Carvalho Chehab wrote:
>>
>>> Em 06-03-2011 14:21, Laurent Pinchart escreveu:
>>
>>>> Hi Mauro,
>>
>>>>
>>
>>>> On Sunday 06 March 2011 14:32:44 Mauro Carvalho Chehab wrote:
>>
>>>>> Em 06-03-2011 08:38, Laurent Pinchart escreveu:
>>
>>>>>> On Sunday 06 March 2011 11:56:04 Mauro Carvalho Chehab wrote:
>>
>>>>>>> Em 05-03-2011 20:23, Sylwester Nawrocki escreveu:
>>
>>>>>>>
>>
>>>>>>> A somewhat unrelated question that occurred to me today: what happens
>>
>>>>>>> when a format change happens while streaming?
>>
>>>>>>>
>>
>>>>>>> Considering that some formats need more bits than others, this could
>>
>>>>>>> lead into buffer overflows, either internally at the device or
>>
>>>>>>> externally, on bridges that just forward whatever it receives to the
>>
>>>>>>> DMA buffers (there are some that just does that). I didn't see anything
>>
>>>>>>> inside the mc code preventing such condition to happen, and probably
>>
>>>>>>> implementing it won't be an easy job. So, one alternative would be to
>>
>>>>>>> require some special CAPS if userspace tries to set the mbus format
>>
>>>>>>> directly, or to recommend userspace to create media controller nodes
>>
>>>>>>> with 0600 permission.
>>
>>>>>>
>>
>>>>>> That's not really a media controller issue. Whether formats can be
>>
>>>>>> changed during streaming is a driver decision. The OMAP3 ISP driver
>>
>>>>>> won't allow formats to be changed during streaming. If the hardware
>>
>>>>>> allows for such format changes, drivers can implement support for that
>>
>>>>>> and make sure that no buffer overflow will occur.
>>
>>>>>
>>
>>>>> Such issues is caused by having two API's that allow format changes, one
>>
>>>>> that does it device-based, and another one doing it subdev-based.
>>
>>>>>
>>
>>>>> Ok, drivers can implementing locks to prevent such troubles, but, without
>>
>>>>> the core providing a reliable mechanism, it is hard to implement a
>>
>>>>> correct lock.
>>
>>>>>
>>
>>>>> For example, let's suppose that some driver is using mt9m111 subdev (I just
>>
>>>>> picked one random sensor that supports lots of MBUS formats). There's
>>
>>>>> nothing there preventing a subdev call for it to change mbus format while
>>
>>>>> streaming. Worse than that, the sensor driver has no way to block it, as
>>
>>>>> it doesn't know that the bridge driver is streaming or not.
>>
>>>>>
>>
>>>>> The code at subdev_do_ioctl() is just:
>>
>>>>>
>>
>>>>> case VIDIOC_SUBDEV_S_FMT: {
>>
>>>>> struct v4l2_subdev_format *format = arg;
>>
>>>>>
>>
>>>>> if (format->which != V4L2_SUBDEV_FORMAT_TRY &&
>>
>>>>> format->which != V4L2_SUBDEV_FORMAT_ACTIVE)
>>
>>>>> return -EINVAL;
>>
>>>>>
>>
>>>>> if (format->pad >= sd->entity.num_pads)
>>
>>>>> return -EINVAL;
>>
>>>>>
>>
>>>>> return v4l2_subdev_call(sd, pad, set_fmt, subdev_fh, format);
>>
>>>>> }
>>
>>>>>
>>
>>>>> So, mc core won't be preventing it.
>>
>>>>>
>>
>>>>> So, I can't see how such subdev request would be implementing a logic to
>>
>>>>> return -EBUSY on those cases.
>>
>>>>
>>
>>>> Drivers can use the media_device graph_mutex to serialize format and stream
>>
>>>> management calls. A finer grain locking mechanism implemented in the core
>>
>>>> might be better, but we're not stuck without a solution at the moment.
>>
>> Am I missing something here? Isn't it as simple as remembering whether the
>>
>> subdev is in streaming mode (s_stream(1) was called) or not? When streaming
>>
>> any attempt to change the format should return an error (unless the hardware
>>
>> can handle it, of course).
>>
>> This is the same as for the 'regular' V4L2 API.
> 
> Not all subdevs implement s_stream, and I suspect that not all bridge drivers
> calls it. The random example I've looked didn't implement (mt9m111.c), but even
> some that implements it (like mt9m001.c) currently don't store the stream status
> or use it to prevent a format change.
> 
> At the moment we open the possibility to directly access the subdev, 
> developers might think that all they need to use the new API is to enable
> the subdev to create subdev nodes (btw, the first mc patch series were enabling
> it by default). However, opening subdev access without address such issues will
> lead into a security breach, as buffer overflows will happen if hardware can't 
> handle format changes in the middle of a streaming [1].
> 
> Also, a lock there will only work if properly implemented at the bridge driver,
> as a bridge driver that implement the media controller should implement something
> like the following sequence (at VIDIOC_REQBUFS):
> 
> 	lock_format_changes_at_subdev();			/* step 1 */
> 	get_subdev_formats();					/* step 2 */
> 	program_bridge_to follow_subdev_format_and_s_fmt();	/* step 3 */
> 	reserve_memory();					/* step 4 */
> 	start_streaming();					/* step 5 */
> 
> 
> In the above, s_stream should be called at the step 1, and not at step 5, as,
> otherwise, a race condition will happen, if a MBUS format change happens between
> step 1 and 5.

In time: assuming that s_stream would implement such lock. 

Also: it this is a mandatory requirement, it should be part of API documentation.
Otherwise, we'll have subdevs that will implement the lock using one way, and others
using a different way, creating an mess at the subdevs in a way that some subdevs
will work with bridge A, but not with bridge B, that has a different requirement
for such lock.

Cheers,
Mauro.
