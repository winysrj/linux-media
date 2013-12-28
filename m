Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:18588 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab3L1WyE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 17:54:04 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYJ0049KGY1VF50@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 28 Dec 2013 17:54:01 -0500 (EST)
Date: Sat, 28 Dec 2013 20:53:52 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "deadletterfile@att.net" <deadletterfile@att.net>
Cc: linux-media@vger.kernel.org, tehpola@gmail.com
Subject: Re: linuxtv patch/11200/
Message-id: <20131228205352.69f57f86.m.chehab@samsung.com>
In-reply-to: <52BF0C1A.4070804@att.net>
References: <52BF0C1A.4070804@att.net>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 28 Dec 2013 12:36:26 -0500
"deadletterfile@att.net" <deadletterfile@att.net> escreveu:

> I am writing regarding Mr. Mike Slegeir's patch 11200, which is listed
> with a 'State: Not Applicable.'

That only means that it is not applicable as a Kernel media patch.

All non-Kernel-media patches at patchwork are tagged as such,
with the exception of the patches for a user application that
I (or a Kernel driver submaintainer) maintains, as I just use
the same script to apply the patch, and my script automatically
updates patchwork status to accepted when I apply a patch.

If you think the patch should be applied on some userspace app, you
should find its maintainer and ask him to apply the patch.
-- 

Cheers,
Mauro
