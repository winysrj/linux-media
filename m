Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:51594 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaKTUKJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 15:10:09 -0500
Received: by mail-la0-f52.google.com with SMTP id q1so3016520lam.25
        for <linux-media@vger.kernel.org>; Thu, 20 Nov 2014 12:10:08 -0800 (PST)
Date: Thu, 20 Nov 2014 22:10:05 +0200 (EET)
From: Olli Salonen <olli.salonen@iki.fi>
To: Michael Holzer <michael.w.holzer@gmail.com>
cc: "olli.salonen" <olli.salonen@iki.fi>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	crazycat69@narod.ru
Subject: Re: [PATCH 1/3] tuners: si2157: Si2148 support.
In-Reply-To: <CA++x_yB3PA=gsFO-Lbhvn7ayUjUDdVJfmkLKqTOn1H14-ytmPQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1411202204550.1388@dl160.lan>
References: <CA++x_yD6oxb4mkbP_8UtHU13LM5dgacbtHXWKe+qpDEfFp5bMw@mail.gmail.com> <CA++x_yB3PA=gsFO-Lbhvn7ayUjUDdVJfmkLKqTOn1H14-ytmPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 17 Nov 2014, Michael Holzer wrote:

> I'd see merit to show the supported chips explicitly as otherwise users
> may be confused if a new unsupported chip  (lets assume Si2159)
> appears and the message is generic as proposed "Si215x".
> To get clarity for this case source code reading would be required.

Well, the user of a Si2159 would never see the printout as the driver 
would not be loaded for a Si2159 user. I'd say just print something like 
"Si215x/Si216x Silicon Tuner" in the printouts and list all the chips in 
the source code. But that's not something that needs to be fixed now 
anyway, we can do that later.

Crazycat, do you think you could change the firmware loading for Si2148 
as discussed here though and send a new patch?

Cheers,
-olli
