Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:57639 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbbBXTEQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2015 14:04:16 -0500
Received: by mail-vc0-f172.google.com with SMTP id kv7so10625646vcb.3
        for <linux-media@vger.kernel.org>; Tue, 24 Feb 2015 11:04:16 -0800 (PST)
Received: from mail-vc0-f179.google.com (mail-vc0-f179.google.com. [209.85.220.179])
        by mx.google.com with ESMTPSA id l6sm322137vdl.7.2015.02.24.11.04.14
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Feb 2015 11:04:15 -0800 (PST)
Received: by mail-vc0-f179.google.com with SMTP id hy4so10794043vcb.10
        for <linux-media@vger.kernel.org>; Tue, 24 Feb 2015 11:04:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54ECB7DE.2010102@xs4all.nl>
References: <54E547F4.6090309@chromium.org>
	<54EC3016.8020407@xs4all.nl>
	<CAPUS08467gbZp3U22K0mFVEzSq0KBQrFBO_x+pcic4R53zWr5g@mail.gmail.com>
	<54ECB7DE.2010102@xs4all.nl>
Date: Tue, 24 Feb 2015 11:04:14 -0800
Message-ID: <CAPUS0854gttyWU9Xaro5AZW_ECx3V+gTd48yO3z=74gLiriryQ@mail.gmail.com>
Subject: Re: [PATCH v2] Adding NV{12,21} and Y{U,V}12 pixel formats support.
From: Miguel Casas-Sanchez <mcasas@chromium.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24 February 2015 at 09:41, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 02/24/2015 06:00 PM, Miguel Casas-Sanchez wrote:
>> Hi Hans,
>>
>> go for it if you feel it's the best approach. Are you planning to add
>> multiplanar formats? Particularly, I'm interested in YUV420M and its
>> twin evil brother YVU420M.
>
> Certainly. I'm planning to add all those YUV420 variants. Once you have
> one working, the others are trivial.

Hooray!

>
>> I would recommend adding support for a less-common format such as
>> YUV410 (or variation thereof). Since this format is so different, it
>> stresses the added code in revealing ways. I was planning to support
>> it as a bonus, but I noticed is not recognised in lib4vl -- neither in
>> qv4l2, therefore. Just saying, it'd be cool.
>
> I'll look at it. Is it something you will need? It's a really rare format,
> and I don't know if I want to spend a lot of time on it.
>

Not particularly high need no; moreover the high downsampling makes
it look visually awful. I just found it was good to stretch assumptions in
the code such as missed hardcoded loop boundaries etc. It'd be a
nice-to-have. Like I said, it also depends on adding support for it in
libv4l (typo before).

> Regards,
>
>         Hans
>
>>
>> Cheers
>> M
>>
>> On 24 February 2015 at 00:02, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>
>>> Hi Miguel,
>>>
>>> Thanks for the patch. However, after reviewing it and testing it
>>> I decided to implement my own version. Partially because several
>>> features were still failing (crop/compose/scale), partially because
>>> I didn't like the way the tpg was changed: too much change basically.
>>>
>>> Yesterday I added YUV 420 support. It's still work in progress as I
>>> am not happy with some of the internal changes and because changing the
>>> compose height fails to work at the moment.
>>>
>>> You can find my preliminary work here:
>>>
>>> http://git.linuxtv.org/cgit.cgi/hverkuil/media_tree.git/log/?h=vivid-420
>>>
>>> I plan to continue work on this on Friday and Monday, fixing any
>>> remaining bugs, adding support for the other planar formats and
>>> carefully reviewing if I handle the downsampling correctly. I also
>>> want to add output support for these formats.
>>>
>>> Regards,
>>>
>>>         Hans
>>>
>>> On 02/19/2015 03:18 AM, Miguel Casas-Sanchez wrote:
>>>>
>>>> This is the second attempt at creating a patch doing
>>>> that while respecting the pattern movements, crops,
>>>> and other artifacts that can be added to the generated
>>>> frames.
>>>>
>>>> Hope it addresses Hans' comments on the first patch.
>>>> It should create properly moving patterns, border,
>>>> square and noise. SAV/EAV are left out for the new
>>>> formats, but can be pulled in if deemed interesting/
>>>> necessary. New formats' descriptions are shorter.
>>>> Needless to say, previous formats should work 100%
>>>> the same as before.
>>>>
>>>> Text is, still, printed as Y only. I think the
>>>> goal of the text is not pixel-value-based comparisons,
>>>> but human reading. Please let me know otherwise.
>>>>
>>>> It needed quite some refactoring of the original
>>>> tpg_fillbuffer() function:
>>>> - the internal code generating the video buffer
>>>>   line-by-line are factored out into a function
>>>>   tpg_fill_oneline(). const added wherever it made
>>>>   sense.
>>>> - this new tpg_fill_oneline() is used by both
>>>>   new functions tpg_fillbuffer_packed() and
>>>>   tpg_fillbuffer_planar().
>>>> - tpg_fillbuffer_packed() does the non-planar
>>>>   formats' buffer composition, so it does, or should
>>>>   do, pretty much the same as vivid did before this
>>>>   patch.
>>>>
>>>> Tested via both guvcview and qv4l2, checking formats,
>>>> patterns, pattern movements, box and frame checkboxes.
>>>>
>>>> Hope I managed to get the patch correctly into the mail
>>>> i.e. no spurious wraparounds, no whitespaces etc :)
>>>>
>>>> Signed-off-by: Miguel Casas-Sanchez <mcasas@chromium.org>
>>>
>
