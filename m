Return-path: <linux-media-owner@vger.kernel.org>
Received: from fortimail.online.lv ([81.198.164.220]:41818 "EHLO
	fortimail.online.lv" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbbAMRzv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 12:55:51 -0500
Received: from mailo-proxy2.online.lv (smtp.online.lv [81.198.164.193])
	by fortimail.online.lv  with ESMTP id t0DHtmNV001938-t0DHtmNW001938
	for <linux-media@vger.kernel.org>; Tue, 13 Jan 2015 19:55:48 +0200
Message-ID: <54B55C23.1070409@apollo.lv>
Date: Tue, 13 Jan 2015 19:55:47 +0200
From: Raimonds Cicans <ray@apollo.lv>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>, gtmkramer@xs4all.nl
Subject: Re: [PATCH] cx23885/vb2 regression: please test this patch
References: <54B52548.7010109@xs4all.nl>
In-Reply-To: <54B52548.7010109@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.01.2015 16:01, Hans Verkuil wrote:
> Hi Raimonds, Jurgen,
>
> Can you both test this patch? It should (I hope) solve the problems you
> both had with the cx23885 driver.
>
> This patch fixes a race condition in the vb2_thread that occurs when
> the thread is stopped. The crucial fix is calling kthread_stop much
> earlier in vb2_thread_stop(). But I also made the vb2_thread more
> robust.

With this patch I am unable to get any error except first
(AMD-Vi: Event logged [IO_PAGE_FAULT...).
But I am not convinced, because before patch I get
first error much often and earlier than almost any other error,
so it may be just "bad luck" and other errors do not
appear because first error appear earlier.

BTW question about RISC engine:
what kind of memory use RISC engine to store
DMA programs (code)? Internal SRAM or host's?
I ask because "cx23885[0]: mpeg risc op code error"
error message storm after first message looks like
RISC engine used host's memory when this memory
was unmapped.



Raimonds Cicans
