Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31573 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3FNTbV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 15:31:21 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOE00K23E5JII60@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 14 Jun 2013 20:31:18 +0100 (BST)
Message-id: <51BB6F85.1030708@samsung.com>
Date: Fri, 14 Jun 2013 21:31:17 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arun Kumar K <arunkk.samsung@gmail.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>, jtp.park@samsung.com,
	avnd.kiran@samsung.com
Subject: Re: [PATCH 5/6] [media] V4L: Add VP8 encoder controls
References: <1370870586-24141-1-git-send-email-arun.kk@samsung.com>
 <1370870586-24141-6-git-send-email-arun.kk@samsung.com>
 <51B5D876.2000704@samsung.com>
 <CALt3h7_BhORpmJUNZD1G-2eEZZ72YKus6wrfRiwRL4eLfViZHA@mail.gmail.com>
 <51BAE81B.4050008@samsung.com>
 <CALt3h78de0geS3+HdD3AE2OvTL3Zz10N5J7GUgHXjBUpz-tXow@mail.gmail.com>
In-reply-to: <CALt3h78de0geS3+HdD3AE2OvTL3Zz10N5J7GUgHXjBUpz-tXow@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 06/14/2013 03:21 PM, Arun Kumar K wrote:
> On Fri, Jun 14, 2013 at 3:23 PM, Sylwester Nawrocki
> <s.nawrocki@samsung.com> wrote:
>> On 06/14/2013 11:26 AM, Arun Kumar K wrote:
>>>>> +     static const char * const vpx_num_partitions[] = {
>>>>> +             "1 partition",
>>>>> +             "2 partitions",
>>>>> +             "4 partitions",
>>>>> +             "8 partitions",
>>>>> +             NULL,
>>>>> +     };
>>>>> +     static const char * const vpx_num_ref_frames[] = {
>>>>> +             "1 reference frame",
>>>>> +             "2 reference frame",
>>>>> +             NULL,
>>>>> +     };
>>>>
>>>> Have you considered using V4L2_CTRL_TYPE_INTEGER_MENU control type for this ?
>>>> One example is V4L2_CID_ISO_SENSITIVITY control.
>>>>
>>>
>>> If I understand correctly, V4L2_CTRL_TYPE_INTEGER_MENU is used for
>>> controls where
>>> the driver / IP can support different values depending on its capabilities.
>>
>> No, not really, it just happens there is no INTEGER_MENU control with standard
>> values yet. I think there are some (minor) changes needed in the v4l2-ctrls
>> code to support INTEGER_MENU control with standard menu items.
>>
>>> But here VP8 standard supports only 4 options for no. of partitions
>>> that is 1, 2, 4 and 8.
>>
>> I think such a standard menu list should be defined in v4l2-ctrls.c then.
> 
> One more concern here is these integer values 1, 2, 4 and 8 may not hold
> much significance while setting to the registers. Some IPs may need these
> values to be set as 0, 1, 2 and 3. So unlike other settings like ISO, the
> values that are given by the user may not be directly applicable to the
> register setting.

The INTEGER_MENU control is not much different than MENU control from
driver POV. s_ctrl() op is called with similarly with the an index to
the menu option. In addition to standard menu applications can query
real value corresponding to a menu option, rather than a character
string only.

With each new control a nw strings are added, that cumulate in the
videodev module and make it bigger. Actually __s64 is not much smaller
than "1 partition" in your case. But it's a bit smaller. :)

That said I'm not either a codec expert or the v4l2 controls maintainer.
I think last words belongs to Hans. I just express my suggestions of
what I though we be more optimal (but not necessarily less work!). :)

>>> Also for number of ref frames, the standard allows only the options 1,
>>> 2 and 3 which
>>> cannot be extended more. So is it correct to use INTEGER_MENU control here and
>>> let the driver define the values?
>>
>> If this is standard then the core should define available menu items. But
>> it seems more appropriate for me to use INTEGER_MENU. I'd like to hear other
>> opinions though.
> 
> Here even though 1,2 and 3 are standard, the interpretation is
> 1 - 1 reference frame (previous frame)
> 2 - previous frame + golden frame
> 3 - previous frame + golden frame + altref frame.

OK, then perhaps for this parameter a standard menu control would be better.
However, why there are only 2 options in vpx_num_ref_frames[] arrays ?
You probably want to change the menu strings to reflect this more precisely,
but there might be not enough room for any creative names anyway. Maybe
something like:

static const char * const vpx_num_ref_frames[] = {
	"Previous Frame",
	"Previous + Golden Frame",
	"Prev + Golden + Altref Frame",
	NULL,
};

Anyway raw numbers might be better for the control and details could be
described in the documentation.

> Again the driver may need to set different registers based on these and the
> integer values as such may not be used.

This is really not relevant, the driver can map index of the menu to any
value that is needed by the hardware.

Regards,
Sylwester

