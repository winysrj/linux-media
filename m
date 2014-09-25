Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:46508 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaIYMtr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 08:49:47 -0400
Received: by mail-la0-f53.google.com with SMTP id ge10so12231239lab.26
        for <linux-media@vger.kernel.org>; Thu, 25 Sep 2014 05:49:45 -0700 (PDT)
Message-ID: <54240F67.90708@cogentembedded.com>
Date: Thu, 25 Sep 2014 16:49:43 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	'Mikhail Ulyanov' <mikhail.ulyanov@cogentembedded.com>,
	horms@verge.net.au, magnus.damm@gmail.com, m.chehab@samsung.com,
	robh+dt@kernel.org, grant.likely@linaro.org
CC: laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	linux-sh@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/6] V4L2: Add Renesas R-Car JPEG codec driver.
References: <1408452653-14067-2-git-send-email-mikhail.ulyanov@cogentembedded.com> <1408969787-23132-1-git-send-email-mikhail.ulyanov@cogentembedded.com> <085201cfd732$a2849bd0$e78dd370$%debski@samsung.com>
In-Reply-To: <085201cfd732$a2849bd0$e78dd370$%debski@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 9/23/2014 5:31 PM, Kamil Debski wrote:

>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Mikhail Ulyanov
>> Sent: Monday, August 25, 2014 2:30 PM

>> This patch contains driver for Renesas R-Car JPEG codec.

>> Cnanges since v1:
>>      - s/g_fmt function simplified
>>      - default format for queues added
>>      - dumb vidioc functions added to be in compliance with standard
>> api:
>>          jpu_s_priority, jpu_g_priority
>>      - standard v4l2_ctrl_subscribe_event and v4l2_event_unsubscribe
>>        now in use by the same reason

> The patch looks good to me. However, I would suggest using the BIT macro

    I'd prefer not using it since the driver #define's not only bits but also bit
values and multi-bit fields. Using BIT() would look inconsistent in this 
situation.

> and making some short functions inline.

    I think the current trend is to use *inline* only in the headers, and let 
gcc figure it out itself in the .c files.

>> Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>

[...]
>> diff --git a/drivers/media/platform/jpu.c
>> b/drivers/media/platform/jpu.c new file mode 100644 index
>> 0000000..da70491
>> --- /dev/null
>> +++ b/drivers/media/platform/jpu.c
>> @@ -0,0 +1,1628 @@
[...]

> Best wishes,

WBR, Sergei

