Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:58999 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260AbaEGPmu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 May 2014 11:42:50 -0400
Received: by mail-qc0-f175.google.com with SMTP id w7so1305560qcr.34
        for <linux-media@vger.kernel.org>; Wed, 07 May 2014 08:42:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399435082-5416-1-git-send-email-cb.xiong@samsung.com>
References: <1399435082-5416-1-git-send-email-cb.xiong@samsung.com>
Date: Wed, 7 May 2014 11:42:50 -0400
Message-ID: <CAGoCfiziMm1zeUkOOd7qwTtQxmMmoqZ=QAvZuPoN71KT0_iUgA@mail.gmail.com>
Subject: Re: [PATCH] au0828: fix logic of tuner disconnection
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: cb.xiong@samsung.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 6, 2014 at 11:58 PM,  <cb.xiong@samsung.com> wrote:
> From: Changbing Xiong <cb.xiong@samsung.com>
>
> The driver crashed when the tuner was disconnected while restart stream
> operations are still being performed. Fixed by adding a flag in struct
> au0828_dvb to indicate whether restart stream operations can be performed.
>
> If the stream gets misaligned, the work of restart stream operations are
>  usually scheduled for many times in a row. If tuner is disconnected at
> this time and some of restart stream operations are still not flushed,
> then the driver crashed due to accessing the resource which used in
> restart stream operations has been released.
>
> Signed-off-by: Changbing Xiong <cb.xiong@samsung.com>

I haven't yet reviewed the logic in detail, but at a minimum this
should really be two patches - one to address the disconnect bug and a
second to deal with failure to cancel to the worker thread.  Also, you
need to pick a name for the variable that is more explanatory than
"flag".

Please resubmit this as two separate patches with "flag" renamed, and
I will then look at the actual implementation to see if it causes any
problems.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
