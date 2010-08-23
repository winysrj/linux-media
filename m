Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39904 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab0HWLTl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Aug 2010 07:19:41 -0400
Received: by iwn5 with SMTP id 5so3496237iwn.19
        for <linux-media@vger.kernel.org>; Mon, 23 Aug 2010 04:19:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1282537951.32217.3874.camel@pc.interlinx.bc.ca>
References: <1282537951.32217.3874.camel@pc.interlinx.bc.ca>
Date: Mon, 23 Aug 2010 07:19:40 -0400
Message-ID: <AANLkTim0Gn8F9bjsnykOkfn54dajtnJRryhRQdJ76thw@mail.gmail.com>
Subject: Re: hvr950q stopped working: read of drv0 never returns
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Mon, Aug 23, 2010 at 12:32 AM, Brian J. Murrell
<brian@interlinx.bc.ca> wrote:
> Hi,
>
> I have an HVR 950Q on my Ubuntu 2.6.32 kernel.  I have in fact tried
> several kernel versions on a couple of different machines with the same
> behaviour.
>
> What seems to be happening is that /dev/dvb/adapter0/dvr0 can be opened:
>
> open("/dev/dvb/adapter0/dvr0", O_RDONLY|O_LARGEFILE) = 0
>
> but a read from it never seems to return any data:
>
> read(0,
> [ process blocks waiting ]

Hi Brian,

What command are you using to control the frontend?  If it's "azap",
did you remember to specify the "-r" argument?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
