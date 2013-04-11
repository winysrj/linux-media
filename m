Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16694 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3DKMjz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 08:39:55 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ML300K3NCG7DV90@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Apr 2013 13:39:54 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, 'Tzu-Jung Lee' <roylee17@gmail.com>
References: <201304111140.48548.hverkuil@xs4all.nl>
In-reply-to: <201304111140.48548.hverkuil@xs4all.nl>
Subject: RE: Exact behavior of the EOS event?
Date: Thu, 11 Apr 2013 14:39:44 +0200
Message-id: <04b201ce36b1$a6bda200$f438e600$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Thursday, April 11, 2013 11:41 AM
> To: k.debski@samsung.com
> Cc: linux-media@vger.kernel.org; Tzu-Jung Lee
> Subject: Exact behavior of the EOS event?
> 
> Hi Kamil, Roy,
> 
> When implementing eos support in v4l2-ctl I started wondering about the
> exact timings of that.
> 
> There are two cases, polling and non-polling, and I'll explain how I do
> it now in v4l2-ctl.
> 
> Polling case:
> 
> I select for both read and exceptions. When the select returns I check
> for exceptions and call DQEVENT, which may return EOS.
> 
> If there is something to read then I call DQBUF to get the frame,
> process it and afterwards exit the capture loop if the EOS event was
> seen.
> 
> This procedure assumes that setting the event and making the last frame
> available to userspace happen atomically, otherwise you can get a race
> condition.
> 
> Non-polling case:
> 
> I select for an exception with a timeout of 0 (i.e. returns
> immediately), then I call DQBUF (which may block), process the frame
> and exit if EOS was seen.
> 
> I suspect this is wrong, since when I call select the EOS may not be
> set yet, but it is after the DQBUF. So in the next run through the
> capture loop I capture one frame too many.
> 
> 
> What I think is the correct sequence is to first select for a read(),
> but not exceptions, then do the DQBUF, and finally do a select for
> exceptions with a timeout of 0. If EOS was seen, then that was the last
> frame.
> 
> A potential problem with that might be when you want to select on other
> events as well. Then you would select on both read and exceptions, and
> we end up with a potential race condition again. The only solution I
> see is to open a second filehandle to the video node and subscribe to
> the EOS event only for that filehandle and use that to do the EOS
> polling.

This would work if we have a single context only. In case of mem2mem
devices, where there is a separate context for each file this would not
work.

> 
> It all feels rather awkward.
> 
> Kamil, Roy, any ideas/suggestions to improve this?
> 
> Regards,
> 
> 	Hans

-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


