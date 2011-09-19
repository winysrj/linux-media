Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53858 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab1ISGIN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 02:08:13 -0400
Received: by pzk1 with SMTP id 1so10115445pzk.1
        for <linux-media@vger.kernel.org>; Sun, 18 Sep 2011 23:08:13 -0700 (PDT)
Message-ID: <4E76DC47.7050106@gmail.com>
Date: Mon, 19 Sep 2011 11:38:07 +0530
From: Subash Patel <subashrp@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Subject: Re: [PATCH 1/3] v4l: Extend V4L2_CID_COLORFX control with AQUA effect
References: <1316192730-18099-1-git-send-email-s.nawrocki@samsung.com> <1316192730-18099-2-git-send-email-s.nawrocki@samsung.com> <201109190108.49283.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201109190108.49283.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

I am not representing Sylwester :), But with a similar sensor I use, 
Aqua means cool tone which is Cb/Cr manipulations.

Regards,
Subash

On 09/19/2011 04:38 AM, Laurent Pinchart wrote:
> Hi Sylwester,
>
> Thanks for the patch.
>
> On Friday 16 September 2011 19:05:28 Sylwester Nawrocki wrote:
>> Add V4L2_COLORFX_AQUA image effect in the V4L2_CID_COLORFX menu.
>
> What's the aqua effect ?
>
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> ---
>>   Documentation/DocBook/media/v4l/controls.xml |    5 +++--
>>   include/linux/videodev2.h                    |    1 +
>>   2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml
>> b/Documentation/DocBook/media/v4l/controls.xml index 8516401..f3c6457
>> 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -294,8 +294,9 @@ minimum value disables backlight compensation.</entry>
>>   <constant>V4L2_COLORFX_SKETCH</constant>  (5),
>>   <constant>V4L2_COLORFX_SKY_BLUE</constant>  (6),
>>   <constant>V4L2_COLORFX_GRASS_GREEN</constant>  (7),
>> -<constant>V4L2_COLORFX_SKIN_WHITEN</constant>  (8) and
>> -<constant>V4L2_COLORFX_VIVID</constant>  (9).</entry>
>> +<constant>V4L2_COLORFX_SKIN_WHITEN</constant>  (8),
>> +<constant>V4L2_COLORFX_VIVID</constant>  (9) and
>> +<constant>V4L2_COLORFX_AQUA</constant>  (10).</entry>
>>   	</row>
>>   	<row>
>>   	<entry><constant>V4L2_CID_ROTATE</constant></entry>
>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>> index fca24cc..5032226 100644
>> --- a/include/linux/videodev2.h
>> +++ b/include/linux/videodev2.h
>> @@ -1144,6 +1144,7 @@ enum v4l2_colorfx {
>>   	V4L2_COLORFX_GRASS_GREEN = 7,
>>   	V4L2_COLORFX_SKIN_WHITEN = 8,
>>   	V4L2_COLORFX_VIVID = 9,
>> +	V4L2_COLORFX_AQUA = 10,
>>   };
>>   #define V4L2_CID_AUTOBRIGHTNESS			(V4L2_CID_BASE+32)
>>   #define V4L2_CID_BAND_STOP_FILTER		(V4L2_CID_BASE+33)
>
