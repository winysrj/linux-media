Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44443 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1AIEBX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 23:01:23 -0500
Received: by gxk9 with SMTP id 9so4601671gxk.19
        for <linux-media@vger.kernel.org>; Sat, 08 Jan 2011 20:01:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <FA1BDB57-229C-424E-A109-6887C4C5CFAC@wilsonet.com>
References: <201101081847.06814.martin.dauskardt@gmx.de>
	<FA1BDB57-229C-424E-A109-6887C4C5CFAC@wilsonet.com>
Date: Sun, 9 Jan 2011 15:01:22 +1100
Message-ID: <AANLkTinrYg=gD3DXu8kXM83hk7mnEFGUY-7gpUegBj5i@mail.gmail.com>
Subject: Re: difference mchehab/new_build.git to media_build.git ?
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Martin Dauskardt <martin.dauskardt@gmx.de>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> There's no difference. It started out at mchehab/new_build.git, then got
> moved
> to media_build.git, but there's a symlink in place to keep from breaking
> things
> for people who originally checked it out at the old location.
>
> The move essentially promoted it from "something Mauro's tinkering with" to
> "something generally useful for a wider audience". And its also being worked
> on
> by more people than just Mauro now (myself included).

Thanks for clarifying this. Doesn't this justify a one-line NEWS item?
I can understand not wanting to mention it while still experimental, but now...

Vince
