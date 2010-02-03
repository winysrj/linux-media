Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:61467 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab0BCUrI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 15:47:08 -0500
Received: by bwz19 with SMTP id 19so515094bwz.28
        for <linux-media@vger.kernel.org>; Wed, 03 Feb 2010 12:47:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B69DF51.4020704@arcor.de>
References: <4B673790.3030706@arcor.de> <4B675B19.3080705@redhat.com>
	 <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com>
	 <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com>
	 <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de>
	 <4B69D8CC.2030008@arcor.de> <4B69DF51.4020704@arcor.de>
Date: Wed, 3 Feb 2010 15:47:06 -0500
Message-ID: <829197381002031247x70b21fe7vfefabc1ea663be67@mail.gmail.com>
Subject: Re: [PATCH 15/15] - tm6000 hack with different demodulator parameter
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 3, 2010 at 3:40 PM, Stefan Ringel <stefan.ringel@arcor.de> wrote:
> signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
>
> --- a/drivers/staging/tm6000/hack.c
> +++ b/drivers/staging/tm6000/hack.c
<snip>

This patch shouldn't be merged at all.  You should figure out the
correct zl10353_config that is required, and hold off on submission
until you have the correct fix.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
