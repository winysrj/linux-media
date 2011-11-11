Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37283 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab1KKWHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 17:07:49 -0500
Received: by wyh15 with SMTP id 15so4294701wyh.19
        for <linux-media@vger.kernel.org>; Fri, 11 Nov 2011 14:07:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EBCF4F1.2030606@redhat.com>
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com>
	<4EBBE336.8050501@linuxtv.org>
	<CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com>
	<4EBC402E.20208@redhat.com>
	<CAHFNz9KFv7XvK4Uafuk8UDZiu1GEHSZ8bUp3nAyM21ck09yOCQ@mail.gmail.com>
	<4EBCF4F1.2030606@redhat.com>
Date: Sat, 12 Nov 2011 03:37:48 +0530
Message-ID: <CAHFNz9JWi3f3kB2UdBQXJBP2Q3Y+a0qBVNBAiZPVxtcCVZCN7g@mail.gmail.com>
Subject: Re: PATCH: Query DVB frontend capabilities
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 11, 2011 at 3:42 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 11-11-2011 04:26, Manu Abraham escreveu:
>> On Fri, Nov 11, 2011 at 2:50 AM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> Em 10-11-2011 13:30, Manu Abraham escreveu:
>> The purpose of the patch is to
>> query DVB delivery system capabilities alone, rather than DVB frontend
>> info/capability.
>>
>> Attached is a revised version 2 of the patch, which addresses the
>> issues that were raised.
>
> It looks good for me. I would just rename it to DTV_SUPPORTED_DELIVERY.
> Please, when submitting upstream, don't forget to increment DVB version and
> add touch at DocBook, in order to not increase the gap between API specs and the
> implementation.

Ok, thanks for the feedback, will do that.

The naming issue is trivial. I would like to have a shorter name
rather that SUPPORTED. CAPS would have been ideal, since it refers to
device capability.

Regards,
Manu
