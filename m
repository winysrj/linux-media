Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58507 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab2KNJsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 04:48:11 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so82050bkw.19
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2012 01:48:09 -0800 (PST)
References: <CAE-UT2ug=U4AJghXfXZBuBoa18JsPSjNsvHUEu9FHZvAm1qi1Q@mail.gmail.com> <50A211BE.60606@redhat.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <50A211BE.60606@redhat.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <1C898410-5C98-4E62-8639-C735185AD618@googlemail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Martin Rudge <martin.rudge@googlemail.com>
Subject: Re: DVB V5 API: Event Model
Date: Wed, 14 Nov 2012 09:47:56 +0000
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Mauro.

I'm not familiar with the code, however I'll review the design/code and see what could be done.

A quick look suggests the events are originating from the tuning loop, so it's down to the timing of copying the parms for voltage/tone (not currently instigated by a DTV_TUNE).

Thanks
Martin

On 13 Nov 2012, at 09:24, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Em 12-11-2012 11:04, Martin Rudge escreveu:
>> Hello All,
>> 
>> When using the V5 API (DVB-S/S2) for the DVB frontend device (with the
>> now merged SEC functionality), setting properties DTV_VOLTAGE and/or
>> DTV_TONE generates extra (unwanted?) events.  This is due to utilising
>> the legacy FE_SET_FRONTEND IOCTL in their respective implementations.
>> 
>> Depending on their placement in one "atomic" FE_SET_PROPERTY call,
>> they can cause an "incorrect" (premature) SYNC/LOCK event to be
>> generated.  For example, when looping issuing tune requests in
>> succession during a scan operation. This was with a fairly recent
>> media build (pulled Saturday).
> 
> I suspect that this is an undesirable behavior, likely there since the initial
> version of DVB-S2 API. It could be too late to fix, as userspace apps may be
> trusting on this behavior.
> 
> Maybe you could propose a patch and ask app developers what they thing about
> it.
> 
>> Conversly using DTV_CLEAR clears the cached values, but doesn't affect
>> the frontend (LNB).  This is probably desirable behaviour.
> 
> This is desirable.
> 
>> Any thoughts, working as designed/intended?
> 
> Regards,
> Mauro
