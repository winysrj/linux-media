Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59223 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab2J2WnL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 18:43:11 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2363620eek.19
        for <linux-media@vger.kernel.org>; Mon, 29 Oct 2012 15:43:10 -0700 (PDT)
Message-ID: <508F067B.7030301@gmail.com>
Date: Mon, 29 Oct 2012 23:43:07 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 10/23] V4L: Add auto focus targets to the selections API
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com> <1336645858-30366-11-git-send-email-s.nawrocki@samsung.com> <20121029200036.GA25623@valkosipuli.retiisi.org.uk>
In-Reply-To: <20121029200036.GA25623@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 10/29/2012 09:00 PM, Sakari Ailus wrote:
> On Thu, May 10, 2012 at 12:30:45PM +0200, Sylwester Nawrocki wrote:
>> The camera automatic focus algorithms may require setting up
>> a spot or rectangle coordinates or multiple such parameters.
>>
>> The automatic focus selection targets are introduced in order
>> to allow applications to query and set such coordinates. Those
>> selections are intended to be used together with the automatic
>> focus controls available in the camera control class.
>>
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> ---
>>   Documentation/DocBook/media/v4l/selection-api.xml  |   33 +++++++++++++++++++-
>>   .../DocBook/media/v4l/vidioc-g-selection.xml       |   11 +++++++
>>   include/linux/videodev2.h                          |    5 +++
>>   3 files changed, 48 insertions(+), 1 deletion(-)
> 
> What's the status of this patch? May I ask if you have plans to continue
> with it?

Thanks for reminding about it. I'd like to make this ready for v3.8, if 
possible. I've done some minor improvements of the related 
V4L2_CID_AUTO_FOCUS_AREA control and we use this patch internally. We would 
like to see how all this can be used for auto focus feature of the s5c73m3 
camera. I hope to have these patches posted next week.
 
> Speaking of multiple AF windows --- I originally thought we could just have
> multiple selection targets for them. I'm not sure which one would be better;
> multiple selection targets or another field telling the window ID. In case
> of the former we'd leave a largish gap for additional window IDs.
> 
> I think I'm leaning towards using one reserved field for the purpose.

That also as my preference. I imagine the ID field could be reused for
other future or existing selection targets anyway. I recall someone already
asked about multiple ROI support for image cropping [1], perhaps the ID 
field could be used also for that.
 
> Another question I had was that which of the selection rectangles would the
> AF rectangle be related to? Is it the compose bounds rectangle, or the crop
> bounds rectangle, for example? I thought it might make sense to use another
> field to tell that, since I think which one this really is related to is
> purely hardware specific.

It's indeed very hardware specific. I've seen sensors that allow to define
bounds for the auto focus rectangle entirely independent from the output 
format, crop or compose rectangle. It may look strange, but some sensor 
firmwares just accept rectangle/point coordinates with bounds rectangle 
corresponding to video display area (so it is easy, e.g. to use coordinates 
coming directly from a touchscreen) and then perform required calculations 
to map/scale it onto e.g. sensor crop or output rectangle.

I guess your question is related to how to determine in what stage of 
video pipeline the AF selections would be and what the configuration 
order should be from the user space side ?
 
--
Regards,
Sylwester

[1] http://www.spinics.net/lists/linux-media/msg55091.html
