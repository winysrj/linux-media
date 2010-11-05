Return-path: <mchehab@gaivota>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45292 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab0KEOEq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Nov 2010 10:04:46 -0400
Received: by iwn41 with SMTP id 41so947023iwn.19
        for <linux-media@vger.kernel.org>; Fri, 05 Nov 2010 07:04:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <da4aa0687909ae3843c682fbf446e452@hardeman.nu>
References: <20101029191711.GA12136@hardeman.nu>
	<20101029192733.GE21604@redhat.com>
	<20101029195918.GA12501@hardeman.nu>
	<20101029200937.GG21604@redhat.com>
	<20101030233617.GA13155@hardeman.nu>
	<AANLkTimLU1TUn6nY4pr2pWNJp1hviyx=NiXYUQLSQA0e@mail.gmail.com>
	<20101101215635.GA4808@hardeman.nu>
	<AANLkTi=c_g7nxCFWsVMYM-tJr68V1iMzhSyJ7=g9VLnR@mail.gmail.com>
	<37bb20b43afce52964a95a72a725b0e4@hardeman.nu>
	<AANLkTimAx+D745-VxoUJ25ii+=Dm6rHb8OXs9_D69S1W@mail.gmail.com>
	<20101104193823.GA9107@hardeman.nu>
	<4CD30CE5.5030003@redhat.com>
	<da4aa0687909ae3843c682fbf446e452@hardeman.nu>
Date: Fri, 5 Nov 2010 09:04:45 -0500
Message-ID: <AANLkTinNadDFESQNx7tiq8V6ksuoOSm_N0BXXe3evWq8@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] Apple remote support
From: Christopher Harrington <ironiridis@gmail.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, Nov 5, 2010 at 08:27, David Härdeman <david@hardeman.nu> wrote:
> If you're referring to the pain caused by changing existing keytables
> (thereby breaking custom keytables), I think it's inevitable. Throwing away
> information is not a good solution.
>
> As this subsystem progresses, there's going to be more and more reports of
> remotes which, intentionally or unintentionally, do not follow the NEC
> "standard" (I use that word in the most liberal sense). Using the full 32
> bits allows us to support them without any module parameters or code
> changes.
>
> Which solution do you suggest?

What about reporting two key events: One with the Apple ID masked, and
one with the Apple ID retained? The "default" keymap could then match
the masked IDs, with the option of the user changing their keymaps to
ignore the masked one and only "pair" with the specific IDs they're
looking for?

As a bonus, they will be able to watch incoming scancodes to see the
ID they might want to pair with, even though those scancodes would be
ignored.

-- 
-Chris Harrington
Phone: 612.598.3650
