Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:21257 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759048AbZDQHco (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 03:32:44 -0400
Received: by rv-out-0506.google.com with SMTP id f9so797832rvb.1
        for <linux-media@vger.kernel.org>; Fri, 17 Apr 2009 00:32:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0904170912550.5119@axis700.grange>
References: <5e9665e10904151712o5fa3076dr85ad12fc7f04914d@mail.gmail.com>
	 <Pine.LNX.4.64.0904162147370.4947@axis700.grange>
	 <5e9665e10904162346g37a29778ub0fd4c9f5c11f1df@mail.gmail.com>
	 <Pine.LNX.4.64.0904170852450.5119@axis700.grange>
	 <5e9665e10904170008q51283185g17f203e2bc969f30@mail.gmail.com>
	 <Pine.LNX.4.64.0904170912550.5119@axis700.grange>
Date: Fri, 17 Apr 2009 16:32:44 +0900
Message-ID: <5e9665e10904170032lce96483xe0cfa288483fa1ed@mail.gmail.com>
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
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 17, 2009 at 4:15 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Fri, 17 Apr 2009, Dongsoo, Nathaniel Kim wrote:
>
>> Hi Guennadi,
>>
>> On Fri, Apr 17, 2009 at 4:00 PM, Guennadi Liakhovetski
>> <g.liakhovetski@gmx.de> wrote:
>> > On Fri, 17 Apr 2009, Dongsoo, Nathaniel Kim wrote:
>> >
>> >> 1. make preview device a video output
>> >> => it makes sense. but codec path also has dedicated DMA to frame buffer.
>> >> What should we do with that? I have no idea by now.
>> >
>> > Add a V4L2_CAP_VIDEO_OVERLAY capability and if the user requests
>> > V4L2_BUF_TYPE_VIDEO_OVERLAY - configure direct output to framebuffer?
>> >
>>
>> OK that's an idea. Then we can use preview as video output device and
>> codec device as a capture device with overlay capability.
>
> Actually, if I interpret the "Camera interface overview" figure (20-1)
> correctly, both capture and output channels have the overlay capability,
> so, you can enable it for both of them and configure the respective one
> accordingly.

You are right. both of them can have overlay capability. I just forgot
that It could be configured like that. Thank you.

>
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
