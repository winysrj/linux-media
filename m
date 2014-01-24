Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4468 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaAXL7F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 06:59:05 -0500
Message-ID: <52E25572.9090808@xs4all.nl>
Date: Fri, 24 Jan 2014 12:58:42 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, m.chehab@samsung.com,
	laurent.pinchart@ideasonboard.com, t.stanislaws@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 05/21] videodev2.h: add struct v4l2_query_ext_ctrl
 and VIDIOC_QUERY_EXT_CTRL.
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl> <1390221974-28194-6-git-send-email-hverkuil@xs4all.nl> <20140124112823.GB13820@valkosipuli.retiisi.org.uk>
In-Reply-To: <20140124112823.GB13820@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 01/24/2014 12:28 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Jan 20, 2014 at 01:45:58PM +0100, Hans Verkuil wrote:
>> +	union {
>> +		__u64 val;
>> +		__u32 reserved[4];
>> +	} step;
> 
> While I do not question that step is obviously always a positive value (or
> zero), using a different type from the value (and min and max) does add
> slight complications every time it is being used. I don't think there's a
> use case for using values over 2^62 for step either.

What sort of complications? The reason I changed it is to avoid having to
check for step < 0. It also makes it clear that it has to be positive.

> 
> Speaking of which --- do you think we should continue to have step in the
> interface? This has been proven to be slightly painful when the step is not
> an integer. Using a step of one in that case has been the only feasible
> solution. Step could be naturally be used as a hint but enforcing it often
> forces setting it to one.

Step is used quite often, so we can't remove it. If the step for a particular
control isn't fixed over the range of possible values (at least, I think that
is what you mean), then I don't see any solution that isn't painful. Not to
mention that GUIs will have a hard time.

Suggestions are welcome, though.

Regards,

	Hans
