Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3892 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164Ab1ERPWk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 11:22:40 -0400
Message-ID: <16ed9ac8f44869af2d6ff7cded1c0023.squirrel@webmail.xs4all.nl>
In-Reply-To: <004501cc1569$58a24280$09e6c780$%debski@samsung.com>
References: <003801cc14ae$be448b90$3acda2b0$%debski@samsung.com>
    <201105181610.13231.laurent.pinchart@ideasonboard.com>
    <004501cc1569$58a24280$09e6c780$%debski@samsung.com>
Date: Wed, 18 May 2011 17:22:33 +0200
Subject: RE: Codec controls question
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Kamil Debski" <k.debski@samsung.com>
Cc: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, hansverk@cisco.com,
	"Marek Szyprowski" <m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
>> Sent: 18 May 2011 16:10
>> Subject: Re: Codec controls question
>>
>> On Tuesday 17 May 2011 18:23:19 Kamil Debski wrote:
>> > Hi,
>
> Hi,
>
>> >
>> > Some time ago we were discussing the set of controls that should be
>> > implemented for codec support.
>> >
>> > I remember that the result of this discussion was that the controls
>> should
>> > be as "integrated" as possible. This included the V4L2_CID_MPEG_LEVEL
>> and
>> > all controls related to the quantization parameter.
>> > The problem with such approach is that the levels are different for
>> MPEG4,
>> > H264 and H263. Same for quantization parameter - it ranges from 1 to
>> 31
>> > for MPEG4/H263 and from 0 to 51 for H264.
>> >
>> > Having single controls for the more than one codec seemed as a good
>> > solution. Unfortunately I don't see a good option to implement it,
>> > especially with the control framework. My idea was to have the min/max
>> > values for QP set in the S_FMT call on the CAPTURE. For MPEG_LEVEL it
>> > would be checked in the S_CTRL callback and if it did not fit the
>> chosen
>> > format it failed.
>> >
>> > So I see three solutions to this problem and I wanted to ask about
>> your
>> > opinion.
>> >
>> > 1) Have a separate controls whenever the range or valid value range
>> > differs.
>> >
>> > This is the simplest and in my opinion the best solution I can think
>> of.
>> > This way we'll have different set of controls if the valid values are
>> > different (e.g. V4L2_CID_MPEG_MPEG4_LEVEL, V4L2_CID_MPEG_H264_LEVEL).
>> > User can set the controls at any time. The only con of this approach
>> is
>> > having more controls.
>> >
>> > 2) Permit the user to set the control only after running S_FMT on the
>> > CAPTURE. This approach would enable us to keep less controls, but
>> would
>> > require to set the min/max values for controls in the S_FMT. This
>> could be
>> > done by adding controls in S_FMT or by manipulating their range and
>> > disabling unused controls. In case of MPEG_LEVEL it would require
>> s_ctrl
>> > callback to check whether the requested level is valid for the chosen
>> > codec.
>> >
>> > This would be somehow against the spec, but if we allow the "codec
>> > interface" to have some differences this would be ok.
>> >
>> > 3) Let the user set the controls whenever and check them during the
>> > STREAMON call.
>> >
>> > The controls could be set anytime, and the control range supplied to
>> the
>> > control framework would cover values possible for all supported
>> codecs.
>> >
>> > This approach is more difficult than first approach. It is worse in
>> case
>> of
>> > user space than the second approach - the user is unaware of any
>> mistakes
>> > until the STREAMON call. The argument for this approach is the
>> possibility
>> > to have a few controls less.
>> >
>> > So I would like to hear a comment about the above propositions.
>> Personally
>> > I would opt for the first solution.
>>
>> I think the question boils down to whether we want to support controls
>> that
>> have different valid ranges depending on formats, or even other
>> controls. I
>> think the issue isn't specific to codoc controls.
>>
>
> So what is your opinion on this? If there are more controls where the
> valid
> range could depend on other controls or the chosen format then it might be
> worth
> implementing such functionality. If there would be only a few such
> controls then
> it might be better to just have separate controls (with the codec controls
> - only
> *_MPEG_LEVEL and quantization parameter related controls would have
> different
> valid range depending on the format).

I have experimented with control events to change ranges and while it can
be done technically it is in practice a bit of a mess. I think personally
it is just easier to have separate controls.

We are going to have similar problems if different video inputs are
controlled by different i2c devices with different (but partially
overlapping) controls. So switching an input also changes the controls. I
have experimented with this while working on control events and it became
very messy indeed. I won't do this for the first version of control
events.

One subtle but real problem with changing control ranges on the fly is
that it makes it next to impossible to save all control values to a file
and restore them later. That is a desirable feature that AFAIK is actually
in use already.

Regards,

        Hans

