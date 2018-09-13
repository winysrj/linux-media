Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f173.google.com ([209.85.208.173]:41260 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726570AbeIMKmx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 06:42:53 -0400
Received: by mail-lj1-f173.google.com with SMTP id y17-v6so3554861ljy.8
        for <linux-media@vger.kernel.org>; Wed, 12 Sep 2018 22:34:57 -0700 (PDT)
Subject: Re: [Xen-devel][PATCH v2 1/1] cameraif: add ABI for para-virtual
 camera
To: Hans Verkuil <hverkuil@xs4all.nl>,
        "Oleksandr_Andrushchenko@epam.com" <Oleksandr_Andrushchenko@epam.com>,
        xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        jgross@suse.com, boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com
References: <20180911082952.23322-1-andr2000@gmail.com>
 <20180911082952.23322-2-andr2000@gmail.com>
 <7291d10d-3fe2-2cba-e5f7-cd30b91a7cf1@xs4all.nl>
 <1e6eca59-c002-42b7-d8b6-f8a525898291@gmail.com>
 <bffe0f61-c2b6-33c9-1fbc-d81bbf52f013@xs4all.nl>
 <8a7b3f0d-4385-201a-d50a-69d81470f2fb@gmail.com>
 <457d93c8-b01e-0824-483d-5bdf6a49e69b@xs4all.nl>
 <1a8e5f3e-cf57-ccb0-f1d2-650e4c325166@gmail.com>
 <007a6af9-e504-dc76-2a61-f3cff1dd61a5@xs4all.nl>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <88d2a7c6-4cbb-0ed6-778b-97abef05bf9e@gmail.com>
Date: Thu, 13 Sep 2018 08:34:54 +0300
MIME-Version: 1.0
In-Reply-To: <007a6af9-e504-dc76-2a61-f3cff1dd61a5@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/12/2018 05:38 PM, Hans Verkuil wrote:
> On 09/12/18 16:15, Oleksandr Andrushchenko wrote:
>> On 09/12/2018 04:38 PM, Hans Verkuil wrote:
>>> On 09/12/18 15:02, Oleksandr Andrushchenko wrote:
>>>> On 09/12/2018 03:25 PM, Hans Verkuil wrote:
>>>>>>>> + * formats
>>>>>>>> + *      Values:         <format, char[4]>
>>>>>>>> + *
>>>>>>>> + *      Formats are organized as a set of directories one per each
>>>>>>>> + *      supported pixel format. The name of the directory is the
>>>>>>>> + *      corresponding FOURCC string label. The next level of
>>>>>>>> + *      the directory under <formats> represents supported resolutions.
>>>>>>> So how will this work for a pixelformat like V4L2_PIX_FMT_ARGB555X?
>>>>>>>
>>>>>>> As mentioned before, we display such formats as 'XXXX-BE', i.e. char[7].
>>>>>> ok, then I'll change this to char[7] and put a note on big-endian:
>>>>>>
>>>>>>      *      If format represents a big-endian FOURCC code, then "-BE"
>>>>>>      *      suffix must be added, case insensitive.
>>>>> Since the fourcc is case-sensitive, I'd keep -BE case sensitive as well.
>>>>> Your decision, though.
>>>> hm, I'm a little bit confused here... One of the previous comments was...
>>>>
>>>>    >> + *      Formats are organized as a set of directories one per each
>>>>    >> + *      supported pixel format. The name of the directory is an
>>>> upper case
>>>>    >> + *      string of the corresponding FOURCC string label. The next
>>>> level of
>>>>    >> + *      the directory under <formats> represents supported resolutions.
>>>>
>>>>    >Lower-case characters are also use in pixelformats, so I'd just keep
>>>> this as-is.
>>>>    >
>>>>    >In addition it is common to set bit 31 of the fourcc to 1 if the format is
>>>>    >big-endian (see v4l2_fourcc_be macro). When v4l utilities print this
>>>> format we
>>>>    >add a -BE suffix, so V4L2_PIX_FMT_ARGB555X becomes "AR15-BE". You
>>>> might want to
>>>>    >keep that convention.
>>>>
>>>> So, finally, I'll put upper case constraint here for fourcc and "-BE"?
>>>> Did I miss something here?
>>> Easiest is to look at videodev2.h. Let me take two examples:
>>>
>>> #define V4L2_PIX_FMT_ARGB555 v4l2_fourcc('A', 'R', '1', '5') /* 16  ARGB-1-5-5-5  */
>>> #define V4L2_PIX_FMT_ARGB555X v4l2_fourcc_be('A', 'R', '1', '5') /* 16  ARGB-5-5-5 BE */
>>>
>>> The fourcc macros are defined as:
>>>
>>> #define v4l2_fourcc(a, b, c, d)\
>>>           ((__u32)(a) | ((__u32)(b) << 8) | ((__u32)(c) << 16) | ((__u32)(d) << 24))
>>> #define v4l2_fourcc_be(a, b, c, d)      (v4l2_fourcc(a, b, c, d) | (1 << 31))
>>>
>>> The characters can be any printable character, but currently we only use
>>> a-z, A-Z, 0-9 and space (' ').
>>>
>>> For big-endian formats we also set bit 31 (i.e. bit 7 of the last character)
>>> to indicate this.
>>>
>>> In our v4l2 utilities we use this function when we want to print a fourcc:
>>>
>>> std::string fcc2s(__u32 val)
>>> {
>>>           std::string s;
>>>
>>>           s += val & 0x7f;
>>>           s += (val >> 8) & 0x7f;
>>>           s += (val >> 16) & 0x7f;
>>>           s += (val >> 24) & 0x7f;
>>>           if (val & (1 << 31))
>>>                   s += "-BE";
>>>           return s;
>>> }
>>>
>>> So the four characters (with bit 7 masked out) and the -BE suffix
>>> if bit 7 was set for the fourth character.
>>>
>>> So for your protocol, if you want to specify the fourcc, then I
>>> assume dealing with characters with bit 7 set is a pain as well,
>>> and in that case you are better off using the same scheme that we
>>> do.
>>>
>>> And to match the formats, applications should remember that the
>>> string is case-sensitive, so 'abcd' != 'Abcd'.
>> Ah, got it, so I'll just make sure that "-BE" part
>> is case sensitive, e.g. remove "case insensitive":
>>
>>    * formats
>>    *      Values:         <format, char[7]>
>>    *
>>    *      Formats are organized as a set of directories one per each
>>    *      supported pixel format. The name of the directory is the
>>    *      corresponding FOURCC string label. The next level of
>>    *      the directory under <formats> represents supported resolutions.
>>    *      If format represents a big-endian FOURCC code, then "-BE"
>>    *      suffix must be added.
> Hmm. How about: "If the format represents a big-endian variant of a little
> endian format, then the "-BE" suffix must be added. E.g. 'AR15' vs 'AR15-BE'."
Sounds good, will use this, thank you
> BTW, using bit 31 for this is a complete V4L2-specific invention.
>
>>> Note that there can be spaces:
>>>
>>> #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
>>> #define V4L2_PIX_FMT_Y16_BE  v4l2_fourcc_be('Y', '1', '6', ' ') /* 16  Greyscale BE  */
>>>
>>> So that would be:
>>>
>>> /local/domain/1/device/vcamera/0/formats/Y16 /1200x720/frame-rates = "15/2"
>>>
>>> and:
>>>
>>> /local/domain/1/device/vcamera/0/formats/Y16 -BE/1200x720/frame-rates = "15/2"
>>>
>>> Not sure if that will fly for you.
>>>
>>> Currently if there are spaced, then they are at the end, but I don't think
>>> we can guarantee that for all time.
>> This is a problem as I cannot have spaces...
>> So, I can only put something like:
>>
>>    *      If FOURCC string label has spaces then those are only allowed to
>>    *      be at the end of the label and must be trimmed.
> I would recommend that you add comments to videodev2.h and the V4L2 specification
> where you put down some requirements. E.g. spaces only at the end, characters must
> be in the range of 0x20-0x7f, and a list of characters that are not allowed such
> as '/' and '\'. Perhaps others (':'?) as well.
Will put:
  * - all FOURCC mappings used for configuration and messaging are
  *   Linux V4L2 ones: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/videodev2.h
  *   with the following exceptions:
  *     - characters are allowed in [0x20; 0x7f] range
  *     - when used for XenStore configuration entries the following
  *       are not allowed:
  *       - '/', '\', ' ' (space), '<', '>', ':', '"', '|', '?', '*'
  *       - if trailing spaces are part of the FOURCC code then those 
must be
  *         trimmed

>>> I just wonder how you want to expose that. E.g. there is one backend and
>>> two frontends. The backend supports two resolutions and that is exposed
>>> to both backends. But once the first backend starts streaming, then the
>>> second backend is suddenly limited to a single resolution.
>>>
>>> Something for you to think about.
>> Scaling on backend side for the second frontend
> That's all very expensive. The amount of data that is being pushed to/from
> HW gets very large very quickly just in terms of pure memory bandwidth.
>
> Especially when you start talking about 1080p or higher resolutions.
>
> Just saying.
>
> A video stream of 1080p30 using RGB 24-bits per pixel produces about 178 MB/s
> worth of data. And that's not extreme at all. 4kp60 video is 1.42 GB/s.
>
> It's what makes video different from other data streams: the sheer amount of
> data. Memory bandwidth can quickly become a bottleneck in a system. Having
> to do conversions will double or probably triple the amount of bandwidth needed.
Yes, I do understand the costs.
This is why I am happy that most of the embedded use-cases are
statically configured, so you can choose the best fit configuration
for your particular use-cases, so there is no need for complex transforms
on the images required.
>
> Regards,
>
> 	Hans
Thank you,
Oleksandr
