Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4649 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0I1LML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 07:12:11 -0400
Message-ID: <f2f80506fee89bd174661947a5a6016f.squirrel@webmail.xs4all.nl>
In-Reply-To: <AANLkTi=wMWjiY2eNR9wSkWxjKX6d_Awm4J1v57tUDB=s@mail.gmail.com>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF3604CAE3BABC@bssrvexch01.BS.local>
    <AANLkTi=wMWjiY2eNR9wSkWxjKX6d_Awm4J1v57tUDB=s@mail.gmail.com>
Date: Tue, 28 Sep 2010 13:12:00 +0200
Subject: Re: RFC: Introduction of M2M capability and buffer types
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Kyungmin Park" <kmpark@infradead.org>
Cc: "Kamil Debski" <k.debski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	pawel@osciak.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> Any comments?

No, other than what has been discussed on irc:

- Add a new V4L2_CAP_VIDEO_M2M capability instead of ORing CAPTURE and
OUTPUT.
- Don't add aliases, just document better if needed.
- The spec has to change so that M2M devices do not need buffers to be
queued before calling STREAMON. It's an exception to the rule.

I hope I got this right, it's from memory :-)

Regards,

        Hans

>
> On Tue, Sep 14, 2010 at 11:29 PM, Kamil Debski <k.debski@samsung.com>
> wrote:
>> Hello,
>>
>> Mem2mem devices currently use V4L2_CAP_VIDEO_CAPTURE and
>> V4L2_CAP_VIDEO_OUTPUT capabilities. One might expect that a capture
>> device is a camera and an output device can display images. If I
>> remember correct our discussion during the Helsinki v4l2 summit, Hans de
>> Goede has pointed that such devices are listed in applications and can
>> confuse users. The user expects a camera and he has to choose from a
>> long list of devices.
>>
>> The solution to this would be the introduction of two new capability
>> V4L2_CAP_VIDEO_M2M. Such devices would not be listed when user is
>> expected to choose which webcam or TV tuner device to use.
>>
>> Another thing about m2m devices is the naming of buffers:
>> V4L2_BUF_TYPE_VIDEO_CAPTURE means the destination buffer and
>> V4L2_BUF_TYPE_VIDEO_OUTPUT means source. This indeed is confusing, so I
>> think the introduction of two new buffer types is justified. I would
>> recommend V4L2_BUF_TYPE_M2M_SOURCE and V4L2_BUF_TYPE_M2M_DESTINATION to
>> clearly state what is the buffer's purpose.
>>
>> I would be grateful for your comments to this RFC.
>>
>> Best wishes,
>> --
>> Kamil Debski
>> Linux Platform Group
>> Samsung Poland R&D Center
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

