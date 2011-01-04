Return-path: <mchehab@gaivota>
Received: from smtp.nokia.com ([147.243.1.47]:23483 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab1ADLax (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jan 2011 06:30:53 -0500
Message-ID: <4D2304D4.6070806@maxwell.research.nokia.com>
Date: Tue, 04 Jan 2011 13:30:28 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Shuzhen Wang <shuzhenw@codeaurora.org>
CC: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	"'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
	"'Hans Verkuil'" <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	hzhong@codeaurora.org, "Yan, Yupeng" <yyan@quicinc.com>
Subject: Re: RFC: V4L2 driver for Qualcomm MSM camera.
References: <000601cba2d8$eaedcdc0$c0c96940$@org> <4D188285.8090603@redhat.com> <000001cba6bd$f2c94ea0$d85bebe0$@org> <201012282123.58775.laurent.pinchart@ideasonboard.com> <000001cbabb8$49892d10$dc9b8730$@org>
In-Reply-To: <000001cbabb8$49892d10$dc9b8730$@org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello,

Shuzhen Wang wrote:
>> -----Original Message-----
>> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
>> Sent: Tuesday, December 28, 2010 12:24 PM
>> To: Shuzhen Wang
>> Cc: 'Mauro Carvalho Chehab'; 'Hans Verkuil'; linux-
>> media@vger.kernel.org; hzhong@codeaurora.org; Yan, Yupeng
>> Subject: Re: RFC: V4L2 driver for Qualcomm MSM camera.
>>
>> I will strongly NAK any implementation that requires a daemon.
>>
> 
> We understand the motivation behind making the daemon optional.
> However there are restrictions from legal perspective, which we
> don't know how to get around.
> 
> A simplest video streaming data flow with MSM ISP is like this:
> 
> Sensor -> ISP Hardware pipeline -> videobuf
> 
> The procedure to set up ISP pipeline is proprietary and cannot
> be open sourced. Without proper pipeline configuration, streaming
> won't work. And That's why we require the daemon. 

Why not? In my opinion the pipeline configuration is quite basic
functionality present also in the OMAP3 ISP, for example. This should be
available through the Media controller interface.

In general, the driver should expose APIs best suited for configuring
the ISP hardware. Existing APIs should be used as much as possible.
There should be no untyped blob passing in its API.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
