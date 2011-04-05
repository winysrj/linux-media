Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:32157 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1DEFgi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 01:36:38 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epmmp2 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LJ500L1QZL0S900@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Apr 2011 14:36:36 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LJ500KRLZL035@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Apr 2011 14:36:36 +0900 (KST)
Date: Tue, 05 Apr 2011 14:36:32 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: [PATCH] Add support for M-5MOLS 8 Mega Pixel camera
In-reply-to: <007901cbf2c2$bb240bb0$316c2310$%kang@samsung.com>
To: sungchun.kang@samsung.com
Cc: linux-media@vger.kernel.org,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D9AAA60.4070004@samsung.com>
Content-transfer-encoding: 8BIT
References: <1300282723-31536-1-git-send-email-riverful.kim@samsung.com>
 <007901cbf2c2$bb240bb0$316c2310$%kang@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sungchun,

The below comments and issues looks the firmware issues.
I add another comments, so you can check this out.

The first plan of this driver I have, is to merge the basic driver code
of M-5MOLS. Because, the M-5MOLS has many variation of versions. It makes
to send the driver to ML or be merged, also respond when the problem issued.

The version considered with version, probably will be the next version.


2011-04-04 오후 9:20, Sungchun Kang 쓴 글:
> Hi heungjun,
> I have tested this version for a few days.
> 
> On 03/16/2011 10:30 PM, Kim, Heungjun wrote:
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Kim, Heungjun
>> Sent: Wednesday, March 16, 2011 10:39 PM
>> To: linux-media@vger.kernel.org
>> Cc: hverkuil@xs4all.nl; laurent.pinchart@ideasonboard.com; Kim,
>> Heungjun; Sylwester Nawrocki; Kyungmin Park
>> Subject: [PATCH] Add support for M-5MOLS 8 Mega Pixel camera
>>
>> Add I2C/V4L2 subdev driver for M-5MOLS camera sensor with integrated
>> image signal processor.
>>
>> Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>
>> Hi Hans and everyone,
>>
>> This is sixth version of M-5MOLS 8 Mega Pixel camera sensor. And, if
>> you see
>> previous version, you can find at:
>> http://www.spinics.net/lists/linux-media/msg29350.html
>>
>> This driver patch is fixed several times, and the important issues is
>> almost
>> corrected. And, I hope that this is the last version one merged for
>> 2.6.39.
>> I look forward to be reviewed one more time.
>>
>> The summary of this version's feature is belows:
>>
>> 1. Add focus control
>> 	: I've suggest menu type focus control, but I agreed this
>> version is
>> 	not yet the level accepted. So, I did not use focus control
>> which
>> 	I suggest.
>> 	The M-5MOLS focus routine takes some time to execute. But, the
>> user
>> 	application calling v4l2 control, should not hanged while
>> streaming
>> 	using q/dqbuf. So, I use workqueue. I want to discuss the focus
>> 	subject on mailnglist next time.
>>
> 
> I wonder this feature is dependent on this firmware version?
> 
> .....snip
The value can be changable by the firmware, but the usage of focus is not.
The specific mode can be added too. But, it also maintains same usage.

It's scheduled at the next time to consider the version. But, it's hard to
consider all cases.

> 
>> +static int m5mols_start_monitor(struct v4l2_subdev *sd)
>> +{
>> +	struct m5mols_info *info = to_m5mols(sd);
>> +	int ret;
>> +
>> +	ret = m5mols_set_mode(sd, MODE_PARAM);
>> +	if (!ret)
>> +		ret = i2c_w8_param(sd, CAT1_MONITOR_SIZE, info-
>>> res_preset);
>> +	if (!ret)
>> +		ret = i2c_w8_param(sd, CAT1_MONITOR_FPS, info->fps_preset);
>> +	if (!ret)
>> +		ret = m5mols_set_mode(sd, MODE_MONITOR);
>> +	if (!ret && info->do_once) {
>> +		/* After probing the driver, this should be callde once.
>> */
>> +		v4l2_ctrl_handler_setup(&info->handle);
> As test result, When sensor is set monitor mode, if this API is called, 
> Preview data(get from sensor) is craked. Surely, it is good working if this API is called in paramset mode.
> That waw no problem in Version 5. Because it is returned before v4l2_ctrl_handler_init()
> In m5mols_init_controls(version 5) :
> 	ret = i2c_r16_ae(sd, CAT3_MAX_GAIN_MON, (u32 *)&max_ex_mon);
> 	if (ret) 
> 		return ret; // if success, return.
> 
> My test case is :
> S_power->s_fmt->s_stream.
It's a little tricky to control parameter & monitor mode in the M-5MOLS sensor.
Any commands or control is specified that it's available in Docunemt, but
it's just literaly "available", doesn't mean "working well". Especially,
the version difference between firmware is the biggest source of this problems.

Probably, the sensor you have is a different firmware I think.
So If there is any other problem, I recommend to use previous version plz.

If you show me the all version strings, I might help you.

> 
> .....
> BRs Sungchun.
> 
> 

Thanks for comments, and any other issues or opinions, let me know.

Regards,
Heungjun Kim
