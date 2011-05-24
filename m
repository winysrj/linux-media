Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54471 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab1EXM2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 08:28:04 -0400
Received: by ewy4 with SMTP id 4so2129776ewy.19
        for <linux-media@vger.kernel.org>; Tue, 24 May 2011 05:28:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306238734.7397.102.camel@ares>
References: <719f9c4d1bd57d5b2711bc24a9d5c3b1@chewa.net>
	<1306238734.7397.102.camel@ares>
Date: Tue, 24 May 2011 08:28:02 -0400
Message-ID: <BANLkTinN1YWpEpxxMgoZ2hMTGt3eEv=peA@mail.gmail.com>
Subject: Re: dvb: one demux per tuner or one demux per demod?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steve Kerrison <steve@stevekerrison.com>,
	Antti Palosaari <crope@iki.fi>
Cc: =?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>,
	linux-media@vger.kernel.org, vlc-devel@videolan.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/5/24 Steve Kerrison <steve@stevekerrison.com>:
> Hi Rémi,
>
> The cxd2820r supports DVB-T/T2 and also DVB-C. As such antti coded up a
> multiple front end (MFE) implementation for em28xx then attaches the
> cxd2820r in both modes.
>
> I believe you can only use one frontend at once per adapter (this is
> certainly enforced in the cxd2820r module), so I don't see how it would
> cause a problem for mappings. I think a dual tuner device would register
> itself as two adapters, wouldn't it?
>
> But I'm new at this, so forgive me if I've overlooked something or
> misunderstood the issue you've raised.

Oh wow, is that what Antti did?  I didn't really give much thought but
I can appreciate why he did it (the DVB 3.x API won't allow a single
frontend to advertise support for DVB-C and DVB-T).

This is one of the big things that S2API fixes (through S2API you can
specify the modulation that you want).  Do we really want to be
advertising two frontends that point to the same demod, when they
cannot be used in parallel?  This seems doomed to create problems with
applications not knowing that they are in fact the same frontend.

I'm tempted to say that this patch should be scapped and we should
simply say that you cannot use DVB-C on this device unless you are
using S2API.  That would certainly be cleaner but it comes at the cost
of DVB-C not working with tools that haven't been converted over to
S2API yet.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
