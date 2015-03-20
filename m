Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcdn-iport-9.cisco.com ([173.37.86.80]:6033 "EHLO
	rcdn-iport-9.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbbCTQr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 12:47:58 -0400
From: "Prashant Laddha (prladdha)" <prladdha@cisco.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 2/2] vivid: add support to set CVT, GTF timings
Date: Fri, 20 Mar 2015 16:47:48 +0000
Message-ID: <D1324CAB.3DF7F%prladdha@cisco.com>
In-Reply-To: <550C4644.6060504@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6E94E8689194D64581C16C2452F79D0A@emea.cisco.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 20/03/15 9:39 pm, "Hans Verkuil" <hverkuil@xs4all.nl> wrote:

>Hi Prashant,
>
>> +
>> +	h_freq = (u32)bt->pixelclock / total_h_pixel;
>> +
>> +	if (bt->standards == V4L2_DV_BT_STD_CVT)
>
>This test and the next isn't right. Apologies that I didn't see that
>when I reviewed v1.
>
>The correct test is:
>
>	if (bt->standard == 0 || (bt->standards & V4L2_DV_BT_STD_CVT))
>
>
>> +		return v4l2_detect_cvt(total_v_lines, h_freq, bt->vsync,
>> +				       bt->polarities, timings);
>
>Just returning here isn't right either: if a CVT format is detected, then
>it can return true, otherwise it should continue and try the GTF format.
>
>> +
>> +	if (bt->standards == V4L2_DV_BT_STD_GTF) {
>
>And this becomes:
>
>	If (bt->standard == 0 || (bt->standards & V4L2_DV_BT_STD_GTF))
>
>When it comes to autodetecting formats the driver can often detect
>only a few timing properties, and it is rarely able to say if it
>will be a CVT or GTF timing. So often they leave bt->standard to 0.
>
Thanks Hans. I will fix it and post v3.

Regards,
Prashant
>

