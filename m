Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54984 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab2EBPMe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 11:12:34 -0400
Received: by qcro28 with SMTP id o28so432874qcr.19
        for <linux-media@vger.kernel.org>; Wed, 02 May 2012 08:12:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201205021338.09817.pboettcher@kernellabs.com>
References: <1335845545-20879-1-git-send-email-mkrufky@linuxtv.org>
	<1335845545-20879-7-git-send-email-mkrufky@linuxtv.org>
	<201205021338.09817.pboettcher@kernellabs.com>
Date: Wed, 2 May 2012 11:12:33 -0400
Message-ID: <CAHAyoxxcyzvbSTL4vB6rECbtmnhWpjmK08GaLyq1HpoaFfYekg@mail.gmail.com>
Subject: Re: [PATCH 07/10] dvb-demux: add functionality to send raw payload to
 the dvr device
From: Michael Krufky <mkrufky@kernellabs.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 2, 2012 at 7:38 AM, Patrick Boettcher
<pboettcher@kernellabs.com> wrote:
> Hi Mike,
>
> On Tuesday 01 May 2012 06:12:22 Michael Krufky wrote:
>> From: Michael Krufky <mkrufky@kernellabs.com>
>>
>> If your driver needs to deliver the raw payload to userspace without
>> passing through the kernel demux, use function: dvb_dmx_swfilter_raw
>
> I like this one very much. I had a background task sleeping in my head
> which was how to add non-Transport-Stream standards to Linux-dvb. This
> one I can now cancel, thanks to this change.
>
> We now can add CMMB-support and DAB to linux-dvb (after more discussions
> on the API of course).
>
> Do you have user-space-tool ready which uses the new RAW-payload
> mechanism? Something which can be used as an example.
>
> Thanks for this development.
>
> --
> Patrick

Thanks for your support, Patrick.

I am working on a bunch of utilities for ATSC-MH, so far I have shown
a simple scanning utility, and I plan to release additional utilities
for parsing the data soon.

The way it works, since we are using the delivery_system ==
SYS_ATSCMH, we know that the payload should be parsed as ATSCMH.
Likewise, when delivery_system == SYS_CMMB, we will parse it as CMMB.
We can use this mechanism for delivering any type of non-TS based data
stream.

Since both CMMB and ATSCMH are IP-based systems, perhaps we can do
this parsing in a common library.

Do you have any CMMB or ATSCMH devices?

-Mike
