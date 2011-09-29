Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:37904 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab1I2G77 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 02:59:59 -0400
Message-ID: <4E84176B.9040003@iki.fi>
Date: Thu, 29 Sep 2011 09:59:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 2/9 v10] V4L: add two new ioctl()s for multi-size videobuffer
 management
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de> <201109271306.21095.hverkuil@xs4all.nl> <Pine.LNX.4.64.1109271417280.5816@axis700.grange> <201109271540.52649.hverkuil@xs4all.nl> <Pine.LNX.4.64.1109271847310.7004@axis700.grange> <Pine.LNX.4.64.1109281502380.30317@axis700.grange> <Pine.LNX.4.64.1109281653580.19957@axis700.grange> <20110928201514.GD6180@valkosipuli.localdomain> <Pine.LNX.4.64.1109282235580.21237@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109282235580.21237@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> On Wed, 28 Sep 2011, Sakari Ailus wrote:
>
>> Hi Guennadi,
>>
>> On Wed, Sep 28, 2011 at 04:56:11PM +0200, Guennadi Liakhovetski wrote:
>>> @@ -2099,6 +2103,15 @@ struct v4l2_dbg_chip_ident {
>>>   	__u32 revision;    /* chip revision, chip specific */
>>>   } __attribute__ ((packed));
>>>
>>> +/* VIDIOC_CREATE_BUFS */
>>> +struct v4l2_create_buffers {
>>> +	__u32			index;		/* output: buffers index...index + count - 1 have been created */
>>> +	__u32			count;
>>> +	enum v4l2_memory        memory;
>>> +	struct v4l2_format	format;		/* "type" is used always, the rest if sizeimage == 0 */
>>> +	__u32			reserved[8];
>>> +};
>>
>> What about the kerneldoc comments you wrote right after v6 on 1st September
>> for v4l2_create_buffers and the same for the compat32 version?
>
> Looks like someone is trying very hard to cause me a heart failure;-) They
> are in a separate patch:

No, I don't! :-) I'm just interested all the appropriate changes are in 
the patchset. My understanding was you intended to add these changes to 
the original patches.

Are you planning to put them to the same patchset still, or a different one?

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
