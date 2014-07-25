Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:35782 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760243AbaGYLxQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 07:53:16 -0400
Received: by mail-oa0-f49.google.com with SMTP id eb12so5350470oac.36
        for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 04:53:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPybu_2R9oj7aF1dUOjdGfHfV=LHaTWDp=CGXAZq76qcvJoAvQ@mail.gmail.com>
References: <53999849.1090105@xs4all.nl> <CAPybu_2R9oj7aF1dUOjdGfHfV=LHaTWDp=CGXAZq76qcvJoAvQ@mail.gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 25 Jul 2014 13:52:55 +0200
Message-ID: <CAPybu_2fPc5z2KyiMzX-=VNQHavyR5WQHX2JcyPYMbUKmLMYYQ@mail.gmail.com>
Subject: Re: [ATTN] Please review/check the REVIEWv4 compound control patch series
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans


Guess it is too late, but just so you know. I have successfully uses
this patches to implement a dead pixel array list.

Tested-by: Ricardo Ribalda <ricardo.ribalda@gmail.com>
Thanked-by: Ricardo Ribalda <ricardo.ribalda@gmail.com>  :)

Thanks!

On Thu, Jul 17, 2014 at 3:56 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> Hello Hans
>
> I am planning to test this patchset for dead pixels by the end of this
> week and the beggining of the next. I am thinking about comparing the
> performance a list of deadpixels against a list of all pixels with
> their property (ok pixel, dead pixel, white pixel, slow pixel...)
>
> Will write back (hopefully) soon
>
> Regards!
>
> On Thu, Jun 12, 2014 at 2:08 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Mauro & anyone else with an interest,
>>
>> I'd appreciate it if this patch series was reviewed, in particular
>> with respect to the handling of multi-dimensional arrays:
>>
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg75929.html
>>
>> This patch series incorporates all comments from the REVIEWv3 series
>> except for two (see the cover letter of the patch series for details),
>>
>> If support for arrays with more than 8 dimensions is really needed,
>> then I would like to know asap so I can implement that in time for
>> 3.17.
>>
>> Regards,
>>
>>         Hans
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Ricardo Ribalda



-- 
Ricardo Ribalda
