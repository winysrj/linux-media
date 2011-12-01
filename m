Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab1LALsb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Dec 2011 06:48:31 -0500
Message-ID: <4ED7698C.4070602@redhat.com>
Date: Thu, 01 Dec 2011 09:48:28 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hamad Kadmany <hkadmany@codeaurora.org>
CC: linux-media@vger.kernel.org
Subject: Re: Support for multiple section feeds with same PIDs
References: <001101ccae6d$9900b350$cb0219f0$@org> <000001ccaff1$cb1cc060$61564120$@org>
In-Reply-To: <000001ccaff1$cb1cc060$61564120$@org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01-12-2011 04:23, Hamad Kadmany wrote:
> Hi,
>
> Sorry to repeat the question, anyone has an idea on this? I appreciate your
> feedback.
>
> Thank you
> Hamad
>
> -----Original Message-----
> From: linux-media-owner@vger.kernel.org
> [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Hamad Kadmany
> Sent: Tuesday, November 29, 2011 10:05 AM
> To: linux-media@vger.kernel.org
> Subject: Support for multiple section feeds with same PIDs
>
> Hello
>
> Question on the current behavior of dvb_dmxdev_filter_start (dmxdev.c)
>
> In case of DMXDEV_TYPE_SEC, the code restricts of having multiple sections
> feeds allocated (allocate_section_feed) with same PID. From my experience,
> applications might request allocating several section feeds using same PID
> but with different filters (for example, in DVB standard, SDT and BAT tables
> have same PID).
>
> The current implementation only supports of having multiple filters on the
> same section feed.
>
> Any special reason why it was implemented this way?

Eventually, you might be able to find some reason by digging into the patches
that introduced such feature. If this went before 2.6.12-rc2, you'll need to
take a look at the Linux history git trees or at the mercurial tree.

In any case, if you need to extend it to support multiple sections, just
propose a patch extending it, yet maintaining backward compatibility with the
existing behavior.

Regards,
Mauro.

>
> Thank you
> Hamad
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

