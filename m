Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62081 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab2BDScN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2012 13:32:13 -0500
Received: by eekc14 with SMTP id c14so1610783eek.19
        for <linux-media@vger.kernel.org>; Sat, 04 Feb 2012 10:32:12 -0800 (PST)
Message-ID: <4F2D79A9.8030504@gmail.com>
Date: Sat, 04 Feb 2012 19:32:09 +0100
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
References: <4F27CF29.5090905@samsung.com> <20120201100007.GA841@valkosipuli.localdomain> <4F2924F8.3040408@samsung.com> <4F2D14ED.8080105@iki.fi> <4F2D4E2D.1030107@gmail.com> <4F2D5231.4000703@iki.fi>
In-Reply-To: <4F2D5231.4000703@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 02/04/2012 04:43 PM, Sakari Ailus wrote:
>> As I explained above I suspect that the sensor sends each image data type
>> on separate channels (I'm not 100% sure) but the bridge is unable to DMA
>> it into separate memory regions.
>>
>> Currently we have no support in V4L2 for specifying separate image data
>> format per MIPI-CSI2 channel. Maybe the solution is just about that -
>> adding support for virtual channels and a possibility to specify an image
>> format separately per each channel ?
>> Still, there would be nothing telling how the channels are interleaved :-/
> 
> _If_ the sensor sends YUV and compressed JPEG data in separate CSI-2

As I learned MIPI-CSI2 specifies 3 data interleaving methods, at: packet, 
frame and virtual channel level. I'm almost certain I'm dealing now with
packet level interleaving, but VC interleaving might need to be supported  
very soon.

> channels then definitely the correct way to implement this is to take
> this kind of setup into account in the frame format description --- we
> do need that quite badly.

Yeah, I will probably want to focus more on that after completing the
camera control works.

> However, this doesn't really help you with your current problem, and
> perhaps just creating a custom format for your sensor driver is the best
> way to go for the time being. But. When someone attaches this kind of

Yes, this is what I started with. What do you think about creating media 
bus codes directly corresponding the the user defined MIPI-CSI data types ?

> sensor to another CSI-2 receiver that can separate the data from
> different channels, I think we should start working towards for a
> correct solution which this driver also should support.

Sure. We would also include description of bus receiver/transmitter 
capabilities, e.g. telling explicitly which interleaving methods are 
supported.

> With information on the frame format, the CSI-2 hardware could properly
> write the data into two separate buffers. Possibly it should provide two
> video nodes, but I'm not sure about that. A multi-plane buffer is
> another option.

Indeed. I think both solutions are equally correct and there should be no
need to restrict us to one or the other. I would leave decision up to the
driver authors, as one option will be more appropriate in some cases than
the other.

--

Thanks,
Sylwester
