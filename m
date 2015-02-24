Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:39193 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753346AbbBXRl5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2015 12:41:57 -0500
Message-ID: <54ECB7DE.2010102@xs4all.nl>
Date: Tue, 24 Feb 2015 18:41:50 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Miguel Casas-Sanchez <mcasas@chromium.org>
CC: linux-media@vger.kernel.org, pawel@osciak.com
Subject: Re: [PATCH v2] Adding NV{12,21} and Y{U,V}12 pixel formats support.
References: <54E547F4.6090309@chromium.org>	<54EC3016.8020407@xs4all.nl> <CAPUS08467gbZp3U22K0mFVEzSq0KBQrFBO_x+pcic4R53zWr5g@mail.gmail.com>
In-Reply-To: <CAPUS08467gbZp3U22K0mFVEzSq0KBQrFBO_x+pcic4R53zWr5g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/24/2015 06:00 PM, Miguel Casas-Sanchez wrote:
> Hi Hans,
> 
> go for it if you feel it's the best approach. Are you planning to add
> multiplanar formats? Particularly, I'm interested in YUV420M and its
> twin evil brother YVU420M.

Certainly. I'm planning to add all those YUV420 variants. Once you have
one working, the others are trivial.

> I would recommend adding support for a less-common format such as
> YUV410 (or variation thereof). Since this format is so different, it
> stresses the added code in revealing ways. I was planning to support
> it as a bonus, but I noticed is not recognised in lib4vl -- neither in
> qv4l2, therefore. Just saying, it'd be cool.

I'll look at it. Is it something you will need? It's a really rare format,
and I don't know if I want to spend a lot of time on it.

Regards,

	Hans

> 
> Cheers
> M
> 
> On 24 February 2015 at 00:02, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> Hi Miguel,
>>
>> Thanks for the patch. However, after reviewing it and testing it
>> I decided to implement my own version. Partially because several
>> features were still failing (crop/compose/scale), partially because
>> I didn't like the way the tpg was changed: too much change basically.
>>
>> Yesterday I added YUV 420 support. It's still work in progress as I
>> am not happy with some of the internal changes and because changing the
>> compose height fails to work at the moment.
>>
>> You can find my preliminary work here:
>>
>> http://git.linuxtv.org/cgit.cgi/hverkuil/media_tree.git/log/?h=vivid-420
>>
>> I plan to continue work on this on Friday and Monday, fixing any
>> remaining bugs, adding support for the other planar formats and
>> carefully reviewing if I handle the downsampling correctly. I also
>> want to add output support for these formats.
>>
>> Regards,
>>
>>         Hans
>>
>> On 02/19/2015 03:18 AM, Miguel Casas-Sanchez wrote:
>>>
>>> This is the second attempt at creating a patch doing
>>> that while respecting the pattern movements, crops,
>>> and other artifacts that can be added to the generated
>>> frames.
>>>
>>> Hope it addresses Hans' comments on the first patch.
>>> It should create properly moving patterns, border,
>>> square and noise. SAV/EAV are left out for the new
>>> formats, but can be pulled in if deemed interesting/
>>> necessary. New formats' descriptions are shorter.
>>> Needless to say, previous formats should work 100%
>>> the same as before.
>>>
>>> Text is, still, printed as Y only. I think the
>>> goal of the text is not pixel-value-based comparisons,
>>> but human reading. Please let me know otherwise.
>>>
>>> It needed quite some refactoring of the original
>>> tpg_fillbuffer() function:
>>> - the internal code generating the video buffer
>>>   line-by-line are factored out into a function
>>>   tpg_fill_oneline(). const added wherever it made
>>>   sense.
>>> - this new tpg_fill_oneline() is used by both
>>>   new functions tpg_fillbuffer_packed() and
>>>   tpg_fillbuffer_planar().
>>> - tpg_fillbuffer_packed() does the non-planar
>>>   formats' buffer composition, so it does, or should
>>>   do, pretty much the same as vivid did before this
>>>   patch.
>>>
>>> Tested via both guvcview and qv4l2, checking formats,
>>> patterns, pattern movements, box and frame checkboxes.
>>>
>>> Hope I managed to get the patch correctly into the mail
>>> i.e. no spurious wraparounds, no whitespaces etc :)
>>>
>>> Signed-off-by: Miguel Casas-Sanchez <mcasas@chromium.org>
>>

