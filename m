Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:55082 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab2BAKoE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2012 05:44:04 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LYP00ICRN5E3G40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 01 Feb 2012 10:44:02 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LYP00GCQN5EDA@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 01 Feb 2012 10:44:02 +0000 (GMT)
Date: Wed, 01 Feb 2012 11:44:02 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [Q] Interleaved formats on the media bus
In-reply-to: <Pine.LNX.4.64.1202010159390.31226@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Message-id: <4F291772.10200@samsung.com>
References: <4F27CF29.5090905@samsung.com>
 <Pine.LNX.4.64.1202010159390.31226@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 02/01/2012 02:44 AM, Guennadi Liakhovetski wrote:
>> V4L2_MBUS_FMT_VYUY_JPEG_1X8
> 
> Hmm... Are such sensors not sending this data over something like CSI-2 
> with different channel IDs? In which case we just deal with two formats 
> cleanly.

I think they could, it might be just a matter of a proper firmware. But now
all that is available is only truly interleaved data, in the chunks of page
or so. For a full picture I should mention that such a frame contains also
embedded non image data, at the end of frame. But this can possibly be handled
with a separate buffer queue, like in VBI case for instance.

> Otherwise - I'm a bit sceptical about defining a new format for each pair 
> of existing codes. Maybe we should rather try to describe individual 
> formats and the way they are interleaved? In any case the end user will 

Yes, sounds reasonable. However the sensor specific frame is transferred
as MIPI-CSI2 User Defined Data 1. So it should be possible to associate such 
information with the format on the media bus, for the bus receiver to be able
to properly handle the data. 

> want them separately, right? So, at some point they will want to know what 
> are those two formats, that the camera has sent.

I'm afraid the data will data have to be separated in user space. Moreover 
the user space needs to know what are resolutions for each YUV and JPEG frames.
But this could be probably queried at relevant subdevs/pads.

> No, I don't know yet how to describe this, proposals are welcome;-)

:-)

>> for interleaved VYUY and JPEG data might do, except it doesn't tell anything
>> about how the data is interleaved.
>>
>> So maybe we could add some code describing interleaving (xxxx)
>>
>> V4L2_MBUS_FMT_xxxx_VYUY_JPEG_1X8
>>
>> or just the sensor name instead ?
> 
> As I said above, I would describe formats separately and the way, how they 
> are interleaved. BTW, this might be related to recent patches from 
> Laurent, introducing data layout in RAM and fixing bytesperline and 
> sizeimage calculations.

Yes, more or less. Except of honoring 'sizeimage' the sensor needs to be
queried for the required buffer frame it sends out. I'm currently doing it
with a patch like this: 

http://www.mail-archive.com/linux-media@vger.kernel.org/msg39780.html

But I'm planning to change it to use a new control instead.


--

Regards,
Sylwester
