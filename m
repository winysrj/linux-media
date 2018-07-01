Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0062.hostedemail.com ([216.40.44.62]:37011 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753200AbeGAS0h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 1 Jul 2018 14:26:37 -0400
Message-ID: <653914f26dc8433a3f682b5e7eb850ab94bd431d.camel@perches.com>
Subject: Re: [PATCH 0/3] cast sizeof to int for comparison
From: Joe Perches <joe@perches.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>, linux-usb@vger.kernel.org,
        Chengguang Xu <cgxu519@gmx.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Date: Sun, 01 Jul 2018 11:26:32 -0700
In-Reply-To: <1530466325-1678-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1530466325-1678-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2018-07-01 at 19:32 +0200, Julia Lawall wrote:
> Comparing an int to a size, which is unsigned, causes the int to become
> unsigned, giving the wrong result.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)

Great, thanks.

But what about the ones in net/smc like:

> net/smc/smc_clc.c:	
> 
>         len = kernel_sendmsg(smc->clcsock, &msg, &vec, 1,
>                              sizeof(struct smc_clc_msg_decline));
>         if (len < sizeof(struct smc_clc_msg_decline))

Are those detected by the semantic match and ignored?
