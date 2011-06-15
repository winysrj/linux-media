Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54524 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab1FOHxx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 03:53:53 -0400
Received: by eyx24 with SMTP id 24so57368eyx.19
        for <linux-media@vger.kernel.org>; Wed, 15 Jun 2011 00:53:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201106151026.36509.past@biztrend.ru>
References: <201106151026.36509.past@biztrend.ru>
Date: Wed, 15 Jun 2011 03:53:52 -0400
Message-ID: <BANLkTimTErrOsveFRQVUfaKjexKKS=TjoA@mail.gmail.com>
Subject: Re: xc4000 and analog tv
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Artem Pastukhov <artem.pastukhov@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jun 15, 2011 at 2:26 AM, Artem Pastukhov
<artem.pastukhov@gmail.com> wrote:
> It's possible to get analog tv from xc4000?
>
> I have Pinnacle PCTV Hybrid Stick Solo

No, this is not currently possible.

The limitation has nothing to do with the xc4000 driver but rather the
dvb-usb framework which currently has no analog support at all.  This
is a problem common to all dib0700 devices, and up to this point no
developer has been prepared to spend the 50-100 hours needed to add
analog support.  You should not expect this situation to change
anytime soon, as it's been a known issue for years.

Regards,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
