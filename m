Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:60484 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726096AbeJHQLL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Oct 2018 12:11:11 -0400
Subject: Re: [PATCH] media: vivid: Support 480p for webcam capture
To: kieran.bingham@ideasonboard.com,
        Keiichi Watanabe <keiichiw@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricky Liang <jcliang@chromium.org>,
        Shik Chen <shik@chromium.org>
References: <20181003070656.193854-1-keiichiw@chromium.org>
 <CAD90VcbBUcpwLsY0sHim+mML6esSjZA2ocX0Ff-YiZxBsLTZ+w@mail.gmail.com>
 <5b236e95-b737-51b3-df4f-eea41a36735e@xs4all.nl>
 <CAD90VcaexKNsRE9s32UanzE32YM2EXFySCArkt_Zo2V3-eRnqQ@mail.gmail.com>
 <997483ea-4a41-a947-2cc8-45892ef91bc6@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d8b8d5bb-788d-1089-3a9d-ca42926ecc7b@xs4all.nl>
Date: Mon, 8 Oct 2018 11:00:25 +0200
MIME-Version: 1.0
In-Reply-To: <997483ea-4a41-a947-2cc8-45892ef91bc6@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/08/2018 10:35 AM, Kieran Bingham wrote:
> On 06/10/18 11:29, Keiichi Watanabe wrote:
>> Hi all,
>>
>> On Fri, Oct 5, 2018 at 6:18 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> On 10/03/18 09:08, Keiichi Watanabe wrote:
>>>> I think 480p is a common frame size and it's worth supporting in vivid.
>>>> But, my patch might be ad-hoc. Actually, I'm not sure which values are
>>>> suitable for the intervals.
>>>
>>> I can apply this ad-hoc patch as-is.
>>>
>>> Or do you want to postpone this and work on a more generic solution?
>>> Although I am not sure what that would look like.
>>
>> I prefer providing a more flexible way rather than this ad-hoc patch.
>> It would be helpful if there is a way of changing supported frame sizes easily.
>> Perhaps, Kieran and me would use it, at least:)
>>
> 
> o/ <raising hand in agreement>
> 
>>>
>>> Proposals are welcome!
>>>
>>> The main purpose of this code is to have something that kind of acts like
>>> a real webcam that has various resolutions, and a slower framerate for
>>> higher resolutions (as you would expect).
>>
>> This sounds reasonable, so I guess we can keep this way as default and
>> provide a way for specifying extra frame sizes as an option.
>>
>> For example, how about a module option like this?
>> "webcam_sizes=640x480@15,320x240@30"
>>
>> If this parameter is passed to vivid, vivid works like a webcam that
>> supports the following 7 pairs of frame size and fps:
>> - 5 pairs of frame sizes and fps, as with the current implementation
>> - 640x480 (15fps)
>> - 320x240 (30fps)
> 
> I like the concept of being able to specify as a module parameter.
> 
> Perhaps we could have a magic marker on the string to define if the
> existing frame sizes should be kept - or if this is just a complete
> override ?

No, just override. It's hard otherwise since you would have to keep the
lists sorted by resolution/fps.

If you want to set it yourself, then just do a complete override.

> 
>  vivid.webcam=640x480@15,320x240@30  # Specify sizes explicitly
>  vivid.webcam=+640x480@15,320x240@30  # Append to existing frames
>               ^ Magic Marker
> 
> We might of course want multiple rates per frame,
> 
>  vivid.webcam=640x480@15-25-30-90-120, # Separator to be defined...

Stick to @, so: vivid.webcam=640x480@15@25@30@90@120

This looks like a good proposal to me.

BTW, I still would like to add 640x480 added to the default list:
it's a common resolution and it makes sense to add it.

So I plan to accept the patch regardless.

Regards,

	Hans

> 
> 
>>
>> If this parameter is not passed, vivid's behavior won't change from
>> the current one.
>>
>> How do you think?
>>
>> We might want to stop using the default framesizes, i.e. vivid only
>> supports framesize/fps that passed as the option.
>> But, if we do so, the parameter will become mandatory and it would be annoying.
> 
> I think mandatory would be annoying yes.
> 
> Thus my suggestion for a magic marker above :)
> 
> --
> Kieran
> 
> 
>> So, I personally like to keep the default framesizes.
>>
>> Best regards,
>> Kei
>>
>>>
>>> Regards,
>>>
>>>         Hans
>>>
>>>>
>>>> We might want to add a more flexible/extensible way to specify frame sizes.
>>>> e.g. passing frame sizes and intervals as module parameters
>>>>
>>>> Kei
>>>>
>>>> On Wed, Oct 3, 2018 at 4:06 PM, Keiichi Watanabe <keiichiw@chromium.org> wrote:
>>>>> Support 640x480 as a frame size for video input devices of vivid.
>>>>>
>>>>> Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
>>>>> ---
>>>>>  drivers/media/platform/vivid/vivid-vid-cap.c | 5 ++++-
>>>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
>>>>> index 58e14dd1dcd3..da80bf4bc365 100644
>>>>> --- a/drivers/media/platform/vivid/vivid-vid-cap.c
>>>>> +++ b/drivers/media/platform/vivid/vivid-vid-cap.c
>>>>> @@ -51,7 +51,7 @@ static const struct vivid_fmt formats_ovl[] = {
>>>>>  };
>>>>>
>>>>>  /* The number of discrete webcam framesizes */
>>>>> -#define VIVID_WEBCAM_SIZES 5
>>>>> +#define VIVID_WEBCAM_SIZES 6
>>>>>  /* The number of discrete webcam frameintervals */
>>>>>  #define VIVID_WEBCAM_IVALS (VIVID_WEBCAM_SIZES * 2)
>>>>>
>>>>> @@ -59,6 +59,7 @@ static const struct vivid_fmt formats_ovl[] = {
>>>>>  static const struct v4l2_frmsize_discrete webcam_sizes[VIVID_WEBCAM_SIZES] = {
>>>>>         {  320, 180 },
>>>>>         {  640, 360 },
>>>>> +       {  640, 480 },
>>>>>         { 1280, 720 },
>>>>>         { 1920, 1080 },
>>>>>         { 3840, 2160 },
>>>>> @@ -75,6 +76,8 @@ static const struct v4l2_fract webcam_intervals[VIVID_WEBCAM_IVALS] = {
>>>>>         {  1, 5 },
>>>>>         {  1, 10 },
>>>>>         {  1, 15 },
>>>>> +       {  1, 15 },
>>>>> +       {  1, 25 },
>>>>>         {  1, 25 },
>>>>>         {  1, 30 },
>>>>>         {  1, 50 },
>>>>> --
>>>>> 2.19.0.605.g01d371f741-goog
>>>>>
>>>
> 
> 
