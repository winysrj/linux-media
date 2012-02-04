Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48006 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab2BDP0l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2012 10:26:41 -0500
Received: by eekc14 with SMTP id c14so1544541eek.19
        for <linux-media@vger.kernel.org>; Sat, 04 Feb 2012 07:26:40 -0800 (PST)
Message-ID: <4F2D4E2D.1030107@gmail.com>
Date: Sat, 04 Feb 2012 16:26:37 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [Q] Interleaved formats on the media bus
References: <4F27CF29.5090905@samsung.com> <20120201100007.GA841@valkosipuli.localdomain> <4F2924F8.3040408@samsung.com> <4F2D14ED.8080105@iki.fi>
In-Reply-To: <4F2D14ED.8080105@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 02/04/2012 12:22 PM, Sakari Ailus wrote:
> Sylwester Nawrocki wrote:
>> On 02/01/2012 11:00 AM, Sakari Ailus wrote:
>>> I'd guess that all the ISP would do to such formats is to write them to
>>> memory since I don't see much use for either in ISPs --- both typically are
>>> output of the ISP.
>>
>> Yep, correct. In fact in those cases the sensor has complicated ISP built in,
>> so everything a bridge have to do is to pass data over to user space.
>>
>> Also non-image data might need to be passed to user space as well.
> 
> How does one know in the user space which part of the video buffer
> contains jpeg data and which part is yuv? Does the data contain some
> kind of header, or how is this done currently?

There is an additional data appended to the image data. Part of it must
be retrieved out of the main DMA channel. I someway missed to mention in
the previous e-mails that the bridge is somehow retarded, probably because
of the way is has been evolving over time. That is, it originally 
supported only the parallel video bus and then a MIPI-CSI2 frontend was 
added. So it cannot split MIPI-CSI data channels into separate memory 
buffers, AFAIK - at this stage. I think it just ignores the VC field of 
the Data Identifier (DI), but it's just a guess for now.

If you look at the S5PV210 datasheet and the MIPI-CSIS device registers,
at the end of the IO region it has 4 x ~4kiB internal buffers for 
"non-image" data. These buffers must be emptied in the interrupt handler 
and I'm going to need this data in user space in order to decode data 
from sensors.

Sounds like a 2-plane buffers is a way to go, one plane for interleaved
YUV/JPEG and the second one for the "metadata".

I originally thought about a separate buffer queue at the MIPI-CSIS driver,
but it likely would have added unnecessary complication in the applications.

> I'd be much in favour or using a separate channel ID as Guennadi asked;
> that way you could quite probably save one memory copy as well. But if
> the hardware already exists and behaves badly there's usually not much
> you can do about it.

As I explained above I suspect that the sensor sends each image data type
on separate channels (I'm not 100% sure) but the bridge is unable to DMA
it into separate memory regions.

Currently we have no support in V4L2 for specifying separate image data 
format per MIPI-CSI2 channel. Maybe the solution is just about that - 
adding support for virtual channels and a possibility to specify an image 
format separately per each channel ?
Still, there would be nothing telling how the channels are interleaved :-/

--
Regards,
Sylwester
