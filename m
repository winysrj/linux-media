Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57294 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867Ab0BCURm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 15:17:42 -0500
Received: by bwz19 with SMTP id 19so478554bwz.28
        for <linux-media@vger.kernel.org>; Wed, 03 Feb 2010 12:17:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B69D83D.5050809@arcor.de>
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de>
	 <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de>
	 <4B688507.606@redhat.com> <4B688E41.2050806@arcor.de>
	 <4B689094.2070204@redhat.com> <4B6894FE.6010202@arcor.de>
	 <4B69D83D.5050809@arcor.de>
Date: Wed, 3 Feb 2010 15:17:40 -0500
Message-ID: <829197381002031217t53bcb2f0w5390635a68c38dab@mail.gmail.com>
Subject: Re: [PATCH 1/15] - tm6000 build hunk
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 3, 2010 at 3:10 PM, Stefan Ringel <stefan.ringel@arcor.de> wrote:
> --- a/drivers/staging/tm6000/tm6000-cards.c
> +++ b/drivers/staging/tm6000/tm6000-cards.c

Before you send too many of these, I should point out that there is a
well-defined format expected for patches.  Look here:

http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches

And you can see an example here:

http://kernellabs.com/hg/~dheitmueller/em28xx-test/rev/42272c1dd883

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
