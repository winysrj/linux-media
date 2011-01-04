Return-path: <mchehab@gaivota>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45731 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab1ADGOM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jan 2011 01:14:12 -0500
Message-ID: <4D22BAA8.9050607@codeaurora.org>
Date: Mon, 03 Jan 2011 22:14:00 -0800
From: Haibo Zhong <hzhong@codeaurora.org>
MIME-Version: 1.0
To: Shuzhen Wang <shuzhenw@codeaurora.org>
CC: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	linux-media@vger.kernel.org, "Yan, Yupeng" <yyan@quicinc.com>
Subject: Re: RFC: V4L2 driver for Qualcomm MSM camera.
References: <000601cba2d8$eaedcdc0$c0c96940$@org> <4D188285.8090603@redhat.com> <000001cba6bd$f2c94ea0$d85bebe0$@org> <201012282123.58775.laurent.pinchart@ideasonboard.com> <000001cbabb8$49892d10$dc9b8730$@org>
In-Reply-To: <000001cbabb8$49892d10$dc9b8730$@org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 1/3/2011 6:37 PM, Shuzhen Wang wrote:
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
> Sensor ->  ISP Hardware pipeline ->  videobuf
>
> The procedure to set up ISP pipeline is proprietary and cannot
> be open sourced. Without proper pipeline configuration, streaming
> won't work. And That's why we require the daemon.

Laurent/Hans/Mauro,

We are working on and will provide more design information on Qualcomm 
MSM ISP design and explain the legal concern of the daemon implementation.

The underlined idea is to comply to V4L2 architecture with MSM solution. 
In the meantime, Laurent, can you share with your major concern about 
the Daemon?

Thanks,
Jeff

>
> Thank,
> Shuzhen
>
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> --
>

