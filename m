Return-path: <mchehab@gaivota>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63846 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab0LYPHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Dec 2010 10:07:52 -0500
Received: by iyi12 with SMTP id 12so6407045iyi.19
        for <linux-media@vger.kernel.org>; Sat, 25 Dec 2010 07:07:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D0256DB.2070303@iki.fi>
References: <4D0256DB.2070303@iki.fi>
Date: Sat, 25 Dec 2010 16:07:51 +0100
Message-ID: <AANLkTinOW7+5Rbf8YmRhq4VMB=DxgDC0HQ5zC8YrULRO@mail.gmail.com>
Subject: Re: dvb-apps: update DVB-T intial tuning files for Finland (fi-*)
From: Christoph Pfister <christophpfister@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

2010/12/10 Antti Palosaari <crope@iki.fi>:
> Moi Christoph,
> Updates all Finnish channels as today.

Committed, thanks (commit message is messed up a bit because I
misinterpreted your patch as a hg changeset :-).

> I accidentally removed first fi-Smedsbole file since that was not generated
> by my scripts. Actually it is for the autonomy island named Åland [1]
> between Finland and Sweden. They have even own top level domain - ax. I
> think correct name for that is ax-Smedsbole instead of fi.
>
> [1] http://en.wikipedia.org/wiki/%C3%85land_Islands

Ok, I've changed that.

> Antti
> --
> http://palosaari.fi/

Christoph
