Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:40837 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaGYMPk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 08:15:40 -0400
Received: by mail-oa0-f51.google.com with SMTP id o6so5492783oag.10
        for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 05:15:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53D245EA.4070803@xs4all.nl>
References: <53999849.1090105@xs4all.nl> <CAPybu_2R9oj7aF1dUOjdGfHfV=LHaTWDp=CGXAZq76qcvJoAvQ@mail.gmail.com>
 <CAPybu_2fPc5z2KyiMzX-=VNQHavyR5WQHX2JcyPYMbUKmLMYYQ@mail.gmail.com> <53D245EA.4070803@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 25 Jul 2014 14:09:31 +0200
Message-ID: <CAPybu_2jZ8qCpoJAe9aaBtnr=r8wzgkMn9onEE1L5C=qybQ4dQ@mail.gmail.com>
Subject: Re: [ATTN] Please review/check the REVIEWv4 compound control patch series
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans

I still need the multiselection support first. Right now it is done by
a modified g/s_selection ioctl.

I would love to upstream the driver, but maybe it is not the right
moment right now. We are selling a mainly to a couple of customers and
the total size of the drivers is > 16000 lines of code, plus 200 MB in
firmware files.

Once we are ready to launch the product to a wider market we will
upstream it, now it will just annoy a lot of people.

Thanks



On Fri, Jul 25, 2014 at 1:56 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Ricardo,
>
> On 07/25/14 13:52, Ricardo Ribalda Delgado wrote:
>> Hello Hans
>>
>>
>> Guess it is too late, but just so you know. I have successfully uses
>> this patches to implement a dead pixel array list.
>>
>> Tested-by: Ricardo Ribalda <ricardo.ribalda@gmail.com>
>> Thanked-by: Ricardo Ribalda <ricardo.ribalda@gmail.com>  :)
>
> Nevertheless nice to hear about this!
>
> BTW, are you planning on upstreaming this driver? Or do you need to
> have multi-selection support first? That needs the compound control
> support as well, so at least it's closer to becoming a reality.
>
> Regards,
>
>         Hans
>
>>
>> Thanks!
>>
>> On Thu, Jul 17, 2014 at 3:56 PM, Ricardo Ribalda Delgado
>> <ricardo.ribalda@gmail.com> wrote:
>>> Hello Hans
>>>
>>> I am planning to test this patchset for dead pixels by the end of this
>>> week and the beggining of the next. I am thinking about comparing the
>>> performance a list of deadpixels against a list of all pixels with
>>> their property (ok pixel, dead pixel, white pixel, slow pixel...)
>>>
>>> Will write back (hopefully) soon
>>>
>>> Regards!
>>>
>>> On Thu, Jun 12, 2014 at 2:08 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> Mauro & anyone else with an interest,
>>>>
>>>> I'd appreciate it if this patch series was reviewed, in particular
>>>> with respect to the handling of multi-dimensional arrays:
>>>>
>>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg75929.html
>>>>
>>>> This patch series incorporates all comments from the REVIEWv3 series
>>>> except for two (see the cover letter of the patch series for details),
>>>>
>>>> If support for arrays with more than 8 dimensions is really needed,
>>>> then I would like to know asap so I can implement that in time for
>>>> 3.17.
>>>>
>>>> Regards,
>>>>
>>>>         Hans
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>> --
>>> Ricardo Ribalda
>>
>>
>>
>



-- 
Ricardo Ribalda
