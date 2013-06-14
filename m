Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:38129 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab3FNJ0F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 05:26:05 -0400
Received: by mail-ve0-f171.google.com with SMTP id b10so276961vea.2
        for <linux-media@vger.kernel.org>; Fri, 14 Jun 2013 02:26:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51B5D876.2000704@samsung.com>
References: <1370870586-24141-1-git-send-email-arun.kk@samsung.com>
	<1370870586-24141-6-git-send-email-arun.kk@samsung.com>
	<51B5D876.2000704@samsung.com>
Date: Fri, 14 Jun 2013 14:56:04 +0530
Message-ID: <CALt3h7_BhORpmJUNZD1G-2eEZZ72YKus6wrfRiwRL4eLfViZHA@mail.gmail.com>
Subject: Re: [PATCH 5/6] [media] V4L: Add VP8 encoder controls
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>, jtp.park@samsung.com,
	avnd.kiran@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

>> +     static const char * const vpx_num_partitions[] = {
>> +             "1 partition",
>> +             "2 partitions",
>> +             "4 partitions",
>> +             "8 partitions",
>> +             NULL,
>> +     };
>> +     static const char * const vpx_num_ref_frames[] = {
>> +             "1 reference frame",
>> +             "2 reference frame",
>> +             NULL,
>> +     };
>
> Have you considered using V4L2_CTRL_TYPE_INTEGER_MENU control type for this ?
> One example is V4L2_CID_ISO_SENSITIVITY control.
>

If I understand correctly, V4L2_CTRL_TYPE_INTEGER_MENU is used for
controls where
the driver / IP can support different values depending on its capabilities.
But here VP8 standard supports only 4 options for no. of partitions
that is 1, 2, 4 and 8.
Also for number of ref frames, the standard allows only the options 1,
2 and 3 which
cannot be extended more. So is it correct to use INTEGER_MENU control here and
let the driver define the values?

Regards
Arun
