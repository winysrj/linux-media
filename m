Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:42246 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab1B1FPi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 00:15:38 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epmmp2 (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LHB008G8ALOY220@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 28 Feb 2011 14:15:24 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LHB004DUALONE@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 28 Feb 2011 14:15:24 +0900 (KST)
Date: Mon, 28 Feb 2011 14:15:23 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: [RFC PATCH RESEND v2 2/3] v4l2-ctrls: modify uvc driver to use new
 menu type of V4L2_CID_FOCUS_AUTO
In-reply-to: <201102251358.29116.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D6B2F6B.2080605@samsung.com>
Content-transfer-encoding: 8BIT
References: <4D67A489.2050808@samsung.com>
 <201102251358.29116.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

2011-02-25 오후 9:58, Laurent Pinchart 쓴 글:
> Hi,
> 
> On Friday 25 February 2011 13:46:01 Kim, HeungJun wrote:
>> As following to change the boolean type of V4L2_CID_FOCUS_AUTO to menu
>> type, this uvc is modified the usage of V4L2_CID_FOCUS_AUTO.
>>
>> Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/media/video/uvc/uvc_ctrl.c |    9 ++++++++-
>>  1 files changed, 8 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
>> b/drivers/media/video/uvc/uvc_ctrl.c index 59f8a9a..b98b9f1 100644
>> --- a/drivers/media/video/uvc/uvc_ctrl.c
>> +++ b/drivers/media/video/uvc/uvc_ctrl.c
>> @@ -333,6 +333,11 @@ static struct uvc_menu_info exposure_auto_controls[] =
>> { { 8, "Aperture Priority Mode" },
>>  };
>>
>> +static struct uvc_menu_info focus_auto_controls[] = {
>> +	{ 1, "Auto Mode" },
>> +	{ 0, "Manual Mode" },
> 
> Now that manual focus has value 0 and auto focus value 1, the menu entries 
> need to be the other way around.
I don't really get it. My understanding is that your words are structure
uvc_menu_info should be changed as fitted to focus menu type. right?
But, I thinks they don't need to be changed, and I don't find wrong,
I don't know how to fix what you telling me exactly.

So, could you explain more details? Some examples helps to me.

Sorry to bother if you are busy, but it's good for me your advice.
I'll waiting.

Thanks and Regards,
Heungjun Kim

