Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:36266 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1G0O6i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 10:58:38 -0400
Received: by eye22 with SMTP id 22so1986258eye.2
        for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 07:58:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E302207.8050409@redhat.com>
References: <20110722183552.169950@gmx.net>
	<4E302207.8050409@redhat.com>
Date: Wed, 27 Jul 2011 10:58:36 -0400
Message-ID: <CAGoCfiyx8d_ALG6N+9Zru8Hps3iACx=jCq+bUDkadQMFae=6gg@mail.gmail.com>
Subject: Re: [PATCH v3] tuner_xc2028: Allow selection of the frequency
 adjustment code for XC3028
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Alina Friedrichsen <x-alina@gmx.net>, linux-media@vger.kernel.org,
	rglowery@exemail.com.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 27, 2011 at 10:34 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Btw, what's the video standard that you're using? DTV7? Does your device use
> a xc3028 or xc3028xl? Whats's your demod and board?

It was in the first sentence of his email.  He's got an HVR-1400,
which uses the xc3028L and dib7000p.

It's also worth noting that he isn't the first person to complain
about tuning offset problems with the xc3028L.  Just look at the
rather nasty hack some random user did for the EVGA inDtube (which is
xc3208L/s5h1409).

http://linuxtv.org/wiki/index.php/EVGA_inDtube

Bear in mind that it worked when I added the original support.
Somebody caused a regression since then though.

In short, I can appreciate why the user is frustrated.  The xc3028L
support worked at one point and then somebody broke the xc3028 driver.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
