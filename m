Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f52.google.com ([209.85.212.52]:43276 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3FZNBl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 09:01:41 -0400
Received: by mail-vb0-f52.google.com with SMTP id f12so10518388vbg.25
        for <linux-media@vger.kernel.org>; Wed, 26 Jun 2013 06:01:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <009b01ce71ac$cc4a5460$64defd20$%debski@samsung.com>
References: <1372157835-27663-1-git-send-email-arun.kk@samsung.com>
	<1372157835-27663-8-git-send-email-arun.kk@samsung.com>
	<009b01ce71ac$cc4a5460$64defd20$%debski@samsung.com>
Date: Wed, 26 Jun 2013 18:31:41 +0530
Message-ID: <CALt3h7-Vkar9AQi9mVZ3t5Qn3qqPWeoLCSSE3jWvK0XUzXqwnA@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] [media] V4L: Add VP8 encoder controls
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>, jtp.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, avnd.kiran@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -424,6 +424,12 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>>               NULL,
>>       };
>>
>> +     static const char * const vpx_golden_frame_sel[] = {
>> +             "Use Previous Frame",
>> +             "Use Previous Specific Frame",
>
> "Use Previous Specific Frame" seems unclear.
> Maybe "Use Previous Golden Frame" or "Use Periodic Golden Frame"?
> I'm not sure if I get the description right.
>

"Use Periodic Golden Frame" seems more reasonable. WIll change it.

Regards
Arun
