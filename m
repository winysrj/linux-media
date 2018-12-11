Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E976FC67839
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 21:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE17120870
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 21:19:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cjz7Zjc0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE17120870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbeLKVTb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 16:19:31 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41200 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbeLKVTb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 16:19:31 -0500
Received: by mail-pf1-f194.google.com with SMTP id b7so7733558pfi.8;
        Tue, 11 Dec 2018 13:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5cMRJK/3F6tDpiBvZXh3f8P7FS10joZts+DR0lTUuww=;
        b=cjz7Zjc0gMM0VUiQDaJRA+1BzoOK+xk+5qWdRX9TmG4mrwfw4XiqUSPRiN5u3bvTEi
         D2XwV+J7/6HRc4FT4NlaC4InKXR6ELVYMiWK9Igf2L/2DdwHMlhutclEglzUM1+655LN
         YOhV4VLnIfcmhmlYrTiouq31pQOBOYiWOKKkngRSK7qqLn7aILdxLfTxsHlhVRUF8Ixy
         lzIzyP8jJYGvYhmLeyjpX/lHKPm84+PiSRvq1uhgiWCOoatHZ5bUW2iN/3a+8ZYW4m3V
         MRf7FdzjPX08xp5l9+RMdKffSiYtLXRZWfItIJOmB9R7cOAuRsqv9L9ZFK6CS/5sZqaR
         ucRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=5cMRJK/3F6tDpiBvZXh3f8P7FS10joZts+DR0lTUuww=;
        b=FcXU+G1mzMG99XmBBU15z/Cxq3m+NiU/FQHD/Zc7v1IqP7a+3saAyJIzMMnVs6Y51O
         fthAkWsZnyIhIKqq0ZCz8zXsE2loX7CJ1PJEIeEg8Y3KmafPzNuQAJYvgIMT/fJOgakc
         2KNkXL0pdYb/aOdlSv62TrBV5d0HnZ2jlDj+g/mg/MM/5mPklT9Jc/I+x2/+PF1a9+vv
         RKcFIg8uY6reyNCDP8QdNZuQnjbBLxg2Udb80s5EaWco5fNt6wDqoaOibJDF+PkzJadY
         uRkm1cEZKjS3KI/WVMmNnVCoyBYtkeiiH+ipJH3kBnBDA6b7kaCDne200Yto6byc/HVH
         OqWg==
X-Gm-Message-State: AA+aEWarCvl20l2gveLtUPI1Iu03Flo/TiwGmSiWCL7q4hSXlGwRNGbx
        u+dfRvc92ZipcmevC9l5ht8=
X-Google-Smtp-Source: AFSGD/XrRgA2FiLEmxa12zGcslH3ljYckka3zEk+G1FIS0TZV0Pk/Pk5BFcLv3JMpU9cFvYEuByLQQ==
X-Received: by 2002:a63:61c8:: with SMTP id v191mr16275116pgb.242.1544563169769;
        Tue, 11 Dec 2018 13:19:29 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g136sm22600461pfb.154.2018.12.11.13.19.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Dec 2018 13:19:29 -0800 (PST)
Date:   Tue, 11 Dec 2018 13:19:28 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: ddbridge: Move asm includes after linux ones
Message-ID: <20181211211928.GA5922@roeck-us.net>
References: <20181210233514.3069-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181210233514.3069-1-natechancellor@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Dec 10, 2018 at 04:35:14PM -0700, Nathan Chancellor wrote:
> Without this, cpumask_t and bool are not defined:
> 
> In file included from drivers/media/pci/ddbridge/ddbridge-ci.c:19:
> In file included from drivers/media/pci/ddbridge/ddbridge.h:22:
> ./arch/arm/include/asm/irq.h:35:50: error: unknown type name 'cpumask_t'
> extern void arch_trigger_cpumask_backtrace(const cpumask_t *mask,
>                                                  ^
> ./arch/arm/include/asm/irq.h:36:9: error: unknown type name 'bool'
>                                            bool exclude_self);
>                                            ^
> 
> Doing a survey of the kernel tree, this appears to be expected because
> '#include <asm/irq.h>' is always after the linux includes.
> 
> This also fixes warnings of this variety (with Clang):
> 
> In file included from drivers/media/pci/ddbridge/ddbridge-ci.c:19:
> In file included from drivers/media/pci/ddbridge/ddbridge.h:56:
> In file included from ./include/media/dvb_net.h:22:
> In file included from ./include/linux/netdevice.h:50:
> In file included from ./include/uapi/linux/neighbour.h:6:
> In file included from ./include/linux/netlink.h:9:
> In file included from ./include/net/scm.h:11:
> In file included from ./include/linux/sched/signal.h:6:
> ./include/linux/signal.h:87:11: warning: array index 3 is past the end
> of the array (which contains 2 elements) [-Warray-bounds]
>                 return (set->sig[3] | set->sig[2] |
>                         ^        ~
> ./arch/arm/include/asm/signal.h:17:2: note: array 'sig' declared here
>         unsigned long sig[_NSIG_WORDS];
>         ^
> 
> Fixes: b6973637c4cc ("media: ddbridge: remove another duplicate of io.h and sort includes")
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Tested-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/media/pci/ddbridge/ddbridge.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
> index 0be6ed216e65..b834449e78f8 100644
> --- a/drivers/media/pci/ddbridge/ddbridge.h
> +++ b/drivers/media/pci/ddbridge/ddbridge.h
> @@ -18,9 +18,6 @@
>  #ifndef _DDBRIDGE_H_
>  #define _DDBRIDGE_H_
>  
> -#include <asm/dma.h>
> -#include <asm/irq.h>
> -
>  #include <linux/clk.h>
>  #include <linux/completion.h>
>  #include <linux/delay.h>
> @@ -48,6 +45,9 @@
>  #include <linux/vmalloc.h>
>  #include <linux/workqueue.h>
>  
> +#include <asm/dma.h>
> +#include <asm/irq.h>
> +
>  #include <media/dmxdev.h>
>  #include <media/dvb_ca_en50221.h>
>  #include <media/dvb_demux.h>
> -- 
> 2.20.0
> 
