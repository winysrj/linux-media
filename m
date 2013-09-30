Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:38905 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3I3AFK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Sep 2013 20:05:10 -0400
Received: by mail-la0-f42.google.com with SMTP id ep20so3851904lab.15
        for <linux-media@vger.kernel.org>; Sun, 29 Sep 2013 17:05:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1379579401.4224.7.camel@pizza.hi.pengutronix.de>
References: <1379576249-16909-1-git-send-email-p.zabel@pengutronix.de>
 <CAMm-=zAYwHRu61dAPrQZq4ghw6pfL=nG-A1iCkLSGJOvBkpgkQ@mail.gmail.com> <1379579401.4224.7.camel@pizza.hi.pengutronix.de>
From: Pawel Osciak <pawel@osciak.com>
Date: Mon, 30 Sep 2013 09:04:28 +0900
Message-ID: <CAMm-=zC2V7fAv3sfHj3HNXR94i65C5qrSeHpsWa8WUWDp2a+AQ@mail.gmail.com>
Subject: Re: [PATCH] [media] videobuf2-core: call __setup_offsets only for
 mmap memory type
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Michael Olbrich <m.olbrich@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Philipp.

Acked-by: Pawel Osciak <pawel@osciak.com>


On Thu, Sep 19, 2013 at 5:30 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Hi Pawel,
>
> Am Donnerstag, den 19.09.2013, 16:54 +0900 schrieb Pawel Osciak:
>> On Thu, Sep 19, 2013 at 4:37 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
>> > __setup_offsets fills the v4l2_planes' mem_offset fields, which is only valid
>> > for V4L2_MEMORY_MMAP type buffers. For V4L2_MEMORY_DMABUF and _USERPTR buffers,
>> > this incorrectly overwrites the fd and userptr fields.
>>
>> I'm not particularly against this change, but I'm curious if anything
>> that you were doing was broken by this call? The buffers are created
>> here, so their fields don't contain anything that could be overwritten
>> (although keeping them at 0 is preferable).
>
> nothing was actually broken, but even though the spec doesn't say
> anything about the QUERYBUF return values in the DMABUF/USERPTR cases,
> setting them to some random initial value doesn't seem right.
>
> Maybe the documentation could be amended to mention fd and userptr,
> although in this case the fd should probably be set to -1 initially.
> QUERYBUF could then be used to find free slots.
>
> regards
> Philipp
>



-- 
Best regards,
Pawel Osciak
