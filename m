Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab0AZM3G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2010 07:29:06 -0500
Message-ID: <4B5EE01F.2080702@redhat.com>
Date: Tue, 26 Jan 2010 13:29:19 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC, PATCH] gspca pac7302: propagate footer to userspace
References: <4B5C8172.1090306@freemail.hu>
In-Reply-To: <4B5C8172.1090306@freemail.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Németh,

On 01/24/2010 06:20 PM, Németh Márton wrote:
> Hi,
>
> I'm dealing with Labtec Webcam 2200 and I found that the pac7302 driver does not
> forward the image footer information to userspace. This footer contains some information
> which might be interesting to the userspace. What exactly this footer means is
> not clear as of this writing, but it is easier to analyze the data in
> userspace than in kernel space.
>
> I modified the sd_pkt_scan() in order the footer is transfered to the userspace together
> with the image. This, however, breaks the image decoding in libv4lconvert. This is
> can be easily solved by passing the image buffer to v4lconvert_convert() truncated by
> 0x4f bytes.
>
> What do you think the right way would be to transfer image footer to userspace?

I agree that in retrospect sending the footer to userspace is a good
idea, but see below.

> Is it necessary to add a new V4L2_PIX_FMT_* format in order not to brake userspace
> programs?
>

Yes that is the only sensible way I see to do this, which IMHO is a too high price
to pay for just getting this info out of the kernel while we are not doing anything
with it. Now if we actually find a good use for this in userspace, then I think
we can do this, but until then I think you need to do this with a local
patch.

Regards,

Hans
