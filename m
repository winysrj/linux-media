Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:41280 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650AbZKBQOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2009 11:14:39 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Date: Mon, 2 Nov 2009 10:14:35 -0600
Subject: RE: [PATCH 2/9] v4l: add new v4l2-subdev sensor operations, use
 g_skip_top_lines in soc-camera
Message-ID: <A69FA2915331DC488A831521EAE36FE40155798D72@dlee06.ent.ti.com>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
 <Pine.LNX.4.64.0910301403550.4378@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40155798784@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0910302126060.4378@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0910302126060.4378@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi,

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Guennadi Liakhovetski
>Sent: Friday, October 30, 2009 4:32 PM
>To: Karicheri, Muralidharan
>Cc: Linux Media Mailing List; Hans Verkuil; Laurent Pinchart; Sakari Ailus
>Subject: RE: [PATCH 2/9] v4l: add new v4l2-subdev sensor operations, use
>g_skip_top_lines in soc-camera
>
>On Fri, 30 Oct 2009, Karicheri, Muralidharan wrote:
>
>> Guennadi,
>>
>>
>> > 	mt9m111->rect.left	= MT9M111_MIN_DARK_COLS;
>> > 	mt9m111->rect.top	= MT9M111_MIN_DARK_ROWS;
>> >diff --git a/drivers/media/video/mt9t031.c
>b/drivers/media/video/mt9t031.c
>> >index 6966f64..57e04e9 100644
>> >--- a/drivers/media/video/mt9t031.c
>> >+++ b/drivers/media/video/mt9t031.c
>> >@@ -301,9 +301,9 @@ static int mt9t031_set_params(struct
>soc_camera_device
>> >*icd,
>> > 		ret = reg_write(client, MT9T031_WINDOW_WIDTH, rect->width - 1);
>> > 	if (ret >= 0)
>> > 		ret = reg_write(client, MT9T031_WINDOW_HEIGHT,
>> >-				rect->height + icd->y_skip_top - 1);
>> >+				rect->height - 1);
>
>> Why y_skip_top is removed?
>
>Because noone ever said they needed it?
>
I suggest you keep it. It can have default 0. I have not viewed the resulting image for the top line to see if it is corrupted. I just
use it to display it to my display device and I am not seeing any
corruption. I need to view the image at some point to check if it has
any corruption.
>> When I connect the sensor output to our SOC
>> input and do format conversion and resize on the fly (frame by frame
>> conversion before writing to SDRAM) I have found that the frame
>> completion interrupt fails to get generated with zero value for
>> y_skip_top. I have used a value
>> of 10 and it worked fine for me. So I would like to have a
>> s_skip_top_lines() in the sensor operations which can be called to
>> update this value from the host/bridge driver.
>
>Hm, strange, that's actually not the purpose of this parameter. Wouldn't
>it work for you just as well, if you just request 10 more lines when
>sending s_fmt from your bridge driver?
Ok. It might work by asking some additional lines from the bridge driver.
I will try this out.
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

