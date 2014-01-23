Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:51751 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbaAWKVJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 05:21:09 -0500
Message-id: <52E0ED10.2020901@samsung.com>
Date: Thu, 23 Jan 2014 11:21:04 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: 'Amit Grover' <amit.grover@samsung.com>, m.chehab@samsung.com,
	linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, rob@landley.net,
	kyungmin.park@samsung.com, jtp.park@samsung.com
Cc: Kamil Debski <k.debski@samsung.com>, hans.verkuil@cisco.com,
	andrew.smirnov@gmail.com, arun.kk@samsung.com,
	anatol.pomozov@gmail.com, jmccrohan@gmail.com,
	austin.lobo@samsung.com, 'Swami Nathan' <swaminath.p@samsung.com>
Subject: Re: [PATCH] [media] s5p-mfc: Add Horizontal and Vertical search range
 for Video Macro Blocks
References: <1388400186-22045-1-git-send-email-amit.grover@samsung.com>
 <019f01cf1823$7e020fa0$7a062ee0$%debski@samsung.com>
In-reply-to: <019f01cf1823$7e020fa0$7a062ee0$%debski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 23/01/14 11:11, Kamil Debski wrote:
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> > b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> > index 4ff3b6c..a02e7b8 100644
>> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> > @@ -208,6 +208,24 @@ static struct mfc_control controls[] = {
>> >  		.default_value = 0,
>> >  	},
>> >  	{
>> > +		.id = V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE,
>> > +		.type = V4L2_CTRL_TYPE_INTEGER,
>> > +		.name = "horizontal search range of video macro block",
>
> This too should be property capitalised. Please mention the motion vectors
> too. 

And additionally length of the name string should not exceed 31 characters.

--
Thanks,
Sylwester
