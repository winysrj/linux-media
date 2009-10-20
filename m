Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:41745 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbZJTNFW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 09:05:22 -0400
Received: by ywh40 with SMTP id 40so3457861ywh.33
        for <linux-media@vger.kernel.org>; Tue, 20 Oct 2009 06:05:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51bd605b0910200329u394e9e56m93ad8ca3cf1dedb5@mail.gmail.com>
References: <51bd605b0910181441l7d6ac90g53978e3e4436f6ba@mail.gmail.com>
	 <829197380910191218u2c281553pad57bff61ffbd3b5@mail.gmail.com>
	 <51bd605b0910191328i3b58c955ha3ade305b4af928d@mail.gmail.com>
	 <829197380910191341p484e070ftd190143f73b1d10e@mail.gmail.com>
	 <51bd605b0910191451x22287c5ai3f829f2af0243879@mail.gmail.com>
	 <829197380910191456g5c53f37bh82ae6d7359ae5d2e@mail.gmail.com>
	 <51bd605b0910191534x48973759g721f4ee79b692059@mail.gmail.com>
	 <alpine.LRH.1.10.0910200938140.3543@pub2.ifh.de>
	 <51bd605b0910200329u394e9e56m93ad8ca3cf1dedb5@mail.gmail.com>
Date: Tue, 20 Oct 2009 09:05:25 -0400
Message-ID: <829197380910200605w48a18ddak83efd9166d92c278@mail.gmail.com>
Subject: Re: pctv nanoStick Solo not recognized
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Matteo Miraz <telegraph.road@gmail.com>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 20, 2009 at 6:29 AM, Matteo Miraz <telegraph.road@gmail.com> wrote:
> Hi Patrick,
>
> here it is the requested patch... note that I don't have a PCTV282E
> device, so I cannot test it!
>
> Thanks for the assistance,
> Matteo

Ok, I heard back from the engineer at PCTV.  He says that the
following products could appear with either the old USB vendor ID or
the new vendor ID.

USB\VID_2013&PID_0245       ; PCTV 73e SE / PCTV nanoStick SE (73e SE)
USB\VID_2013&PID_0246       ; PCTV 74e / PCTV picoStick (74e)
USB\VID_2013&PID_0248       ; PCTV 282e (Peanut) / PCTV FlashStick nano (282e)

Looks like we're already got the 73e and 282e, so we just need to do
the 74e as well (assuming we support the 74e at all, which I haven't
checked yet).

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
