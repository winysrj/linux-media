Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44263 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbeJIMBF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 08:01:05 -0400
Received: by mail-pl1-f194.google.com with SMTP id p25-v6so164751pli.11
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2018 21:46:04 -0700 (PDT)
Date: Mon, 8 Oct 2018 21:46:01 -0700
From: Joel Fernandes <joel@joelfernandes.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 03/21] media: davinci_vpfe: fix vpfe_ipipe_init() error
 handling
Message-ID: <20181009044601.GA123155@joelaf.mtv.corp.google.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
 <5963491651fe2385fa50cf9371cb826f640e91e8.1523024380.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5963491651fe2385fa50cf9371cb826f640e91e8.1523024380.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 06, 2018 at 10:23:04AM -0400, Mauro Carvalho Chehab wrote:
> As warned:
> 	drivers/staging/media/davinci_vpfe/dm365_ipipe.c:1834 vpfe_ipipe_init() error: we previously assumed 'res' could be null (see line 1797)
> 
> There's something wrong at vpfe_ipipe_init():
> 
> 1) it caches the resourse_size() from from the first region
>    and reuses to the second region;
> 
> 2) the "res" var is overriden 3 times;
> 
> 3) at free logic, it assumes that "res->start" is not
>    overriden by platform_get_resource(pdev, IORESOURCE_MEM, 6),
>    but that's not true, as it can even be NULL there.
> 
> This patch fixes the above issues by:
> 
> a) store the resources used by release_mem_region() on
>    a separate var;
> 
> b) stop caching resource_size(), using the function where
>    needed.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

I ran coccicheck on a 4.14.74 stable kernel and noticed that 'res' can be
NULL in vpfe_ipipe_init. It looks like this patch is not included in the 4.14
stable series. Can this patch be applied? I applied it myself and it applies
cleanly, but I have no way to test it.

That 'res->start' error_release could end up a NULL pointer deref.

 - Joel

 
