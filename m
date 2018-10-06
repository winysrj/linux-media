Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38676 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbeJFRcU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 6 Oct 2018 13:32:20 -0400
Received: by mail-lj1-f193.google.com with SMTP id v7-v6so13319341ljg.5
        for <linux-media@vger.kernel.org>; Sat, 06 Oct 2018 03:29:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5b236e95-b737-51b3-df4f-eea41a36735e@xs4all.nl>
References: <20181003070656.193854-1-keiichiw@chromium.org>
 <CAD90VcbBUcpwLsY0sHim+mML6esSjZA2ocX0Ff-YiZxBsLTZ+w@mail.gmail.com> <5b236e95-b737-51b3-df4f-eea41a36735e@xs4all.nl>
From: Keiichi Watanabe <keiichiw@chromium.org>
Date: Sat, 6 Oct 2018 19:29:33 +0900
Message-ID: <CAD90VcaexKNsRE9s32UanzE32YM2EXFySCArkt_Zo2V3-eRnqQ@mail.gmail.com>
Subject: Re: [PATCH] media: vivid: Support 480p for webcam capture
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricky Liang <jcliang@chromium.org>,
        Shik Chen <shik@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

On Fri, Oct 5, 2018 at 6:18 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 10/03/18 09:08, Keiichi Watanabe wrote:
>> I think 480p is a common frame size and it's worth supporting in vivid.
>> But, my patch might be ad-hoc. Actually, I'm not sure which values are
>> suitable for the intervals.
>
> I can apply this ad-hoc patch as-is.
>
> Or do you want to postpone this and work on a more generic solution?
> Although I am not sure what that would look like.

I prefer providing a more flexible way rather than this ad-hoc patch.
It would be helpful if there is a way of changing supported frame sizes easily.
Perhaps, Kieran and me would use it, at least:)

>
> Proposals are welcome!
>
> The main purpose of this code is to have something that kind of acts like
> a real webcam that has various resolutions, and a slower framerate for
> higher resolutions (as you would expect).

This sounds reasonable, so I guess we can keep this way as default and
provide a way for specifying extra frame sizes as an option.

For example, how about a module option like this?
"webcam_sizes=640x480@15,320x240@30"

If this parameter is passed to vivid, vivid works like a webcam that
supports the following 7 pairs of frame size and fps:
- 5 pairs of frame sizes and fps, as with the current implementation
- 640x480 (15fps)
- 320x240 (30fps)

If this parameter is not passed, vivid's behavior won't change from
the current one.

How do you think?

We might want to stop using the default framesizes, i.e. vivid only
supports framesize/fps that passed as the option.
But, if we do so, the parameter will become mandatory and it would be annoying.
So, I personally like to keep the default framesizes.

Best regards,
Kei

>
> Regards,
>
>         Hans
>
>>
>> We might want to add a more flexible/extensible way to specify frame sizes.
>> e.g. passing frame sizes and intervals as module parameters
>>
>> Kei
>>
>> On Wed, Oct 3, 2018 at 4:06 PM, Keiichi Watanabe <keiichiw@chromium.org> wrote:
>>> Support 640x480 as a frame size for video input devices of vivid.
>>>
>>> Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
>>> ---
>>>  drivers/media/platform/vivid/vivid-vid-cap.c | 5 ++++-
>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
>>> index 58e14dd1dcd3..da80bf4bc365 100644
>>> --- a/drivers/media/platform/vivid/vivid-vid-cap.c
>>> +++ b/drivers/media/platform/vivid/vivid-vid-cap.c
>>> @@ -51,7 +51,7 @@ static const struct vivid_fmt formats_ovl[] = {
>>>  };
>>>
>>>  /* The number of discrete webcam framesizes */
>>> -#define VIVID_WEBCAM_SIZES 5
>>> +#define VIVID_WEBCAM_SIZES 6
>>>  /* The number of discrete webcam frameintervals */
>>>  #define VIVID_WEBCAM_IVALS (VIVID_WEBCAM_SIZES * 2)
>>>
>>> @@ -59,6 +59,7 @@ static const struct vivid_fmt formats_ovl[] = {
>>>  static const struct v4l2_frmsize_discrete webcam_sizes[VIVID_WEBCAM_SIZES] = {
>>>         {  320, 180 },
>>>         {  640, 360 },
>>> +       {  640, 480 },
>>>         { 1280, 720 },
>>>         { 1920, 1080 },
>>>         { 3840, 2160 },
>>> @@ -75,6 +76,8 @@ static const struct v4l2_fract webcam_intervals[VIVID_WEBCAM_IVALS] = {
>>>         {  1, 5 },
>>>         {  1, 10 },
>>>         {  1, 15 },
>>> +       {  1, 15 },
>>> +       {  1, 25 },
>>>         {  1, 25 },
>>>         {  1, 30 },
>>>         {  1, 50 },
>>> --
>>> 2.19.0.605.g01d371f741-goog
>>>
>
