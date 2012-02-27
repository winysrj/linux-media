Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64866 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597Ab2B0VZb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Feb 2012 16:25:31 -0500
Received: by eekc41 with SMTP id c41so934625eek.19
        for <linux-media@vger.kernel.org>; Mon, 27 Feb 2012 13:25:30 -0800 (PST)
Message-ID: <4F4BF4C1.2050803@gmail.com>
Date: Mon, 27 Feb 2012 22:25:21 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 1/6] V4L: Add V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8 media
 bus format
References: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com> <1329416639-19454-2-git-send-email-s.nawrocki@samsung.com> <20120216194615.GF7784@valkosipuli.localdomain> <4F3E6395.4070208@samsung.com> <20120217181501.GH7784@valkosipuli.localdomain> <4F3FC914.9060702@gmail.com> <4F4AB167.7020906@iki.fi>
In-Reply-To: <4F4AB167.7020906@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 02/26/2012 11:25 PM, Sakari Ailus wrote:
>>> I think we could use the framesize control to tell the size of the frame, or
>>> however it is done for jpeg blobs.
>>
>> Yes, we could add a standard framesize control to the Image Source class but it
>> will solve only part of the problem. Nevertheless it might be worth to have it.
>> It could be used by applications to configure subdevs directly, while the host
>> drivers could use e.g. s/g_frame_config op for that.
> 
> (I think we could continue this discussion in the context of the RFC.)

Sure, let's continue in your RFC thread.

>>> The issue I see in the pass-through mode is that the user would have no
>>> information whatsoever what he's getting. This would be perhaps fixed by
>>> adding the frame format descriptor: it could contain information how to
>>> handle the data. (Just thinking out loud. :))
>>
>> Do you mean a user space application by "user" ?
> 
> Yeah.
> 
>> I'd like to clearly separate blob media bus pixel codes and hardware-specific
>> blob fourccs. If we don't want to change fundamental assumptions of V4L2
>> we likely need separate fourccs for each weird format.
>>
>> I can imagine "pass-through" media bus pixel code but a transparent fourcc
>> sounds like a higher abstraction. :)
> 
> I agree... how about this:
> 
> We currently provide the information on the media bus pixel code to the
> CSI-2 receivers but most of the time it's not necessary for them to know
> what the pixel code exactly is: it doesn't do anything with the data but
> writes it to memory. Bits uncompressed, compressed and the compression
> method are enough --- if uncompression is desired. Even pixel order
> isn't always needed.

I don't think so. For all image formats defined by MIPI-CSI2 standard a pixel 
code is necessary. Sample compression or bit expansion is most of the time 
related to a specific image format. A MIPI-CSI2 receiver must know an exact 
image format, otherwise it won't be able to decode data from the low level 
protocol.

> What might make sense is to provide generic table with pixel code
> related information, such as bits compressed and uncompressed, pixel
> order, compression method and default 4CC.

This doesn't look like an improvement to me, most of these information we 
now have in single 4-byte media bus pixel code. Do you want the drivers 
to search such tables by comparing all those parameters ?

> Custom formats would only be present in this table without individual
> CSI-2 receiver drivers having to know about them. Same goes with 4CC's.

Media bus/fourcc translation tables will always be driver-specific. There 
have already been discussions about centralizing such tables IIRC. All you
can have is probably just some default ("statistical") fourcc, which is really
useful for nothing. 

Having a bunch of parameters for each custom format could be useful probably
only if we've dropped an assumption that each hardware specific data format 
gets it's own fourcc, and have exposed those parameters to the user space.

The multi-planar formats complicate things further. Now the fourcc determines
whether a v4l2 buffer is has more than one data plane.

--

Regards,
Sylwester
