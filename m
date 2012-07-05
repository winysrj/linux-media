Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:39427 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab2GEOZV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 10:25:21 -0400
Received: by ghrr11 with SMTP id r11so7431972ghr.19
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2012 07:25:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341497792-6066-2-git-send-email-mchehab@redhat.com>
References: <1341497792-6066-1-git-send-email-mchehab@redhat.com>
	<1341497792-6066-2-git-send-email-mchehab@redhat.com>
Date: Thu, 5 Jul 2012 10:25:18 -0400
Message-ID: <CAGoCfixNj8CiSA8E1bDUg2+bUB9jq-pV7JuOht2QyT8NhK0=sA@mail.gmail.com>
Subject: Re: [PATCH 2/3] [media] tuner-xc2028: Fix signal strength report
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 5, 2012 at 10:16 AM, Mauro Carvalho Chehab
> -       /* Use both frq_lock and signal to generate the result */
> -       signal = signal || ((signal & 0x07) << 12);
> +       /* Signal level is 3 bits only */
> +
> +       signal = ((1 << 12) - 1) | ((signal & 0x07) << 12);

Are you sure this is correct?   It's entirely possible the original
code used a logical or because the signal level isn't valid unless
there is a lock.  The author may have been intending to say:

if (signal != 0) /* There is a lock, so set the signal level */
  signal = (signal & 0x07) << 12;
else
  signal = 0 /* Leave signal level at zero since there is no lock */

I agree that the way the original code was written is confusing, but
it may actually be correct.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
