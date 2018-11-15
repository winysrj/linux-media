Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:51070 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732702AbeKOVAO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 16:00:14 -0500
Subject: Re: [PATCH v7 03/16] v4l: Add Intel IPU3 meta data uAPI
To: "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: "Zhi, Yong" <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        "Li, Chao C" <chao.c.li@intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-4-git-send-email-yong.zhi@intel.com>
 <20181102104908.609177e5@coco.lan>
 <CAAFQd5B_OVV-Nh0uOGHdQE4eSKcs5N8Nn1t-Zz-GbvgpB9P38A@mail.gmail.com>
 <6F87890CF0F5204F892DEA1EF0D77A5981524580@fmsmsx122.amr.corp.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <653bae0f-899a-5a8b-a1d0-814f6b44f8f8@xs4all.nl>
Date: Thu, 15 Nov 2018 11:52:48 +0100
MIME-Version: 1.0
In-Reply-To: <6F87890CF0F5204F892DEA1EF0D77A5981524580@fmsmsx122.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/07/18 00:27, Mani, Rajmohan wrote:
> Hi Mauro,
> 
> Thanks for the reviews.
> 
>> Subject: Re: [PATCH v7 03/16] v4l: Add Intel IPU3 meta data uAPI
>>
>> Hi Mauro,
>>
>> On Fri, Nov 2, 2018 at 10:49 PM Mauro Carvalho Chehab
>> <mchehab+samsung@kernel.org> wrote:
>>>
>>> Em Mon, 29 Oct 2018 15:22:57 -0700
>>> Yong Zhi <yong.zhi@intel.com> escreveu:
>> [snip]
>>>> +struct ipu3_uapi_awb_config_s {
>>>> +     __u16 rgbs_thr_gr;
>>>> +     __u16 rgbs_thr_r;
>>>> +     __u16 rgbs_thr_gb;
>>>> +     __u16 rgbs_thr_b;
>>>> +     struct ipu3_uapi_grid_config grid; }
>>>> +__attribute__((aligned(32))) __packed;
>>>
>>> Hmm... Kernel defines a macro for aligned attribute:
>>>
>>>         include/linux/compiler_types.h:#define __aligned(x)
>> __attribute__((aligned(x)))
>>>
>>
>> First, thanks for review!
>>
>> Maybe I missed something, but last time I checked, it wasn't accessible from
>> UAPI headers in userspace.
> 
> Ack. We see that's still the case.
> 
>>
>>> I'm not a gcc expert, but it sounds weird to first ask it to align
>>> with 32 bits and then have __packed (with means that pads should be
>>> removed).
>>>
>>> In other words, I *guess* is it should either be __packed or
>>> __aligned(32).
>>>
>>> Not that it would do any difference, in practice, as this specific
>>> struct has a size with is multiple of 32 bits, but let's do the right
>>> annotation here, not mixing two incompatible alignment requirements.
>>>
>>
>> My understanding was that __packed makes the compiler not insert any
>> alignment between particular fields of the struct, while __aligned makes the
>> whole struct be aligned at given boundary, if placed in another struct. If I
>> didn't miss anything, having both should make perfect sense here.
> 
> Ack
> 
> I also recall that as part of addressing review comments  (from Hans and Sakari),
> on earlier versions of this patch series, we added __packed attribute to all structs
> to ensure the size of the structs remains the same between 32 and 64 bit builds.
> 
> The addition of structure members of the name padding[x] in some of the structs
> ensures that respective members are aligned at 32 byte boundaries, while the
> overall size of the structs remain the same between 32 and 64 bit builds.

I recommend that this is documented in the header. It's not a common construction
so an explanation will help.

Regards,

	Hans

> 
> Thanks
> Raj
> 
>>
>> Best regards,
>> Tomasz
