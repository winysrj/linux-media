Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:44435 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbZDQHIB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 03:08:01 -0400
Received: by wf-out-1314.google.com with SMTP id 29so784248wff.4
        for <linux-media@vger.kernel.org>; Fri, 17 Apr 2009 00:08:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0904170852450.5119@axis700.grange>
References: <5e9665e10904151712o5fa3076dr85ad12fc7f04914d@mail.gmail.com>
	 <Pine.LNX.4.64.0904162147370.4947@axis700.grange>
	 <5e9665e10904162346g37a29778ub0fd4c9f5c11f1df@mail.gmail.com>
	 <Pine.LNX.4.64.0904170852450.5119@axis700.grange>
Date: Fri, 17 Apr 2009 16:08:01 +0900
Message-ID: <5e9665e10904170008q51283185g17f203e2bc969f30@mail.gmail.com>
Subject: Re: [RFC] Making Samsung S3C64XX camera interface driver in SoC
	camera subsystem
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	kernel@pengutronix.de,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	dongsoo45.kim@samsung.com, Hans Verkuil <hverkuil@xs4all.nl>,
	"Ailus Sakari (Nokia-D/Helsinki)" <Sakari.Ailus@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Fri, Apr 17, 2009 at 4:00 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Fri, 17 Apr 2009, Dongsoo, Nathaniel Kim wrote:
>
>> Hi Guennadi,
>>
>>
>> On Fri, Apr 17, 2009 at 4:58 AM, Guennadi Liakhovetski
>> <g.liakhovetski@gmx.de> wrote:
>> >
>> > Ok, now I understand your comments to my soc-camera thread better. Now,
>> > what about making one (or more) video devices with V4L2_CAP_VIDEO_CAPTURE
>> > type and one with V4L2_CAP_VIDEO_OUTPUT? Then you can use your capture
>> > type devices to switch between cameras and to configure input, and your
>> > output device to configure preview? Then you can use soc-camera to control
>> > your capture devices (if you want to of course) and implement an output
>> > device directly. It should be a much simpler device, because it will not
>> > be communicating with the cameras and only modify various preview
>> > parameters.
>> >
>>
>> It's a cool idea! Adding my understanding to your comment,
>>
>> 1. make preview device a video output
>> => it makes sense. but codec path also has dedicated DMA to frame buffer.
>> What should we do with that? I have no idea by now.
>
> Add a V4L2_CAP_VIDEO_OVERLAY capability and if the user requests
> V4L2_BUF_TYPE_VIDEO_OVERLAY - configure direct output to framebuffer?
>

OK that's an idea. Then we can use preview as video output device and
codec device as a capture device with overlay capability.

>> 2. preview device can have two inputs
>>    a) input from camera device : ok it's an ordinary way
>>    b) input from MSDMA : we can give RGB data upto 720P to preview
>> device with rotating and resizing supported
>>
>> Does it sound ok?
>
> Yes, looks good to me:-)
>
>> BTW, OMAP3 has similar feature with this. omap vout something?
>> And by now I'm gonna make my driver with soc camera subsystem without
>> VIDIOC_S_INPUT/G_INPUT, but I'm still desperate for that.
>
> Don't dispair - better send a patch when good times return (i.e., when we
> are fully with v4l2-subdev):-)
>

Priority job first and let's talk about it later. I also have to
convert my sensor drivers into v4l2-subdev drivers before I post my
patches to the list.
Cheers,

Nate

> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
>



-- 
========================================================
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
