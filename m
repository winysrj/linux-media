Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:32888 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651Ab1HXSMA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 14:12:00 -0400
Message-ID: <4E553CBE.8010506@linuxtv.org>
Date: Wed, 24 Aug 2011 20:02:38 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] DVB: dvb_frontend: convert semaphore to mutex
References: <1314207232-6031-1-git-send-email-obi@linuxtv.org> <CAGoCfizk8Ni96yJJq7Q=MGhH_-EgLskYd3SDMJ4w9mAdEPg1mg@mail.gmail.com>
In-Reply-To: <CAGoCfizk8Ni96yJJq7Q=MGhH_-EgLskYd3SDMJ4w9mAdEPg1mg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24.08.2011 19:54, Devin Heitmueller wrote:
> On Wed, Aug 24, 2011 at 1:33 PM, Andreas Oberritter <obi@linuxtv.org> wrote:
>> Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
> 
> This may seem like a silly question, but *why* are you making this
> change?  There is no explanation for what prompted it.  Is it in
> response to some issue you encountered?

A semaphore with only one unit is nothing but a mutex. Using a mutex
structure decreases memory footprint and improves readability.

> I'm asking because in general dvb_frontend has a fairly complicated
> locking model, and unless there is a compelling reason to make changes
> I would be against it.

The lock is part of fepriv, which is local to dvb_frontend.c. The patch
is really simple.

> In other words, this is a bad place for arbitrary "cleanup patches".

It's impossible to clean up dvb_frontend.c, which looks quite
unmaintained, without touching it.

Regards,
Andreas
