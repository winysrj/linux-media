Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f53.google.com ([209.85.212.53]:51493 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab3ILBLd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 21:11:33 -0400
Received: by mail-vb0-f53.google.com with SMTP id i3so6885593vbh.12
        for <linux-media@vger.kernel.org>; Wed, 11 Sep 2013 18:11:32 -0700 (PDT)
Received: by mail-qe0-f47.google.com with SMTP id b4so6064032qen.6
        for <linux-media@vger.kernel.org>; Wed, 11 Sep 2013 18:11:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201309101117.01044.hverkuil@xs4all.nl>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
 <04c001cead3a$f8ea0dc0$eabe2940$%debski@samsung.com> <522D9065.3040209@samsung.com>
 <201309101117.01044.hverkuil@xs4all.nl>
From: Pawel Osciak <posciak@chromium.org>
Date: Thu, 12 Sep 2013 10:10:49 +0900
Message-ID: <CACHYQ-rTaU5mgQ=p1ARx+PDk8wPR5yVxhJob5hHGxLg8zjne8g@mail.gmail.com>
Subject: Re: [PATCH v1 16/19] v4l: Add encoding camera controls.
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 10, 2013 at 6:17 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Mon 9 September 2013 11:09:57 Sylwester Nawrocki wrote:
>> On 09/09/2013 11:00 AM, Kamil Debski wrote:
>> [...]
>> >>>> We have QP controls separately for H264, H263 and MPEG4. Why is that?
>> >>>> Which one should I use for VP8? Shouldn't we unify them instead?
>> >>>
>> >>> I can't quite remember the details, so I've CCed Kamil since he added
>> >> those controls.
>> >>> At least the H264 QP controls are different from the others as they
>> >>> have a different range. What's the range for VP8?
>> >>
>> >> Yes, it differs, 0-127.
>> >> But I feel this is pretty unfortunate, is it a good idea to multiply
>> >> controls to have one per format when they have different ranges
>> >> depending on the selected format in general? Perhaps a custom handler
>> >> would be better?
>> >>
>> >>> I'm not sure why the H263/MPEG4 controls weren't unified: it might be
>> >>> that since the
>> >>> H264 range was different we decided to split it up per codec. But I
>> >>> seem to remember that there was another reason as well.
>> >
>> > We had a discussion about this on linux-media mailing list. It can be found
>> > here:
>> > http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/32606
>> > In short, it is a mix of two reasons: one - the valid range is different for
>> > different formats and second - implementing controls which have different
>> > min/max values depending on format was not easy.
>>
>> Hmm, these seem pretty vague reasons. And since some time we have support
>> for dynamic control range update [1].
>
> I don't think we should change this. We chose to go with separate controls,
> and we should stick with that. We might do it differently today, but it's
> not a big deal.

I guess I can't reuse MPEG controls as you suggested then. But I could
either create a new VPX class, or keep these ones in camera class and
create separate VPX class later for codecs. It's technically possible
for UVC to have different constraints on some controls though, even if
the codec is the same, potentially creating more confusion...


>
> Regards,
>
>         Hans
>
>>
>> > On the one hand I am thinking that now, when we have more codecs, it would
>> > be better
>> > to have a single control, on the other hand what about backward
>> > compatibility?
>> > Is there a graceful way to merge H263 and H264 QP controls?
>>
>> [1] https://patchwork.linuxtv.org/patch/16436/
>>
>> --
>> Regards,
>> Sylwester
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
