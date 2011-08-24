Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42178 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1HXSym (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 14:54:42 -0400
Received: by bke11 with SMTP id 11so1126561bke.19
        for <linux-media@vger.kernel.org>; Wed, 24 Aug 2011 11:54:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E553E2E.2020803@linuxtv.org>
References: <1314207232-6031-1-git-send-email-obi@linuxtv.org>
	<CAGoCfizk8Ni96yJJq7Q=MGhH_-EgLskYd3SDMJ4w9mAdEPg1mg@mail.gmail.com>
	<4E553CBE.8010506@linuxtv.org>
	<CAGoCfiwt6siLdT_bCgnBnpmUuwL-CK+r8rCUTviNHWko7=NKQA@mail.gmail.com>
	<4E553E2E.2020803@linuxtv.org>
Date: Wed, 24 Aug 2011 14:54:41 -0400
Message-ID: <CAGoCfixD0QVvWKc-6w+OrckJo2wX6q6ndpzCg5aOV2W0pgVUvg@mail.gmail.com>
Subject: Re: [PATCH 1/2] DVB: dvb_frontend: convert semaphore to mutex
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 24, 2011 at 2:08 PM, Andreas Oberritter <obi@linuxtv.org> wrote:
> Instead of wasting your time with theory, you could have easily reviewed
> my patch. It's really *very* simple any anyone having used semphores or
> mutexes in the kernel should be able to see that.

There's no need to resort to belittlement.  Both of us have a
non-trivial number of commits to the Linux kernel.

My concern is that in the kernel a semaphore with a unit of one is
*not* necessarily the same as a mutex.  In particular you need to take
into account the calling context since mutexes do more enforcement of
certain conditions that may have been acceptable for a semaphore.

>From http://www.kernel.org/doc/Documentation/mutex-design.txt :

===
 - 'struct mutex' semantics are well-defined and are enforced if
   CONFIG_DEBUG_MUTEXES is turned on. Semaphores on the other hand have
   virtually no debugging code or instrumentation. The mutex subsystem
   checks and enforces the following rules:

   * - only one task can hold the mutex at a time
   * - only the owner can unlock the mutex
   * - multiple unlocks are not permitted
   * - recursive locking is not permitted
   * - a mutex object must be initialized via the API
   * - a mutex object must not be initialized via memset or copying
   * - task may not exit with mutex held
   * - memory areas where held locks reside must not be freed
   * - held mutexes must not be reinitialized
   * - mutexes may not be used in hardware or software interrupt
   *   contexts such as tasklets and timers
===

and:

===
Disadvantages
-------------

The stricter mutex API means you cannot use mutexes the same way you
can use semaphores: e.g. they cannot be used from an interrupt context,
nor can they be unlocked from a different context that which acquired
it. [ I'm not aware of any other (e.g. performance) disadvantages from
using mutexes at the moment, please let me know if you find any. ]
===

In short, you cannot just arbitrarily replace one with the other.  You
need to look at all the possible call paths and ensure that there
aren't any cases for example where the mutex is set in one but cleared
in the other.  Did you evaluate your change in the context of each of
the differences described in the list above?

Without any documentation in the patch, we have absolutely no idea
what level of due diligence you exercised in ensuring this didn't
cause breakage.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
