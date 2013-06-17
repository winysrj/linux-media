Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f50.google.com ([209.85.212.50]:64404 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3FQEZN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 00:25:13 -0400
Received: by mail-vb0-f50.google.com with SMTP id w16so1627500vbb.37
        for <linux-media@vger.kernel.org>; Sun, 16 Jun 2013 21:25:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51BB6F85.1030708@samsung.com>
References: <1370870586-24141-1-git-send-email-arun.kk@samsung.com>
	<1370870586-24141-6-git-send-email-arun.kk@samsung.com>
	<51B5D876.2000704@samsung.com>
	<CALt3h7_BhORpmJUNZD1G-2eEZZ72YKus6wrfRiwRL4eLfViZHA@mail.gmail.com>
	<51BAE81B.4050008@samsung.com>
	<CALt3h78de0geS3+HdD3AE2OvTL3Zz10N5J7GUgHXjBUpz-tXow@mail.gmail.com>
	<51BB6F85.1030708@samsung.com>
Date: Mon, 17 Jun 2013 09:55:12 +0530
Message-ID: <CALt3h7-N=9+GHEzSdBG-wTu4yJoeiiCrNJMhwLWb4GjSMo=o-g@mail.gmail.com>
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

On Sat, Jun 15, 2013 at 1:01 AM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> Hi Arun,
>
> On 06/14/2013 03:21 PM, Arun Kumar K wrote:
>> On Fri, Jun 14, 2013 at 3:23 PM, Sylwester Nawrocki
>> <s.nawrocki@samsung.com> wrote:
>>> On 06/14/2013 11:26 AM, Arun Kumar K wrote:
>>>>>> +     static const char * const vpx_num_partitions[] = {
>>>>>> +             "1 partition",
>>>>>> +             "2 partitions",
>>>>>> +             "4 partitions",
>>>>>> +             "8 partitions",
>>>>>> +             NULL,
>>>>>> +     };
>>>>>> +     static const char * const vpx_num_ref_frames[] = {
>>>>>> +             "1 reference frame",
>>>>>> +             "2 reference frame",
>>>>>> +             NULL,
>>>>>> +     };
>>>>>
>>>>> Have you considered using V4L2_CTRL_TYPE_INTEGER_MENU control type for this ?
>>>>> One example is V4L2_CID_ISO_SENSITIVITY control.
>>>>>
>>>>
>>>> If I understand correctly, V4L2_CTRL_TYPE_INTEGER_MENU is used for
>>>> controls where
>>>> the driver / IP can support different values depending on its capabilities.
>>>
>>> No, not really, it just happens there is no INTEGER_MENU control with standard
>>> values yet. I think there are some (minor) changes needed in the v4l2-ctrls
>>> code to support INTEGER_MENU control with standard menu items.
>>>
>>>> But here VP8 standard supports only 4 options for no. of partitions
>>>> that is 1, 2, 4 and 8.
>>>
>>> I think such a standard menu list should be defined in v4l2-ctrls.c then.
>>
>> One more concern here is these integer values 1, 2, 4 and 8 may not hold
>> much significance while setting to the registers. Some IPs may need these
>> values to be set as 0, 1, 2 and 3. So unlike other settings like ISO, the
>> values that are given by the user may not be directly applicable to the
>> register setting.
>
> The INTEGER_MENU control is not much different than MENU control from
> driver POV. s_ctrl() op is called with similarly with the an index to
> the menu option. In addition to standard menu applications can query
> real value corresponding to a menu option, rather than a character
> string only.
>
> With each new control a nw strings are added, that cumulate in the
> videodev module and make it bigger. Actually __s64 is not much smaller
> than "1 partition" in your case. But it's a bit smaller. :)
>

Yes that makes sense. But there will be a few extra functions that
would be needed in the v4l2-ctrls.c like may be
v4l2_ctrl_new_int_menu_fixed() which doesnt take qmenu arg from driver.
Will try to make this change.

> That said I'm not either a codec expert or the v4l2 controls maintainer.
> I think last words belongs to Hans. I just express my suggestions of
> what I though we be more optimal (but not necessarily less work!). :)
>
>>>> Also for number of ref frames, the standard allows only the options 1,
>>>> 2 and 3 which
>>>> cannot be extended more. So is it correct to use INTEGER_MENU control here and
>>>> let the driver define the values?
>>>
>>> If this is standard then the core should define available menu items. But
>>> it seems more appropriate for me to use INTEGER_MENU. I'd like to hear other
>>> opinions though.
>>
>> Here even though 1,2 and 3 are standard, the interpretation is
>> 1 - 1 reference frame (previous frame)
>> 2 - previous frame + golden frame
>> 3 - previous frame + golden frame + altref frame.
>
> OK, then perhaps for this parameter a standard menu control would be better.
> However, why there are only 2 options in vpx_num_ref_frames[] arrays ?

Thats because MFCv7 doesnt support the 3rd option yet. But still I would
add this in the control to make it generic.

> You probably want to change the menu strings to reflect this more precisely,
> but there might be not enough room for any creative names anyway. Maybe
> something like:
>
> static const char * const vpx_num_ref_frames[] = {
>         "Previous Frame",
>         "Previous + Golden Frame",
>         "Prev + Golden + Altref Frame",
>         NULL,
> };
>
> Anyway raw numbers might be better for the control and details could be
> described in the documentation.

Ok will do like this.

Regards
Arun
