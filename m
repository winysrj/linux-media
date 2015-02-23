Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:61659 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbbBWP0P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 10:26:15 -0500
Message-id: <54EB468E.2050505@samsung.com>
Date: Mon, 23 Feb 2015 16:26:06 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Tony K Nadackal <tony.kn@samsung.com>,
	linux-samsung-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	mchehab@osg.samsung.com, j.anaszewski@samsung.com,
	kgene@kernel.org, k.debski@samsung.com, bhushan.r@samsung.com
Subject: Re: [PATCH] [media] s5p-jpeg: Fix crash in jpeg isr due to multiple
 interrupts.
References: <1418797512-30226-1-git-send-email-tony.kn@samsung.com>
In-reply-to: <1418797512-30226-1-git-send-email-tony.kn@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/12/14 07:25, Tony K Nadackal wrote:
> In case of corrupt images, multiple interrupts may occur
> due to different error scenarios.
> 
> Since we are removing the src and dest buffers in the first
> interrupt itself, crash occurs in the second error interrupts.
> 
> Disable the global interrupt before we start processing
> the interrupt avoid the crash.
> 
> Disable System interrupt in isr to avoid the crash below.

Rather than disabling all interrupts, is there no way to check
the interrupt reason from some status register and decide
whether we return the buffers or just ignore the interrupt ?

-- 
Thanks,
Sylwester
