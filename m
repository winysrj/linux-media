Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:39739 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2CGX6F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 18:58:05 -0500
Message-ID: <4F57F5F4.5080103@iki.fi>
Date: Thu, 08 Mar 2012 01:57:40 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5 27/35] omap3isp: Introduce isp_video_check_external_subdevs()
References: <20120306163239.GN1075@valkosipuli.localdomain> <51199527.ynQze3IDdP@avalon> <20120307174946.GD1476@valkosipuli.localdomain> <1513668.GA27SF7oCM@avalon>
In-Reply-To: <1513668.GA27SF7oCM@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> On Wednesday 07 March 2012 19:49:46 Sakari Ailus wrote:
>> On Wed, Mar 07, 2012 at 11:43:31AM +0100, Laurent Pinchart wrote:
>>> On Tuesday 06 March 2012 18:33:08 Sakari Ailus wrote:
>>>> isp_video_check_external_subdevs() will retrieve external subdev's
>>>> bits-per-pixel and pixel rate for the use of other ISP subdevs at
>>>> streamon
>>>> time. isp_video_check_external_subdevs() is called after pipeline
>>>> validation.
>>>>
>>>> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>
>>>> ---
>>>>
>>>>   drivers/media/video/omap3isp/ispvideo.c |   75
>>>>   ++++++++++++++++++++++++++++
>>>>   1 files changed, 75 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/media/video/omap3isp/ispvideo.c
>>>> b/drivers/media/video/omap3isp/ispvideo.c index 4bc9cca..ef5c770 100644
>>>> --- a/drivers/media/video/omap3isp/ispvideo.c
>>>> +++ b/drivers/media/video/omap3isp/ispvideo.c
>>>> @@ -934,6 +934,77 @@ isp_video_dqbuf(struct file *file, void *fh, struct
>>>> v4l2_buffer *b) file->f_flags&  O_NONBLOCK);
>>>>
>>>>   }
>>>>
>>>> +static int isp_video_check_external_subdevs(struct isp_pipeline *pipe)
>>>> +{
>>>> +	struct isp_device *isp =
>>>> +		container_of(pipe, struct isp_video, pipe)->isp;
>>>
>>> Any reason not to pass isp_device * from the caller to this function ?
>>
>> I didn't simply because it was unnecessary. Should I? "pipe" is needed in
>> any case.
>
> It will look simpler (in my opinion), and will probably generate less code, so
> I think you should.

I'll change that for a new version tomorrow.

-- 
Sakari Ailus
sakari.ailus@iki.fi
