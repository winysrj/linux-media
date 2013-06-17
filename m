Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41857 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab3FQJE0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 05:04:26 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOJ00KKV57BVF90@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 17 Jun 2013 10:04:23 +0100 (BST)
Message-id: <51BED113.90908@samsung.com>
Date: Mon, 17 Jun 2013 11:04:19 +0200
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
 <51BB6F85.1030708@samsung.com>
 <CALt3h7-N=9+GHEzSdBG-wTu4yJoeiiCrNJMhwLWb4GjSMo=o-g@mail.gmail.com>
In-reply-to: <CALt3h7-N=9+GHEzSdBG-wTu4yJoeiiCrNJMhwLWb4GjSMo=o-g@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 06/17/2013 06:25 AM, Arun Kumar K wrote:
> On Sat, Jun 15, 2013 at 1:01 AM, Sylwester Nawrocki
> <s.nawrocki@samsung.com> wrote:
>> On 06/14/2013 03:21 PM, Arun Kumar K wrote:
>>> On Fri, Jun 14, 2013 at 3:23 PM, Sylwester Nawrocki
>>> <s.nawrocki@samsung.com> wrote:
>>>> On 06/14/2013 11:26 AM, Arun Kumar K wrote:
>>>>>>> +     static const char * const vpx_num_partitions[] = {
>>>>>>> +             "1 partition",
>>>>>>> +             "2 partitions",
>>>>>>> +             "4 partitions",
>>>>>>> +             "8 partitions",
>>>>>>> +             NULL,
>>>>>>> +     };
>>>>>>> +     static const char * const vpx_num_ref_frames[] = {
>>>>>>> +             "1 reference frame",
>>>>>>> +             "2 reference frame",
>>>>>>> +             NULL,
>>>>>>> +     };
>>>>>>
>>>>>> Have you considered using V4L2_CTRL_TYPE_INTEGER_MENU control type for this ?
>>>>>> One example is V4L2_CID_ISO_SENSITIVITY control.
>>>>>>
>>>>>
>>>>> If I understand correctly, V4L2_CTRL_TYPE_INTEGER_MENU is used for
>>>>> controls where
>>>>> the driver / IP can support different values depending on its capabilities.
>>>>
>>>> No, not really, it just happens there is no INTEGER_MENU control with standard
>>>> values yet. I think there are some (minor) changes needed in the v4l2-ctrls
>>>> code to support INTEGER_MENU control with standard menu items.
>>>>
>>>>> But here VP8 standard supports only 4 options for no. of partitions
>>>>> that is 1, 2, 4 and 8.
>>>>
>>>> I think such a standard menu list should be defined in v4l2-ctrls.c then.
>>>
>>> One more concern here is these integer values 1, 2, 4 and 8 may not hold
>>> much significance while setting to the registers. Some IPs may need these
>>> values to be set as 0, 1, 2 and 3. So unlike other settings like ISO, the
>>> values that are given by the user may not be directly applicable to the
>>> register setting.
>>
>> The INTEGER_MENU control is not much different than MENU control from
>> driver POV. s_ctrl() op is called with similarly with the an index to
>> the menu option. In addition to standard menu applications can query
>> real value corresponding to a menu option, rather than a character
>> string only.
>>
>> With each new control a nw strings are added, that cumulate in the
>> videodev module and make it bigger. Actually __s64 is not much smaller
>> than "1 partition" in your case. But it's a bit smaller. :)
> 
> Yes that makes sense. But there will be a few extra functions that
> would be needed in the v4l2-ctrls.c like may be
> v4l2_ctrl_new_int_menu_fixed() which doesnt take qmenu arg from driver.
> Will try to make this change.

I wouldn't be adding another helper like this, IMHO v4l2_ctrl_new_menu()
could well handle such entirely standard control type. I looked into that
over the weekend, let me send you my work-in-progress patch. Maybe you find
it useful.

>> That said I'm not either a codec expert or the v4l2 controls maintainer.
>> I think last words belongs to Hans. I just express my suggestions of
>> what I though we be more optimal (but not necessarily less work!). :)
>>
>>>>> Also for number of ref frames, the standard allows only the options 1,
>>>>> 2 and 3 which
>>>>> cannot be extended more. So is it correct to use INTEGER_MENU control here and
>>>>> let the driver define the values?
>>>>
>>>> If this is standard then the core should define available menu items. But
>>>> it seems more appropriate for me to use INTEGER_MENU. I'd like to hear other
>>>> opinions though.
>>>
>>> Here even though 1,2 and 3 are standard, the interpretation is
>>> 1 - 1 reference frame (previous frame)
>>> 2 - previous frame + golden frame
>>> 3 - previous frame + golden frame + altref frame.
>>
>> OK, then perhaps for this parameter a standard menu control would be better.
>> However, why there are only 2 options in vpx_num_ref_frames[] arrays ?
> 
> Thats because MFCv7 doesnt support the 3rd option yet. But still I would
> add this in the control to make it generic.

I see. Yes, I think it makes more sense to specify the control fully,
according to the standard.

>> You probably want to change the menu strings to reflect this more precisely,
>> but there might be not enough room for any creative names anyway. Maybe
>> something like:
>>
>> static const char * const vpx_num_ref_frames[] = {
>>         "Previous Frame",
>>         "Previous + Golden Frame",
>>         "Prev + Golden + Altref Frame",
>>         NULL,
>> };
>>
>> Anyway raw numbers might be better for the control and details could be
>> described in the documentation.
> 
> Ok will do like this.

Just one more note, I think I might have confused you with my comment
on the enum v4l2_vp8_num_partitions. Presumably we just need to define
contiguous enumeration for all options of V4L2_CID_VPX_NUM_PARTITIONS
control. And the actual values would be defined only on the integer
menu values array, e.g.

copnst s64 qmenu_int_vpx_num_partitions[] [
	1, 2, 4, 8
};

and

#define V4L2_CID_VPX_NUM_PARTITIONS	(V4L2_CID_MPEG_BASE + ?)
enum v4l2_vp8_num_partitions {
	V4L2_VPX_1_PARTITION	= 0,
	V4L2_VPX_2_PARTITIONS	= 1,
	V4L2_VPX_4_PARTITIONS	= 2,
	V4L2_VPX_8_PARTITIONS	= 3,
};

or

#define V4L2_CID_VPX_NUM_PARTITIONS	(V4L2_CID_MPEG_BASE + ?)
#define V4L2_VPX_1_PARTITION	0
#define V4L2_VPX_2_PARTITIONS	1
#define V4L2_VPX_4_PARTITIONS	2
#define V4L2_VPX_8_PARTITIONS	3

Each driver could then map enum v4l2_vp8_num_partitions onto its
required H/W register values, without having to translate from
the MFC specific values. :)

Regards,
Sylwester


