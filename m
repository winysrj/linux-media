Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37320 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab1FTSYk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 14:24:40 -0400
Received: by ewy4 with SMTP id 4so1322479ewy.19
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2011 11:24:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>
	<201106202037.19535.remi@remlab.net>
	<BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>
	<BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>
Date: Mon, 20 Jun 2011 14:24:36 -0400
Message-ID: <BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: HoP <jpetrous@gmail.com>
Cc: =?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jun 20, 2011 at 2:17 PM, HoP <jpetrous@gmail.com> wrote:
> Can you tell me when such disscussion was done? I did a big attempt
> to check if my work is not reinventing wheels, but I found only some
> very generic frontend template by Emard <emard@softhome.net>.

See the "userspace tuner" thread here for the background:

http://www.linuxtv.org/pipermail/linux-dvb/2007-August/thread.html#19840

>> easier for evil tuner manufacturers to leverage all the hard work done
>> by the LinuxTV developers while providing a closed-source solution.
>
> May be I missunderstood something, but I can't see how frontend
> virtualization/sharing can help to leverage others work.

It helps in that it allows third parties to write drivers in userspace
that leverage the in-kernel implementation of DVB core.  It means that
a product developer who didn't want to abide by the GPL could write a
closed-source driver in userland which takes advantage of the
thousands of lines of code that make up the DVB core.

>> It was an explicit goal to *not* allow third parties to reuse the
>> Linux DVB core unless they were providing in-kernel drivers which
>> conform to the GPL.
>
> I'm again not sure if you try to argument against vtunerc code
> or nope.

I am against things like this being in the upstream kernel which make
it easier for third parties to leverage GPL code without making their
code available under the GPL.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
