Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout.microchip.com ([198.175.253.82]:44356 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933063AbcKNIXV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 03:23:21 -0500
Subject: Re: [RFC PATCH 6/7] atmel-isi: remove dependency of the soc-camera
 framework
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
References: <1471415383-38531-1-git-send-email-hverkuil@xs4all.nl>
 <1471415383-38531-7-git-send-email-hverkuil@xs4all.nl>
 <3b1f31fd-c6c9-2d8d-008a-4491e2132160@microchip.com>
 <7026180d-6180-af21-b8bd-23f673e015a7@xs4all.nl>
 <f929eb2f-05a4-e674-c90b-b9141de04153@microchip.com>
 <ad11ae23-402f-6e20-6201-af466ff7da2e@microchip.com>
 <86371d6b-3549-0d75-201e-53a0226872db@xs4all.nl>
 <1a034eb2-4d2f-5640-54c4-ed3702ae7202@microchip.com>
 <38cace16-a523-857c-4081-0f5e28550bc5@xs4all.nl>
 <9f054ac5-0891-869b-c5fb-5652bd49fa30@microchip.com>
 <5e077970-440f-a658-7238-2a152a8aba9d@xs4all.nl>
From: "Wu, Songjun" <Songjun.Wu@microchip.com>
Message-ID: <bc4b4051-ac67-b980-502a-7d867f359ed1@microchip.com>
Date: Mon, 14 Nov 2016 16:22:28 +0800
MIME-Version: 1.0
In-Reply-To: <5e077970-440f-a658-7238-2a152a8aba9d@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/14/2016 16:19, Hans Verkuil wrote:
> Hi Songjun,
>
> On 10/19/2016 09:48 AM, Wu, Songjun wrote:
>>
>>
>> On 10/19/2016 15:46, Hans Verkuil wrote:
>>> On 10/19/2016 09:36 AM, Wu, Songjun wrote:
>>>>
>>>>
>>>> On 10/18/2016 18:58, Hans Verkuil wrote:
>>>>> On 10/18/16 11:21, Wu, Songjun wrote:
>>>>>> Hi Hans,
>>>>>>
>>>>>> Do you have any issue on this patch?
>>>>>
>>>>> ENOTIME :-(
>>>>>
>>>>>> Could I give you some help? :)
>>>>>
>>>>> I would certainly help if you can make the requested change to this patch.
>>>>>
>>>>> Let me know if you want to do that, because in that case I'll rebase my
>>>>> tree
>>>>> to the latest media_tree master.
>>>>>
>>>> Yes, I would like to make the requested change to this patch. :)
>>>> It seems the patch is not based on the latest media_tree master.
>>>> Will you rebase this patch to the latest media_tree, or let me move it
>>>> and make the requested change based on the media_tree?
>>>
>>> I've rebased my branch:
>>>
>>> https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=sama5d3-2
>>>
>> Thank you very much.
>> I will make the requested change based on your branch.
>
> Did you make any progress on this? I plan on finalizing the atmel-isi driver
> next week.
>
I checked the code, you have already modified the code according the 
comments, and I also validate the ISI driver, no errors.
You can finalize the atmel-isi driver.
Thank you very much.

> Regards,
>
> 	Hans
>
