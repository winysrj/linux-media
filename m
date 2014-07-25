Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4659 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaGYMQX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 08:16:23 -0400
Message-ID: <53D24A74.5060001@xs4all.nl>
Date: Fri, 25 Jul 2014 14:15:48 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [ATTN] Please review/check the REVIEWv4 compound control patch
 series
References: <53999849.1090105@xs4all.nl> <CAPybu_2R9oj7aF1dUOjdGfHfV=LHaTWDp=CGXAZq76qcvJoAvQ@mail.gmail.com> <CAPybu_2fPc5z2KyiMzX-=VNQHavyR5WQHX2JcyPYMbUKmLMYYQ@mail.gmail.com> <53D245EA.4070803@xs4all.nl> <CAPybu_2jZ8qCpoJAe9aaBtnr=r8wzgkMn9onEE1L5C=qybQ4dQ@mail.gmail.com>
In-Reply-To: <CAPybu_2jZ8qCpoJAe9aaBtnr=r8wzgkMn9onEE1L5C=qybQ4dQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/25/14 14:09, Ricardo Ribalda Delgado wrote:
> Hello Hans
> 
> I still need the multiselection support first. Right now it is done by
> a modified g/s_selection ioctl.
> 
> I would love to upstream the driver, but maybe it is not the right
> moment right now. We are selling a mainly to a couple of customers and
> the total size of the drivers is > 16000 lines of code, plus 200 MB in
> firmware files.

I was thinking of just the sensor driver, not the other components.
That would provide a proper use-case for both the dead pixel array
and multi-selection.

I assume that the sensor driver is a lot smaller? Does it need fw as well?

Regards,

	Hans

> 
> Once we are ready to launch the product to a wider market we will
> upstream it, now it will just annoy a lot of people.
> 
> Thanks
> 
> 
> 
> On Fri, Jul 25, 2014 at 1:56 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Ricardo,
>>
>> On 07/25/14 13:52, Ricardo Ribalda Delgado wrote:
>>> Hello Hans
>>>
>>>
>>> Guess it is too late, but just so you know. I have successfully uses
>>> this patches to implement a dead pixel array list.
>>>
>>> Tested-by: Ricardo Ribalda <ricardo.ribalda@gmail.com>
>>> Thanked-by: Ricardo Ribalda <ricardo.ribalda@gmail.com>  :)
>>
>> Nevertheless nice to hear about this!
>>
>> BTW, are you planning on upstreaming this driver? Or do you need to
>> have multi-selection support first? That needs the compound control
>> support as well, so at least it's closer to becoming a reality.
>>
>> Regards,
>>
>>         Hans
>>
>>>
>>> Thanks!
>>>
>>> On Thu, Jul 17, 2014 at 3:56 PM, Ricardo Ribalda Delgado
>>> <ricardo.ribalda@gmail.com> wrote:
>>>> Hello Hans
>>>>
>>>> I am planning to test this patchset for dead pixels by the end of this
>>>> week and the beggining of the next. I am thinking about comparing the
>>>> performance a list of deadpixels against a list of all pixels with
>>>> their property (ok pixel, dead pixel, white pixel, slow pixel...)
>>>>
>>>> Will write back (hopefully) soon
>>>>
>>>> Regards!
>>>>
>>>> On Thu, Jun 12, 2014 at 2:08 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>> Mauro & anyone else with an interest,
>>>>>
>>>>> I'd appreciate it if this patch series was reviewed, in particular
>>>>> with respect to the handling of multi-dimensional arrays:
>>>>>
>>>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg75929.html
>>>>>
>>>>> This patch series incorporates all comments from the REVIEWv3 series
>>>>> except for two (see the cover letter of the patch series for details),
>>>>>
>>>>> If support for arrays with more than 8 dimensions is really needed,
>>>>> then I would like to know asap so I can implement that in time for
>>>>> 3.17.
>>>>>
>>>>> Regards,
>>>>>
>>>>>         Hans
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>>
>>>> --
>>>> Ricardo Ribalda
>>>
>>>
>>>
>>
> 
> 
> 

