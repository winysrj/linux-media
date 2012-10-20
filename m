Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62904 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab2JTKFR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 06:05:17 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so450867eek.19
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2012 03:05:16 -0700 (PDT)
Message-ID: <50827759.3080302@gmail.com>
Date: Sat, 20 Oct 2012 12:05:13 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, k.debski@samsung.com,
	s.nawrocki@samsung.com, patches@linaro.org
Subject: Re: [PATCH 1/1] [media] s5p-mfc: Fix compilation warning
References: <1350127114-5170-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1350127114-5170-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/13/2012 01:18 PM, Sachin Kamat wrote:
> Added missing const qualifier.
> Without this patch compiler gives the following warning:
>
> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1576:2: warning:
> initialization from incompatible pointer type [enabled by default]
> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1576:2: warning:
> (near initialization for ‘s5p_mfc_enc_ioctl_ops.vidioc_subscribe_event’)
> [enabled by default]

Applied to my tree. Thank you.
