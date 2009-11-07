Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:18493 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbZKGQ1O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 11:27:14 -0500
Received: by fg-out-1718.google.com with SMTP id d23so189595fga.1
        for <linux-media@vger.kernel.org>; Sat, 07 Nov 2009 08:27:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6174dfda0911070731q535e9027q3a0feb483515436e@mail.gmail.com>
References: <6174dfda0911061223k75f31fd5je33a8e75e9e3c391@mail.gmail.com>
	 <6174dfda0911061258u254ba6bbh4610291a904edc0a@mail.gmail.com>
	 <156a113e0911061716t758d7ee3ta709b406c2f074a1@mail.gmail.com>
	 <6174dfda0911070246v61b5b3f5rdea26406066e3fa4@mail.gmail.com>
	 <156a113e0911070435w4be2b9dfo17f8e9c910bab437@mail.gmail.com>
	 <829197380911070725y12c984bamb1d157419b991c9a@mail.gmail.com>
	 <6174dfda0911070731q535e9027q3a0feb483515436e@mail.gmail.com>
Date: Sat, 7 Nov 2009 11:20:31 -0500
Message-ID: <829197380911070820v156e1d6cu8ccc82aba11a2064@mail.gmail.com>
Subject: Re: em28xx based USB Hybrid (Analog & DVB-T) TV Tuner not supported
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Johan Mutsaerts <johmut@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 7, 2009 at 10:31 AM, Johan Mutsaerts <johmut@gmail.com> wrote:
> Hi,
>
> Something caught my eye while examining em28xx-dvb.c
>
> #include "mt352.h"
> #include "mt352_priv.h" /* FIXME */
>
> What's the FIXME about ? Could it be a clue ?
>
> What do you suggest I try/text ?

Please don't top post.

No, I just put that FIXME there because the driver really shouldn't be
using the private headers.

I'm actually not in front of the code right now, so I cannot provide
any recommendations.  I will be back home on Sunday though and at that
point I can take a look at the code and offer some suggestions.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
