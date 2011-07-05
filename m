Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56954 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab1GEBR1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 21:17:27 -0400
Received: by ewy4 with SMTP id 4so1881913ewy.19
        for <linux-media@vger.kernel.org>; Mon, 04 Jul 2011 18:17:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DCBEB52.5060808@iinet.net.au>
References: <4DCBEB52.5060808@iinet.net.au>
Date: Mon, 4 Jul 2011 21:17:24 -0400
Message-ID: <CAGoCfixa7tT1rensOa9GW1NRHrkxgSmwvSrAqP=THJpm2rZJzQ@mail.gmail.com>
Subject: Re: Bug in HVR1300. Found part of a patch, if reverted
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mike <michael.stock@iinet.net.au>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, May 12, 2011 at 10:14 AM, Mike <michael.stock@iinet.net.au> wrote:
> Hi there
>
> in the latest kernel (and all those since when the patch was written) this
> patch is still required for the HVR-1300 to work, any chance of it getting
> incorporated?
>
> thanks
> Mike

Hello Mike,

Please try out the following patch which has been submitted upstream,
which should fix the actual underlying problem (the patch that has
been circulating in Launchpad 439163 doesn't fix the *actual* issue).

https://launchpadlibrarian.net/74557311/frontend_dvb_init.patch

The above patch has been submitted for upstream inclusion, so feedback
from users would be useful.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
