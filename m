Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:62381 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbaKRNMq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 08:12:46 -0500
Received: by mail-wg0-f45.google.com with SMTP id b13so1131845wgh.18
        for <linux-media@vger.kernel.org>; Tue, 18 Nov 2014 05:12:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415964052-30351-1-git-send-email-nikhil.nd@ti.com>
References: <1415964052-30351-1-git-send-email-nikhil.nd@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 18 Nov 2014 13:12:14 +0000
Message-ID: <CA+V-a8sJW=yjQ_sEDmq2Mb+SGAHPFr-hs7pqc1BRqsMRMz9d2Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] VPE improvements
To: Nikhil Devshatwar <nikhil.nd@ti.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nikhil,

On Fri, Nov 14, 2014 at 11:20 AM, Nikhil Devshatwar <nikhil.nd@ti.com> wrote:
> This patchset adds following improvements for the ti-vpe driver.
> * Support SEQ_TB format for interlaced buffers
>         Some of the video decoders generate interlaced content in SEQ_TB format
>         Y top, T bottom in one plane and UV top, UV bottom in another
> * Improve multi instance latency
>         Improve m2m job scheduling in multi instance use cases
>         Start processing even if all buffers aren't present
> * N frame de-interlace support
>         For N input fields, generate N progressive frames
>
While you are at it can you test the following 2 patches ?
(had CCed to Archit but the mail bounced back)

https://patchwork.kernel.org/patch/5328481/
https://patchwork.kernel.org/patch/5327801/

Thanks,
--Prabhakar Lad
