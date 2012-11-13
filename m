Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab2KMJYY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 04:24:24 -0500
Message-ID: <50A211BE.60606@redhat.com>
Date: Tue, 13 Nov 2012 07:24:14 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Martin Rudge <martin.rudge@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: DVB V5 API: Event Model
References: <CAE-UT2ug=U4AJghXfXZBuBoa18JsPSjNsvHUEu9FHZvAm1qi1Q@mail.gmail.com>
In-Reply-To: <CAE-UT2ug=U4AJghXfXZBuBoa18JsPSjNsvHUEu9FHZvAm1qi1Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 12-11-2012 11:04, Martin Rudge escreveu:
> Hello All,
>
> When using the V5 API (DVB-S/S2) for the DVB frontend device (with the
> now merged SEC functionality), setting properties DTV_VOLTAGE and/or
> DTV_TONE generates extra (unwanted?) events.  This is due to utilising
> the legacy FE_SET_FRONTEND IOCTL in their respective implementations.
>
> Depending on their placement in one "atomic" FE_SET_PROPERTY call,
> they can cause an "incorrect" (premature) SYNC/LOCK event to be
> generated.  For example, when looping issuing tune requests in
> succession during a scan operation. This was with a fairly recent
> media build (pulled Saturday).

I suspect that this is an undesirable behavior, likely there since the initial
version of DVB-S2 API. It could be too late to fix, as userspace apps may be
trusting on this behavior.

Maybe you could propose a patch and ask app developers what they thing about
it.

> Conversly using DTV_CLEAR clears the cached values, but doesn't affect
> the frontend (LNB).  This is probably desirable behaviour.

This is desirable.

> Any thoughts, working as designed/intended?

Regards,
Mauro
