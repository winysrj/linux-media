Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:40072 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3LKK3y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 05:29:54 -0500
Message-ID: <52A83E33.9010107@cisco.com>
Date: Wed, 11 Dec 2013 11:28:03 +0100
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: "'Hans Verkuil'" <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>, pawel@osciak.com,
	laurent.pinchart@ideasonboard.com, awalls@md.metrocast.net,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	g.liakhovetski@gmx.de, "'Hans Verkuil'" <hans.verkuil@cisco.com>,
	"'Lad, Prabhakar'" <prabhakar.csengg@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFCv4 PATCH 7/8] vb2: return ENODATA in start_streaming in case
 of too few buffers.
References: <1386596592-48678-1-git-send-email-hverkuil@xs4all.nl> <1386596592-48678-8-git-send-email-hverkuil@xs4all.nl> <52A6C807.6040102@xs4all.nl> <00c101cef65b$8abd4640$a037d2c0$%debski@samsung.com>
In-Reply-To: <00c101cef65b$8abd4640$a037d2c0$%debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On 12/11/13 11:27, Kamil Debski wrote:
> Hi,
> 
>> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>> Sent: Tuesday, December 10, 2013 8:52 AM
>>
>> As Guennadi mentioned in his review, ENODATA will be replaced by
>> ENOBUFS, which is more appropriate.
>>
>> Prabhakar, Kamil, Tomasz, are you OK with this patch provided
>> s/ENODATA/ENOBUFS/ ?
> 
> The patch looks good. However, shouldn't the documentation be changed too?
> 
> Now it says: [1]
> "(...) Accordingly the output hardware is disabled, no video signal is
> produced until VIDIOC_STREAMON has been called. The ioctl will succeed
> only when at least one output buffer is in the incoming queue. (...)"
> 
> If I understand correctly, now the ioctl will succeed with no buffers
> queued.

That's true *only* for drivers using vb2. As long as not all drivers are
converted (which is a *very* long-term project) I don't think i can change
the documentation.

Regards,

	Hans

> Apart from the above you have my ack.
> 
> Acked-by: Kamil Debski <k.debski@samsung.com>
> 
> Best wishes,
> 
