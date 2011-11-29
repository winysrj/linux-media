Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36822 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab1K2Tjp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 14:39:45 -0500
Received: by yenl6 with SMTP id l6so4429564yen.19
        for <linux-media@vger.kernel.org>; Tue, 29 Nov 2011 11:39:44 -0800 (PST)
Message-ID: <4ED534FB.5060401@gmail.com>
Date: Tue, 29 Nov 2011 20:39:39 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@redhat.com, m.szyprowski@samsung.com,
	jonghun.han@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 1/2] v4l: Add new alpha component control
References: <1322235572-22016-1-git-send-email-s.nawrocki@samsung.com> <201111291208.10495.hverkuil@xs4all.nl> <4ED50AEA.4050109@samsung.com> <201111291910.40076.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111291910.40076.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent!

On 11/29/2011 07:10 PM, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> On Tuesday 29 November 2011 17:40:10 Sylwester Nawrocki wrote:
>> On 11/29/2011 12:08 PM, Hans Verkuil wrote:
>>> On Monday 28 November 2011 14:02:49 Sylwester Nawrocki wrote:
>>>> On 11/28/2011 01:39 PM, Hans Verkuil wrote:
>>>>> On Monday 28 November 2011 13:13:32 Sylwester Nawrocki wrote:
>>>>>> On 11/28/2011 12:38 PM, Hans Verkuil wrote:
>>>>>>> On Friday 25 November 2011 16:39:31 Sylwester Nawrocki wrote:

>>
>> Nevertheless I have at least two use cases, for the alpha control and
>> for the image sensor driver. In case of the camera sensor, different device
>> revisions may have different step and maximum value for some controls,
>> depending on firmware.
>> By using v4l2_ctrl_range_update() I don't need to invoke lengthy sensor
>> start-up procedure just to find out properties of some controls.
> 
> Wouldn't it be confusing for applications to start with a range and have it 
> updated at runtime ?
> 

Indeed, changing a control range like this is not the brightest idea ever.
I would not consider doing something like this commonly. However if the
applications are aware that the control range may change at any time and
they handle the events, there shouldn't be a problem. Of course life for
applications is getting harder. The complexity for applications is increasing
maybe a bit too much at this point already...

I guess you would agree that it's best to power up the sensor when sub-device
node is opened and do all necessary setup before any subdev file operation
is commenced. For that I'm just looking forward for the common struct clk
to be merged and all platforms to be converted to it. So we can use
a struct clk object to enable sensor clock from subdev drivers level.


--

Regards,
Sylwester


