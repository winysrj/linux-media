Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:36766 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbeJCSEd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2018 14:04:33 -0400
Subject: Re: [PATCH] media: vivid: Support 480p for webcam capture
To: Keiichi Watanabe <keiichiw@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricky Liang <jcliang@chromium.org>,
        Shik Chen <shik@chromium.org>
References: <20181003070656.193854-1-keiichiw@chromium.org>
 <CAD90VcbBUcpwLsY0sHim+mML6esSjZA2ocX0Ff-YiZxBsLTZ+w@mail.gmail.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <ff25134a-6d61-6dd4-f157-8acd53722ad9@ideasonboard.com>
Date: Wed, 3 Oct 2018 12:16:32 +0100
MIME-Version: 1.0
In-Reply-To: <CAD90VcbBUcpwLsY0sHim+mML6esSjZA2ocX0Ff-YiZxBsLTZ+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kei,

On 03/10/18 08:08, Keiichi Watanabe wrote:
> I think 480p is a common frame size and it's worth supporting in vivid.
> But, my patch might be ad-hoc. Actually, I'm not sure which values are
> suitable for the intervals.

Aha - yes I did think the duplicates were a bit odd. Anyway, replied
inline there :)

> We might want to add a more flexible/extensible way to specify frame sizes.
> e.g. passing frame sizes and intervals as module parameters

I agree here, having recently extended this table my self with some
local patches it would be great to be able to request some more
arbitrary sizes and rates from VIVID in a more flexible manner.

Regards

Kieran


> 
> Kei
> 
> On Wed, Oct 3, 2018 at 4:06 PM, Keiichi Watanabe <keiichiw@chromium.org> wrote:
>> Support 640x480 as a frame size for video input devices of vivid.
>>
>> Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
>> ---
>>  drivers/media/platform/vivid/vivid-vid-cap.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
>> index 58e14dd1dcd3..da80bf4bc365 100644
>> --- a/drivers/media/platform/vivid/vivid-vid-cap.c
>> +++ b/drivers/media/platform/vivid/vivid-vid-cap.c
>> @@ -51,7 +51,7 @@ static const struct vivid_fmt formats_ovl[] = {
>>  };
>>
>>  /* The number of discrete webcam framesizes */
>> -#define VIVID_WEBCAM_SIZES 5
>> +#define VIVID_WEBCAM_SIZES 6
>>  /* The number of discrete webcam frameintervals */
>>  #define VIVID_WEBCAM_IVALS (VIVID_WEBCAM_SIZES * 2)
>>
>> @@ -59,6 +59,7 @@ static const struct vivid_fmt formats_ovl[] = {
>>  static const struct v4l2_frmsize_discrete webcam_sizes[VIVID_WEBCAM_SIZES] = {
>>         {  320, 180 },
>>         {  640, 360 },
>> +       {  640, 480 },
>>         { 1280, 720 },
>>         { 1920, 1080 },
>>         { 3840, 2160 },
>> @@ -75,6 +76,8 @@ static const struct v4l2_fract webcam_intervals[VIVID_WEBCAM_IVALS] = {
>>         {  1, 5 },
>>         {  1, 10 },
>>         {  1, 15 },
>> +       {  1, 15 },
>> +       {  1, 25 },
>>         {  1, 25 },
>>         {  1, 30 },
>>         {  1, 50 },
>> --
>> 2.19.0.605.g01d371f741-goog
>>
