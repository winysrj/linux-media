Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:54429 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab0DHOBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 10:01:10 -0400
Received: by gxk9 with SMTP id 9so1367655gxk.8
        for <linux-media@vger.kernel.org>; Thu, 08 Apr 2010 07:01:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1270727417-3872-1-git-send-email-weiyi.huang@gmail.com>
References: <1270727417-3872-1-git-send-email-weiyi.huang@gmail.com>
Date: Thu, 8 Apr 2010 10:01:08 -0400
Message-ID: <m2y829197381004080701uf00e37cavaf0eaac85d6c15f@mail.gmail.com>
Subject: Re: [PATCH 11/16] V4L/DVB: DVB: ngene, remove unused #include
	<linux/version.h>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 8, 2010 at 7:50 AM, Huang Weiyi <weiyi.huang@gmail.com> wrote:
> Remove unused #include <linux/version.h>('s) in
>  drivers/media/dvb/ngene/ngene-core.c
>
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
> ---
>  drivers/media/dvb/ngene/ngene-core.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
> index 645e8b8..6dc567b 100644
> --- a/drivers/media/dvb/ngene/ngene-core.c
> +++ b/drivers/media/dvb/ngene/ngene-core.c
> @@ -37,7 +37,6 @@
>  #include <linux/pci_ids.h>
>  #include <linux/smp_lock.h>
>  #include <linux/timer.h>
> -#include <linux/version.h>
>  #include <linux/byteorder/generic.h>
>  #include <linux/firmware.h>
>  #include <linux/vmalloc.h>

Hello Huang,

I just wanted to let you know that KernelLabs has a rather large
project ongoing to clean up the ngene driver.  So while I have no
objection to this patch in principle, please be advised that there is
not much value in doing additional cleanup to that driver as it is
likely to be redundant (and will just increase our work in merging the
changes upstream).

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
