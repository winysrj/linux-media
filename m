Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B12BC43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 011FC21939
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732584AbeLVRLn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 12:11:43 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:38558 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731640AbeLVRLn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 12:11:43 -0500
Received: from [IPv6:2001:983:e9a7:1:a083:659e:88da:d180] ([IPv6:2001:983:e9a7:1:a083:659e:88da:d180])
        by smtp-cloud9.xs4all.net with ESMTPA
        id aerrgkVyaMlDTaersgyWbH; Sat, 22 Dec 2018 11:50:52 +0100
Subject: Re: [PATCH v4l-utils] v4l2-ctl: Add support for CROP selection in m2m
 streaming
To:     Dafna Hirschfeld <dafna3@gmail.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        helen.koike@collabora.com
References: <20181218111140.90645-1-dafna3@gmail.com>
 <603cad44-4a52-73d1-3ad5-5474ee549977@xs4all.nl>
 <CAJ1myNRieZveHD95YBXiLx6Ka6pDBrW8Cvmh0Nvxt1f=YDDUyg@mail.gmail.com>
 <a0e7ade6-d3e4-132a-0629-4fb6a4b664b2@xs4all.nl>
 <CAJ1myNT_8mrQOE+o7auzAibG+Tn_zjUobMtMUtBFW55yF72zcA@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5a0a823c-a459-afa6-519c-77756355b1c1@xs4all.nl>
Date:   Sat, 22 Dec 2018 11:50:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <CAJ1myNT_8mrQOE+o7auzAibG+Tn_zjUobMtMUtBFW55yF72zcA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGumHqqD2xmo6Mwph6AUQOJKu+gELe9shbtLsuCYLPp+B/HcGpm+QOxz2PUqqluKIrwebcQ+yK2nNxRvINPIVMsvwS49QreibeplWegkQYns+hcE0YAy
 8aB/F9Eadd8WyCfc0kM9965UUNtTufixeQNZ1kem0Kp+x0hdEakzKgLGdHDGDA8S3+CFmJIiXO5rc5YBlXVBff2et21HKaYXL1IuarujaBwsfPCfhiXiTR+e
 oJ3ZIMlzOCAL8Z4Vqnbz1U/DSiOByW9XshfIcLza9Xlv4L1IwdoNqnnB62NLXlIz53onRFXgfeVTAeDGxMx9wy7uC/fx1TtlKHpw9FZwzeE=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/22/18 10:03 AM, Dafna Hirschfeld wrote:
> On Wed, Dec 19, 2018 at 12:03 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> Yes, but those values are used in ioctl calls to the driver, so rather
>> than using those values you query the driver.
>>
>>> They are needed in order to
>>> read raw frames line by line for the encoder.
>>
>> Why not call G_FMT and G_SELECTION(TGT_CROP) to obtain that information?
>>
> The way vicodec is now implemented is that it does not hold the
> original width/height given in S_FMT but the coded once.
> But the userspace still needs these values in order to read raw frames
> from the file.
> Not sure how to solve it.

When running v4l2-ctl you have to set both the width and height with the
-x option, AND you set the selection crop rectangle to that same width and height.

So the selection crop rectangle has the actual visible width and height.

In fact, for a video output device in general you can call G_SELECTION(TGT_CROP)
and use the returned width and height when reading from the file, or (if not
supported) you use the width and height returned by G_FMT.

> Why does the userspace encoder need to query this values from the
> driver ? Since these are raw frames the userspace
> should already know the dimensions.

This assumes that the user explicitly provides the visible width and height,
but that doesn't have to be the case. In which case the drivers values should
be used.

Also, m2m devices are special in that the configuration is stored per-filehandle,
but that is not case for regular capture and output devices: the configuration is
per device in that case, so you can set the width and height with v4l2-ctl and
then in a new v4l2-ctl command query the width and height and you'll get back the
width and height you set previously. Just try this with e.g. vivid and vim2m and
see the difference in behavior.

BTW, right now when we set the output width and height for the encoder with the -x
option we do not set the CROP rectangle with that width and height, we only clamp
any existing rectangle.

This is right according to the current V4L2 spec, but it is not clear if this
behavior makes sense for codecs. In the new year this is something we should discuss
with others. Perhaps S_FMT for an encoder should automatically set the CROP target
for the output as well using the original S_FMT width and height.

Regards,

	Hans

> 
> Dafna
> 
>> Please note that all the set and get options are all processed before the
>> streaming options. So when you start streaming the driver is fully configured.
>>
>>> Maybe I can implement it by calling 'parse_fmt' in 'stream_cmd'
>>> function similar to how 'vidout_cmd' do it.
>>>
>>> https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-ctl/v4l2-ctl-vidout.cpp#n90
>>>
>>>
>>>> Remember that you can call v4l2-ctl without setting the output width and height
>>>> if the defaults that the driver sets are already fine. In that case the width and height
>>>> variables in this source are just 0.
>>>>
>>>>> +
>>>>>  void vidout_list(cv4l_fd &fd)
>>>>>  {
>>>>>       if (options[OptListOutFormats]) {
>>>>> diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
>>>>> index 5a52a0a4..ab2994b2 100644
>>>>> --- a/utils/v4l2-ctl/v4l2-ctl.h
>>>>> +++ b/utils/v4l2-ctl/v4l2-ctl.h
>>>>> @@ -357,6 +357,8 @@ void vidout_cmd(int ch, char *optarg);
>>>>>  void vidout_set(cv4l_fd &fd);
>>>>>  void vidout_get(cv4l_fd &fd);
>>>>>  void vidout_list(cv4l_fd &fd);
>>>>> +void vidcap_get_orig_from_set(unsigned int &r_width, unsigned int &r_height);
>>>>> +void vidout_get_orig_from_set(unsigned int &r_width, unsigned int &r_height);
>>>>>
>>>>>  // v4l2-ctl-overlay.cpp
>>>>>  void overlay_usage(void);
>>>>>
>>>>
>>>> This patch needs more work (not surprisingly, since it takes a bit of time to
>>>> understand the v4l2-ctl source code).
>>>>
>>>> Please stick to the kernel coding style! Using a different style makes it harder
>>>> for me to review since my pattern matches routines in my brain no longer work
>>>> optimally. It's like reading text with spelling mistakes, you cn stil undrstant iT,
>>>> but it tekes moore teem. :-)
>>>>
>>> okei :)
>>>
>>>> Regards,
>>>>
>>>>         Hans
>>
>> Regards,
>>
>>         Hans

