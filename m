Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57381 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab0J2G2X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 02:28:23 -0400
Received: by ewy7 with SMTP id 7so2078071ewy.19
        for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 23:28:22 -0700 (PDT)
Date: Fri, 29 Oct 2010 09:29:35 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linuxtv-commits@linuxtv.org,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: Re: [git:v4l-dvb/v2.6.37] [media] radio-si4713: Add regulator
 framework support
Message-Id: <20101029092935.b6dd7693.jhnikula@gmail.com>
In-Reply-To: <E1P7ZwW-0003bq-Uv@www.linuxtv.org>
References: <E1P7ZwW-0003bq-Uv@www.linuxtv.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi

On Sun, 17 Oct 2010 22:34:32 +0200
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/media_tree.git tree:
> 
> Subject: [media] radio-si4713: Add regulator framework support
> Author:  Jarkko Nikula <jhnikula@gmail.com>
> Date:    Tue Sep 21 05:49:43 2010 -0300
> 
> Convert the driver to use regulator framework instead of set_power callback.
> This with gpio_reset platform data provide cleaner way to manage chip VIO,
> VDD and reset signal inside the driver.
> 
> Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
> Cc: Eduardo Valentin <eduardo.valentin@nokia.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  drivers/media/radio/si4713-i2c.c |   74 ++++++++++++++++++++++++++++++++------
>  drivers/media/radio/si4713-i2c.h |    5 ++-
>  2 files changed, 67 insertions(+), 12 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=d455b639c1fb09f8ea888371fb6e04b490e115fb
> 
Was this patch lost somewhere? I don't see it in mainline for 2.6.37
but e.g. 85c55ef is there.


-- 
Jarkko
