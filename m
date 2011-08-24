Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46171 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab1HXSGc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 14:06:32 -0400
Received: by bke11 with SMTP id 11so1096239bke.19
        for <linux-media@vger.kernel.org>; Wed, 24 Aug 2011 11:06:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E553CBE.8010506@linuxtv.org>
References: <1314207232-6031-1-git-send-email-obi@linuxtv.org>
	<CAGoCfizk8Ni96yJJq7Q=MGhH_-EgLskYd3SDMJ4w9mAdEPg1mg@mail.gmail.com>
	<4E553CBE.8010506@linuxtv.org>
Date: Wed, 24 Aug 2011 14:06:28 -0400
Message-ID: <CAGoCfiwt6siLdT_bCgnBnpmUuwL-CK+r8rCUTviNHWko7=NKQA@mail.gmail.com>
Subject: Re: [PATCH 1/2] DVB: dvb_frontend: convert semaphore to mutex
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 24, 2011 at 2:02 PM, Andreas Oberritter <obi@linuxtv.org> wrote:
> It's impossible to clean up dvb_frontend.c, which looks quite
> unmaintained, without touching it.

It is quite unmaintained.  In fact, it was broken for numerous cards
for almost two years before I finally got someone in the Hauppauge UK
office to mail me a couple of affected boards to test with.

Now that it works, I'm very hesitant to see any chances made unless
there is a *very* good reason. It's just too damn easy to introduce
subtle bugs in there that work for "your card" but cause breakage for
others.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
