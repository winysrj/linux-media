Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51587 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719Ab1LEXrX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2011 18:47:23 -0500
Received: by yenm1 with SMTP id m1so2326427yen.19
        for <linux-media@vger.kernel.org>; Mon, 05 Dec 2011 15:47:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKdnbx7Ayg6AGS-u=z9Pg6pHV6UN_ZiB-kQ1rv78zG9nm+U9TA@mail.gmail.com>
References: <1321800978-27912-1-git-send-email-mchehab@redhat.com>
	<1321800978-27912-2-git-send-email-mchehab@redhat.com>
	<1321800978-27912-3-git-send-email-mchehab@redhat.com>
	<1321800978-27912-4-git-send-email-mchehab@redhat.com>
	<1321800978-27912-5-git-send-email-mchehab@redhat.com>
	<CAGoCfiwv1MWnJc+3HL+9-E=o+HG09jjdGYOfpoXSoPd+wW3oHg@mail.gmail.com>
	<4EDD0F01.7040808@redhat.com>
	<CAGoCfizRuBEgBhfnzyrE=aJD-WMXCz9OmkoEqQCDpqmYXU2=zA@mail.gmail.com>
	<CAGoCfiywqY+U0+t9tget1X09=apDm46GpGCa-_QiGp+JhyLXxQ@mail.gmail.com>
	<CAKdnbx7Ayg6AGS-u=z9Pg6pHV6UN_ZiB-kQ1rv78zG9nm+U9TA@mail.gmail.com>
Date: Mon, 5 Dec 2011 18:47:20 -0500
Message-ID: <CAGoCfiwwt898OwmNNwrboT7q5v-sNQuTP6TxCdtY-fFauAyHrA@mail.gmail.com>
Subject: Re: [PATCH 5/8] [media] em28xx: initial support for HAUPPAUGE
 HVR-930C again
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Eddi De Pieri <eddi@depieri.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Mark Lord <kernel@teksavvy.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 5, 2011 at 6:32 PM, Eddi De Pieri <eddi@depieri.net> wrote:
> Sorry,  I think I applied follow patch on my tree while I developed
> the driver trying to fix tuner initialization.
>
> http://patchwork.linuxtv.org/patch/6617/
>
> I forgot to remove from my tree after I see that don't solve anything.

Ok, great.  At least that explains why it's there (since I couldn't
figure out how on Earth the patch made sense otherwise).

Eddi, could you please submit a patch removing the offending code?

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
