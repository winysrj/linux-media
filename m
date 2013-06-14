Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f173.google.com ([209.85.128.173]:34288 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3FNNVQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 09:21:16 -0400
Received: by mail-ve0-f173.google.com with SMTP id jw11so463604veb.32
        for <linux-media@vger.kernel.org>; Fri, 14 Jun 2013 06:21:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51BAE81B.4050008@samsung.com>
References: <1370870586-24141-1-git-send-email-arun.kk@samsung.com>
	<1370870586-24141-6-git-send-email-arun.kk@samsung.com>
	<51B5D876.2000704@samsung.com>
	<CALt3h7_BhORpmJUNZD1G-2eEZZ72YKus6wrfRiwRL4eLfViZHA@mail.gmail.com>
	<51BAE81B.4050008@samsung.com>
Date: Fri, 14 Jun 2013 18:51:15 +0530
Message-ID: <CALt3h78de0geS3+HdD3AE2OvTL3Zz10N5J7GUgHXjBUpz-tXow@mail.gmail.com>
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

On Fri, Jun 14, 2013 at 3:23 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> Hi Arun,
>
> On 06/14/2013 11:26 AM, Arun Kumar K wrote:
>> Hi Sylwester,
>>
>>>> +     static const char * const vpx_num_partitions[] = {
>>>> +             "1 partition",
>>>> +             "2 partitions",
>>>> +             "4 partitions",
>>>> +             "8 partitions",
>>>> +             NULL,
>>>> +     };
>>>> +     static const char * const vpx_num_ref_frames[] = {
>>>> +             "1 reference frame",
>>>> +             "2 reference frame",
>>>> +             NULL,
>>>> +     };
>>>
>>> Have you considered using V4L2_CTRL_TYPE_INTEGER_MENU control type for this ?
>>> One example is V4L2_CID_ISO_SENSITIVITY control.
>>>
>>
>> If I understand correctly, V4L2_CTRL_TYPE_INTEGER_MENU is used for
>> controls where
>> the driver / IP can support different values depending on its capabilities.
>
> No, not really, it just happens there is no INTEGER_MENU control with standard
> values yet. I think there are some (minor) changes needed in the v4l2-ctrls
> code to support INTEGER_MENU control with standard menu items.
>
>> But here VP8 standard supports only 4 options for no. of partitions
>> that is 1, 2, 4 and 8.
>
> I think such a standard menu list should be defined in v4l2-ctrls.c then.

One more concern here is these integer values 1, 2, 4 and 8 may not hold
much significance while setting to the registers. Some IPs may need these
values to be set as 0, 1, 2 and 3. So unlike other settings like ISO, the
values that are given by the user may not be directly applicable to the
register setting.

>
>> Also for number of ref frames, the standard allows only the options 1,
>> 2 and 3 which
>> cannot be extended more. So is it correct to use INTEGER_MENU control here and
>> let the driver define the values?
>
> If this is standard then the core should define available menu items. But
> it seems more appropriate for me to use INTEGER_MENU. I'd like to hear other
> opinions though.


Here even though 1,2 and 3 are standard, the interpretation is
1 - 1 reference frame (previous frame)
2 - previous frame + golden frame
3 - previous frame + golden frame + altref frame.

Again the driver may need to set different registers based on these and the
integer values as such may not be used.


Regards
Arun
