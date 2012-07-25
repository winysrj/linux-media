Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46622 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933207Ab2GYOhA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jul 2012 10:37:00 -0400
Received: by yhmm54 with SMTP id m54so761035yhm.19
        for <linux-media@vger.kernel.org>; Wed, 25 Jul 2012 07:37:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <500FF804.9050308@canonical.com>
References: <1343222119-82246-1-git-send-email-tim.gardner@canonical.com>
	<CAGoCfiziwAz0q2D_qKX=1nrAKQybeX+Ho5eu_gsERhd7QtsaDQ@mail.gmail.com>
	<500FF804.9050308@canonical.com>
Date: Wed, 25 Jul 2012 10:36:59 -0400
Message-ID: <CAGoCfiyFxctHa13x4TKUgTa9gWrX5EQ_RCXK997iQhfiNoDNkQ@mail.gmail.com>
Subject: Re: [PATCH] xc5000: Add MODULE_FIRMWARE statements
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Eddi De Pieri <eddi@depieri.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 25, 2012 at 9:43 AM, Tim Gardner <tim.gardner@canonical.com> wrote:
> Devin - Please have a closer look. XC5000A_FIRMWARE and XC5000C_FIRMWARE
> are defined in the patch.

Yup, my bad.  I looked at the patch twice but for some reason didn't
see the #define.

I'm not really taking a position on whether this approach is good or not.

Mauro, let me know if this should be accepted and if so I will stick
it onto the end of my tree before sending it upstream this weekend.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
