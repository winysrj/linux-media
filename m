Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60171 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab1ITVZl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 17:25:41 -0400
Received: by mail-fx0-f46.google.com with SMTP id 4so907736fxe.19
        for <linux-media@vger.kernel.org>; Tue, 20 Sep 2011 14:25:41 -0700 (PDT)
Message-ID: <4E7904CB.3000006@gmail.com>
Date: Tue, 20 Sep 2011 23:25:31 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Subject: Re: [PATCH v1 2/3] v4l: Add AUTO option for the V4L2_CID_POWER_LINE_FREQUENCY
 control
References: <1316519939-22540-1-git-send-email-s.nawrocki@samsung.com> <1316519939-22540-3-git-send-email-s.nawrocki@samsung.com> <20110920205730.GN1845@valkosipuli.localdomain>
In-Reply-To: <20110920205730.GN1845@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 09/20/2011 10:57 PM, Sakari Ailus wrote:
> Hi Sylwester,
> 
> On Tue, Sep 20, 2011 at 01:58:58PM +0200, Sylwester Nawrocki wrote:
>> V4L2_CID_POWER_LINE_FREQUENCY control allows applications to instruct
>> a driver what is the power line frequency so an appropriate filter
>> can be used by the device to cancel flicker by compensating the light
>> intensity ripple and thus. Currently in the menu we have entries for
>> 50 and 60 Hz and for entirely disabling the anti-flicker filter.
>> However some devices are capable of automatically detecting the
>> frequency, so add V4L2_CID_POWER_LINE_FREQUENCY_AUTO entry for them.
>>
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> Acked-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
>> ---
>>   Documentation/DocBook/media/v4l/controls.xml |    5 +++--
>>   drivers/media/video/v4l2-ctrls.c             |    1 +
>>   include/linux/videodev2.h                    |    1 +
>>   3 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
>> index 2420e4a..c6b3c46 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -232,8 +232,9 @@ control is deprecated. New drivers and applications should use the
>>   	<entry>Enables a power line frequency filter to avoid
>>   flicker. Possible values for<constant>enum v4l2_power_line_frequency</constant>  are:
>>   <constant>V4L2_CID_POWER_LINE_FREQUENCY_DISABLED</constant>  (0),
>> -<constant>V4L2_CID_POWER_LINE_FREQUENCY_50HZ</constant>  (1) and
>> -<constant>V4L2_CID_POWER_LINE_FREQUENCY_60HZ</constant>  (2).</entry>
>> +<constant>V4L2_CID_POWER_LINE_FREQUENCY_50HZ</constant>  (1),
>> +<constant>V4L2_CID_POWER_LINE_FREQUENCY_60HZ</constant>  (2) and
>> +<constant>V4L2_CID_POWER_LINE_FREQUENCY_AUTO</constant>  (3).</entry>
> 
> A stupid question: wouldn't this be a case for a new control for automatic
> power line frequency, in other words enabling or disabling it?

IMO this would complicate things in kernel and user land, without any reasonable
positive effects. AUTO seems to fit well here, it's just another mode of operation
of a power line noise filter. Why make things more complicated than they need to be ? 

> 
>>   	</row>
>>   	<row>
>>   	<entry><constant>V4L2_CID_HUE_AUTO</constant></entry>
>> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
>> index 06b6014..20abe5d 100644
>> --- a/drivers/media/video/v4l2-ctrls.c
>> +++ b/drivers/media/video/v4l2-ctrls.c
>> @@ -210,6 +210,7 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>>   		"Disabled",
>>   		"50 Hz",
>>   		"60 Hz",
>> +		"Auto",
>>   		NULL
>>   	};
>>   	static const char * const camera_exposure_auto[] = {
>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>> index c33f462..87210f1 100644
>> --- a/include/linux/videodev2.h
>> +++ b/include/linux/videodev2.h
>> @@ -1125,6 +1125,7 @@ enum v4l2_power_line_frequency {
>>   	V4L2_CID_POWER_LINE_FREQUENCY_DISABLED	= 0,
>>   	V4L2_CID_POWER_LINE_FREQUENCY_50HZ	= 1,
>>   	V4L2_CID_POWER_LINE_FREQUENCY_60HZ	= 2,
>> +	V4L2_CID_POWER_LINE_FREQUENCY_AUTO	= 3,
>>   };
>>   #define V4L2_CID_HUE_AUTO			(V4L2_CID_BASE+25)
>>   #define V4L2_CID_WHITE_BALANCE_TEMPERATURE	(V4L2_CID_BASE+26)
>> -- 
>> 1.7.6.3
>>
> 

--
Thanks,
Sylwester
