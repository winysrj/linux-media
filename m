Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48966 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaDVHea (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Apr 2014 03:34:30 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Pawel Osciak' <posciak@chromium.org>,
	'Arun Kumar K' <arunkk.samsung@gmail.com>
Cc: linux-media@vger.kernel.org,
	'linux-samsung-soc' <linux-samsung-soc@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
References: <1398072362-24962-1-git-send-email-arun.kk@samsung.com>
 <1398072362-24962-2-git-send-email-arun.kk@samsung.com>
 <CACHYQ-qE4Qnwa9txUsx=MSM4NRG6HrDxqp=qOJUzCPv6uf9egw@mail.gmail.com>
 <CALt3h7--QSL-UD=mAa5NPvy8UUeZB02o097y_+LqZTp2mXD5Pg@mail.gmail.com>
 <CACHYQ-p564-HHpx0mY6rcq+Mg3kPp24pvfk2_MH7Vf5U0ygSOw@mail.gmail.com>
In-reply-to: <CACHYQ-p564-HHpx0mY6rcq+Mg3kPp24pvfk2_MH7Vf5U0ygSOw@mail.gmail.com>
Subject: RE: [PATCH v2 1/2] v4l: Add resolution change event.
Date: Tue, 22 Apr 2014 09:34:32 +0200
Message-id: <042601cf5dfd$4dfa44b0$e9eece10$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

> From: Pawel Osciak [mailto:posciak@chromium.org]
> Sent: Monday, April 21, 2014 12:27 PM
> To: Arun Kumar K
> Cc: linux-media@vger.kernel.org; linux-samsung-soc; Kamil Debski;
> Sylwester Nawrocki; Hans Verkuil; Laurent Pinchart
> Subject: Re: [PATCH v2 1/2] v4l: Add resolution change event.
> 
> As a side note, because this is not really codified in the API, I would
> like this event to indicate not only resolution change mid-stream, but
> also detection of initial resolution, which should be a subset of
> resolution change. I think this would make sense for the codec
> interface:
> 
> Video decode:
> 1. S_FMT to given codec on OUTPUT queue.
> 2. REQBUFS(n) and STREAMON on OUTPUT queue.
> 3. Keep QBUFing until we get an resolution change event on the CAPTURE
> queue; until then, the driver/codec HW will operate on the OUTPUT queue
> only and try to detect relevant headers in the OUTPUT buffers, and will
> send resolution change event once it finds resolution, profile, etc.
> info). DQEVENT.
> 4. G_FMT on CAPTURE to get the discovered output format (resolution),
> REQBUFS and STREAMON on the CAPTURE queue.
> 5. Normal mem-to-mem decoding.
> 6. If a resolution change event arrives on CAPTURE queue, DQEVENT,
> STREAMOFF, REQBUFS(0) only on CAPTURE queue, and goto 4. OUTPUT queue
> operates completely independently of this.
> 
> Also, this event should invariably indicate all of the below:
> - all output buffers from before resolution change are already ready on
> the CAPTURE queue to DQBUF (so it's ready to REQBUFS(0) after DQBUFs),
> and
> - there will be no more new ready buffers on the CAPTURE queue until
> the streamoff-reqbufs(0)-g_fmt-reqbufs()-streamon is performed, and
> - OUTPUT queue is completely independent of all of the above and can be
> still used as normal, i.e. stream buffers can still keep being queued
> at any stage of the resolution change and they will be decoded after
> resolution change sequence is finished;
> 
> If we all agree to the above, I will prepare a subsequent patch for the
> documentation to include the above.

If I understand correctly this will keep the old application working.
By this I mean application that do not use events and rely on the current
mechanism to detect initial header parsing and resolution change.

If backward compatibility is kept I am all for the changes proposed by you.

> 
> Thanks,
> Pawel

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

