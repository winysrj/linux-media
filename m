Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:60309 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651Ab1HXSIt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 14:08:49 -0400
Message-ID: <4E553E2E.2020803@linuxtv.org>
Date: Wed, 24 Aug 2011 20:08:46 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] DVB: dvb_frontend: convert semaphore to mutex
References: <1314207232-6031-1-git-send-email-obi@linuxtv.org>	<CAGoCfizk8Ni96yJJq7Q=MGhH_-EgLskYd3SDMJ4w9mAdEPg1mg@mail.gmail.com>	<4E553CBE.8010506@linuxtv.org> <CAGoCfiwt6siLdT_bCgnBnpmUuwL-CK+r8rCUTviNHWko7=NKQA@mail.gmail.com>
In-Reply-To: <CAGoCfiwt6siLdT_bCgnBnpmUuwL-CK+r8rCUTviNHWko7=NKQA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24.08.2011 20:06, Devin Heitmueller wrote:
> On Wed, Aug 24, 2011 at 2:02 PM, Andreas Oberritter <obi@linuxtv.org> wrote:
>> It's impossible to clean up dvb_frontend.c, which looks quite
>> unmaintained, without touching it.
> 
> It is quite unmaintained.  In fact, it was broken for numerous cards
> for almost two years before I finally got someone in the Hauppauge UK
> office to mail me a couple of affected boards to test with.
> 
> Now that it works, I'm very hesitant to see any chances made unless
> there is a *very* good reason. It's just too damn easy to introduce
> subtle bugs in there that work for "your card" but cause breakage for
> others.

Instead of wasting your time with theory, you could have easily reviewed
my patch. It's really *very* simple any anyone having used semphores or
mutexes in the kernel should be able to see that.
