Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:61445 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab2BZBLD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Feb 2012 20:11:03 -0500
Message-ID: <4F498695.6000708@iki.fi>
Date: Sun, 26 Feb 2012 03:10:45 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 30/33] omap3isp: Add resizer data rate configuration
 to resizer_set_stream
References: <20120220015605.GI7784@valkosipuli.localdomain> <1329703032-31314-30-git-send-email-sakari.ailus@iki.fi> <1709623.OrBLBvPVIp@avalon>
In-Reply-To: <1709623.OrBLBvPVIp@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the patch.
> 
> On Monday 20 February 2012 03:57:09 Sakari Ailus wrote:
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>> ---
>>  drivers/media/video/omap3isp/ispresizer.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/video/omap3isp/ispresizer.c
>> b/drivers/media/video/omap3isp/ispresizer.c index 6ce2349..81e1bc4 100644
>> --- a/drivers/media/video/omap3isp/ispresizer.c
>> +++ b/drivers/media/video/omap3isp/ispresizer.c
>> @@ -1147,9 +1147,13 @@ static int resizer_set_stream(struct v4l2_subdev *sd,
>> int enable) struct device *dev = to_device(res);
>>
>>  	if (res->state == ISP_PIPELINE_STREAM_STOPPED) {
>> +		struct isp_pipeline *pipe = to_isp_pipeline(&sd->entity);
>> +
>>  		if (enable == ISP_PIPELINE_STREAM_STOPPED)
>>  			return 0;
>>
>> +		omap3isp_resizer_max_rate(res, &pipe->max_rate);
>> +
>>  		omap3isp_subclk_enable(isp, OMAP3_ISP_SUBCLK_RESIZER);
>>  		resizer_configure(res);
>>  		resizer_print_status(res);
> 
> What about moving this to link validation ?

Done. I hope I can resend the patchset tomorrow. The SMIA++ driver is
unchanged just in case you happen to have time to review that one. ;-)

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
