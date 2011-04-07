Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1977 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab1DGJ3F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 05:29:05 -0400
Message-ID: <67d14bc84cde1153c035ddff7efdcb8f.squirrel@webmail.xs4all.nl>
In-Reply-To: <201104071117.59995.laurent.pinchart@ideasonboard.com>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
    <Pine.LNX.4.64.1104070914540.24325@axis700.grange>
    <058f16a20d747a5ef6b300e119fa69b4.squirrel@webmail.xs4all.nl>
    <201104071117.59995.laurent.pinchart@ideasonboard.com>
Date: Thu, 7 Apr 2011 11:28:57 +0200
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size
 videobuffer management
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Hans Verkuil" <hansverk@cisco.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Hi Hans,
>
> On Thursday 07 April 2011 09:50:13 Hans Verkuil wrote:
>> > On Thu, 7 Apr 2011, Hans Verkuil wrote:
>
> [snip]
>
>> >> Regarding DESTROY_BUFS: perhaps we should just skip this for now and
>> wait
>> >> for the first use-case. That way we don't need to care about holes. I
>> >> don't like artificial restrictions like 'no holes'. If someone has a
>> good
>> >> use-case for selectively destroying buffers, then we need to look at
>> this
>> >> again.
>> >
>> > Sorry, skip what? skip the ioctl completely and rely on REQBUFS(0) /
>> > close()?
>>
>> Yes.
>
> I don't really like that as it would mix CREATE and REQBUFS calls.
> Applications should either use the old API (REQBUFS) or the new one, but
> not
> mix both.

That's a completely unnecessary limitation. And from the point of view of
vb2 it shouldn't even matter.

> The fact that freeing arbitrary spans of buffers gives us uneasy feelings
> might be a sign that the CREATE/DESTROY API is not mature enough. I'd
> rather
> try to solve the issue now instead of postponing it for later and discover
> that our CREATE API should have been different.

What gives me an uneasy feeling is prohibiting freeing arbitrary spans of
buffers. I rather choose not to implement the DESTROY ioctl instead of
implementing a limited version of it, also because we do not have proper
use cases yet. But I have no problems with the CREATE/DESTROY API as such.

Regards,

       Hans

