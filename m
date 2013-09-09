Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18818 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3IIJKC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Sep 2013 05:10:02 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MSU00M12PGH5Y40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Sep 2013 10:10:00 +0100 (BST)
Message-id: <522D9065.3040209@samsung.com>
Date: Mon, 09 Sep 2013 11:09:57 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Kamil Debski <k.debski@samsung.com>
Cc: 'Pawel Osciak' <posciak@chromium.org>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	linux-media@vger.kernel.org,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v1 16/19] v4l: Add encoding camera controls.
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
 <1377829038-4726-17-git-send-email-posciak@chromium.org>
 <52204058.6070008@xs4all.nl>
 <CACHYQ-oGaAS1TVLqm-wRsPSg5xDqBTuvj9PcMAmu5vEc-aVb1A@mail.gmail.com>
 <522D7E3E.8070104@xs4all.nl>
 <CACHYQ-ph7eBPkr38c__Wpr_ixPChQQi5tYJENrR3GAfyDzcThQ@mail.gmail.com>
 <04c001cead3a$f8ea0dc0$eabe2940$%debski@samsung.com>
In-reply-to: <04c001cead3a$f8ea0dc0$eabe2940$%debski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/09/2013 11:00 AM, Kamil Debski wrote:
[...]
>>>> We have QP controls separately for H264, H263 and MPEG4. Why is that?
>>>> Which one should I use for VP8? Shouldn't we unify them instead?
>>>
>>> I can't quite remember the details, so I've CCed Kamil since he added
>> those controls.
>>> At least the H264 QP controls are different from the others as they
>>> have a different range. What's the range for VP8?
>>
>> Yes, it differs, 0-127.
>> But I feel this is pretty unfortunate, is it a good idea to multiply
>> controls to have one per format when they have different ranges
>> depending on the selected format in general? Perhaps a custom handler
>> would be better?
>>
>>> I'm not sure why the H263/MPEG4 controls weren't unified: it might be
>>> that since the
>>> H264 range was different we decided to split it up per codec. But I
>>> seem to remember that there was another reason as well.
> 
> We had a discussion about this on linux-media mailing list. It can be found
> here:
> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/32606
> In short, it is a mix of two reasons: one - the valid range is different for
> different formats and second - implementing controls which have different
> min/max values depending on format was not easy.

Hmm, these seem pretty vague reasons. And since some time we have support
for dynamic control range update [1].

> On the one hand I am thinking that now, when we have more codecs, it would
> be better
> to have a single control, on the other hand what about backward
> compatibility?
> Is there a graceful way to merge H263 and H264 QP controls?

[1] https://patchwork.linuxtv.org/patch/16436/

--
Regards,
Sylwester
