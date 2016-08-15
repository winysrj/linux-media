Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:42992 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbcHOOmn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 10:42:43 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3 09/14] media: platform: pxa_camera: add buffer sequencing
References: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
	<1470684652-16295-10-git-send-email-robert.jarzmik@free.fr>
	<87mvkeqi1q.fsf@belgarion.home>
	<9883272f-cffd-e550-f784-32977bace0c0@xs4all.nl>
Date: Mon, 15 Aug 2016 16:42:38 +0200
In-Reply-To: <9883272f-cffd-e550-f784-32977bace0c0@xs4all.nl> (Hans Verkuil's
	message of "Mon, 15 Aug 2016 15:31:14 +0200")
Message-ID: <87inv2qejl.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> On 08/15/2016 03:26 PM, Robert Jarzmik wrote:
>> Robert Jarzmik <robert.jarzmik@free.fr> writes:
>> I've seen no documentation on the rules applicable to this sequence number:
>>  - should it be reset if a "start streaming" operation occurs ?
>
> start_streaming is the recommended place for setting the counter to 0. It's what
> v4l2-compliance expects.
>
> It is not documented since 1) not every driver does this and 2) there may
> be cases where this behavior is not desired.
>
> That said, I have yet to see a driver where zeroing this in start_streaming
> is not appropriate.

Thanks for the information Hans, I'll modify this patch accordingly.

Cheers.

--
Robert
