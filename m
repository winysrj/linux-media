Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012Ab2GLPwb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 11:52:31 -0400
Message-ID: <4FFEF2E4.4010906@redhat.com>
Date: Thu, 12 Jul 2012 17:53:08 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: halli manjunatha <hallimanju@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/5] v4l2: Add rangelow and rangehigh fields to the v4l2_hw_freq_seek
 struct
References: <1342021658-27821-1-git-send-email-hdegoede@redhat.com> <1342021658-27821-2-git-send-email-hdegoede@redhat.com> <201207112001.18960.hverkuil@xs4all.nl> <CAMT6Pycuhe7OnP7D_FJy1yp2oFH780diTiHxEyTiPpyaaVX9Ug@mail.gmail.com>
In-Reply-To: <CAMT6Pycuhe7OnP7D_FJy1yp2oFH780diTiHxEyTiPpyaaVX9Ug@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/11/2012 08:37 PM, halli manjunatha wrote:
> On Wed, Jul 11, 2012 at 1:01 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Hans,
>>
>> Thanks for the patch.
>>
>> I've CC-ed Halli as well.
>>
>> On Wed July 11 2012 17:47:34 Hans de Goede wrote:
>>> To allow apps to limit a hw-freq-seek to a specific band, for further
>>> info see the documentation this patch adds for these new fields.
>>>
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>> ---
>>>   .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |   44 ++++++++++++++++----
>>>   include/linux/videodev2.h                          |    5 ++-
>>>   2 files changed, 40 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
>>> index f4db44d..50dc9f8 100644
>>> --- a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
>>> +++ b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
>>> @@ -52,11 +52,21 @@
>>>       <para>Start a hardware frequency seek from the current frequency.
>>>   To do this applications initialize the <structfield>tuner</structfield>,
>>>   <structfield>type</structfield>, <structfield>seek_upward</structfield>,
>>> -<structfield>spacing</structfield> and
>>> -<structfield>wrap_around</structfield> fields, and zero out the
>>> -<structfield>reserved</structfield> array of a &v4l2-hw-freq-seek; and
>>> -call the <constant>VIDIOC_S_HW_FREQ_SEEK</constant> ioctl with a pointer
>>> -to this structure.</para>
>>> +<structfield>wrap_around</structfield>, <structfield>spacing</structfield>,
>>> +<structfield>rangelow</structfield> and <structfield>rangehigh</structfield>
>>> +fields, and zero out the <structfield>reserved</structfield> array of a
>>> +&v4l2-hw-freq-seek; and call the <constant>VIDIOC_S_HW_FREQ_SEEK</constant>
>>> +ioctl with a pointer to this structure.</para>
>>> +
>>> +    <para>The <structfield>rangelow</structfield> and
>>> +<structfield>rangehigh</structfield> fields can be set to a non-zero value to
>>> +tell the driver to search a specific band. If the &v4l2-tuner;
>>> +<structfield>capability</structfield> field has the
>>> +<constant>V4L2_TUNER_CAP_HWSEEK_PROG_LIM</constant> flag set, these values
>>> +must fall within one of the bands returned by &VIDIOC-ENUM-FREQ-BANDS;. If
>>> +the <constant>V4L2_TUNER_CAP_HWSEEK_PROG_LIM</constant> flag is not set,
>>> +then these values must exactly match those of one of the bands returned by
>>> +&VIDIOC-ENUM-FREQ-BANDS;.</para>
>>
>> OK, I have some questions here:
>>
>> 1) If you have a multiband tuner, what should happen if both low and high are
>> zero? Currently it is undefined, other than that the seek should start from
>> the current frequency until it reaches some limit.
>>
>> Halli, what does your hardware do? In particular, is the hwseek limited by the
>> US/Europe or Japan band range or can it do the full range? If I'm not mistaken
>> it is the former, right?
>
> You are right... my hardware seek is limited by the japan/US band range....
>
>> If it is the former, then you need to explicitly set low + high to ensure that
>> the hwseek uses the correct range because the driver can't guess which of the
>> overlapping bands to use.
>
> Yes in my driver I will take care of this :)....

I think you misunderstood Hans here, not the driver but userspace will need
to fill in the rangelow / rangehigh fields of struct v4l2_hw_freq_seek, because if
the current freq is in the overlapping area of the bands, the driver cannot know
which band to seek, so it will just have to guess, I think it is best to just leave
the band at its current setting in that case.

The way the new API works (which was done this way to preserve backward compat)
is that the bands returned from ENUM_BANDS are there as information only. userspace
never explicitly sets a band, so an old app will just see the entire 76-108 MHZ range
in the tuner struct and may do a S_FREQUENCY for any of those frequencies, and the
driver must automatically switch bands when necessary.

With S_HW_FREQ_SEEK we've the 2 new fields to indicate the band to seek for new apps,
but with old apps these fields will be 0, and the driver needs to just pick a band
to search on a best effort basis, for the si470x IE, if no band is specified
in struct v4l2_hw_freq_seek,  I simply always switch to the "Japan wide" band
of 76-108 Mhz as that includes all other bands supported by the si470x.

Regards,

Hans
