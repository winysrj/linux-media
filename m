Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50096 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab2JCRlV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 13:41:21 -0400
Received: by bkcjk13 with SMTP id jk13so6290910bkc.19
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2012 10:41:20 -0700 (PDT)
Message-ID: <506C6AB0.2010608@googlemail.com>
Date: Wed, 03 Oct 2012 19:41:20 +0300
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: hverkuil@xs4all.nl
CC: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
Subject: Re: qv4l2-bug / libv4lconvert API issue
References: <50636DD2.3070508@googlemail.com> <506816EF.90001@redhat.com> <506C11F8.7090105@googlemail.com> <201210031432.39578.hverkuil@xs4all.nl>
In-Reply-To: <201210031432.39578.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 03.10.2012 15:32, schrieb Hans Verkuil:
> On Wed 3 October 2012 12:22:48 Frank Schäfer wrote:
>> Hi Hans,
>>
>> Am 30.09.2012 11:54, schrieb Hans de Goede:
>>> Hi,
>>>
>>> On 09/28/2012 07:09 PM, Frank Schäfer wrote:
>>>> Hi,
>>>>
>>>> Am 27.09.2012 21:41, schrieb Hans de Goede:
>>>>> Hi,
>>>>>
>>>>> On 09/27/2012 03:20 PM, Frank Schäfer wrote:
>>>>>
>>>>> <snip>
>>>>>
>>>>>>> What you've found is a qv4l2 bug (do you have the latest version?)
>>>>>> Of course, I'm using the latest developer version.
>>>>>>
>>>>>> Even if this is just a qv4l2-bug: how do you want to fix it without
>>>>>> removing the format selction feature ?
>>>>> Well, if qv4l2 can only handle rgb24 data, then it should gray out the
>>>>> format selection (fixing it at rgb24) when not in raw mode.
>>>> So you say "just remove this feature from qv4l2".
>>>> I prefer fixing the library / API instead.
>>> No I'm suggesting to keep the feature to select which input format
>>> to use when in raw mode, while at the same time disabling the feature)
>>> when in libv4l2 mode. What use is it to ask libv4l2 for say YUV420 data
>>> and then later ask libv4lconvert to convert this to RGB24, when you could
>>> have asked libv4l2 for RGB24 right away.
>> I assume the idea behind input format selction when using libv4l2 is to
>> provide a possibilty to test libv4l2 ?
> The main reason why I show all formats is that the driver reports all these
> formats, so one should be able to select them in order to test the driver.
>
> And I'm using libv4l2convert so that I can actually see a picture. For formats
> like MPEG that are unsupported by libv4l2convert I just dump the 'image' as is.

Yes, but for pure testing of the driver output formats, it is better to
open the device in raw mode and convert the picture for GUI-output with
a v4lconvert_convert() call.

> It is counterintuitive if a YUV format is converted to a proper picture using
> qv4l2 -r, but that it is all wrong with qv4l2.

I'm not sure I understand what you mean...

Regards,
Frank

> I'm all for improving the library.
>
> Regards,
>
> 	Hans

