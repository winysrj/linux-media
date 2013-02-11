Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:60216 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444Ab3BKPLP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Feb 2013 10:11:15 -0500
Received: by mail-pa0-f50.google.com with SMTP id fa11so3142144pad.9
        for <linux-media@vger.kernel.org>; Mon, 11 Feb 2013 07:11:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5119064C.8040807@redhat.com>
References: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
	<201302111421.17226.hverkuil@xs4all.nl>
	<5118F4F4.1070602@redhat.com>
	<201302111451.31133.hverkuil@xs4all.nl>
	<5119064C.8040807@redhat.com>
Date: Mon, 11 Feb 2013 17:11:15 +0200
Message-ID: <CAJL_dMs5SXV7ExrQnmZhhikkBa9JsMk=-wdET2tkL92j2acpfA@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 01/12] stk-webcam: the initial hflip and vflip setup
 was the wrong way around
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Arvydas Sidorenko <asido4@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think the driver is not up to standard: look at the error messages.
And there are a lot of "to do" because of lack of documentation.

On Mon, Feb 11, 2013 at 4:55 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
>
> On 02/11/2013 02:51 PM, Hans Verkuil wrote:
>>
>> On Mon February 11 2013 14:41:08 Hans de Goede wrote:
>>>
>>> Hi,
>>>
>>> On 02/11/2013 02:21 PM, Hans Verkuil wrote:
>>>>
>>>> On Mon February 11 2013 14:08:44 Hans de Goede wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> Subject: stk-webcam: the initial hflip and vflip setup was the wrong
>>>>> way around
>>>>>
>>>>> No it is not.
>>>>
>>>>
>>>> You are right, that patch makes no sense. It was a long day :-)
>>>>
>>>>> On 02/10/2013 06:52 PM, Hans Verkuil wrote:
>>>>>>
>>>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>>
>>>>>> This resulted in an upside-down picture.
>>>>>
>>>>>
>>>>> No it does not, the laptop having an upside down mounted camera and not
>>>>> being
>>>>> in the dmi-table is what causes an upside down picture. For a non
>>>>> upside
>>>>> down camera (so no dmi-match) hflip and vflip should be 0.
>>>>>
>>>>> The fix for the upside-down-ness Arvydas Sidorenko reported would be to
>>>>> add his laptop to the upside down table.
>>>>
>>>>
>>>> That doesn't make sense either. Arvydas, it worked fine for you before,
>>>> right?
>>>
>>>
>>> Yes, it probably worked before, but not with...
>>>
>>>> That is, if you use e.g. v3.8-rc7 then your picture is the right side
>>>> up.
>>>
>>>
>>> 3.8 will show it upside down for Arvydas
>>>
>>> The story goes likes this:
>>>
>>> 1) Once upon a time the stkwebcam driver was written
>>> 2) The webcam in question was used mostly in Asus laptop models,
>>> including
>>> the laptop of the original author of the driver, and in these models, in
>>> typical Asus fashion (see the long long list for uvc cams inside
>>> v4l-utils),
>>> they mounted the webcam-module the wrong way up. So the hflip and vflip
>>> module options were given a default value of 1 (the correct value for
>>> upside down mounted models)
>>>
>>> 3) Years later I got a bug report from a user with a laptop with
>>> stkwebcam,
>>> where the module was actually mounted the right way up, and thus showed
>>> upside
>>> down under Linux. So now I was facing the choice of 2 options:
>>> a) Add a not-upside-down list to stkwebcam, which overrules the default
>>> b) Do it like all the other drivers do, and make the default right for
>>> cams mounted the proper way and add an upside-down model list, with
>>> models
>>> where we need to flip-by-default.
>>>
>>> Despite knowing that going b) would cause a period of pain where we were
>>> building the table (ie what we're discussing now) I opted to go for
>>> option
>>> b), since a) is just too ugly, and worse different from how every other
>>> driver does it leading to confusion in the long run.
>>>
>>> IOW this is entirely my fault, and I take full responsibility for it.
>>
>>
>> Ah, OK. Now it makes sense. I wasn't aware of this history and it
>> (clearly)
>> confused me greatly.
>>
>> Can you perhaps provide me with a patch that adds some comments to the
>> source
>> explaining this. And in particular with which kernel this change took
>> place?
>
>
> Feel free to copy my 1) - 3) From above to a comment, step 3 landed in
> kernel 3.6
> (you doing it seems better then me doing a patch conflicting with your
> patchset)
>
>
>> The next time some poor sod (e.g. me) has to work on this the comments
>> should
>> explain this history.
>
>
> Ack.
>
>
> Regards,
>
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
