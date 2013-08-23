Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35761 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab3HWNLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 09:11:52 -0400
Message-id: <52175F95.2040108@samsung.com>
Date: Fri, 23 Aug 2013 15:11:49 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] s5k6aa: off by one in s5k6aa_enum_frame_interval()
References: <20130823093306.GH31293@elgon.mountain> <4319865.UMEVfJshWy@avalon>
In-reply-to: <4319865.UMEVfJshWy@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 08/23/2013 02:54 PM, Laurent Pinchart wrote:
> Hi Dan,
> 
> Thank you for the patch.
> 
> On Friday 23 August 2013 12:33:06 Dan Carpenter wrote:
>> The check is off by one so we could read one space past the end of the
>> array.
>>
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Mauro, I have no other pending sensor patches, can you pick this one up from 
> the list, or should I send you a pull request ?

I can handle all pending patches for the Samsung sensors, I was planning
to send a pull request today. I can pick up the ov9650 patch as well.
I'd like to also include the s5k5bafx sensor patch in one of my pull
requests.

IIRC it was agreed that we as Samsung will handle our stuff ourselves
and be sending it to Mauro directly.

--
Thanks,
Sylwester
