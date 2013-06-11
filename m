Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f181.google.com ([209.85.220.181]:61957 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3FKJOv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 05:14:51 -0400
Received: by mail-vc0-f181.google.com with SMTP id lf11so4417704vcb.12
        for <linux-media@vger.kernel.org>; Tue, 11 Jun 2013 02:14:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51B5D876.2000704@samsung.com>
References: <1370870586-24141-1-git-send-email-arun.kk@samsung.com>
	<1370870586-24141-6-git-send-email-arun.kk@samsung.com>
	<51B5D876.2000704@samsung.com>
Date: Tue, 11 Jun 2013 14:44:50 +0530
Message-ID: <CALt3h7_Riq2i7nRsxb9aBWyOVkmW6TFr7aMiomrHNv+kJN7TOw@mail.gmail.com>
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

Thank you for the review.

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

Ok will change it to V4L2_CTRL_TYPE_INTEGER_MENU.

>
>> +/*  VPX streams, specific to multiplexed streams */
>> +#define V4L2_CID_VPX_NUM_PARTITIONS          (V4L2_CID_VPX_BASE+0)
>> +enum v4l2_vp8_num_partitions {
>> +     V4L2_VPX_1_PARTITION    = 0,
>> +     V4L2_VPX_2_PARTITIONS   = (1 << 1),
>> +     V4L2_VPX_4_PARTITIONS   = (1 << 2),
>> +     V4L2_VPX_8_PARTITIONS   = (1 << 3),
>> +};
>
> I think we could still have such standard value definitions if needed,
> but rather in form of:
>
> #define V4L2_VPX_1_PARTITION    1
> #define V4L2_VPX_2_PARTITIONS   2
> #define V4L2_VPX_4_PARTITIONS   4
> #define V4L2_VPX_8_PARTITIONS   8
>

Ok will change.

Regards
Arun
