Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:59883 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3LJEog (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Dec 2013 23:44:36 -0500
MIME-Version: 1.0
In-Reply-To: <52A5C3F8.1090503@xs4all.nl>
References: <1386594961-17803-1-git-send-email-arun.kk@samsung.com>
	<52A5C3F8.1090503@xs4all.nl>
Date: Tue, 10 Dec 2013 10:14:35 +0530
Message-ID: <CALt3h789M_yT465LXcZ2QKXHPKXbvOk9GyP0GJYi_W4Nq6u6fQ@mail.gmail.com>
Subject: Re: [PATCH] CHROMIUM: s5p-mfc: add controls to set vp8 enc profile
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>, avnd.kiran@samsung.com,
	posciak@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the review.

On Mon, Dec 9, 2013 at 6:52 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Arun,
>
> Some comments below...
>
> On 12/09/2013 02:16 PM, Arun Kumar K wrote:
>> Add v4l2 controls to set desired profile for VP8 encoder.
>> Acceptable levels for VP8 encoder are
>> 0: Version 0
>> 1: Version 1
>> 2: Version 2
>> 3: Version 3
>>
>> Signed-off-by: Pawel Osciak <posciak@chromium.org>
>> Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> ---
>> This patch is rebased over another VP8 control patch from me:
>> https://linuxtv.org/patch/20733/
>> ---
>>  Documentation/DocBook/media/v4l/controls.xml    |    9 +++++++++
>>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    1 +
>>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   11 +++++++++++
>>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    6 ++----
>>  drivers/media/v4l2-core/v4l2-ctrls.c            |    8 ++++++++
>>  include/uapi/linux/v4l2-controls.h              |    1 +
>>  6 files changed, 32 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
>> index e4db4ac..c1f7544 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -3193,6 +3193,15 @@ V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD as a golden frame.</entry>
>>             <row><entry spanname="descr">Quantization parameter for a P frame for VP8.</entry>
>>             </row>
>>
>> +           <row><entry></entry></row>
>> +           <row>
>> +             <entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VPX_PROFILE</constant>&nbsp;</entry>
>> +             <entry>integer</entry>
>
> This says 'integer' whereas the control is actually an integer menu.
>
> Why did you choose 'integer menu' for this? Would a regular integer or perhaps a standard
> menu be better?
>

I chose integer menu as it is standard set of values with only 4
options (integers).
Same thing is done in the controls - V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS
and V4L2_CID_MPEG_VIDEO_VPX_NUM_REF_FRAMES. I felt this new controls is also
in-line with the requirement of a integer-menu type. What do you think?

>> +           </row>
>> +           <row><entry spanname="descr">Select the desired profile for VP8 encoder.
>> +Acceptable values are 0, 1, 2 and 3 corresponding to encoder versions 0, 1, 2 and 3.</entry>
>
> Is it a 'profile' or a 'version'? It looks a bit confusing. I don't have the VP8 standard,
> so I can't really tell what the correct terminology is.
>

Ok will make it more clear.

> Also, does this control apply just to VP8 or also to other VP versions? The control name
> says 'VPX' while the description says 'VP8' explicitly.
>

As of now its applicable to VP8, but I am not sure if the same thing
will apply to VP9 also.

Regards
Arun
