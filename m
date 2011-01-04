Return-path: <mchehab@gaivota>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22021 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1ADCiq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 21:38:46 -0500
From: "Shuzhen Wang" <shuzhenw@codeaurora.org>
To: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>
Cc: "'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
	"'Hans Verkuil'" <hverkuil@xs4all.nl>,
	<linux-media@vger.kernel.org>, <hzhong@codeaurora.org>,
	"Yan, Yupeng" <yyan@quicinc.com>
References: <000601cba2d8$eaedcdc0$c0c96940$@org> <4D188285.8090603@redhat.com> <000001cba6bd$f2c94ea0$d85bebe0$@org> <201012282123.58775.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201012282123.58775.laurent.pinchart@ideasonboard.com>
Subject: RE: RFC: V4L2 driver for Qualcomm MSM camera.
Date: Mon, 3 Jan 2011 18:37:10 -0800
Message-ID: <000001cbabb8$49892d10$dc9b8730$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-language: en-us
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Tuesday, December 28, 2010 12:24 PM
> To: Shuzhen Wang
> Cc: 'Mauro Carvalho Chehab'; 'Hans Verkuil'; linux-
> media@vger.kernel.org; hzhong@codeaurora.org; Yan, Yupeng
> Subject: Re: RFC: V4L2 driver for Qualcomm MSM camera.
>
> I will strongly NAK any implementation that requires a daemon.
> 

We understand the motivation behind making the daemon optional.
However there are restrictions from legal perspective, which we
don't know how to get around.

A simplest video streaming data flow with MSM ISP is like this:

Sensor -> ISP Hardware pipeline -> videobuf

The procedure to set up ISP pipeline is proprietary and cannot
be open sourced. Without proper pipeline configuration, streaming
won't work. And That's why we require the daemon. 
 
Thank,
Shuzhen

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
--

